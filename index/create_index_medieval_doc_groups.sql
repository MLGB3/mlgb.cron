
drop table if exists index_medieval_doc_groups;

create table index_medieval_doc_groups( 

  doc_group_id integer not null auto_increment, 
  doc_group_type varchar(12) not null, 
  doc_group_name varchar(255) not null default '',

  primary key( doc_group_id ),

  -- N.B. with the current setup of MySQL, foreign key creation statements are silently ignored.
  -- See http://stackoverflow.com/questions/380057/foreign-key-not-working-in-mysql-why-can-i-insert-a-value-thats-not-in-the-for
  -- We would apparently need to change the underlying engine to INNODB, but I'm not quite sure
  -- how to go about this, so will have to leave this pending for now.
  foreign key ( doc_group_type )
  references index_medieval_doc_group_types( doc_group_type_code )
  
);


 
