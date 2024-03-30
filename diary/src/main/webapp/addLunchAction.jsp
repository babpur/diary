<%@page import="org.apache.catalina.ha.backend.Sender"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	

	// 점심 메뉴 투표 완료 시 추가
	
	// 값 넘어오는지 확인
	String diaryDate = request.getParameter("diaryDate");
	String menu = request.getParameter("menu");
	
	System.out.println("diaryDate: "+ diaryDate);
	System.out.println("menu: " + menu);
	
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	// 로그인 session
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해 주세요.", "utf-8");
		// 에러 메시지(한글) 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return;
	 }
	
	// DB 추가 쿼리문
	/*
		INSERT INTO lunch(lunch_date, menu, update_date, create_date)
		VALUES('2024-03-14', '기타', NOW(), NOW());
	*/
	String sql = "insert into lunch(lunch_date, menu, update_date, create_date) values(?, ?, now(), now())";
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, menu);
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	
	if(row == 1){
		System.out.println("투표 완료");
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate);
	} else {
		System.out.println("투표 실패");
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate);
	}
	
%>