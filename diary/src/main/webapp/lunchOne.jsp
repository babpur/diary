<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// ON -> OFF로 변경
	// 당연히 OFF 상태로는 logout.jsp 접근 안 됨.
	
	// where?
	System.out.println("------------------------------");
	System.out.println("lunchOne.jsp");		
		
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
	// 투표 날짜 중복 체크

	String diaryDate = request.getParameter("diaryDate");
	String msg = request.getParameter("msg");
	String errorMsg = request.getParameter("errorMsg");
	System.out.println("diaryDate: " + diaryDate);
	
	// 쿼리문
	String sql = "select * from lunch where lunch_date = ?";
	PreparedStatement stmt = null;
	ResultSet rs = null;
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, diaryDate);
	rs = stmt.executeQuery();
	System.out.println(stmt);

	// 투표 날짜 중복 체크
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
		.main-container {
		}
		.msg-container {
			display: flex;
		    justify-content: center;
		    text-align: center; 
		    flex-direction: column; 
		    margin: auto; 
		    width: fit-content; 
		}
		.form-container {
			display: flex;
		    justify-content: center;
		    text-align: center; 
		    flex-direction: column; 
		    margin: auto; 
		    width: fit-content; 
		}
		.form-head-container {
			display: flex;
		    justify-content: center;
		    text-align: center; 
		    flex-direction: column; 
		    margin: auto; 
		    width: fit-content; 
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
	
	<div class="main-container">
	<%
		if(rs.next()){ // 투표한 날짜가 존재한다면 기존 투표 결과를 보여주기.
			String year = diaryDate.substring(0,4);
			String month = diaryDate.substring(5,7);
			String day = diaryDate.substring(8,10);
	%>
	
			<div class="msg-container font">
				<div style="font-size: 50px;">투표가 완료되었습니다.</div><br>
				<div style="font-size: 40px;">
					<%=year%>년 <%=month%>월 <%=day%>일&nbsp;
					점심 메뉴는 <b>'<%=rs.getString("menu")%>'</b>입니다.
				</div><br>
				<div>
					<a class="btn btn-outline-dark font" href="/diary/deleteLunchAction.jsp?diaryDate=<%=diaryDate%>">투표 메뉴 삭제</a>&nbsp;&nbsp;
					<a class="btn btn-outline-dark font" href="/diary/statsLunch.jsp">전체 통계</a>
				</div>
			
				<%
					} else { // 투표 결과 없을 시 투표창 출력
				%>
						<div class="form-head-container font"
								style="font-size: 50px;">점심 메뉴 선택</div>
				<%
						if(msg == null) {
				%>
							<div class="form-head-container font"></div>
				<%			
					} else if(msg.equals("삭제 완료")){
				%>
						<div class="form-head-container font"
								style="font-size: 50px;">
								기존 투표 데이터 삭제 완료하였습니다. <br> 
								다시 선택해 주세요.
						</div>
				<%
					}
				%>
				<div class="form-container font" style="font-size: 40px;">
					<form method="post" action="/diary/addLunchAction.jsp?diaryDate=<%=diaryDate%>">
						<input type="radio" name="menu" class="m-3" value="양식" id="menu1">&nbsp;
						<label for="menu1">양식</label><br>
							
						<input type="radio" name="menu" class="m-3" value="일식" id="menu2">&nbsp;
						<label for="menu2">일식</label><br>
							
						<input type="radio" name="menu" class="m-3" value="중식" id="menu3">&nbsp;
						<label for="menu3">중식</label><br>
						
						<input type="radio" name="menu" class="m-3" value="한식" id="menu4">&nbsp;
						<label for="menu4">한식</label><br>
						
						<input type="radio" name="menu" class="m-3" value="기타" id="menu5">&nbsp;
						<label for="menu5">기타</label><br>
						<button id="lunchBtn" class="btn btn-outline-dark" style="font-size: 30px;">투표 완료</button>
					</form>
					<%
						if(errorMsg != null){
					%>
							<div><%=errorMsg%></div>
					<%		
						}
					%>
				</div>
			<%
				}
			%>
		</div>
		</div>
		<div class="col"></div>

	<script>
		window.addEventListener('load', function(){
			let lunchBtn = document.querySelector('#lunchBtn');
			let menu = document.querySelector('[name=:menu]').value.trim();
			
			loginBtn.addEventListener('click', function(event) {
				
				if(menu === '') {
					alert('메뉴를 선택해 주세요.');
					event.preventDefault();
					return;
				}
			}
		});
	</script>
</body>
</html>
