<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// where?
	System.out.println("------------------------------");
	System.out.println("addDiaryAction.jsp");
	
	// 로그인 session
	String loginMember = (String)(session.getAttribute("loginMember"));
	 if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해 주세요.", "utf-8");
		// 에러 메시지(한글) 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return;
	}

	// 요청값
	String diaryDate = request.getParameter("diaryDate");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");

	String errorMsg = null;
	
	if(diaryDate == null || diaryDate.isEmpty() || feeling == null || feeling.isEmpty() || title == null || title.isEmpty() 
			|| weather == null || weather.isEmpty() || content == null || content.isEmpty()) {
		errorMsg = URLEncoder.encode("정보가 입력되지 않았습니다.", "utf-8");
	}
	
	System.out.println("diaryDate: " + diaryDate);
	System.out.println("title: " + title);
	System.out.println("weather: " + weather);
	System.out.println("content: " + content);
	
	
	Class.forName("org.mariadb.jdbc.Driver");

	// 변수 초기화
	Connection conn = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	
	// --------------------------------------------------------------------
	
	// 쿼리
	/* INSERT INTO diary(diary_date, title, weather, content, update_date, create_date)
	VALUES(?, ?, ?, ?, NOW(), NOW()); */
	
	String sql = "INSERT INTO diary(diary_date, feeling, title, weather, content, update_date, create_date) VALUES(?, ?, ?, ?, ?, NOW(), NOW())";
	
	PreparedStatement stmt = null;
	stmt = conn.prepareStatement(sql);
	
	stmt.setString(1, diaryDate);
	stmt.setString(2, feeling);
	stmt.setString(3, title);
	stmt.setString(4, weather);
	stmt.setString(5, content);

	System.out.println("stmt2: " + stmt);
	
	// 입력 성공 or 실패 여부에 따라 재요청(redirect)하게 한다.
	int row = 0;
	row = stmt.executeUpdate();
	// 만약 1이라면 입력 성공, 0이라면 입력된 값이 없다.
	if(row == 1){
		System.out.println("입력 성공");
		response.sendRedirect("/diary/diary.jsp");
	} else {
		System.out.println("입력 실패");
		response.sendRedirect("/diary/addDiaryForm.jsp?errorMsg=" + errorMsg);
	}
	
%>