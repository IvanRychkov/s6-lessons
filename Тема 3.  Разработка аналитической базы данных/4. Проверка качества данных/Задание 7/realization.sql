with ids as (
    select id from RYCHYRYCHYANDEXRU__STAGING.users
)
(SELECT count(1), 'missing group admin info' as info
FROM RYCHYRYCHYANDEXRU__STAGING.groups g
WHERE admin_id not in (select id from RYCHYRYCHYANDEXRU__STAGING.users))
UNION ALL
(SELECT COUNT(1), 'missing sender info'
FROM RYCHYRYCHYANDEXRU__STAGING.dialogs d
WHERE message_from not in (select id from RYCHYRYCHYANDEXRU__STAGING.users))
UNION ALL
(SELECT COUNT(1), 'missing receiver info'
FROM RYCHYRYCHYANDEXRU__STAGING.dialogs d
WHERE message_to not in (select id from RYCHYRYCHYANDEXRU__STAGING.users))
UNION ALL
(SELECT COUNT(1), 'norm receiver info'
FROM RYCHYRYCHYANDEXRU__STAGING.dialogs d
WHERE message_to in (select id from RYCHYRYCHYANDEXRU__STAGING.users))