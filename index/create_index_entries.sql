
drop table if exists index_entries;

create table index_entries( 

  entry_id        integer      not null, 
  letter          varchar(3)   not null default '',
  entry_name      longtext     not null default '',
  xref_name       longtext     not null default '',
  entry_biblio_line   longtext     not null default '',
  entry_biblio_block  longtext     not null default '',

  primary key ( entry_id )
); 



