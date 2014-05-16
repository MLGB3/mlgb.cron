# -*- coding: utf-8 -*-
"""
Create a preliminary version of output from Richard Sharpe's list.master.
By Sushila Burgess
"""
##=====================================================================================

import sys
import MySQLdb

import connectToMLGB as c
import writeHTML as w
import cataloguesHTML as cat

##=====================================================================================

output_filename = w.final_output_dir + 'decode.html'

newline = '\n'

##=====================================================================================

def writeFlagDecodes(): #{

  the_database_connection = None
  the_cursor = None

  try:
    outfile_handle = file
    outfile_handle = open( output_filename, 'wb' ) # 'wb' allows entry of UTF-8

    cat.write_inherit_and_title_block( outfile_handle )
    cat.write_start_main_content( outfile_handle )

    outfile_handle.write( '<h3>Definition of codes used in the index</h3>' )
    outfile_handle.write( '<dl class="catalogue_entry_flags">' )

    the_database_connection = c.get_database_connection()
    the_cursor = the_database_connection.cursor() 

    statement = "select flag_code, flag_desc, flag_example from index_entry_flags "
    statement += " order by flag_id" 

    the_cursor.execute( statement )
    results = the_cursor.fetchall()

    for row in results: #{
      flag_code = w.reformat( row[ 0 ] )
      flag_desc = w.reformat( row[ 1 ] )
      flag_example = w.reformat( row[ 2 ] )

      outfile_handle.write( '<dt>' + newline )
      outfile_handle.write( flag_code )
      if flag_example: outfile_handle.write( ' e.g. %s' % flag_example)
      outfile_handle.write( newline + '</dt>' + newline + '<dd>' + newline )
      outfile_handle.write( '%s' % flag_desc ) 
      outfile_handle.write( newline )
      outfile_handle.write( '</dd>' + newline + newline )
    #}

    outfile_handle.write( '</dl>' )
    cat.write_end_main_content( outfile_handle, include_link_to_definitions = False )

    outfile_handle.close()

    the_cursor.close()
    the_database_connection.close()

  except:
    if isinstance( outfile_handle, file ):
      if not outfile_handle.closed : outfile_handle.close()
    if the_cursor: the_cursor.close()
    if the_database_connection: the_database_connection.close()
    raise
#}

##=====================================================================================

if __name__ == '__main__':


  # These two lines are hacks (copied from Mat's clever hack, thanks Mat). 
  # They switch the default encoding to utf8 so that the command line will convert UTF8 + Ascii to UTF8
  reload(sys)
  sys.setdefaultencoding("utf8")

  writeFlagDecodes()

##=====================================================================================
