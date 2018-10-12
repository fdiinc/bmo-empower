import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;

public class FileSizeList {

    public void walk( String path, PrintWriter writer) {
        File root = new File( path );
        File[] list = root.listFiles();
 
        if (list == null) 
        	{
        		System.out.println( "NO FILES IN:" + path );
        		return;
        	
        	}
        for ( File f : list ) {
            if ( f.isDirectory() ) {
                walk( f.getAbsolutePath(), writer );
                System.out.println( "Dir:" + f.getAbsoluteFile() );
            }
            else {
            	writer.println(f.getAbsoluteFile() + "\t" + f.length());
            }
        }

    }

    public static void main(String[] args) {
    	if (args.length < 2)
    	{
    		System.err.println("Not enough Parameters..");
    		System.err.println("   Param 1 = Path to source directory");
    		System.err.println("   Param 2 = Path to output file");
    		return;
    	}
    	String sourceFilePath = args[0];
    	String outputFile = args[1];
        FileSizeList fw = new FileSizeList();
        PrintWriter writer = null;
		try {
			writer = new PrintWriter(outputFile, "UTF-8");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        fw.walk(sourceFilePath, writer);
		writer.close();

    }

}