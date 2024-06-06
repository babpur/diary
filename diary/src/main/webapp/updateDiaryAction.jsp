<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	//where?
	System.out.println("------------------------------");
	System.out.println("updateDiaryAction.jsp");

	String checkDate = request.getParameter("checkDate");
	String ck = request.getParameter("ck");
	
	System.out.println(checkDate);
	System.out.println(ck);
	
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
	%>
	<%
		String diaryDate = request.getParameter("diaryDate");
		String title = request.getParameter("title");
		String weather = request.getParameter("weather");
		String content = request.getParameter("content");
		
		System.out.println(diaryDate);
		System.out.println(title);
		System.out.println(weather);
		System.out.println(content);
	
		String errorMsg = null;
		if(diaryDate == null || diaryDate.isEmpty() || title == null || title.isEmpty()
				|| weather == null || weather.isEmpty() || content == null || content.isEmpty()){
			errorMsg = "정보를 입력해 주세요";
		}
				
		// update 쿼리
		// ? 4개
		String sql = "update diary set title= ?, weather= ?, content= ?, update_date = now() where diary_date = ?";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, title);
		stmt.setString(2, weather);
		stmt.setString(3, content);
		stmt.setString(4, diaryDate);
		
		System.out.println("stmt: " + stmt);
		
		int row = 0;
		
		row = stmt.executeUpdate(); 
		if(errorMsg == null) {
			if(row == 1) {
				response.sendRedirect("/diary/diaryOne.jsp?diaryDate="+diaryDate);
			} else {
				errorMsg = URLEncoder.encode( errorMsg, "utf-8");
				response.sendRedirect("/diary/updateDiaryForm.jsp?diaryDate=" + diaryDate + "&" + "errorMsg=" + errorMsg);			
			}
		}
	%>
