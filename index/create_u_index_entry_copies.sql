drop table if exists u_index_entry_copies;

create table u_index_entry_copies( 

  entry_id          integer      not null, 
  entry_book_count  integer      not null, 
  copy_count        integer      not null, 

  copy_code         varchar(255) not null default '',
  document_code     varchar(12)  null,
  seqno_in_document integer      null,

  copy_notes        longtext     not null default '',

  document_name       varchar(255),
  doc_group_name      varchar(255),
  doc_group_type      varchar(12), 
  doc_group_type_name varchar(255),

  document_code_sort  varchar(12),

  printed_yn          varchar(1) not null default 'n',
  survives_yn         varchar(1) not null default 'n',
  uncertain_yn        varchar(1) not null default 'n',
  duplicate_title_yn  varchar(1) not null default 'n',

  primary key ( entry_id, entry_book_count, copy_count )
)   DEFAULT CHARSET=utf8; 



