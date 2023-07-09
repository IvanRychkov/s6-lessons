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

AWS_ACCESS_KEY_ID = "YCAJEWXOyY8Bmyk2eJL-hlt2K"
AWS_SECRET_ACCESS_KEY = "YCPs52ajb2jNXxOUsL4-pFDL1HnV2BCPd928_ZoA"
