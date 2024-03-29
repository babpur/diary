<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%
	// 점심투표 삭제하기
	
	// 넘어온 변수값 불러오기
	String diaryDate = request.getParameter("diaryDate");
	System.out.println("diaryDate: " + diaryDate);
	
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
	
	
	// DB 삭제 쿼리
	/*
		DELETE FROM lunch
		WHERE lunch_Date = ?;
	*/
	
	String sql = "delete from lunch where lunch_date = ?";
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	String msg = null;
	
	if(row == 1){
		System.out.println("삭제 완료");
		msg = "삭제 완료";
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate+"&msg="+msg);
	}else{
		System.out.println("삭제 실패");
		msg = "삭제 실패";
		response.sendRedirect("/diary/lunchOne.jsp?diaryDate="+diaryDate+"&msg="+msg);
	}	
%>