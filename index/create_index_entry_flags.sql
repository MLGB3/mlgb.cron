
drop table if exists index_entry_flags;

create table index_entry_flags( 

  flag_id      integer     not null auto_increment,
  flag_code    varchar(20) not null,
  flag_desc    longtext    not null,
  flag_example varchar(50) not null default '',

  primary key ( flag_id )
); 



