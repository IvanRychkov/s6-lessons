from conn_info import *  # noqa

with vertica_python.connect(**conn_info) as conn:
    curs = conn.cursor()
    insert_stmt = 'INSERT INTO BAD_IDEA VALUES ({},\'a\');'

    for i in range(0, N, batch):
        # будем отправлять сразу по несколько команд
        curs.execute(
            '\n'.join(
                [insert_stmt.format(i + j) for j in range(batch)])
        )

    conn.commit()
