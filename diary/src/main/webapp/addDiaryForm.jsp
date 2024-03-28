<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	//where?
	System.out.println("------------------------------");
	System.out.println("addDiaryForm.jsp");

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
	
	
	
	if(checkDate == null){
		checkDate = "";
	}
	if(ck == null){
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")){
		msg = "일기 작성이 가능합니다.";
	} else if(ck.equals("F")){
		msg = "일기 작성이 불가능합니다.";
	}
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
			margin-top: 10px;
		}
		legend {
			font-size: 60px;
		}
		table {
			font-size: 30px;
			justify-content: center;
		}
		.link-container {
			ext-align: right;
		}
		.searchWord {
			text-align: center;
			margin-top: 10px;
		}
		button {
			margin: 5px;
		}
		
		.table-box {
			width: 90%;
			margin: auto;
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
	
	<div class="container">
		<div class="row">
			<div class="col"></div>		
			<div class="col-12">
			<%-- <fieldset class="font">
				<legend>날짜 중복 확인</legend>
				<table class="table">
					<tr>
						<td>날짜 확인</td>
						<td><%=checkDate%></td>
					</tr>
					<tr>
						<td>ck</td>
						<td><%=ck%></td>
					</tr>
				</table>
			</fieldset><br> --%>
				
				<form method="post" action="/diary/checkDateAction.jsp">
					<table class="font">
						<tr>
							<td>
								<input type="date" name="checkDate" value="<%=checkDate%>"> <!-- type=date 날짜 인터페이스 제공 -->
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
				<fieldset class="font">
					<legend>일기 쓰기</legend>
					<form method="get" action="/diary/addDiaryAction.jsp">
					<table>
						<tr>
							<td>날짜: </td>
							<td class="table-box">
								<%
									if(ck.equals("T")){
								%>		
										<input type="text" name="diaryDate" value="<%=checkDate%>" readonly="readonly">
								<%
									} else {
								%>
										<input type="text" name="diaryDate" value="" readonly="readonly">
								<%
									}
								%>
							</td>
						</tr>
						<tr>
							<td>기분: </td>
							<td class="table-box">
								<input type="radio" name="feeling" value="&#128512;">&#128512;
								<input type="radio" name="feeling" value="&#128514;">&#128514;
								<input type="radio" name="feeling" value="&#128544;">&#128544;
								<input type="radio" name="feeling" value="&#128547;">&#128547;
								<input type="radio" name="feeling" value="&#128564;">&#128564;
							</td>
						</tr>
						<tr>
							<td>제목: </td>
							<td class="table-box">
								<input type="text" name="title">
							</td>
						</tr>
						<tr>
							<td>날씨: </td>
							<td class="table-box">
								<select name="weather">
									<option value="맑음">맑음</option>
									<option value="흐림">흐림</option>
									<option value="비">비</option>
									<option value="눈">눈</option>
								</select>
							</td>
						</tr>
						<tr>
							<td>내용: </td>
							<td class="table-box">
								<textarea name="content"></textarea>
							</td>
						</tr>
					</table>
					<button class="btn btn-outline-dark font" type="submit">작성</button>
					<button class="btn btn-outline-dark font" type="reset">초기화</button>	
					</form>
				</fieldset>
			</div>
			<div class="col"></div>
		</div>
	</div>
</body>
</html>