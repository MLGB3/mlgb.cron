
drop table if exists index_mlgb_links;

create table index_mlgb_links( 

  index_mlgb_link_id integer not null auto_increment, 
  mlgb_book_id       integer not null, 
  document_code      varchar(12) not null default '',
  seqno_in_document  integer not null default 0,

  primary key( index_mlgb_link_id ),

  -- N.B. with the current setup of MySQL, foreign key creation statements are silently ignored.
  -- See http://stackoverflow.com/questions/380057/foreign-key-not-working-in-mysql-why-can-i-insert-a-value-thats-not-in-the-for
  -- We would apparently need to change the underlying engine to INNODB, but I'm not quite sure
  -- how to go about this, so will have to leave this pending for now.
  foreign key ( mlgb_book_id )
  references books_book( id )
  
);


 
