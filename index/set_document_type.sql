update index_medieval_documents 
set document_type = 'undefined';

update index_medieval_documents 
set document_type = 'Henry de Kirkestede'
where document_group in (select doc_group_id from index_medieval_doc_groups where doc_group_type = 'K')
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'Registrum Anglie'
where (document_group in (select doc_group_id from index_medieval_doc_groups where doc_group_type = 'R')
or lower( document_name ) like '%registrum anglie%' )
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'Leland'
where document_name like '%Leland%'
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'Bale'
where document_name like '%Bale%'
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'Lincolnshire list'
where lower( document_name ) like '%lincolnshire list%'
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'catalogue'
where lower( document_name ) like '%catalogue%'
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'inventory'
where lower( document_name ) like '%inventory%'
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'bequest'
where (lower( document_name ) like '%bequest%'
or lower( document_name ) like '%bequeathed%'
or lower( document_name ) like '%will%'
or lower( document_name ) like '%testament%')
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'donation'
where (lower( document_name ) like '%donation%'
or lower( document_name ) like '%donated%'
or lower( document_name ) like '%donor%'
or lower( document_name ) like '%benefactor%'
or lower( document_name ) like '%gift%'
or lower( document_name ) like '%given%'
or lower( document_name ) like '%granted%')
and document_type = 'undefined'
;


update index_medieval_documents 
set document_type = 'electio'
where lower( document_name ) like '%electio%'
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'loan'
where (lower( document_name ) like '%loan%'
or lower( document_name ) like '%borrowed%'
or lower( document_name ) like '%borrower%')
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'Reginensis/Italian visitor'
where (lower( document_name ) like '%anonymus reginensis%'
or lower( document_name ) like '%italian visitor%')
and document_type = 'undefined'
;

update index_medieval_documents 
set document_type = 'accounts'
where (lower( document_name ) like '%account%'
or lower( document_name ) like '%bill%'
or lower( document_name ) like '%bought%'
or lower( document_name ) like '%expenditure%'
or lower( document_name ) like '%expenses%'
or lower( document_name ) like '%payment%'
or lower( document_name ) like '%purchase%'
or lower( document_name ) like '%receipt%'
or lower( document_name ) like '%valuation%')
and document_type = 'undefined'
;
