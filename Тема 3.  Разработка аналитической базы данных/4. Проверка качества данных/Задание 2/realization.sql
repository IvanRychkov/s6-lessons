select count(*) as total, count(distinct id) as uniq, 'users' as dataset
from RYCHYRYCHYANDEXRU__STAGING.users
union all
select count(*), count(distinct id), 'groups'
from RYCHYRYCHYANDEXRU__STAGING.groups
union all
select count(*), count(distinct message_id), 'dialogs'
from RYCHYRYCHYANDEXRU__STAGING.dialogs;