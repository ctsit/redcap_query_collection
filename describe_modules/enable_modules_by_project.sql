-- enable_modules_by_project.sql

SELECT ems.project_id, app_title, directory_prefix
FROM redcap_external_module_settings as ems
inner join redcap_external_modules as em on (ems.external_module_id = em.external_module_id)
inner join redcap_projects as p on (ems.project_id = p.project_id)
where 
`key` = "enabled" and 
value = "true" and 
ems.project_id is not null 
order by ems.project_id;