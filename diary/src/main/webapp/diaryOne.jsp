<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.net.*"%>
<%	// ON -> OFF로 변경
	// 당연히 OFF 상태로는 logout.jsp 접근 안 됨.
	
	// where?
	System.out.println("------------------------------");
	System.out.println("diaryOne.jsp");		
		
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
	
	// ---------------------------------------
	
	// 요청값 diary.jsp에서 diaryDate 넘김
	String diaryDate = request.getParameter("diaryDate");
	System.out.println("diaryDate: " + diaryDate);
	
	// DB -> One에 필요한 데이터
	
	String sql2 = "select diary_date, feeling, title, weather, content, update_date updateDate from diary WHERE diary_date=?";
	
	// stmt2 -> null
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setString(1, diaryDate);
	rs2 = stmt2.executeQuery();

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
		 	
		}
		.link-container {
		text-align: right;
		}
		.searchWord {
		text-align: center;
		margin-top: 10px;
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
			<div class="col-7">
				<fieldset class="font">
					<legend>오늘의 일기</legend>
					<table class="table table-hover">
						<tr>
							<td>날짜</td>
							<td><%=diaryDate%></td>
						</tr>
						<tr>
							<td>기분</td>
							<td><%=rs2.getString("feeling")%></td>
						</tr>
						<tr>
							<td>제목</td>
							<td><%=rs2.getString("title")%></td>
						</tr>
						<tr> 
							<td>날씨</td>
							<td><%=rs2.getString("weather")%></td>
						</tr>
						<tr>
							<td>내용</td>
							<td><%=rs2.getString("content")%></td>
						</tr>
						<tr>
							<td>수정 시간</td>
							<td><%=rs2.getString("updateDate")%></td>
						</tr>
					</table>
				</fieldset>
				<div class="link-container">
					<a class="btn btn-outline-dark font" href="/diary/diaryList.jsp">목록</a>
					<a class="btn btn-outline-dark font" href="/diary/updateDiaryForm.jsp?diaryDate=<%=diaryDate%>">수정</a>
					<a class="btn btn-outline-dark font" href="/diary/deleteDiary.jsp?diaryDate=<%=diaryDate%>">삭제</a>
				</div>
			</div>
			<div class="col"></div>
		</div>
	</div>
</body>
</html>