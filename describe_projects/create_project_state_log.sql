-- project_state_log.sql
-- Save snapshots of project details to allow retrospective analysis throughout a project's lifecycle

create table project_state_log as
select now() as report_date,
    rcp.project_id, rcp.project_name, rcp.app_title, rcp.status, rcp.creation_time, rcp.production_time,
    rcp.inactive_time, rcui.username as creator, rcp.surveys_enabled, rcp.repeatforms, rcp.scheduling,
    rcp.purpose, rcp.purpose_other, rcp.double_data_entry, rcp.randomization, rcp.template_id, rcp.date_deleted,
    rcp.last_logged_event,
    rcps.saved_attribute_count, rcrc.record_count,
    ufufdbp.uploaded_file_count, ufufdbp.total_file_storage_in_mb,
    ufpo.username as owner_username,
    ufpo.firstname as owner_firstname, ufpo.lastname as owner_lastname, ufpo.email as owner_email,
    project_pi_firstname, project_pi_lastname, project_pi_email, project_irb_number
from redcap_projects as rcp
left join redcap_record_counts rcrc on (rcp.project_id = rcrc.project_id)
left join redcap_project_stats as rcps on (rcp.project_id = rcps.project_id)
left join uf_uploaded_file_data_by_project as ufufdbp on (rcp.project_id = ufufdbp.project_id)
left join uf_project_ownership as ufpo on (rcp.project_id = ufpo.project_id)
left join redcap_user_information as rcui on (rcp.created_by = rcui.ui_id);
