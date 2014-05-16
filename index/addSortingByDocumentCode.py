# -*- coding: utf-8 -*-
"""
Make a copy of document codes in a form suitable for numerical sorting, e.g. '0010' instead of '10'.
By Sushila Burgess
"""
##=====================================================================================

import sys
import connectToMLGB as c

##=====================================================================================

def addDocumentCodeSort(): #{

  the_database_connection = None
  the_cursor = None

  #=================================================================
  # Read each line of the original file, manipulate it as necessary,
  # and then write it into the new file.
  #=================================================================
  try:
    # Connect to the database and create a cursor
    the_database_connection = c.get_database_connection()
    the_cursor = the_database_connection.cursor() 

    # Update both the 'documents' lookup table and the 'copies' table.
    # Although this duplicates the same information in two places, it makes it much
    # simpler to access the data.

    tables_to_update = [ 'index_medieval_documents', 'index_entry_copies' ]

    for the_table in tables_to_update: #{
      select = "select distinct document_code from %s " % the_table
      select += " where document_code > '' order by document_code"

      the_cursor.execute( select )
      results = the_cursor.fetchall()

      for row in results: #{

        document_code = row[ 0 ].strip()
        new_code = pad_with_zeroes( document_code )

        upd = "update %s set document_code_sort = '%s' where document_code = '%s'" \
            % (the_table, new_code, document_code)
        print upd

        the_cursor.execute( upd )
      #}
    #}

    the_cursor.close()
    the_database_connection.close()

  except:
    if the_cursor: the_cursor.close()
    if the_database_connection: the_database_connection.close()
    raise
#}

##=====================================================================================

def pad_with_zeroes( document_code ): #{

  new_code = ''
  alpha_chars = ''
  numeric_chars = ''
  number_of_digits = 6

  for one_char in document_code: #{
    if one_char.isdigit(): #{
      numeric_chars = "%s%s" % (numeric_chars, one_char)
    #}
    elif numeric_chars == '' and one_char.isalpha() and one_char.isupper(): #{
      alpha_chars = "%s%s" % (alpha_chars, one_char)
    #}
  #}

  if numeric_chars:
    numeric_chars = numeric_chars.rjust( number_of_digits, '0' )
  else:
    numeric_chars = numeric_chars.rjust( number_of_digits, '9' ) # sort null values to the end

  new_code = '%s%s' % (alpha_chars, numeric_chars)
  return new_code
#}

##=====================================================================================

if __name__ == '__main__':

  addDocumentCodeSort()

##=====================================================================================
