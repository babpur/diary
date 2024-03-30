<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	System.out.println("------------------------------");
	System.out.println("addCommentAction.jsp");		
		
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	 String loginMember = (String)(session.getAttribute("loginMember"));
	 if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해 주세요.", "utf-8");
		// 에러 메시지(한글) 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return;
	 }

	String diaryDate = request.getParameter("diaryDate"); 
	String memo = request.getParameter("memo");
	 
	System.out.println("memo: " + memo);
	 
	/* INSERT INTO COMMENT(
	diary_date, memo, update_date, create_date
	) VALUES (
	?, ?, NOW(), NOW()); */
	String sql = "INSERT INTO COMMENT(diary_date, memo, update_date, create_date) VALUES(?, ?, NOW(), NOW())";
	 
	PreparedStatement stmt = null;
	
	// ? 2개
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	stmt.setString(2, memo);
	
	System.out.println("stmt: " + stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	// 만약 1이라면 입력 성공, 0이라면 입력된 값이 없다.
	if(row == 1){
		System.out.println("입력 성공");
	} else {
		System.out.println("입력 실패");
	}
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" +diaryDate);
%>