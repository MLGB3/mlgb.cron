
drop table if exists index_medieval_doc_group_types;

create table index_medieval_doc_group_types( 

  doc_group_type_code varchar(12) not null, 
  doc_group_type_name varchar(255) not null,

  doc_group_type_parent varchar(12) null,

  primary key ( doc_group_type_code )
); 



