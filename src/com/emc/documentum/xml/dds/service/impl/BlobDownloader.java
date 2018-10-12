package com.emc.documentum.xml.dds.service.impl;

import java.io.IOException;
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.emc.documentum.xml.dds.DDS;
import com.emc.documentum.xml.dds.application.Application;
import com.emc.documentum.xml.dds.logging.LogCenter;
import com.emc.documentum.xml.dds.operation.exception.RollbackFailedException;
import com.emc.documentum.xml.dds.persistence.Session;
import com.emc.documentum.xml.dds.persistence.Store;
import com.emc.documentum.xml.dds.persistence.StoreUser;
import com.emc.documentum.xml.dds.persistence.exception.StoreSpecificException;
import com.emc.documentum.xml.dds.servlet.AbstractDDSHttpServlet;
import com.emc.documentum.xml.dds.user.User;
import com.emc.documentum.xml.dds.user.UserToken;
import com.xhive.core.interfaces.XhiveSessionIf;
import com.xhive.dom.interfaces.XhiveBlobNodeIf;
import com.xhive.dom.interfaces.XhiveLibraryChildIf;

public class BlobDownloader extends AbstractDDSHttpServlet {
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getParameter("path");
		String mimeType = request.getParameter("mimeType");
		Application application = DDS.getApplication();
		User user = getUserFromRequest(request);
		Store store = application.getMainStore();
		Session session = null;
		//Log blob download request
		auditLog(path, user, request);
		try {
			StoreUser storeUser = store.getDefaultStoreUser();
			session = store.getSession(storeUser, true);
		} catch (StoreSpecificException e1) {
			e1.printStackTrace();
		}
		XhiveSessionIf s = (XhiveSessionIf) session.getSession();
		s.begin();
		XhiveLibraryChildIf child = s.getDatabase().getRoot().getByPath("/DATA/bmoglo/Collection/" + path);
		if (child == null) {
			response.sendError(404, "Blob: " + path + " not found");
		}
		int lastSlashIndex = path.lastIndexOf('/');
		if (lastSlashIndex >= 0) {
			String filename = path.substring(lastSlashIndex + 1);
			response.setHeader(
					"Content-Disposition",
					"attachment; filename=\""
							+ filename + "\"");
			response.setHeader("Content-Type", mimeType);
		} else {
			response.setHeader(
					"Content-Disposition",
					"attachment; filename=\""
							+ "download" + "\"");
		}

		// these next three lines are needed for IE8 compatibility
		response.setHeader("Expires", "-1");
		response.setHeader("Pragma", "token");
		response.setHeader("Cache-Control", "private");
		
		try {
			XhiveBlobNodeIf node = (XhiveBlobNodeIf) child;
			InputStream ins = node.getContents();
			ServletOutputStream outs = response.getOutputStream();
			ReadableByteChannel in = Channels.newChannel(ins);
			WritableByteChannel out = Channels.newChannel(outs);
			ByteBuffer buffer = ByteBuffer.allocate(1024 * 16);
			int length = 0;
			while (in.read(buffer) > 0) {
				buffer.flip();
				while (buffer.remaining() > 0) {
					out.write(buffer);
				}
				buffer.clear();
			}
			in.close();
			out.close();
			ins.close();
			outs.close();
		} catch (IOException e) {
			e.printStackTrace();
//			LogCenter.exception(e.getLocalizedMessage(), e);
		} catch (NullPointerException e) {
//			LogCenter.exception(e.getLocalizedMessage(), e);
			response.sendError(404, "file: " + path + " not found");
			e.printStackTrace();
		}
		try {
			session.rollback();
		} catch (RollbackFailedException e) {
//			LogCenter.exception(e.getLocalizedMessage(), e);
			e.printStackTrace();
		}
	}
	
	private void auditLog(String path, User user, HttpServletRequest request) {
		UserToken userToken = getUserTokenFromRequest(request);
		String appName = "";
		if (userToken != null) {
			appName = userToken.getApplicationName();
		}
		StringBuilder auditLogEntry = new StringBuilder();
		auditLogEntry.append("app : '");
		auditLogEntry.append(appName);
		auditLogEntry.append("', IRM_CODE : E10, user : ");
		auditLogEntry.append(user.getId());
		auditLogEntry.append(", searchConfiguration : '");
		auditLogEntry.append("DocumentDownload");
		auditLogEntry.append("', fields : ");
		auditLogEntry.append("<data><path>");
		auditLogEntry.append(path);
		auditLogEntry.append("</path></data>");

		String msg = auditLogEntry.toString();
		LogCenter.log(msg);
	}

}
