# -*- coding: utf-8 -*-
"""
Create a preliminary version of output from Richard Sharpe's list.master.
By Sushila Burgess
"""
##=====================================================================================

import sys
import MySQLdb
import unicodedata

import connectToMLGB as c

##=====================================================================================

output_filename = 'convert_encoded_latin_to_greek.sql'

fields_to_check = {

  'index_entries'     : [ 'entry_name', 
                          'xref_name', 
                          'entry_biblio_line', 
                          'entry_biblio_block', 
                        ],

  'index_entry_books' : [ 'title_of_book', 
                          'book_biblio_line',
                          'xref_title_of_book',
                          'copies', 
                        ],

  'index_entry_copies': [ 'copy_notes', 
                        ],
}

final_s = '$' # we will need to convert s/sigma at the end of words to 'final sigma'

letters = {  
  'A': 'GREEK CAPITAL LETTER ALPHA',      # &#913;   &Alpha;   
  'B': 'GREEK CAPITAL LETTER BETA',       # &#914;   &Beta;   
  'G': 'GREEK CAPITAL LETTER GAMMA',      # &#915;   &Gamma;   
  'D': 'GREEK CAPITAL LETTER DELTA',      # &#916;   &Delta;   
  'E': 'GREEK CAPITAL LETTER EPSILON',    # &#917;   &Epsilon;   
  'Z': 'GREEK CAPITAL LETTER ZETA',       # &#918;   &Zeta;   
  'H': 'GREEK CAPITAL LETTER ETA',        # &#919;   &Eta;   
  'Q': 'GREEK CAPITAL LETTER THETA',      # &#920;   &Theta;   
  'I': 'GREEK CAPITAL LETTER IOTA',       # &#921;   &Iota;   
  'K': 'GREEK CAPITAL LETTER KAPPA',      # &#922;   &Kappa;   
  'L': 'GREEK CAPITAL LETTER LAMDA',      # &#923;   &Lambda;   
  'M': 'GREEK CAPITAL LETTER MU',         # &#924;   &Mu;   
  'N': 'GREEK CAPITAL LETTER NU',         # &#925;   &Nu;   
  'X': 'GREEK CAPITAL LETTER XI',         # &#926;   &Xi;   
  'O': 'GREEK CAPITAL LETTER OMICRON',    # &#927;   &Omicron;   
  'P': 'GREEK CAPITAL LETTER PI',         # &#928;   &Pi;   
  'R': 'GREEK CAPITAL LETTER RHO',        # &#929;   &Rho;   
  'S': 'GREEK CAPITAL LETTER SIGMA',      # &#931;   &Sigma;   
  'T': 'GREEK CAPITAL LETTER TAU',        # &#932;   &Tau;   
  'U': 'GREEK CAPITAL LETTER UPSILON',    # &#933;   &Upsilon;   
  'F': 'GREEK CAPITAL LETTER PHI',        # &#934;   &Phi;   
  'C': 'GREEK CAPITAL LETTER CHI',        # &#935;   &Chi;   
  'Y': 'GREEK CAPITAL LETTER PSI',        # &#936;   &Psi;   
  'W': 'GREEK CAPITAL LETTER OMEGA',      # &#937;   &Omega;   
             
  'a': 'GREEK SMALL LETTER ALPHA',      # &#945;   &alpha;   
  'b': 'GREEK SMALL LETTER BETA',       # &#946;   &beta;   
  'g': 'GREEK SMALL LETTER GAMMA',      # &#947;   &gamma;   
  'd': 'GREEK SMALL LETTER DELTA',      # &#948;   &delta;   
  'e': 'GREEK SMALL LETTER EPSILON',    # &#949;   &epsilon;   
  'z': 'GREEK SMALL LETTER ZETA',       # &#950;   &zeta;   
  'h': 'GREEK SMALL LETTER ETA',        # &#951;   &eta;   
  'q': 'GREEK SMALL LETTER THETA',      # &#952;   &theta;   
  'i': 'GREEK SMALL LETTER IOTA',       # &#953;   &iota;   
  'j': 'COMBINING RETROFLEX HOOK BELOW',
  'k': 'GREEK SMALL LETTER KAPPA',      # &#954;   &kappa;   
  'l': 'GREEK SMALL LETTER LAMDA',      # &#955;   &lambda;   
  'm': 'GREEK SMALL LETTER MU',         # &#956;   &mu;   
  'n': 'GREEK SMALL LETTER NU',         # &#957;   &nu;   
  'x': 'GREEK SMALL LETTER XI',         # &#958;   &xi;   
  'o': 'GREEK SMALL LETTER OMICRON',    # &#959;   &omicron;   
  'p': 'GREEK SMALL LETTER PI',         # &#960;   &pi;   
  'r': 'GREEK SMALL LETTER RHO',        # &#961;   &rho;   
  's': 'GREEK SMALL LETTER SIGMA',      # &#963;   &sigma;   
  't': 'GREEK SMALL LETTER TAU',        # &#964;   &tau;   
  'u': 'GREEK SMALL LETTER UPSILON',    # &#965;   &upsilon;   
  'f': 'GREEK SMALL LETTER PHI',        # &#966;   &phi;   
  'c': 'GREEK SMALL LETTER CHI',        # &#967;   &chi;   
  'y': 'GREEK SMALL LETTER PSI',        # &#968;   &psi;   
  'w': 'GREEK SMALL LETTER OMEGA',      # &#969;   &omega;   

  final_s: 'GREEK SMALL LETTER FINAL SIGMA', # &#962; &sigmaf;   
}

