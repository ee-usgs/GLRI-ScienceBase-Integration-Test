/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package gov.usgs.cida.glri.sb.ui;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.HttpEntity;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.*;
import org.apache.http.impl.client.*;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

/**
 *
 * @author eeverman
 */
public class ScienceBaseService extends HttpServlet {

	/**
	 * Processes requests for both HTTP
	 * <code>GET</code> and
	 * <code>POST</code> methods.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		PrintWriter out = response.getWriter();
		
		
		Map<String, String[]> reqMap = request.getParameterMap();
		reqMap = addProjectConstantParams(reqMap);
		
		ScienceBaseQuery query = new ScienceBaseQuery();
		
		try {
			
			String strResponse = query.getQueryResponse(reqMap);
			response.setContentType(query.getRequestedFormat().getFullName() + "; charset=UTF-8");
			
			System.out.println("Sending back: \n[" + strResponse + "]\n");
			
			out.write(strResponse);
		
		} catch (Exception ex) {
			Logger.getLogger(ScienceBaseService.class.getName()).log(Level.SEVERE, null, ex);
			
			response.setContentType("text/html;charset=UTF-8");
			out.println("<!DOCTYPE html>");
			out.println("<html>");
			out.println("<head>");
			out.println("<title>Servlet ScienceBaseQuery</title>");			
			out.println("</head>");
			out.println("<body>");
			out.println("<h1>Servlet ScienceBaseQuery at " + request.getContextPath() + "</h1>");
			out.println("<p>Error</p>");
			out.println("</body>");
			out.println("</html>");
		} finally {			
			out.close();
		}
	}

	// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
	/**
	 * Handles the HTTP
	 * <code>GET</code> method.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * Handles the HTTP
	 * <code>POST</code> method.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		processRequest(request, response);
	}

	/**
	 * Returns a short description of the servlet.
	 *
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Short description";
	}// </editor-fold>
	
	protected Map<String, String[]> addProjectConstantParams(Map<String, String[]> existingParams) {
		HashMap<String, String[]> paramMap = new HashMap<String, String[]>();
		
		//Add the GLRI project collection ID so that all searches take place w/in this collection
		//paramMap.put(ScienceBaseParam.PARENT_ID.getShortName(), new String[]{"52e6a0a0e4b012954a1a238a"});
		
		paramMap.putAll(existingParams);
		return paramMap;
	}
}
