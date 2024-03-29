<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	System.out.println("------------------------------");
	System.out.println("logout.jsp");	

	
	// session.removeAttribute("loginMember");
	System.out.println("session.getId()" +session.getId());
	session.invalidate(); // 기존 세션 공간 초기화
	
	response.sendRedirect("/diary/loginForm.jsp");
%>
