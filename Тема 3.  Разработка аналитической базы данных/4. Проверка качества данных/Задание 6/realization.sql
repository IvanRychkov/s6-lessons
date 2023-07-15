select count(*)
from RYCHYRYCHYANDEXRU__STAGING.groups g
where admin_id not in (select id from RYCHYRYCHYANDEXRU__STAGING.users);