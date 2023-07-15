SELECT min(registration_dt)         as datestamp,
       'earliest user registration' as info
FROM RYCHYRYCHYANDEXRU__STAGING.users
UNION ALL
SELECT max(registration_dt), 'latest user registration'
FROM RYCHYRYCHYANDEXRU__STAGING.users u
union all
select min(registration_dt), 'earliest group registration'
from RYCHYRYCHYANDEXRU__STAGING.groups
union all
select max(registration_dt), 'earliest group creation'
from RYCHYRYCHYANDEXRU__STAGING.groups
union all
select min(message_ts), 'earliest dialog message'
from RYCHYRYCHYANDEXRU__STAGING.dialogs
union all
select max(message_ts), 'latest dialog message'
from RYCHYRYCHYANDEXRU__STAGING.dialogs
;