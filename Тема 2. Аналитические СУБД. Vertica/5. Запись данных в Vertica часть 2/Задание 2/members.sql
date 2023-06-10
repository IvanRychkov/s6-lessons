drop table if exists members;
CREATE TABLE if not exists members
(
    id     int NOT NULL,
    age    int,
    gender char,
    email  varchar(50),
    CONSTRAINT C_PRIMARY PRIMARY KEY (id) DISABLED
);

truncate table members;
copy members (id, age, gender, email)
    from local '/Users/ivan/dev/s6-lessons/Тема 2. Аналитические СУБД. Vertica/5. Запись данных в Vertica часть 2/Задание 2/members.csv'
    delimiter ';'
    skip 1
    REJECTED DATA AS TABLE RYCHYRYCHYANDEXRU.members_rej
;