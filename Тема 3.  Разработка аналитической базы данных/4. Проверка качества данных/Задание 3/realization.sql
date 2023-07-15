select count(*), count(distinct hash(group_name))
from RYCHYRYCHYANDEXRU__STAGING.groups;


select 1 as i, hash(1) as i_hash, hash('123AFJDGTQ');