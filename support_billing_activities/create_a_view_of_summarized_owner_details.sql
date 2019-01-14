-- create a view of summarized owner details
create or replace view uf_project_ownership as
select rcpo.pid as project_id, rcpo.username, rcui.user_email as email, rcui.user_firstname as firstname, rcui.user_lastname as lastname
from redcap_entity_project_ownership as rcpo
left join redcap_user_information as rcui on (rcpo.username = rcui.username)
where rcpo.username is not null
  UNION
select pid, username, email, firstname, lastname
from redcap_entity_project_ownership as rcpo
where rcpo.username is null;
