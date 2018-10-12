FileSizeList

This program creates a list of filenames with their corresponding file size.
It is primarily used to check if copy operations have transferred completely.
It could also be used to calculate directory sizes.

This program is an executable jar file.

Execution is as follows:

java -jar fileSizeList.jar <path to top folder to traverse> <path and name of output file>

Example:

java -jar fileSizeList.jar c:\junk .\junkfiles.txt

This traverses all the files in c:\junk and child folders and writes a list 
of every file with its size to the folder the program is running from in a file
named junkfiles.txt

The records of the output file are 2 fields with a tab delimiter, suitable for import into Excel.
Field 1 is the full path and filename of the file 
Field 2 is the size of the file in bytes.
