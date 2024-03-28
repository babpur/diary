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
	
		// update 쿼리
		// ? 4개
		String sql2 = "update diary set title=?, weather=?, content=?, updateDate=now() where diaryDate = ?";
		PreparedStatement stmt2 = null;
		ResultSet rs2 = null;
		
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, title);
		stmt2.setString(2, weather);
		stmt2.setString(3, content);
		stmt2.setString(4, diaryDate);
		
		System.out.println("stmt2: " + stmt2);
		
		int row = 0;
		
		row = stmt2.executeUpdate(); 
		
		if(row == 1) {
			response.sendRedirect("diary/diaryOne.jsp?diaryDate="+diaryDate);
		} else {
			response.sendRedirect("diary/updateDiaryForm.jsp?diaryDate="+diaryDate);			
		}
		
	%>
