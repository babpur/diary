<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// 0. 인증 분기 // 
	// where?
	System.out.println("------------------------------");
	System.out.println("checkDateAction.jsp");		
	
	Class.forName("org.mariadb.jdbc.Driver");

	// 변수 초기화
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
	
	
	
	String checkDate = request.getParameter("checkDate");
	
	String dateCkMsg = null;
	
	if(checkDate == null || checkDate.isEmpty()){
		dateCkMsg = URLEncoder.encode("확인할 날짜를 입력해 주세요", "utf-8");
		response.sendRedirect("/diary/addDiaryForm.jsp?dateCkMsg=" + dateCkMsg);
		response.getWriter().close();
		return;
	}

	System.out.println(checkDate);
	String sql = "select diary_date diaryDate from diary where diary_date=?";
	// 해당 결과에 해당되는 날짜가 있다면 해당 날짜로는 입력이 안 됨.
	PreparedStatement stmt = null;
	ResultSet rs = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, checkDate);
	rs = stmt.executeQuery();
	
	if(dateCkMsg == null) {
		if(rs.next()) {
			// 이미 존재하는 날짜이므로 기록 불가능
			response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate + "&ck=F");
		} else {
			// 해당되는 날짜 일기 기록 가능
			
			response.sendRedirect("/diary/addDiaryForm.jsp?checkDate=" + checkDate + "&ck=T" + "&dateCkMsg=" + dateCkMsg);
		}
	}
%>
