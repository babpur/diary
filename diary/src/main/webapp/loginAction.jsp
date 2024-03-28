<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>

<%
	// where?
	System.out.println("------------------------------");
	System.out.println("loginAction.jsp");		
		
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
	if(mySession.equals("ON")){
		response.sendRedirect("/diary/loginForm.jsp");
		return;
		// 해당 코드 내 return 사용: off일 시 코드를 더 이상 진행하지 말 것. ex) 메서드 종료 시 'return' 사용해 종료.
	}
	
	// 1. 요청값 분석
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 요청값 디버깅
	System.out.println(memberId);
	System.out.println(memberPw);

	String sql2 = "select member_id memberId from member where member_id=? and member_pw=?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, memberId);
	stmt2.setString(2, memberPw);
	rs2 = stmt2.executeQuery();
	
	
	if(rs2.next()) {
		// 로그인 성공
		System.out.println("로그인 성공");
		String sql3 = "update login set my_session='ON', on_date = NOW()";
		// diary.login.my_session값을 "ON"으로 변경 
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate();
		System.out.println("row: " + row);
		response.sendRedirect("/diary/diary.jsp");
	} else {
		System.out.println("로그인 실패");
		// 로그인 실패
		// 오류 메시지 + loginForm으로 redirect
		String errMsg = URLEncoder.encode("잘못된 접근입니다. ID와 비밀번호를 확인해 주세요.", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return;
	}
	
	// if문에서 안 걸릴 때를 위해 if문 밖에도 자원 반납 코드 작성
	rs1.close();
	stmt1.close();
	
	rs2.close();
	stmt2.close();
	
	conn.close();
%>

