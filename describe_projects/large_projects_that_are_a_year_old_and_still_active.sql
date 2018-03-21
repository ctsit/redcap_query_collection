-- Large REDCap Projects that are a year old and still active
--
-- Requirements
--   This query requires the last_user concept be added via the Report Production Candidates module.  See https://github.com/ctsit/report_production_candidates

SELECT rcps.project_id, rcp.app_title, rcp.creation_time, rcp.purpose, rcp.status, rcp.last_logged_event FROM redcap_project_stats as rcps
inner join redcap_projects as rcp on (rcps.project_id = rcp.project_id)
where rcps.saved_attribute_count > 1000
and rcp.app_title not like "%copy%"
and rcp.app_title not like "% test %"
and rcp.purpose != 0
and rcp.status in (0,1)
and datediff(now(), rcp.creation_time) > 365
and datediff(now(), rcp.last_logged_event) < 90;
