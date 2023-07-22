import logging
import vertica_python

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.models import Variable
from pendulum import datetime
from conn_info import conn_info

files = [
    'users',
    'groups',
    'dialogs',
    'group_log'
]


def upload_file(table):
    logging.info('Creating Vertica connection...')
    with vertica_python.connect(
            password=Variable.get('RYCHYRYCHYANDEXRU_VERTICA_PASSWORD'),
            **conn_info
    ) as conn:
        curs = conn.cursor()
        insert_stmt = '''
        truncate table RYCHYRYCHYANDEXRU__STAGING.{table};
        copy RYCHYRYCHYANDEXRU__STAGING.{table}
        from local '/data/{table}.csv'
        delimiter ','
        skip 1
        '''
        logging.info(f'Uploading /data/{table}.csv -> RYCHYRYCHYANDEXRU__STAGING.{table}...')
        curs.execute(insert_stmt.format(table=table))
        conn.commit()
        logging.info(f'Upload OK!')


dag = DAG(
    dag_id='sprint6_dag_upload_to_staging',
    start_date=datetime(2023, 7, 2),
    catchup=False,
    schedule_interval=None,
)

with dag:
    for f in files:
        t = PythonOperator(
            task_id=f'load_{f}',
            python_callable=upload_file,
            op_args=(f,),
        )
