-- Generate project billing record

-- projects in dev or prod status, > 1 yr old, > 500 attributes, <180 days since last loged event and good titles
select rcp.project_id, rcp.app_title, rcp.project_name, rcp.creation_time
from redcap_projects as rcp
inner join redcap_project_stats as rcps on (rcp.project_id = rcps.project_id)
where 
	rcp.status in (0,1)
    and rcp.purpose != 0
    and rcp.app_title not like "%copy%"
    and rcp.app_title not like "% test %"
    and datediff(now(), rcp.creation_time) > 365
    and rcps.saved_attribute_count > 1000
    and datediff(now(), rcp.last_logged_event) < 180
order by rcp.project_id desc;


-- active users and owners on projects above
select rcp.project_id, rcp.app_title, rcp.project_name, rcp.creation_time, rcui_owner.user_email as owner_email, rcui.user_email
from redcap_projects as rcp
inner join redcap_project_stats as rcps on (rcp.project_id = rcps.project_id)
left join redcap_user_rights as rcur on (rcp.project_id = rcur.project_id)
left join redcap_user_roles as rcuro on (rcp.project_id = rcuro.project_id and rcur.role_id = rcuro.role_id)
inner join redcap_user_information as rcui on (rcur.username = rcui.username)
left join rcpo_test as rcpo on (rcp.project_id = rcpo.pid)
inner join redcap_user_information as rcui_owner on (rcpo.username = rcui_owner.username)
where 
	rcp.status in (0,1)
    and rcp.purpose != 0
    and rcp.app_title not like "%copy%"
    and rcp.app_title not like "% test %"
    and datediff(now(), rcp.creation_time) > 365
    and rcps.saved_attribute_count > 1000
    and datediff(now(), rcp.last_logged_event) < 180
    and rcui.user_suspended_time is null
    and datediff(now(), rcui.user_lastlogin) < 180
order by rcp.project_id desc;

-- projects in dev or prod status, > 1 yr old, > 500 attributes, <180 days since last loged event and good titles
select rcui_owner.user_email as owner_email, count(*)
from redcap_projects as rcp
inner join redcap_project_stats as rcps on (rcp.project_id = rcps.project_id)
left join rcpo_test as rcpo on (rcp.project_id = rcpo.pid)
left join redcap_user_information as rcui_owner on (rcpo.username = rcui_owner.username)
where 
	rcp.status in (0,1)
    and rcp.purpose != 0
    and rcp.app_title not like "%copy%"
    and rcp.app_title not like "% test %"
    and datediff(now(), rcp.creation_time) > 365
    and rcps.saved_attribute_count > 1000
    and datediff(now(), rcp.last_logged_event) < 180
group by owner_email;
