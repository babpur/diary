<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>

<%
	// where?
	System.out.println("------------------------------");
	System.out.println("loginAction.jsp");		
		
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String loginMember = (String)session.getAttribute("loginMember");
	// loginMember라는 변수를 가져와서 String으로 형 변환
	// session.getAttribute는 찾는 변수가 없다면 null을 반환한다. == login한 적이 없다.
	// null == 로그아웃, null != 로그인 
	System.out.println("loginMember: " + loginMember);
	
	//loginForm 페이지는 로그아웃 상태일 때만 출력됨.
	if(loginMember != null){
		// login 성공 시 diary.jsp로 redirect
		response.sendRedirect("/diary/diary.jsp");
		return;
	}
	 // loginMember가 null이다.
	 // session 공간에 loginMember 변수 생성
 
%>
<%

	// 1. 요청값 분석 -> 로그인 성공 여부 판단 -> session 공간에 loginMember 변수 생성
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 요청값 디버깅
	System.out.println(memberId);
	System.out.println(memberPw);
	
	String sql = "select member_id memberId from member where member_id=? and member_pw=?";
	PreparedStatement stmt = null;
	ResultSet rs = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	stmt.setString(2, memberPw);
	rs = stmt.executeQuery();
	
	if(rs.next()) {
		// 로그인 성공
		System.out.println("로그인 성공");
		/* String sql3 = "update login set my_session='ON', on_date = NOW()";
		// diary.login.my_session값을 "ON"으로 변경 
		PreparedStatement stmt3 = conn.prepareStatement(sql3);
		int row = stmt3.executeUpdate();
		System.out.println("row: " + row); */
		
		// 로그인 성공 시 DB값 설정 -> session 변수 세팅으로 변경
		session.setAttribute("loginMember", rs.getString("memberId"));
		// pw는 세션에 포함하지 않는 게 좋다.
		
		response.sendRedirect("/diary/diary.jsp");
	} else {
		System.out.println("로그인 실패");
		// 로그인 실패
		// 오류 메시지 + loginForm으로 redirect
		String errMsg = URLEncoder.encode("잘못된 접근입니다. ID와 비밀번호를 확인해 주세요.", "utf-8");
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return;
	}
%>