raw_accents = {
  ">": 'COMBINING GRAVE ACCENT',         # 'U+0300', 768, 
  "<": 'COMBINING ACUTE ACCENT',         # 'U+0301', 769, 
  "^": 'COMBINING INVERTED BREVE',       # 'U+0311', 785, 
  "'": 'COMBINING COMMA ABOVE',          # 'U+0313', 787, smooth breathing
  "`": 'COMBINING REVERSED COMMA ABOVE', # 'U+0314', 788, rough breathing
}

accent_entities = []
for raw_char, unicode_accent_name in raw_accents.items(): #{
  unicode_char = unicodedata.lookup( unicode_accent_name )
  entity_code = '&#%d;' % ord( unicode_char )
  accent_entities.append( entity_code )
#}

numeric_non_break_space = '&#160;' # will use this instead of &nbsp; as it fits in later with the 
                                   # formatting done in writeHTML.py

greek_start = '$sp$$'
greek_end = '$rm' #the full code is '$rm$$', but some entries are missing one or both final dollar signs
full_greek_end = '$rm$$'
unidentified_chars = []

percent = '%'
newline = '\n'
space = ' '

##=====================================================================================

def changeAllTextFields(): #{

  global unidentified_chars
  unidentified_chars = []

  try:
    outfile_handle = file
    outfile_handle = open( output_filename, 'wb' ) # 'wb' allows entry of UTF-8
    outfile_handle.write( newline + '-- This script was generated by greek.py ' + newline + newline )

    for table_name, fields in fields_to_check.items(): #{
      for field in fields: #{
        changeOneTextField( outfile_handle, table_name, field )
      #}
    #}

    outfile_handle.close()

    print ' '
    print 'Unidentified chars found:', unidentified_chars
    print ' '

  except:
    if isinstance( outfile_handle, file ):
      if not outfile_handle.closed : outfile_handle.close()
    raise
#}

##=====================================================================================

