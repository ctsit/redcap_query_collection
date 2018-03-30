-- Create a view that quantifies uploaded file data by project
-- Delineates the upload files from downloaded files by looking for null rows in the
--   redcap_docs table when redcap_edocs_metadata is joined to it.
--
-- create_uf_uploaded_file_data_by_project.sql
create view uf_uploaded_file_data_by_project as
select rcedm.project_id, count(*) as uploaded_file_count, round(sum(rcedm.doc_size)/1024/1024) as total_file_storage_in_mb
from redcap_edocs_metadata as rcedm
left join redcap_docs_to_edocs as rcdted on (rcedm.doc_id = rcdted.doc_id)
left join redcap_docs as rcd on (rcdted.docs_id = rcd.docs_id)
where rcd.docs_id is null
group by rcedm.project_id
order by uploaded_file_count desc;
