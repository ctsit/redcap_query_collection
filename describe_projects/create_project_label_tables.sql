-- create_project_label_tables.sql
-- Create a table of project status labels
create temporary table redcap_project_status_lu (
  id int(1) NOT NULL,
  label varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


insert INTO redcap_project_status_lu VALUES (0, "Development");
insert INTO redcap_project_status_lu VALUES (1, "Production");
insert INTO redcap_project_status_lu VALUES (2, "Inactive");
insert INTO redcap_project_status_lu VALUES (3, "Archived");


-- Create a table of project purpose labels
create temporary table redcap_project_purpose_lu (
  id int(2) NOT NULL,
  label varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

insert INTO redcap_project_purpose_lu VALUES (4, "Operational Support");
insert INTO redcap_project_purpose_lu VALUES (2, "Research");
insert INTO redcap_project_purpose_lu VALUES (3, "Quality Improvement");
insert INTO redcap_project_purpose_lu VALUES (1, "Other");
insert INTO redcap_project_purpose_lu VALUES (0, "Practice / Just for fun");
