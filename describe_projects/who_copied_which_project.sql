-- who_copied_which_project.sql

-- redcap_log_event logs projects created by project copy operations,  but it
-- does not log the id of the source project. That fact can be  acquired from
-- the redcap_log_view table. It records who accessed the copy_project_form
-- and what project_id was in effect when they did.  This project id is the
-- source project for any 'Copy project' event  in redcap_log_event with the
-- same user and a slighlty larger time stamp.

-- Credit to Luke Stevens for this data hack.

SELECT log_view_id, ts, user, page, project_id FROM redcap_log_view
where page = 'ProjectGeneral/copy_project_form.php';
