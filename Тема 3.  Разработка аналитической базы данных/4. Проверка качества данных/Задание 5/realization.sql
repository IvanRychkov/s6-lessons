(SELECT max(registration_dt) < now()         as "no future dates",
        min(registration_dt) >= '2020-09-03' as "no false-start dates",
        'users'                              as dataset
 FROM RYCHYRYCHYANDEXRU__STAGING.users u)
UNION ALL
(SELECT max(registration_dt) < now(),
        min(registration_dt) >= '2020-09-03',
        'groups'
 FROM RYCHYRYCHYANDEXRU__STAGING.groups g)
UNION ALL
(SELECT max(message_ts) < now(),
        min(message_ts) >= '2020-09-03',
        'dialogs'
 FROM RYCHYRYCHYANDEXRU__STAGING.dialogs d);