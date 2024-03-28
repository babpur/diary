<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// where?
	System.out.println("------------------------------");
	System.out.println("addDiaryAction.jsp");
	
	// 요청값
	String diaryDate = request.getParameter("diaryDate");
	String feeling = request.getParameter("feeling");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	System.out.println("diaryDate: " + diaryDate);
	System.out.println("title: " + title);
	System.out.println("weather: " + weather);
	System.out.println("content: " + content);
	
	// 0. 인증 분기 
	// ㄴ login
	
	// diary.login.my_session => 'ON' -> redirect("diary.jsp")
	// db	table	col
	
	// ------------------------------
	
	String sql1 = "select my_session mySession from login";
	// DB상 my_session을 mySession으로 가져오겠다.
	
	Class.forName("org.mariadb.jdbc.Driver");

	// 변수 초기화
	Connection conn = null;
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	stmt1 = conn.prepareStatement(sql1);
	
	rs1 = stmt1.executeQuery();
	
	String mySession = null;
	if(rs1.next()){
		mySession = rs1.getString("mySession");	
	}
	if(mySession.equals("OFF")) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해 주세요", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return; 
		// 해당 코드 내 return 사용: off일 시 코드를 더 이상 진행하지 말 것. ex) 메서드 종료 시 'return' 사용해 종료.
	}
	
	// --------------------------------------------------------------------
	
	// 쿼리
	/* INSERT INTO diary(diary_date, title, weather, content, update_date, create_date)
	VALUES(?, ?, ?, ?, NOW(), NOW()); */
	
	String sql2 = "INSERT INTO diary(diary_date, feeling, title, weather, content, update_date, create_date)	VALUES(?, ?, ?, ?, ?, NOW(), NOW())";
	
	PreparedStatement stmt2 = null;
	stmt2 = conn.prepareStatement(sql2);
	
	stmt2.setString(1, diaryDate);
	stmt2.setString(2, feeling);
	stmt2.setString(3, title);
	stmt2.setString(4, weather);
	stmt2.setString(5, content);

	System.out.println("stmt2: " + stmt2);
	
	// 입력 성공 or 실패 여부에 따라 재요청(redirect)하게 한다.
	int row = 0;
	row = stmt2.executeUpdate();
	// 만약 1이라면 입력 성공, 0이라면 입력된 값이 없다.
	if(row == 1){
		System.out.println("입력 성공");
		response.sendRedirect("/diary/diary.jsp");
	} else {
		System.out.println("입력 실패");
		response.sendRedirect("/diary/addDiaryForm.jsp");
	}
	
%>