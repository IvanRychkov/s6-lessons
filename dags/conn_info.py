import vertica_python  # noqa

conn_info = {'host': 'vertica.tgcloudenv.ru',
             'port': '5433',
             'user': 'rychyrychyandexru',
             'password': 'EQjITFSka7dXH7z',
             'database': 'dwh',
             # Вначале он нам понадобится, а дальше — решите позже сами
             'autocommit': True
             }

vertica_user = conn_info['user']
