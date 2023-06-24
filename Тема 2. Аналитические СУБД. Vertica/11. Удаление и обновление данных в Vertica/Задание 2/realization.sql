SET SESSION AUTOCOMMIT TO off;

truncate table members;

SELECT node_name, projection_name, deleted_row_count
FROM DELETE_VECTORS
where projection_name like 'members%';

SELECT deleted_row_count
FROM DELETE_VECTORS
where projection_name like 'members%'
-- group by node_name
order by deleted_row_count desc
limit 1;

ROLLBACK;