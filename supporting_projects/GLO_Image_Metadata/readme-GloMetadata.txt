GloMetadata

This program creates metadata specifically for GLO documents.
It will likely not be usefull for other project directly but may be useful as 
a template for creating metadata from data where the filename is parsable for 
appropriate field information.  This is written for files that reside on a Windows
file system.

The input is a file that is created from the windows shell command DIR /S/B
Example: dir /s/b c:\junk > junkfilelist.txt

That command creates a file that has all the files in c:\junk and its subfolders
with fully qualified paths and writes it to junkfilelist.txt in the current folder.

This program is an executable jar file.

Execution is as follows:

java -jar GloMetadata.jar <path to file to read> 

Output is written to STDOUT (console).
Output is XML data in the following format:

<GLO_FILE_DATA>
	<GLO_FILE_DATA-ROW>
               <FILE_NAME>somefile.pdf</FILE_NAME>
               <FILE_PATH>"/EL/Data/somefile.pdf</FILE_PATH>
               <FILE_TYPE>pdf</FILE_TYPE>
	</GLO_FILE_DATA-ROW>
</GLO_FILE_DATA>

Example:

java -jar GloMetadata.jar c:\junk\junkfilelist.txt  > glometadata.xml

This reads the file c:\junk\junkfilelist.txt and writes the xml data for each file 
to glometadata.xml in the current folder.

