from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from airflow.models import Variable
from pendulum import datetime

import boto3
import logging
from conn_info import *  # noqa

bucket = 'sprint6'
files = [
    'users.csv',
    'groups.csv',
    'dialogs.csv',
    'group_log.csv',
]

bash_command_tmpl = """
head -n 10 {{ params.files | join(' ') }}
"""


def download_file(bucket_name, filename):
    s = boto3.session.Session()
    s3 = s.client(
        service_name='s3',
        endpoint_url='https://storage.yandexcloud.net',
        aws_access_key_id=Variable.get('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=Variable.get('AWS_SECRET_ACCESS_KEY'),
    )

    logging.info(f'Downloading {filename} from s3...')
    s3.download_file(Bucket=bucket_name, Key=filename, Filename='/data/' + filename)
    logging.info(f'Successfully downloaded to /data/{filename}! finishing...')


dag = DAG(
    dag_id='sprint6_dag_get_data',
    start_date=datetime(2023, 7, 2),
    catchup=False,
    schedule_interval=None,
)

with dag:
    bash_op = BashOperator(
        task_id='print_10_lines_of_each',
        bash_command=bash_command_tmpl,
        params={'files': ['/data/' + f for f in files]}
    )

    for f in files:
        t = PythonOperator(
            task_id=f'download_{f}',
            python_callable=download_file,
            op_args=(bucket, f),
        )

        t >> bash_op
