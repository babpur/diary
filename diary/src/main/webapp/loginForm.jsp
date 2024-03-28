<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>

<% // diary
	// where?
	System.out.println("------------------------------");
	System.out.println("loginForm.jsp");		
		
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
		response.sendRedirect("/diary/diary.jsp");
		rs1.close();
		stmt1.close();
		conn.close();
		// 자원 반납 먼저 하고 코드 종료
		return; 
		// 해당 코드 내 return 사용: off일 시 코드를 더 이상 진행하지 말 것. ex) 메서드 종료 시 'return' 사용해 종료.
	}
	
	// if문에서 안 걸릴 때를 위해 if문 밖에도 자원 반납 코드 작성
	rs1.close();
	stmt1.close();
	conn.close();
	
	// 1. 요청값 분석
	String errMsg = request.getParameter("errMsg");
	System.out.println("errMsg: " + errMsg);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>loginForm</title>
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
	font-size: 50px;
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
	legend {
	font-size: 90px;
	}
	fieldset {
	margin-top: 120px;
	}
	table {
	font-size: 40px;
	}
	.link-container {
	text-align: center;
	}
	.day, .cell {
	width: 14.2%; /* 100% / 7 days */
	border: 1px solid #000000;
	box-sizing: border-box;
	margin: 0.5px;
	}
	.day {
	font-weight: bold;
	}
	.cell {
	height: 100px; /* or adjust based on your content */
	}
	.sun {
	color: #FF0000;
	}
	button {
	margin-top: 20px;
	width: 80px;
	height: 80px;
	}
	</style>
</head>

<body>
<form method="post" 
			action="/diary/loginAction.jsp">
		<nav class="navbar navbar-dark bg-dark">
			<div class="navbar-nav">
			    <span class="nav-link active font" aria-current="page" 
			    	style="color: #FFFFFF;">DIARY</span>
		    </div>
		</nav>	
		<div class="login-container">	
			<form>
			<fieldset class="font">	
				<legend>로그인</legend>
				<table class="table" >
					<tbody>
						<tr>
							<td><label for="memberId">아이디</label></td>
							<td><input type="text" id="memberId" name=memberId placeholder="아이디를 입력해 주세요"></td>
							<td rowspan="2">
								<button class="btn btn-outline-dark font" type="submit">로그인</button>
							</td>
						</tr>
					
						<tr>
							<td><label for="memberPw">비밀번호</label></td>
							<td>
								<input type="password" id="memberPw" name=memberPw placeholder="비밀번호를 입력해 주세요">
							</td>
						</tr>
					</tbody>
				</table>
			</fieldset>
			<div>
			<%
				if(errMsg != null){
			%>
					&#128204 <%=errMsg%> 
			<%		
				}
			%>
			</div>
			</form>	
		</div>	
	</form>
</body>
</html>