drop table if exists dialogs;

create table dialogs
(
    message_id   int PRIMARY KEY,
    message_ts   timestamp(6)                NOT NULL,
    message_from int REFERENCES members (id) NOT NULL,
    message_to   int REFERENCES members (id) NOT NULL,
    message      varchar(1000),
    message_type varchar(100)
)
    order by message_from, message_ts
    SEGMENTED BY hash(message_id) all nodes
    PARTITION BY message_ts::date
        group by calendar_hierarchy_day(message_ts::date, 3, 2)
;