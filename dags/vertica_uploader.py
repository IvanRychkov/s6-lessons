from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.models import Variable
from pendulum import datetime
import vertica_python
from conn_info import conn_info

files = [
    'users',
    'groups',
    'dialogs',
    'group_log'
]


def upload_file(table):
    with vertica_python.connect(
            password=Variable.get('RYCHYRYCHYANDEXRU_VERTICA_PASSWORD'),
            **conn_info
    ) as conn:
        curs = conn.cursor()
        insert_stmt = '''
        copy RYCHYRYCHYANDEXRU__STAGING.{table}
        from local '/data/{table}.csv'
        delimiter ','
        --enclosed by '"'
        --null ''
        skip 1
        -- rejected data as table RYCHYRYCHYANDEXRU__STAGING.{table}_rej
        '''
        curs.execute(insert_stmt.format(table=table))
        conn.commit()


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
