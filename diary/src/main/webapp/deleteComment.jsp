<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	System.out.println("------------------------------");
	System.out.println("deleteComment.jsp");		
		
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
%>