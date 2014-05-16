truncate table index_entry_flags;

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
 '* (asterisk)', 'Surviving book', 'B79.*241'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
 '{P}', 'Printed book', 'S16.{P}10'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
 '{P}*', 'Surviving printed book', 'H2.{P}*189'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'{+}', 'Against an item number signifies that the identification is uncertain, and the entry will usually have a quotation in brackets following.', 'FA8.{+}50a (`flores moralium beati Gregorii'')'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
 '{P}{+}', 'Possibly a printed book (uncertain)', 'UO25.{P}{+}30 (`tractatus sancti Augustini'')'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'{+}{+}', 'Means it looks like a fit but is utterly incredible, i.e. very {+}.', 'B24.{+}{+}92'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'{+}', 'Against an author''s date means "died".', 'Bernard of Parma [{+}1266]'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'{+}', 'Against a word is half a dozen times used to mean that there has been an error in the copying.', '{+}inferno [l. infirmo]'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'++', 'Means the entry could refer to one of several works with the same title, so there are likely to be two (or more) entries for the same item.', 'FA8.++435'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'&loz;', 'Signifies that the report is based on literary evidence rather than on sight of an actual book. So, e.g. Kirkstead includes works that were lost a thousand years earlier but rated a mention in a work of Jerome.', '&loz; Agrippa Castor [2nd cent.]'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'Superscript x,', 'An "extra" title recorded from the manuscript itself in addition to titles mentioned in the documents on which the List of Identifications is based.', 'UO68.*164{^x^}'
)
\p\g

insert into index_entry_flags (flag_code, flag_desc, flag_example) values (
'Superscript i,', 'Occurs only with BA1 and signifies that an entry is matched with the medieval index. It is used relatively rarely, just on occasions when the index provides help towards the identification or contents.', 'BA1.*{^i^}849'
)
\p\g


