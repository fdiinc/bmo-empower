package com.flatirons.pathtraversal;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PathTraverser {

	static Boolean started = true;
	static Boolean finished = false;
	static Integer outputFlag = 0;
	static String lastFile = null;

	public static void main(String[] args) {
		if (args.length < 1 || args[0].equals("--help")) {
			System.err.println("usage: java -jar fileHashWalker.jar <directory> [output file]");
			System.exit(-1);
		}
		
		File root = new File(args[0]);
		lastFile = root.getPath();
		File logFile = new File("counts.txt");
		if (args.length > 1) {
			logFile = new File(args[1]);
		}
		
		String name = logFile.getName();
		int dotIndex = name.lastIndexOf('.');
		if (dotIndex != -1) {
			name = name.substring(0, dotIndex);
		}
		final File lastPath = new File(name + ".lastPath");
		if (lastPath.exists()) {
			try  {
				FileInputStream in = new FileInputStream(lastPath);
				byte[] data = new byte[(int) lastPath.length()];
				in.read(data);
				lastFile = new File(new String(data)).getPath();
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				System.exit(-1);
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(-1);
			}
		}
		
		
		Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
			
			public void run() {
				if (finished) {
					if (lastPath.exists()) {
						lastPath.delete();
					}
				} else {
					FileOutputStream out = null;
					try  {
						System.out.println("ABNORMAL TERMINATION");
						out = new FileOutputStream(lastPath);
						out.write(lastFile.toString().getBytes());
					} catch (FileNotFoundException e) {
						e.printStackTrace();
						System.exit(-1);
					} catch (IOException e) {
						e.printStackTrace();
						System.exit(-1);
					}
				}
			}
		}));
			
			
		
		
		if (lastPath.exists()) {
			started=false;
		}
		
			try {
				FileOutputStream log = new FileOutputStream(logFile, true);
				
				outputMD5(root.getPath(), log);
				System.out.println("done with: " + outputFlag + " files");
				finished=true;
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(-1);
			}
			finally {

				
			}
			
		}	

			
		public static void outputMD5(String path, FileOutputStream log) {
		byte[] dataBytes = new byte[1024];
		try {
			File thisPath = new File(path);
			File[] files = thisPath.listFiles();
			for (File file : files) {
				if (file.isDirectory()) {
					System.out.println("directory:" + file.getCanonicalPath());
					outputMD5(file.getCanonicalPath(), log);
				} else {
					if (started) {
						System.out.println("     Processing file:" + file.getCanonicalPath());
						/////////////////////////////////////////////
						// do hash here
						
						MessageDigest md = null;
						try {
							md = MessageDigest.getInstance("MD5");
						} catch (NoSuchAlgorithmException e1) {
							e1.printStackTrace();
						}
						
						if (file.canRead() && file.isFile()) {
							FileInputStream fis = null;
							try {
								fis = new FileInputStream(file);
								int nread = 0;
								while ((nread = fis.read(dataBytes)) != -1) {
									md.update(dataBytes, 0, nread);
								};
								byte[] mdbytes = md.digest();
								
								//convert the byte to hex format method 1
								StringBuffer sb = new StringBuffer();
								for (int i = 0; i < mdbytes.length; i++) {
									sb.append(Integer.toString((mdbytes[i] & 0xff) + 0x100, 16).substring(1));
								}
								
								String hashString = sb.toString();
								sb.setLength(0);

								log.write((file.toString()+"\t"+hashString+"\n").getBytes() );
								// Set last completed file
								lastFile = file.getPath();
//								log.write("\t".getBytes());
//								log.write(hashString.getBytes());
								outputFlag++;
								if ((outputFlag+1) % 100 == 0) {
									System.out.println("done with: " + outputFlag + " files");
								}
							}
							finally {
								if (fis != null) {
									fis.close();
								}
							}
						}
						/////////////////////////////////////////////
					} else 
						System.out.println("     Ignoring file:" + file.getCanonicalPath());

						if (file.getPath().equals(lastFile)) {
						
						started=true;
					}
					
				}
				}
			return;
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
