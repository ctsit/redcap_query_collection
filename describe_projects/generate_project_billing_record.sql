-- Generate project billing record

-- projects in dev or prod status, > 1 yr old, > 500 attributes, <180 days since last loged event and good titles
-- uf_valued_project_details.csv
select rcp.project_id, rcp.app_title, rcp.creation_time, 
       ufpo.firstname as owner_firstname, ufpo.lastname as owner_lastname, ufpo.email as owner_email,
       project_pi_firstname, project_pi_lastname, project_irb_number
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
order by rcp.project_id desc;


-- active users and owners on projects above
-- active_users_and_owners_of_uf_valued_projects.csv
select rcp.project_id, rcp.app_title, rcp.creation_time, ufpo.email as owner_email, rcui.user_email
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join redcap_user_rights as rcur on (rcp.project_id = rcur.project_id)
inner join redcap_user_information as rcui on (rcur.username = rcui.username)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
where 
    rcui.user_suspended_time is null
    and datediff(now(), rcui.user_lastlogin) < 180
order by rcp.project_id desc;

-- distinct_active_users_of_uf_valued_projects.csv
select rcui.user_email, count(*) as qty
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join redcap_user_rights as rcur on (rcp.project_id = rcur.project_id)
inner join redcap_user_information as rcui on (rcur.username = rcui.username)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
where 
    rcui.user_suspended_time is null
    and datediff(now(), rcui.user_lastlogin) < 180
group by rcui.user_email
order by qty desc;

-- Count of significant projects by owner email
-- unique_owners_of_uf_valued_projects.csv
select ufpo.email as owner_email, count(*) as qty
from redcap_projects as rcp
inner join uf_valued_projects as ufvp on (rcp.project_id = ufvp.project_id)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
group by email
order by qty desc;
