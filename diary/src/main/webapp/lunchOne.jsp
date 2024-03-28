<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// ON -> OFF로 변경
	// 당연히 OFF 상태로는 logout.jsp 접근 안 됨.
	
	// where?
	System.out.println("------------------------------");
	System.out.println("lunchOne.jsp");		
		
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
	// 날짜 중복 체크

	String checkDateLunch = request.getParameter("checkDateLunch");
	System.out.println("checkDateLunch: " + checkDateLunch);
	
	String ck = request.getParameter("ck");
	System.out.println("ck: " + ck);
	// 쿼리문
	String sql2 = "select lunch_date lunchDate from lunch where lunch_date = ?";
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, checkDateLunch);
	rs2 = stmt2.executeQuery();

	if(checkDateLunch == null) {
		checkDateLunch = "";
	}
	if(ck == null){
		ck = "";
	}
	
	String msg = "";
	if(ck.equals("T")) {
		msg  = "투표 가능";
	} else if(ck.equals("F")) {
		msg  = "투표 불가능";
	}
	
	if(rs2.next()) {
		// 이미 투표한 날짜: 기록 불가능		
		response.sendRedirect("/diary/lunchOne.jsp?checkDateLunch=" + checkDateLunch + "&ck=F");
		return;
	} else {
		// 빈 날짜: 기록 가능
		response.sendRedirect("/diary/lunchOne.jsp?checkDateLunch=" + checkDateLunch + "&ck=T");
		return;
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
		 	margin-top: 20px;
		}
		.calendar-container {
			display: flex;
			flex-wrap: wrap;
			text-align: center;
		}
		.logout-container {
			text-align: right;
			margin-right: 10px;
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
		legend {
			font-size: 50px;
		}
		.fieldset-container {
			display: flex;
			justify-content: center;
			vertical-align: middle;
			margin-top: 50px;
		}
		.radio-container {
			text-align: center;
		}
	</style>
</head>
<body>
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
			<div class="col">
				<div class="fieldset-container">
					<div>
						점심 날짜 확인:
						<%=checkDateLunch%>
					</div>
					<div>
						ck:
						<%=ck%>
					</div>
					
					
					
					<form method="post" action="/diary/lunchAction.jsp">
					<fieldset class="font">
						<legend>점심 날짜</legend>
						<table>
							<tr>
								<td>
									<input type="date" name="lunchOne" value="<%=checkDateLunch%>"> <!-- type=date 날짜 인터페이스 제공 -->
									<span><%=msg%></span>
								</td>
							</tr>
						</table>
						<button class="btn btn-outline-dark font" type="submit">날짜 확인</button>
					</fieldset>
				</form>
				</div>
			</div>
			<div class="col">
				<div class="fieldset-container">
					<form method="get" action="/diary/lunchAction.jsp" class="font">
						<fieldset>
						<legend>오늘 먹은 점심 메뉴</legend>
							<div class="radio-container">
								<input type="radio" id="menuK" name="menu" value="한식">
								<label for="menuK">한식</label><br>
								<input type="radio" id="menuC" name="menu" value="중식">
								<label for="menuC">중식</label><br>
								<input type="radio" id="menuJ" name="menu" value="일식">
								<label for="menuK">일식</label><br>
								<input type="radio" id="menuE" name="menu" value="기타">
								<label for="menuE">기타</label><br>
							</div>
							<div class="link-container">	
								<button class="btn btn-outline-dark" type="submit">투표하기</button>
								<a class="btn btn-outline-dark" href="/diary/statsLunch.jsp">결과 보기</a>
							</div>
						</fieldset>
					</form>
				</div>
			</div>		
		</div>
	</div>
	
	
</body>
</html>