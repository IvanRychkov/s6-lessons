import vertica_python  # noqa

conn_info = {'host': 'vertica.tgcloudenv.ru',
             'port': '5433',
             'user': 'rychyrychyandexru',
             'database': 'dwh',
             'autocommit': False,
             }

vertica_user = conn_info['user']
