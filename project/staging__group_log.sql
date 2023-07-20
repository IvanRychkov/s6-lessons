drop table if exists RYCHYRYCHYANDEXRU__STAGING.group_log;
create table RYCHYRYCHYANDEXRU__STAGING.group_log
(
    group_id     int        not null primary key,
    user_id      int        not null,
    user_id_from int,
    event        varchar(6) not null,
    datetime     timestamp  not null
)
    order by group_id, event, datetime
    segmented by hash(group_id) all nodes
    partition by datetime::date
        group by calendar_hierarchy_day(datetime::date, 3, 2);
