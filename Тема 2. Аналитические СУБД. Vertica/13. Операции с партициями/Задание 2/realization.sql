create table
    dialogs_temp like dialogs
    including projections;

truncate table dialogs_temp;

insert into dialogs_temp
select message_id,
       message_ts,
       message_from,
       message_to,
       message,
       coalesce(message_type, '0') as message_type
from dialogs /* исходная таблица */
where datediff('month', message_ts, now()) < 4;

/* test */
select
    /* Если запрос вернёт хотя бы одну запись,
       эта функция выдаст ошибку */
    THROW_ERROR('Остались NULL в клоне!') as test_nulls
from dialogs_temp /* клон */
where message_type is NULL;

select max(message_ts)::date, min(message_ts)::date
from dialogs_temp;

select swap_partitions_between_tables(
               'dialogs_temp', /*укажите название таблицы 1*/
               '2023-03-01', /*укажите начальную партицую диапазона */
               '2023-05-21', /*укажите конечнцю партицию диапаона*/
               'dialogs' /*укажите название таблицы 2*/
           );

select
    /* Если запрос вернёт хотя бы одну запись,
       эта функция выдаст ошибку */
    THROW_ERROR('Остались NULL в основной таблице!') as test_nulls
-- max(message_ts)
from dialogs /* оригинал */
where message_type is NULL
  and datediff('month', message_ts, now()) < 4;
