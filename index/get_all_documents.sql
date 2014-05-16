select concat( doc_group_type, ', ', doc_group_type_name, ', ',  doc_group_name, ', ',  coalesce(document_code, 'No code'), ', ',  document_name ) as "Documents by institution type" from index_medieval_documents_view order by doc_group_type, coalesce( document_code_sort, '');
