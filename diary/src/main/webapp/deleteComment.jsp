<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	System.out.println("------------------------------");
	System.out.println("deleteComment.jsp");		
		
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
	
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String diaryDate = request.getParameter("diaryDate");
	System.out.println("commentNo: " + commentNo);

	// delete문
	String sql = "delete from comment where comment_no = ? AND diary_date = ?;";
	
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, commentNo);
	stmt.setString(2,diaryDate);
	
	System.out.println(stmt);
	
	int row = 0;
	row = stmt.executeUpdate();
	System.out.println("row: " + row);

	if(row == 1){
		System.out.println("댓글 삭제 성공");
	} else {
		System.out.println("댓글 삭제 실패");
	}
	response.sendRedirect("/diary/diaryOne.jsp?diaryDate=" +diaryDate);
%>