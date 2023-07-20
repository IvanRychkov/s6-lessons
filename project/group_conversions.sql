set search_path = RYCHYRYCHYANDEXRU__DWH;

with old_groups as (
    -- 10 самых старых групп
    select hk_group_id
    from h_groups
    order by registration_dt
    limit 10),
     -- Кол-во юзеров в старых группах, у которых было событие 'add'
     user_group_log as (select hk_group_id,
                               count(hk_user_id) as cnt_added_users
                        from l_user_group_activity
                        where hk_group_id in (select hk_group_id from old_groups)
                          and hk_l_user_group_activity in
                            -- Среди активности которых есть событие добавления
                              (select distinct hk_l_user_group_activity from s_auth_history where event = 'add')
                        group by hk_group_id),
     -- Количество уникальных юзеров, у которых есть сообщение в старых группах
     user_group_messages as (select hk_group_id,
                                    count(distinct hk_user_id) as cnt_users_in_group_with_messages
                             from l_groups_dialogs gd
                                      join l_user_message um using (hk_message_id)
                             where hk_group_id in (select hk_group_id
                                                   from old_groups)
                             group by hk_group_id)


select ug.hk_group_id,
       cnt_added_users,
       cnt_users_in_group_with_messages,
       cnt_users_in_group_with_messages / cnt_added_users group_conversion
from user_group_log ug
         join user_group_messages using (hk_group_id)
order by group_conversion desc