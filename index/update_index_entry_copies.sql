
-- Add decodes of flags embedded in the copy codes
update index_entry_copies
set survives_yn = 'y'
where copy_code like '%*%'
\p\g

update index_entry_copies
set printed_yn = 'y'
where copy_code like '%{P}%'
\p\g

update index_entry_copies
set uncertain_yn = 'y'
where copy_code like '%{+}%'
\p\g

update index_entry_copies
set duplicate_title_yn = 'y'
where copy_code like '%++%'
\p\g


-- Add document names etc.

update index_entry_copies 
set document_name = (select v.document_name
                     from index_medieval_documents_view v
                     where v.document_code = index_entry_copies.document_code
                     and v.document_code is not null
                     and v.document_code != 'X-' /*non-unique code*/)
where document_code is not null
and document_code != 'X-' /*non-unique code*/
\p\g


update index_entry_copies 
set doc_group_type = (select v.doc_group_type
                      from index_medieval_documents_view v
                      where v.document_code = index_entry_copies.document_code
                      and v.document_code is not null
                      and v.document_code != 'X-' /*non-unique code*/)
where document_code is not null
and document_code != 'X-' /*non-unique code*/
\p\g


update index_entry_copies 
set doc_group_type_name = (select v.doc_group_type_name
                           from index_medieval_documents_view v
                           where v.document_code = index_entry_copies.document_code
                           and v.document_code is not null
                           and v.document_code != 'X-' /*non-unique code*/)
where document_code is not null
and document_code != 'X-' /*non-unique code*/
\p\g


update index_entry_copies 
set doc_group_name = (select v.doc_group_name
                      from index_medieval_documents_view v
                      where v.document_code = index_entry_copies.document_code
                      and v.document_code is not null
                      and v.document_code != 'X-' /*non-unique code*/)
where document_code is not null
and document_code != 'X-' /*non-unique code*/
\p\g


-- Some groups of documents, particularly K and UO, plus R, do not seem to have been set up yet.
-- Fill in what information we can

update index_entry_copies 
set doc_group_type = 'K', doc_group_type_name = (select t.doc_group_type_name
                                                 from index_medieval_doc_group_types t
                                                 where t.doc_group_type_code = 'K')
where document_code like 'K%'
and doc_group_type is null
and doc_group_type_name is null
\p\g


update index_entry_copies 
set doc_group_type = 'UO', doc_group_type_name = (select t.doc_group_type_name
                                                  from index_medieval_doc_group_types t
                                                  where t.doc_group_type_code = 'UO')
where document_code like 'UO%'
and doc_group_type is null
and doc_group_type_name is null
\p\g


update index_entry_copies
set doc_group_type = 'R', doc_group_type_name = (select t.doc_group_type_name
                                                 from index_medieval_doc_group_types t
                                                 where t.doc_group_type_code = 'R')
where document_code like 'R%'
and doc_group_type is null
and doc_group_type_name is null
\p\g

-- There also seem to be a few documents where only the document type has been given
-- instead of a full code, e.g. BA instead of BA22. Once again, we can fill in a tiny bit here.

update index_entry_copies
set 

doc_group_type = (select t.doc_group_type_code
                  from index_medieval_doc_group_types t
                  where t.doc_group_type_code = index_entry_copies.document_code),

doc_group_type_name = (select t.doc_group_type_name
                       from index_medieval_doc_group_types t
                       where t.doc_group_type_code = index_entry_copies.document_code)
where doc_group_type is null
and doc_group_type_name is null
\p\g

-- And document codes like P9 that are in a valid format but just don't appear in Key.doc.
-- Presumably Key.doc is now a bit out of date.

update index_entry_copies
set doc_group_type = 'BA', doc_group_type_name = (select t.doc_group_type_name
                                                 from index_medieval_doc_group_types t
                                                 where t.doc_group_type_code = 'BA')
where document_code like 'BA%'
and doc_group_type is null
and doc_group_type_name is null
\p\g


update index_entry_copies
set doc_group_type = 'BC', doc_group_type_name = (select t.doc_group_type_name
                                                 from index_medieval_doc_group_types t
                                                 where t.doc_group_type_code = 'BC')
where document_code like 'BC%'
and doc_group_type is null
and doc_group_type_name is null
\p\g


update index_entry_copies
set doc_group_type = 'P', doc_group_type_name = (select t.doc_group_type_name
                                                 from index_medieval_doc_group_types t
                                                 where t.doc_group_type_code = 'P')
where document_code like 'P%'
and doc_group_type is null
and doc_group_type_name is null
\p\g




