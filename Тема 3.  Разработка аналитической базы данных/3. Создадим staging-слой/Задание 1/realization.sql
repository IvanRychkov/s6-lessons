drop table if exists RYCHYRYCHYANDEXRU__STAGING.users cascade;
create table RYCHYRYCHYANDEXRU__STAGING.users
(
    id              int primary key,
    chat_name       varchar(200),
    registration_dt timestamp,
    country         varchar(200),
    age             int
)
    order by id;

drop table if exists RYCHYRYCHYANDEXRU__STAGING.groups cascade;
create table RYCHYRYCHYANDEXRU__STAGING.groups
(
    id              int primary key,
    admin_id        int references RYCHYRYCHYANDEXRU__STAGING.users (id),
    group_name      varchar(100),
    registration_dt timestamp,
    is_private      boolean
) order by id, admin_id
    PARTITION BY registration_dt::date
        GROUP BY calendar_hierarchy_day(registration_dt::date, 3, 2);

drop table if exists RYCHYRYCHYANDEXRU__STAGING.dialogs;
create table RYCHYRYCHYANDEXRU__STAGING.dialogs
(
    message_id    int           not null primary key,
    message_ts    timestamp     not null,
    message_from  int references RYCHYRYCHYANDEXRU__STAGING.users (id),
    message_to    int references RYCHYRYCHYANDEXRU__STAGING.users (id),
    message       varchar(1000) not null,
    message_group int references RYCHYRYCHYANDEXRU__STAGING.groups (id)
)
    order by message_id
    partition by message_ts::date
        group by calendar_hierarchy_day(message_ts::date, 3, 2);
