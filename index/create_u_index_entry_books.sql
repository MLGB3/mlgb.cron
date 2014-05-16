
drop table if exists u_index_entry_books;

create table u_index_entry_books( 

  entry_id         integer      not null, 
  entry_book_count integer      not null, 

  role_in_book        varchar(255) not null default '',
  title_of_book       longtext     not null default '',
  book_biblio_line    longtext     not null default '',
  xref_title_of_book  longtext     not null default '',
  copies              longtext     not null default '',
  problem             varchar(255) not null default '',

  primary key ( entry_id, entry_book_count )
)  DEFAULT CHARSET=utf8; 



