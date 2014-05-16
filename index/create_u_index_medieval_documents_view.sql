
create or replace view u_index_medieval_documents_view
as select
  g.doc_group_type,
  gt.doc_group_type_name,
  g.doc_group_name,
  d.document_code,
  d.document_code_sort,
  d.document_name,
  d.document_id,
  g.doc_group_id,
  gt.doc_group_type_parent,
  d.start_date,
  d.end_date,
  d.document_type,
  d.date_in_words,
  d.start_year,
  d.end_year
from
  index_medieval_doc_group_types gt, -- no need for UTF-8 version of this one, it is completely ASCII
  index_medieval_doc_groups g,       -- no need for UTF-8 version of this one, it is completely ASCII
  u_index_medieval_documents d
where
  g.doc_group_type = gt.doc_group_type_code
and
  g.doc_group_id = d.document_group
order by
  doc_group_type,
  doc_group_name,
  document_code_sort;


