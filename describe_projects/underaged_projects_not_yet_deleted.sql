-- underaged_projects_not_yet_deleted.sql

-- status=3 indicates a deleted project
SELECT rcp.project_id, rcp.purpose, rcp.status, rcp.last_logged_event FROM redcap_projects as rcp
where status != 3
and datediff(now(), rcp.creation_time) < 365;
