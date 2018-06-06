-- all_projects_with_description_pi_and_owner.sql
create temporary table redcap_project_status_lu (
  id int(1) NOT NULL,
  label varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


insert INTO redcap_project_status_lu VALUES (0, "Development");
insert INTO redcap_project_status_lu VALUES (1, "Production");
insert INTO redcap_project_status_lu VALUES (2, "Inactive");
insert INTO redcap_project_status_lu VALUES (3, "Archived");


create temporary table redcap_project_purpose_lu (
  id int(2) NOT NULL,
  label varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

insert INTO redcap_project_purpose_lu VALUES (4, "Operational Support");
insert INTO redcap_project_purpose_lu VALUES (2, "Research");
insert INTO redcap_project_purpose_lu VALUES (3, "Quality Improvement");
insert INTO redcap_project_purpose_lu VALUES (1, "Other");
insert INTO redcap_project_purpose_lu VALUES (0, "Practice / Just for fun");

SELECT rcp.project_id, app_title, status, pslu.label as status_label, purpose, pplu.label as purpose_label, project_pi_firstname,
project_pi_lastname, project_pi_email, project_irb_number, rcp.date_deleted,
po.username as owner_username, po.email as owner_email, po.firstname as owner_first_name, po.lastname as owner_last_name
from redcap_projects as rcp
inner join uf_project_ownership po on (rcp.project_id = po.project_id)
left join redcap_project_purpose_lu pplu on (rcp.purpose = pplu.id)
left join redcap_project_status_lu pslu on (rcp.status = pslu.id);
