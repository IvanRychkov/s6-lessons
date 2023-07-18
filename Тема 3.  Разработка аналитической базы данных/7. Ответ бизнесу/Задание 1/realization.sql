with old_groups as (select hk_group_id
                    from RYCHYRYCHYANDEXRU__DWH.h_groups
                    order by registration_dt
                    limit 10),
     old_group_messages as (select hk_message_id
                            from RYCHYRYCHYANDEXRU__DWH.l_groups_dialogs
                            where hk_group_id in (select hk_group_id from old_groups)),
     message_senders as (select hk_user_id
                         from RYCHYRYCHYANDEXRU__DWH.l_user_message
                         where hk_message_id in (select hk_message_id from old_group_messages))
select age, count(distinct ms.hk_user_id) as "count"
from message_senders ms
         join RYCHYRYCHYANDEXRU__DWH.s_user_socdem us
              using (hk_user_id)
group by age
order by "count" desc;
