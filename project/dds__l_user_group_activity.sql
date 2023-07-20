drop table if exists RYCHYRYCHYANDEXRU__DWH.l_user_group_activity;
create table RYCHYRYCHYANDEXRU__DWH.l_user_group_activity
(
    hk_l_user_group_activity int not null primary key,
    hk_user_id               int references RYCHYRYCHYANDEXRU__DWH.h_users (hk_user_id),
    hk_group_id              int references RYCHYRYCHYANDEXRU__DWH.h_groups (hk_group_id),
    load_dt                  timestamp,
    load_src                 varchar(20)
)
    order by load_dt
    segmented by hk_l_user_group_activity all nodes
    partition by load_dt::date group by calendar_hierarchy_day(load_dt::date, 3, 2);


insert into RYCHYRYCHYANDEXRU__DWH.l_user_group_activity (hk_l_user_group_activity, hk_user_id, hk_group_id, load_dt, load_src)
select hash(hk_user_id, hk_group_id),
       hu.hk_user_id,
       hg.hk_group_id,
       now(),
       's3'
/* имеет смысл добавлять только уникальные сочетания юзеров-групп,
   тк вся информация о событиях будет браться из сателлита с размножением строк,
   а здесь будет храниться только факт наличия активности */
from (select distinct user_id, group_id from RYCHYRYCHYANDEXRU__STAGING.group_log) l
         left join RYCHYRYCHYANDEXRU__DWH.h_users hu on l.user_id = hu.user_id
         left join RYCHYRYCHYANDEXRU__DWH.h_groups hg on l.group_id = hg.group_id
-- вставляем только новые данные
where hash(hk_user_id, hk_group_id) not in
      (select hk_l_user_group_activity from RYCHYRYCHYANDEXRU__DWH.l_user_group_activity);