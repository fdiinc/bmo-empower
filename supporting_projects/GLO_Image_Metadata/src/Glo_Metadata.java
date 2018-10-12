import java.io.*;

public class Glo_Metadata {
    public static void main(String [] args) {

        // The name of the file to open.
        String fileName = "";
		int folderLevel = 0;
		int nameLevel = 0;
    	String folderName = "";
    	String imageFilename = "";
    	String loanKey = "";
    	String type = "";
        if (args.length > 0) {
        		fileName = args[0]; // open the file with the file paths
        }
        else
        {
        	System.err.println("Invalid Parameters:");
        	System.err.println("   Parameter 1: Path to a file that has a list of fully qualified paths from DOS cmd -  dir /s/b somefolderpath");
        }
        String line = null;

        try {
            // FileReader reads text files in the default encoding.
            FileReader fileReader = 
                new FileReader(fileName);

            // Always wrap FileReader in BufferedReader.
            BufferedReader bufferedReader = new BufferedReader(fileReader);
            System.out.println("<GLO_FILE_DATA>");
            while((line = bufferedReader.readLine()) != null) {
            	line = line.replace("\\", "/");
            	String[] pathParts = line.split("/");
            	int fnIndex = pathParts.length-1;
            	if (!pathParts[fnIndex].contains(".") ) {continue;}
        		folderLevel = pathParts.length -2;
        		nameLevel = pathParts.length -1;

            	folderName = pathParts[folderLevel].trim();
            	imageFilename = pathParts[nameLevel].trim();
            	loanKey = imageFilename.substring(0, imageFilename.indexOf("_"));
            	type = imageFilename.substring(imageFilename.lastIndexOf(".")+1).toLowerCase();
            	// Ignore empty file names
            	if (imageFilename == "") {continue;}
                System.out.println("\t<GLO_FILE_DATA-ROW>");
                System.out.println("\t\t<LNKEY>" + loanKey + "</LNKEY>");
                System.out.println("\t\t<FILE_NAME>" + imageFilename + "</FILE_NAME>");
                System.out.println("\t\t<FILE_PATH>" + folderName + "/" + imageFilename + "</FILE_PATH>");
                System.out.println("\t\t<FILE_TYPE>" + type + "</FILE_TYPE>");
                System.out.println("\t</GLO_FILE_DATA-ROW>");
           	
            }   
            System.out.println("</GLO_FILE_DATA>");

            // Always close files.
            bufferedReader.close();         
        }
        catch(FileNotFoundException ex) {
            System.out.println(
                "Unable to open file '" + 
                fileName + "'");                
        }
        catch(IOException ex) {
            System.out.println(
                "Error reading file '" 
                + fileName + "'");                  
            // Or we could just do this: 
            // ex.printStackTrace();
        }
    }
}