<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// 0. 인증 분기 // 
		// where?
	System.out.println("------------------------------");
	System.out.println("checkDateAction.jsp");		
		
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
	
	String checkDate = request.getParameter("checkDate");
	System.out.println(checkDate);
	String sql2 = "select diary_date diaryDate from diary where diary_date=?";
	// 해당 결과에 해당되는 날짜가 있다면 해당 날짜로는 입력이 안 됨.
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, checkDate);
	rs2 = stmt2.executeQuery();
	if(rs2.next()) {
		// 이미 존재하는 날짜이므로 기록 불가능
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate + "&ck=F");
	} else {
		// 해당되는 날짜 일기 기록 가능
		response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate + "&ck=T");
	}
	
%>
