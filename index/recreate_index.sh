#! /bin/bash

echo ''
echo ''

echo "Recreating tables and views..."
for recreation_script in create_index_medieval_doc_group_types.sql \
                         create_index_medieval_doc_groups.sql \
                         create_index_medieval_documents.sql \
                         create_index_medieval_documents_view.sql \
                         create_index_entries.sql \
                         create_index_entry_books.sql \
                         create_index_entry_copies.sql \
                         create_index_mlgb_links.sql \
                         create_index_entry_flags.sql \
                         create_u_index_all.sql
do
  echo $recreation_script
  mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < $recreation_script
done
echo ''

echo "Inserting lookup data..."
# N.B. these three scripts were MANUALLY created so any changes also need to be applied MANUALLY.
for insert_script in insert_index_medieval_doc_group_types.sql \
                     insert_index_medieval_doc_groups.sql \
                     insert_index_medieval_documents.sql \
                     insert_index_entry_flags.sql
do
  echo $insert_script
  mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < $insert_script
done
echo ''

echo "Adding dates to medieval catalogues..."
python dates.py
echo 'Generated set_catalogue_dates.sql, now about to run it.'
mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < set_catalogue_dates.sql

echo "Adding types to medieval catalogues..."
mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < set_document_type.sql


echo 'Running importIndexEntries.py ...'
# This generates the script "insert_index_entries_and_entry_books.sql".
python importIndexEntries.py
echo ''

echo "Running SQL script 'insert index entries and entry books'."
mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < insert_index_entries_and_entry_books.sql
echo ''

echo 'Running importIndexedCopies.py ...'
# This generates the script "insert_index_entry_copies.sql"
python importIndexedCopies.py
echo ''

echo "Running SQL script 'insert index entry copies'."
mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < insert_index_entry_copies.sql
echo ''

echo 'Running greek.py ...'
# This generates the script "convert_encoded_latin_to_greek.sql"
python greek.py
echo ''

echo "Running SQL script 'convert_encoded_latin_to_greek.sql'."
mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < convert_encoded_latin_to_greek.sql
echo ''


echo 'Adding ability to sort by document code...'
python addSortingByDocumentCode.py
echo ''

echo 'Adding decodes: document name, document group, etc.'
mysql -u mlgbAdmin -p$MLGBADMINPW mlgb < update_index_entry_copies.sql
echo ''

echo 'Creating links between the index and the MLGB database...'
python setIndexBookIDs.py
echo ''

echo 'Creating UTF-8 version of ASCII-based encoding...'
python utf8.py
echo ''

echo 'Writing XML file for input into Solr catalogues index'
python authortitle_to_xml.py
echo ''

echo ''
date

echo 'The basic database should now have been recreated.'

echo -n 'Do you want to create the Solr catalogues index now? (y/n) '
read answer
echo ''
echo ''

if [ "$answer" = "y" -o "$answer" = "Y" ]
then
  sudo curl http://localhost:8180/solr/catalogues/dataimport?command=full-import
fi

echo -n 'Do you want to rewrite the static HTML output now? (y/n) '
read answer
echo ''
echo ''

if [ "$answer" = "y" -o "$answer" = "Y" ]
then
  echo "Recreating static HTML files..."
  python decode_flags.py
  python writeHTML.py
  python cataloguesHTML.py
  echo 'Index should now have been recreated.'
else
  echo "The HTML files will not be changed."
fi


echo ''
echo ''