def changeOneTextField( handle, table_name, field_name ): #{

  global unidentified_chars

  the_database_connection = c.get_database_connection()
  the_cursor = the_database_connection.cursor() 

  statement = "select distinct entry_id, %s from %s " % (field_name, table_name)
  statement += " where %s like '%s%s%s'" % (field_name, percent, greek_start, percent)
  statement += " order by entry_id, %s" % field_name
  #print statement

  the_cursor.execute( statement )
  results = the_cursor.fetchall()


  for row in results: #{
    entry_id = row[ 0 ]
    fieldval = row[ 1 ]
    field_parts = fieldval.split( greek_start )
    index = -1
    for section in field_parts: #{
      index += 1
      if index == 0: continue # before first bit of Greek

      sub_sections = section.split( greek_end )
      encoded_latin = sub_sections[ 0 ].strip()
      orig_encoded_latin = encoded_latin

      greek = u''

      print entry_id, encoded_latin

      # We need to change s/sigma at the end of words to 'final sigma'
      final_char = encoded_latin[ -1 : ]
      if final_char == 's': #{
        encoded_latin = '%s%s' % (encoded_latin[ 0 : -1 ], final_s)
      #}

      encoded_latin = encoded_latin.replace( 's ', final_s + ' ' )

      print entry_id, encoded_latin

      # Now look up the name of the Greek character corresponding to this Latin character
      for one_char in encoded_latin[ : ]: #{
        greek_char_name = ''
        greek_char = ''

        if one_char.strip() == '': # whitespace character of some kind
          greek += one_char

        elif letters.has_key( one_char ): #{
          greek_char_name = letters[ one_char ]
          #print '%s = %s' % (one_char, greek_char_name)
        #}

        elif raw_accents.has_key( one_char ): #{
          greek_char_name = raw_accents[ one_char ]
          #print '%s = %s' % (one_char, greek_char_name)
        #}

        else:
          if one_char not in unidentified_chars: unidentified_chars.append( one_char )

        if greek_char_name: #{
          greek_char = unicodedata.lookup( greek_char_name )
          charnum = ord( greek_char )
          greek += '&#%d;' % charnum
        #}
      #}

      # Breathings and accents appear BEFORE capital letters, and are written that way in the English,
      # e.g. "'Aposhmeiw<seis". However, combining characters always follow the character to which they
      # apply. So we need to do some rearrangement. In practice I think we need to add an extra space
      # before the start of the word, for the breathings and accents to sit on. 
      processed_words = []
      words = greek.split()
      for word in words: #{
        for numeric_entity in accent_entities: #{
          if word.startswith( numeric_entity ): #{
            word = numeric_non_break_space + ' ' + word
          #}
        #}
        processed_words.append( word )
      #}
      greek = ' '.join( processed_words )


      orig_encoded_latin = orig_encoded_latin.replace( "'", "''" )  # escape single quotes for SQL

      handle.write( "update %s set %s = replace( %s, '"  % (table_name, field_name, field_name))
      handle.write( orig_encoded_latin )
      handle.write( "', '" )
      handle.write( greek )
      handle.write( "' ) where entry_id = %d" % entry_id )
      handle.write( " and %s like '%s%s%s';" % (field_name, percent, orig_encoded_latin, percent) )
      handle.write( newline + newline )
      print ' '
    #}
  #}

  # remove the marker for 'Greek starts here'
  handle.write( "update %s set %s = replace( %s, '%s', '' );"  \
                % (table_name, field_name, field_name, greek_start) )
  handle.write( newline )

  # remove the marker for 'Greek end here',
  # but remember that sometimes one or two dollar signs have been missed off the end
  tmp_greek_end = full_greek_end
  while len( tmp_greek_end ) >= len( greek_end ): #{
    handle.write( "update %s set %s = replace( %s, '%s', '' );"  \
                  % (table_name, field_name, field_name, tmp_greek_end) )
    handle.write( newline )
    tmp_greek_end = tmp_greek_end[ 0 : -1 ]  # trim off the last character
  #}


  the_cursor.close()
  the_database_connection.close()

  print '----'
  print 'Finished processing %s %s' % (table_name, field_name)
  print '----'
  print ' '
#}

##=====================================================================================

if __name__ == '__main__':


  # These two lines are hacks (copied from Mat's clever hack, thanks Mat). 
  # They switch the default encoding to utf8 so that the command line will convert UTF8 + Ascii to UTF8
  reload(sys)
  sys.setdefaultencoding("utf8")

  changeAllTextFields()

##=====================================================================================
