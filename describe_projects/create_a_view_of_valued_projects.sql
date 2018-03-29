-- Create a view of valued projects
-- Theese are projects that are:
--   in dev or prod status
--   project is not "Practice just for fun"
--   titles do not look like copies of projects
--   > 1 yr old
--   > 1000 saved attributes
--   < 180 days since last logged event

create or replace view uf_valued_projects as
select rcp.project_id
from redcap_projects as rcp
left join redcap_project_stats as rcps on (rcp.project_id = rcps.project_id)
where
    rcp.status in (0,1)
    and rcp.purpose != 0
    and rcp.app_title not like "%copy%"
    and rcp.app_title not like "% test %"
    and datediff(now(), rcp.creation_time) > 365
    and rcps.saved_attribute_count > 1000
    and datediff(now(), rcp.last_logged_event) < 180;

