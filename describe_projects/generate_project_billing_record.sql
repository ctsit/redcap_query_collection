-- Generate project billing record

-- projects in dev or prod status, > 1 yr old, > 500 attributes, <180 days since last loged event and good titles
select rcp.project_id, rcp.app_title, rcp.project_name, rcp.creation_time
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
order by rcp.project_id desc;


-- active users and owners on projects above
select rcp.project_id, rcp.app_title, rcp.project_name, rcp.creation_time, ufpo.email as owner_email, rcui.user_email
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join redcap_user_rights as rcur on (rcp.project_id = rcur.project_id)
inner join redcap_user_information as rcui on (rcur.username = rcui.username)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
where 
    rcui.user_suspended_time is null
    and datediff(now(), rcui.user_lastlogin) < 180
order by rcp.project_id desc;

-- Count of significant projects by owner email
select ufpo.email as owner_email, count(*)
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
group by email;
