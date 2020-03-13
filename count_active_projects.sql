-- N=365
select count(*) from redcap_projects
where 
last_logged_event is not null and 
date_deleted is null and 
datediff(now(), last_logged_event) <= 365;

-- N=90
select count(*) from redcap_projects
where 
last_logged_event is not null and 
date_deleted is null and 
datediff(now(), last_logged_event) <= 90;

-- N=30
select count(*) from redcap_projects
where 
last_logged_event is not null and 
date_deleted is null and 
datediff(now(), last_logged_event) <= 30;
    
    
  
  

