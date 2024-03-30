<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// ON -> OFF로 변경
	// 당연히 OFF 상태로는 logout.jsp 접근 안 됨.
	
	// where?
	System.out.println("------------------------------");
	System.out.println("diaryList.jsp");		
		
	
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
	// 출력 리스트
	// 가독성 향상을 위해 나눔
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	// 사용자에 따라 변동될 수 있음
	
	int rowPerPage = 10 ;
	// 한 페이지 10개
	/* if(request.getParameter("rowPerPage") != null){
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	} */
	// 사용자에 따라 변동될 수 있음
	
	int startRow = (currentPage -1 ) * rowPerPage; 
	
	String searchWord = "";
	if(request.getParameter("searchWord") != null){
		searchWord = request.getParameter("searchWord");
	}
	
	
	// 0 ~ 10 개
	
	// "selecet diary_date diaryDate, title from diary where title like ? order by diary_date desc limit ?, ?";
	String sql1 = "select diary_date diaryDate, title from diary where title like ? order by diary_date desc limit ?, ?";
	
	PreparedStatement stmt1 = null;
	ResultSet rs1 = null;
	
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, "%" + searchWord + "%");
	stmt1.setInt(2, startRow);
	stmt1.setInt(3, rowPerPage);
	
	System.out.println("stmt1: " + stmt1);

	rs1 = stmt1.executeQuery();
%>
<%
	// lastPage
	String sql2 = "select count(*) cnt from diary where title like ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1,"%" + searchWord + "&");
	rs2 = stmt2.executeQuery();
	int totalRow = 0;
	if(rs2.next()){
		totalRow = rs2.getInt("cnt");
	}
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0){
		lastPage = lastPage + 1;
	}
%>	

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
	<!-- font -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
	<style>
		a {
			text-decoration: none;
		}
		a:link {
			color: #000000;
		}
		a:visited{
			color: #000000;
		}
		a:hover {
			color: #FFFFFF;
			background-color: #000000;
		}
		a:active {
			color: #FFFFFF;
			background-color: #000000;
		}
		h1 {
			font-size: 40px;
		}
		.font{
			font-family: "Dongle", sans-serif;
			font-weight: 400;
			font-style: normal;
			font-size: 30px;
			color: #000000;
		}
		 html, body {
			margin: 5;
			padding: 5;
			width: 100%;
			height: 100%;
		}
		.head-container {
			text-align: center;
			margin-top: 5px;
		}
		.login-container {
			display: flex;
			justify-content: center;
			align-items: center;
		}
		.logout-container {
			text-align: right;
			margin-right: 10px;
		}
		fieldset {
			justify-content: center;
		}
		legend {
			font-size: 60px;
		}
		table {
			font-size: 40px;
			width: 500px;
		}
		.link-container {
			text-align: center;
		}
		.searchWord {
			text-align: center;
			margin-top: 10px;
		}
		.fieldset-container {
			justify-content: center;
		}
	</style>
</head>
<body>
	<nav class="navbar navbar-dark bg-dark">
		<div class="navbar-nav">
		    <a class="nav-link active font" aria-current="page" href="/diary/diary.jsp" 
		    	style="color: #FFFFFF;">DIARY</a>
	    </div>
	</nav><br>
	
	<div class="logout-container">
		<a class="btn btn-outline-dark font right" href="/diary/logout.jsp">로그아웃</a>
	</div>
	<div class="link-container">
		<a href="/diary/diary.jsp" style="font-size: 50px;">&#128197;</a>
		<a href="/diary/addDiaryForm.jsp" style="font-size: 50px;">&#128395;</a>
		<a href="/diary/lunchOne.jsp" style="font-size: 50px;">&#127857;</a>
	</div>
	
	
	<div class="container">
		<div class="row">
			<div class="col"></div>
			<div class="col-7">
				<div class="fieldset-container p-20">
					<fieldset class="font">
						<legend>일기 목록</legend>
						<table class="table mt-2">
							<thead>
								<tr>
									<td>날짜</td>
									<td>제목</td>
								</tr>
							</thead>
							<tbody>
								<%
									while(rs1.next()){
								%>
										<tr>
											<td><a href="/diary/diaryOne.jsp?diaryDate=<%=rs1.getString("diaryDate")%>"><%=rs1.getString("diaryDate")%></a></td>
											<td><a href="/diary/diaryOne.jsp?diaryDate=<%=rs1.getString("diaryDate")%>"><%=rs1.getString("title")%></a></td>
										</tr>
								<%		
									}
								%>
							</tbody>
						</table>
					</fieldset>
					
					<form method="get" action="/diary/diaryList.jsp">
						<div class="searchWord font">
							제목 검색 :
							<input type="text" name="searchWord">
							<button class="btn btn-outline-dark font" type="submit">검색</button>
						</div>
					</form>
					
					<nav aria-label="Page navigation" style="clear:both;"><br>
						<ul class="pagination justify-content-center "
							style="color: #FFFFFF;">
							
							<%
								if (currentPage > 1) {
							%>
									<li class="page-item">
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=1&searchWord=<%=searchWord%>">처음</a>
									</li>
									<li class="page-item">	 
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=<%=currentPage - 1%>&searchWord=<%=searchWord%>">이전</a>
									</li>
							<%
								} else {
							%>	
									<li class="page-item disabled">
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=1&searchWord=<%=searchWord%>">처음</a>
									</li>
									<li class="page-item disabled">
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=<%=currentPage - 1%>&searchWord=<%=searchWord%>">이전</a>
									</li>
							<%		
								}
							
								if(currentPage < lastPage) {
							%>
									<li class="page-item">
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=<%=currentPage + 1%>&searchWord=<%=searchWord%>">다음</a>
									</li>
									<li class="page-item">
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=<%=lastPage+1%>&searchWord=<%=searchWord%>">마지막</a>
									</li>
							<%		
								} else {
							%>
									<li class="page-item disabled">
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=<%=currentPage + 1%>&searchWord=<%=searchWord%>">다음</a>
									</li>
									<li class="page-item disabled">
										<a class="page-link btn btn-outline-dark font m-1" href="/diary/diaryList.jsp?currentPage=<%=lastPage+1%>&searchWord=<%=searchWord%>">마지막</a>
									</li>
							<%		
								}
							%>
						</ul>
					</nav>
				</div>
			</div>
			<div class="col"></div>
		</div>
	</div>
</body>
</html>