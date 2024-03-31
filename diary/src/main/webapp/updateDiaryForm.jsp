<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	//where?
	System.out.println("------------------------------");
	System.out.println("updateDiaryForm.jsp");

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
	
	
	if(checkDate == null){
		checkDate = "";
	}
	if(ck == null){
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")){
		msg = "입력 가능한 날짜";
	} else if(ck.equals("F")){
		msg = "입력 불가능한 날짜";
	}
%>
<%
	// diaryOne -> updateDiaryForm
	String diaryDate = request.getParameter("diaryDate");
	String title = request.getParameter("title");
	String weather = request.getParameter("weather");
	String content = request.getParameter("content");
	
	System.out.println("diaryDate: "+diaryDate);
	System.out.println("title: "+title);
	System.out.println("weather: "+weather);
	System.out.println("content: "+content);

	String sql = "select diary_date diaryDate, feeling, title, weather, content, update_date updateDate from diary where diary_date = ?";
	PreparedStatement stmt = null;
	ResultSet rs = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	rs = stmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>addDiaryForm</title>
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
			vertical-align: middle;
			text-aling: center;
			justify-content: center;
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
		.table-link-container {
			text-align: center;
		}
		.center {
			text-align: center;
		}
		
	</style>
</head>
<!-- new form -->
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
	<div class="container">
		<div class="row">
			<div class="col"></div>		
			<div class="col-7">
				
				<fieldset class="font">
					<legend>일기 수정</legend>
					<form method="post" action="/diary/checkDateAction.jsp">
					<table class="font center">
						<tr>
							<td>
								<input type="date" name="checkDate" value="<%=checkDate%>"
										style="width: 300px;" class="center"> <!-- type=date 날짜 인터페이스 제공 -->
							</td>
							<td>
								<button class="btn btn-outline-dark font" type="submit">날짜 확인</button>
							</td>
						</tr>
						<tr>
							<td><%=msg%></td>
						</tr>
					</table>
					</form>
					<form method="get" action="/diary/addDiaryAction.jsp">
					<table class= center>
						<%
							if(rs.next()){
						%>
			
						<tr>
							<td>날짜</td>
							<td class="table-box">
								<input type="text" name="diaryDate" value="<%=diaryDate%>" readonly="readonly">
							</td>
						</tr>
						<tr>
							<td>기분</td>
							<td class="table-box" style="font-size: 30px;">
								<%
									if(rs.getString("feeling").equals("&#128512;")) {
								%>
										<input type="radio" name="feeling" value="&#128512;" checked="checked">&#128512;
										<input type="radio" name="feeling" value="&#128514;">&#128514;
										<input type="radio" name="feeling" value="&#128544;">&#128544;
										<input type="radio" name="feeling" value="&#128547;">&#128547;
										<input type="radio" name="feeling" value="&#128564;">&#128564;
								<%		
									} else if(rs.getString("feeling").equals("&#128514;")) {
								%> 
										<input type="radio" name="feeling" value="&#128512;">&#128512;
										<input type="radio" name="feeling" value="&#128514;" checked="checked">&#128514;
										<input type="radio" name="feeling" value="&#128544;">&#128544;
										<input type="radio" name="feeling" value="&#128547;">&#128547;
										<input type="radio" name="feeling" value="&#128564;">&#128564;
								<%		
									} else if(rs.getString("feeling").equals("&#128544;")) {
								%>
										<input type="radio" name="feeling" value="&#128512;">&#128512;
										<input type="radio" name="feeling" value="&#128514;">&#128514;
										<input type="radio" name="feeling" value="&#128544;" checked="checked">&#128544;
										<input type="radio" name="feeling" value="&#128547;">&#128547;
										<input type="radio" name="feeling" value="&#128564;">&#128564;
								<%		
									} else if(rs.getString("feeling").equals("&#128547;")) {
								%>
										<input type="radio" name="feeling" value="&#128512;">&#128512;
										<input type="radio" name="feeling" value="&#128514;">&#128514;
										<input type="radio" name="feeling" value="&#128544;">&#128544;
										<input type="radio" name="feeling" value="&#128547;" checked="checked">&#128547;
										<input type="radio" name="feeling" value="&#128564;">&#128564;
								<%		
									} else {
								%>
										<input type="radio" name="feeling" value="&#128512;">&#128512;
										<input type="radio" name="feeling" value="&#128514;">&#128514;
										<input type="radio" name="feeling" value="&#128544;">&#128544;
										<input type="radio" name="feeling" value="&#128547;">&#128547;
										<input type="radio" name="feeling" value="&#128564;" checked="checked">&#128564;
								<%		
									}
								%>
								
							</td>
						</tr>
						<tr>
							<td>제목</td>
							<td class="table-box">
								<input type="text" name="title" value="<%=rs.getString("title")%>">
							</td>
						</tr>
						<tr>
							<td class="table-box">날씨</td>
							<td  style="font-size: 30px;">
								<select name="weather" style="border-radius:10px;">
									<%
										if(rs.getString("weather").equals("맑음")){
									%>
											<option value="맑음" selected>맑음</option>
											<option value="흐림">흐림</option>
											<option value="비">비</option>
											<option value="눈">눈</option>
									<% 
										} else if (rs.getString("weather").equals("흐림")){
									%>
											<option value="맑음">맑음</option>
											<option value="흐림" selected>흐림</option>
											<option value="비">비</option>
											<option value="눈">눈</option>
									<% 
										} else if (rs.getString("weather").equals("비")){
									%>
											<option value="맑음">맑음</option>
											<option value="흐림">흐림</option>
											<option value="비" selected>비</option>
											<option value="눈">눈</option>
									<% 	
										} else {
									%>
											<option value="맑음">맑음</option>
											<option value="흐림">흐림</option>
											<option value="비">비</option>
											<option value="눈" selected>눈</option>
									<% 	
										}
									%>
								</select>
							</td>	
						</tr>
						<tr>
							<td>내용</td>
							<td>
								<textarea name="content"><%=rs.getString("content")%></textarea>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<button class="btn btn-outline-dark font table-link-container" type="submit">수정</button>
								<button class="btn btn-outline-dark font table-link-container" type="reset">초기화</button>
							</td>
						</tr>
						<%
							}
						%>
					</table>
					</form>
				</fieldset>
			</div>
			<div class="col"></div>
		</div>
	</div>
</body>
</html>