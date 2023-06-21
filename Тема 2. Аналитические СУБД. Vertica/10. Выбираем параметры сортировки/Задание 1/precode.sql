drop table if exists dialogs;
create table dialogs
(
    message_id    int PRIMARY KEY,
    message_ts    timestamp(6),
    message_from  int REFERENCES members (id),
    message_to    int REFERENCES members (id),
    message       varchar(1000),
    message_group int
)
    order by message_from, message_ts
    SEGMENTED BY hash(message_id) all nodes;

-- truncate table dialogs;
copy dialogs (message_id, message_ts, message_from, message_to, message, message_group)
    from local '//Users/ivan/dev/s6-lessons/Тема 2. Аналитические СУБД. Vertica/10. Выбираем параметры сортировки/Задание 1/dialogs.csv'
    delimiter ',';

truncate table members;
copy members (id, age, gender, email enforcelength)
    from local '/Users/ivan/dev/s6-lessons/Тема 2. Аналитические СУБД. Vertica/5. Запись данных в Vertica часть 2/Задание 2/members.csv'
    delimiter ';'
    rejected data as table members_rej;
select * from members limit 10;