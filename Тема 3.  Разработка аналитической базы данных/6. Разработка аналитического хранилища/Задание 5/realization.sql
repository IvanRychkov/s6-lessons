drop table if exists RYCHYRYCHYANDEXRU__DWH.s_admins;
create table RYCHYRYCHYANDEXRU__DWH.s_admins
(
    hk_admin_id bigint not null REFERENCES RYCHYRYCHYANDEXRU__DWH.l_admins (hk_l_admin_id),
    is_admin    boolean,
    admin_from  datetime,
    load_dt     datetime,
    load_src    varchar(20)
)
    order by load_dt
    SEGMENTED BY hk_admin_id all nodes
    PARTITION BY load_dt::date
        GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


INSERT INTO RYCHYRYCHYANDEXRU__DWH.s_admins(hk_admin_id, is_admin, admin_from, load_dt, load_src)
select la.hk_l_admin_id,
       True  as is_admin,
       hg.registration_dt,
       now() as load_dt,
       's3'  as load_src
from RYCHYRYCHYANDEXRU__DWH.l_admins as la
         left join RYCHYRYCHYANDEXRU__DWH.h_groups as hg on la.hk_group_id = hg.hk_group_id;

-- 2

drop table if exists RYCHYRYCHYANDEXRU__DWH.s_group_name;
create table RYCHYRYCHYANDEXRU__DWH.s_group_name
(
    hk_group_id bigint not null REFERENCES RYCHYRYCHYANDEXRU__DWH.h_groups (hk_group_id),
    group_name  varchar(100),
    load_dt     datetime,
    load_src    varchar(20)
)
    order by load_dt
    SEGMENTED BY hk_group_id all nodes
    PARTITION BY load_dt::date
        GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


INSERT INTO RYCHYRYCHYANDEXRU__DWH.s_group_name(hk_group_id, group_name, load_dt, load_src)
select hk_group_id,
       group_name,
       now() as load_dt,
       's3'  as load_src
from RYCHYRYCHYANDEXRU__STAGING.groups as g
         join RYCHYRYCHYANDEXRU__DWH.h_groups as hg on g.id = hg.group_id;

-- 3

drop table if exists RYCHYRYCHYANDEXRU__DWH.s_group_private_status;
create table RYCHYRYCHYANDEXRU__DWH.s_group_private_status
(
    hk_group_id bigint not null REFERENCES RYCHYRYCHYANDEXRU__DWH.h_groups (hk_group_id),
    is_private  boolean,
    load_dt     datetime,
    load_src    varchar(20)
)
    order by load_dt
    SEGMENTED BY hk_group_id all nodes
    PARTITION BY load_dt::date
        GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


INSERT INTO RYCHYRYCHYANDEXRU__DWH.s_group_private_status(hk_group_id, is_private, load_dt, load_src)
select hk_group_id,
       g.is_private,
       now() as load_dt,
       's3'  as load_src
from RYCHYRYCHYANDEXRU__STAGING.groups as g
         join RYCHYRYCHYANDEXRU__DWH.h_groups as hg on g.id = hg.group_id;

-- 4

drop table if exists RYCHYRYCHYANDEXRU__DWH.s_dialog_info;
create table RYCHYRYCHYANDEXRU__DWH.s_dialog_info
(
    hk_message_id bigint not null REFERENCES RYCHYRYCHYANDEXRU__DWH.h_dialogs (hk_message_id),
    message       varchar(1000),
    message_from  int,
    message_to    int,
    load_dt       datetime,
    load_src      varchar(20)
)
    order by load_dt
    SEGMENTED BY hk_message_id all nodes
    PARTITION BY load_dt::date
        GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


INSERT INTO RYCHYRYCHYANDEXRU__DWH.s_dialog_info(hk_message_id, message, message_from, message_to, load_dt, load_src)
select hk_message_id,
       message,
       message_from,
       message_to,
       now() as load_dt,
       's3'  as load_src
from RYCHYRYCHYANDEXRU__STAGING.dialogs as d
         join RYCHYRYCHYANDEXRU__DWH.h_dialogs as hd on d.message_id = hd.message_id;

-- 5

drop table if exists RYCHYRYCHYANDEXRU__DWH.s_user_chatinfo;
create table RYCHYRYCHYANDEXRU__DWH.s_user_chatinfo
(
    hk_user_id bigint not null REFERENCES RYCHYRYCHYANDEXRU__DWH.h_users (hk_user_id),
    chat_name  varchar(200),
    load_dt    datetime,
    load_src   varchar(20)
)
    order by load_dt
    SEGMENTED BY hk_user_id all nodes
    PARTITION BY load_dt::date
        GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


INSERT INTO RYCHYRYCHYANDEXRU__DWH.s_user_chatinfo(hk_user_id, chat_name, load_dt, load_src)
select hk_user_id,
       chat_name,
       now() as load_dt,
       's3'  as load_src
from RYCHYRYCHYANDEXRU__STAGING.users as u
         join RYCHYRYCHYANDEXRU__DWH.h_users as hu on u.id = hu.user_id;

-- 6

drop table if exists RYCHYRYCHYANDEXRU__DWH.s_user_socdem;
create table RYCHYRYCHYANDEXRU__DWH.s_user_socdem
(
    hk_user_id bigint not null REFERENCES RYCHYRYCHYANDEXRU__DWH.h_users (hk_user_id),
    country    varchar(200),
    age        int,
    load_dt    datetime,
    load_src   varchar(20)
)
    order by load_dt
    SEGMENTED BY hk_user_id all nodes
    PARTITION BY load_dt::date
        GROUP BY calendar_hierarchy_day(load_dt::date, 3, 2);


INSERT INTO RYCHYRYCHYANDEXRU__DWH.s_user_socdem(hk_user_id, country, age, load_dt, load_src)
select hk_user_id,
       country,
       age,
       now() as load_dt,
       's3'  as load_src
from RYCHYRYCHYANDEXRU__STAGING.users as u
         join RYCHYRYCHYANDEXRU__DWH.h_users as hu on u.id = hu.user_id;
