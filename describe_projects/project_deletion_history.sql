-- project_deletion_history.sql

-- The redcap_log_event table is among the largest redcap tables. In the test
-- instance where this script was developed it is 2.2m rows The same system
-- has 29m rows in the corresponding redcap_data table. A row count in the
-- millions is completely normal. To keep the query fast, note the utiltity of
-- these indexed columns:
--
--   description
--     description is indexed by default
--     description has a cardinality of 1076
--     description like "%delete%project%" represents 0.07% of the 2.2 million rows
--
--   object_type = "redcap_projects"
--     object_type is indexed by default
--     object_types has a cardinality of 182 in our test system.
--     object_type = "redcap_projects" represents 2.5% of the 2.2m rows in redcap_log_event
--
--   event = "MANAGE"
--     event is not indexed by default
--     event has a cardinality of 10 in our test system.
--     event = "MANAGE" represents 50% of the 2.2m rows in redcap_log_event
--     all records with object_type = "redcap_projects" also have event = "MANAGE"
--     event is not as useful object_type for narrowing the row count.
--
-- Every project deletion is composed of multiple events. The simplest event
-- is a deletion by a user followed by a permanent deletion by the system via
-- a cron job 30 days later. While admins can always do this, users are only
-- allowed to delete non-production projects. For production projects, users
-- must submit a request to delete.  An admin then deletes the project.  30
-- days later the system will permanently delete the project via a cron job.
-- As project can be undeleted before the permanent deletion and/or changes
-- status, the above sequences can have sub-loops and intermingle.
--
-- To address who wanted a project deleted and got it done, one must find the
-- last "Send request to delete project" or "Delete project" event to get the
-- username and the "Permanently delete project" event to verify the deletion.
-- If both a request and a delete event preceed the "Permanently delete
-- project" event, the username on the request should be consider the
-- deleter.  The admin who executed the task is just the custodian.

select *,
  concat_ws('-', substr(ts,1,4), substr(ts,5,2), substr(ts,7,2)) as event_date
from redcap_log_event
where
description in (
  "Send request to delete project",
  "Delete project",
  "Permanently delete project",
  "Restore/undelete project"
  )
order by project_id desc, ts asc
limit 1000000;
