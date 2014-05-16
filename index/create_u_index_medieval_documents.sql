
drop table if exists u_index_medieval_documents;

create table u_index_medieval_documents( 

  document_id integer not null auto_increment, 
  document_group integer null, 
  document_code varchar(12) null,
  document_code_sort varchar(12) null,
  document_name varchar(255) not null default '',

  start_date date null,
  end_date date null,

  document_type varchar(50) not null default 'undefined',

  date_in_words varchar(100) not null default '',
  start_year integer null,
  end_year integer null,

  primary key( document_id )
)  DEFAULT CHARSET=utf8;


-- N.B. with the current setup of MySQL, foreign key creation statements are silently ignored.
-- See http://stackoverflow.com/questions/380057/foreign-key-not-working-in-mysql-why-can-i-insert-a-value-thats-not-in-the-for
-- We would apparently need to change the underlying engine to INNODB, but I'm not quite sure
-- how to go about this, so will have to leave this pending for now.
alter table u_index_medieval_documents
add constraint foreign_document_group
foreign key ( document_group )
references u_index_medieval_doc_groups( doc_group_type_code );

 
