# Stats we could present on the redcap.ctsi home page

# Active project count
SELECT count(*)  as n
FROM ctsi_redcap.redcap_projects
where date_deleted is null;

# Projects created in the past 30 days
SELECT count(*)  as n
FROM ctsi_redcap.redcap_projects
where date_deleted is null and
datediff(now(), creation_time) <= 30;

# Projects deleted in the past 30 days
SELECT count(*)  as n
FROM ctsi_redcap.redcap_projects
where date_deleted is not null and
datediff(now(), date_deleted) <= 30;

# Projects moved to production in the past 30 days
SELECT count(*)  as n
FROM ctsi_redcap.redcap_projects
where date_deleted is null and
datediff(now(), production_time) <= 30;

# Users active in the past 30 
select count(*) as n
from redcap_user_information
where datediff(now(), user_lastactivity) <= 30
and user_suspended_time is NULL;


# All metrics suitable for publication combined into a single select
select 
(SELECT count(*)  as n
FROM ctsi_redcap.redcap_projects
where date_deleted is null) as count_of_existing_projects,
(SELECT count(*)  as n
FROM ctsi_redcap.redcap_projects
where date_deleted is null and
datediff(now(), creation_time) <= 30) as count_of_projects_created_in_the_past_30_days,
(SELECT count(*)  as n
FROM ctsi_redcap.redcap_projects
where date_deleted is null and
datediff(now(), production_time) <= 30) as count_of_projects_moved_to_production_in_the_past_30_days,
(select count(*) as n
from redcap_user_information
where datediff(now(), user_lastactivity) <= 30
and user_suspended_time is NULL) as count_of_users_active_in_the_past_30_days
from dual;

