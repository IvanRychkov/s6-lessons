drop table if exists RYCHYRYCHYANDEXRU__DWH.s_auth_history;
create table RYCHYRYCHYANDEXRU__DWH.s_auth_history
(
    hk_l_user_group_activity int references RYCHYRYCHYANDEXRU__DWH.l_user_group_activity (hk_l_user_group_activity),
    user_id_from             int,
    event                    varchar(6)  not null,
    event_dt                 timestamp   not null,
    load_dt                  timestamp   not null,
    load_src                 varchar(20) not null
)
    order by load_dt
    segmented by hk_l_user_group_activity all nodes
    partition by load_dt::date group by calendar_hierarchy_day(load_dt::date, 3, 2);


insert into RYCHYRYCHYANDEXRU__DWH.s_auth_history (hk_l_user_group_activity, user_id_from, event, event_dt, load_dt,
                                                   load_src)
select hash(hk_user_id, hk_group_id),
       user_id_from,
       event,
       datetime,
       now(),
       's3'
from RYCHYRYCHYANDEXRU__STAGING.group_log l
         left join RYCHYRYCHYANDEXRU__DWH.l_user_group_activity hu
                   on hash(l.user_id) = hu.hk_user_id
                       and hash(l.group_id) = hu.hk_group_id
-- Догружаем только инкремент
where datetime > (select nvl(max(event_dt), '2000-01-01') from RYCHYRYCHYANDEXRU__DWH.s_auth_history)
;