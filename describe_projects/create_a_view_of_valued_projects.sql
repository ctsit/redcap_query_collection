-- Create a view of valued projects
-- These are projects that are:
--   in dev or prod status
--   titles do not look like copies of projects
--   > 1 yr old
--   > 1000 saved attributes
--   < 180 days since last logged event

create or replace view uf_valued_projects as
select rcp.project_id, rcps.saved_attribute_count, rcrc.record_count,
       ufufdbp.uploaded_file_count, ufufdbp.total_file_storage_in_mb
from redcap_projects as rcp
left join redcap_record_counts rcrc on (rcp.project_id = rcrc.project_id)
left join redcap_project_stats as rcps on (rcp.project_id = rcps.project_id)
left join uf_uploaded_file_data_by_project as ufufdbp on (rcp.project_id = ufufdbp.project_id)
where
    rcp.status in (0,1)
    and rcp.app_title not like "%copy%"
    and rcp.app_title not like "% test %"
    and datediff(now(), rcp.creation_time) > 365
    and rcps.saved_attribute_count > 1000
    and datediff(now(), rcp.last_logged_event) < 180;
