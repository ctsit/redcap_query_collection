-- Insignificant REDCap projects that can probably be deleted
--
-- Requirements
--   This query requires the last_user concept be added via the Report Production Candidates module.  See https://github.com/ctsit/report_production_candidates

SELECT rcps.project_id, last_user, rcp.purpose, rcp.status, rcp.last_logged_event FROM redcap_project_stats as rcps
inner join redcap_projects as rcp on (rcps.project_id = rcp.project_id)
where saved_attribute_count = 0
and status in (0,2,3)
and (datediff(now(), rcp.last_logged_event) > 180
or rcp.last_logged_event is null);
