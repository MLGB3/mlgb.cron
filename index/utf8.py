# -*- coding: utf-8 -*-
"""
Convert data from Richard Sharpe's encoded ASCII file into UTF-8 for indexing in Solr.
By Sushila Burgess
"""
##=====================================================================================

import sys
import MySQLdb
import HTMLParser

import connectToMLGB as c
import writeHTML as w

##=====================================================================================

html_parser = HTMLParser.HTMLParser()

tables_to_process = [ 
  'u_index_medieval_documents',
  'u_index_entries',
  'u_index_entry_books',
  'u_index_entry_copies',
]

table_keys = {
  'u_index_medieval_documents': [ 'document_id' ],
  'u_index_entries'           : [ 'entry_id' ],
  'u_index_entry_books'       : [ 'entry_id', 'entry_book_count' ],
  'u_index_entry_copies'      : [ 'entry_id', 'entry_book_count', 'copy_count' ],
}

fields_to_convert = {

  'u_index_medieval_documents': [ 'document_name' ],

  'u_index_entries': [ 'entry_name', 'xref_name', 'entry_biblio_line', 'entry_biblio_block', ],

  'u_index_entry_books': [ 'role_in_book', 'title_of_book', 'book_biblio_line', 'xref_title_of_book',
                           'copies', 'problem', ],

  'u_index_entry_copies': [ 'copy_code', 'copy_notes', 'document_name', ],
}

##=====================================================================================

def changeAllTables(): #{

  for table_name in tables_to_process: #{
    print 'Starting', table_name
    changeOneTable( table_name )
    print 'Finished', table_name
    print ' '
  #}
#}

##=====================================================================================

def changeOneTable( table_name ): #{

  the_database_connection = c.get_database_connection()
  the_cursor = the_database_connection.cursor() 

  statement = 'truncate table %s' % table_name
  the_cursor.execute( statement )

  source_table = table_name[ 2 : ] # strip off 'u_' prefix
  statement = 'insert into %s select * from %s' % (table_name, source_table)
  the_cursor.execute( statement )

  key_list = table_keys[ table_name ]  
  select_keys = ", ".join( key_list ) 

  statement = "select %s from %s order by %s" % (select_keys, table_name, select_keys)
  the_cursor.execute( statement )
  results = the_cursor.fetchall()

  for row in results: #{
    i = -1
    where_clause = ""
    for keyname in key_list: #{
      i += 1
      if where_clause != "": where_clause += " and "
      where_clause += "%s = %d" % (keyname, row[ i ])
    #}

    field_list = fields_to_convert[ table_name ]
    for fieldname in field_list: #{
      statement = "select %s from %s where %s" % (fieldname, table_name, where_clause)
      the_cursor.execute( statement )
      one_result = the_cursor.fetchone()
      fieldval = one_result[ 0 ]
      if not fieldval: continue

      # Reformat in 2 steps: 
      # 1. Convert homespun ASCII coding invented by Richard Sharpe to HTML entities.
      # 2. Convert the HTML entities to UTF-8.

      # Turn ASCII coding into HTML
      fieldval = w.reformat( fieldval )

      # Turn HTML entities into UTF-8 characters
      fieldval = html_parser.unescape( fieldval )

      # Remove some Django template tags
      fieldval = fieldval.replace( '{% templatetag openvariable %}', '{{' )
      fieldval = fieldval.replace( '{% templatetag closevariable %}', '}}' )

      fieldval = fieldval.replace( "'", "''" ) # escape for SQL
      statement = "update %s set %s = '%s' where %s" % (table_name, fieldname, fieldval, where_clause)
      #print statement.encode( 'utf8' )
 
      the_cursor.execute( statement.encode( 'utf8' ) )
    #}
  #}

  the_cursor.close()
  the_database_connection.close()
#}

##=====================================================================================

if __name__ == '__main__':


  # These two lines are hacks (copied from Mat's clever hack, thanks Mat). 
  # They switch the default encoding to utf8 so that the command line will convert UTF8 + Ascii to UTF8
  reload(sys)
  sys.setdefaultencoding("utf8")

  changeAllTables()

##=====================================================================================
