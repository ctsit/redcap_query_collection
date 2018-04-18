-- deleted_projects.sql

-- status=3 indicates a deleted project
SELECT *
from redcap_projects as rcp
where status in (3);
