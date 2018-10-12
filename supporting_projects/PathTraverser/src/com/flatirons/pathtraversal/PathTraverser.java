package com.flatirons.pathtraversal;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.FileVisitor;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class PathTraverser {

	public static void main(String[] args) {
		if (args.length < 1 || args[0].equals("--help")) {
			System.err.println("usage: java -jar fileHashWalker.jar <directory> [output file]");
			System.exit(-1);
		}
		
		final File root = new File(args[0]);
		final AtomicReference<Path> lastFile = new AtomicReference<Path>(root.toPath());
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
			try (FileInputStream in = new FileInputStream(lastPath)) {
				byte[] data = new byte[(int) lastPath.length()];
				in.read(data);
				lastFile.set(new File(new String(data)).toPath());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				System.exit(-1);
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(-1);
			}
		}
		
		final AtomicBoolean finished = new AtomicBoolean(false);
		
		Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
			
			@Override
			public void run() {
				if (finished.get()) {
					if (lastPath.exists()) {
						lastPath.delete();
					}
				} else {
					try (FileOutputStream out = new FileOutputStream(lastPath)) {
						out.write(lastFile.get().toString().getBytes());
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
		
		final AtomicBoolean started = new AtomicBoolean(true);
		if (lastPath.exists()) {
			started.set(false);
		}
		
		final AtomicInteger outputFlag = new AtomicInteger(0);
		while (true) {
			try (FileOutputStream log = new FileOutputStream(logFile, true)) {
				Files.walkFileTree(root.toPath(), new FileVisitor<Path>() {

					@Override
					public FileVisitResult postVisitDirectory(Path dir,
							IOException exc) throws IOException {
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult preVisitDirectory(Path dir,
							BasicFileAttributes attrs) throws IOException {
						return FileVisitResult.CONTINUE;
					}
					
					byte[] dataBytes = new byte[1024];
					
					@Override
					public FileVisitResult visitFile(Path file,
							BasicFileAttributes attrs) throws IOException {
						if (started.get()) {
							log.write("".getBytes());
							log.write(file.toString().getBytes());
							log.write("\t".getBytes());
							/////////////////////////////////////////////
							// do hash here
							
							MessageDigest md = null;
							try {
								md = MessageDigest.getInstance("MD5");
							} catch (NoSuchAlgorithmException e1) {
								e1.printStackTrace();
							}
							if (file.toFile().canRead() && file.toFile().isFile()) {
								try (FileInputStream fis = new FileInputStream(file.toFile())) {
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
									log.write(hashString.getBytes());
									if (outputFlag.getAndIncrement() % 100 == 0) {
										System.out.println("done with: " + outputFlag.get() + " files");
									}
								}
							}
							log.write("\n".getBytes());
							/////////////////////////////////////////////
							// Set last checked file
							lastFile.set(file);
						} else if (file.equals(lastFile.get())) {
							started.set(true);
						}
						return FileVisitResult.CONTINUE;
					}

					@Override
					public FileVisitResult visitFileFailed(Path file,
							IOException exc) throws IOException {
						return FileVisitResult.CONTINUE;
					}
				});
				System.out.println("done with: " + outputFlag.get() + " files");
				finished.set(true);
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(-1);
			}
			break;
		}
	}

}
