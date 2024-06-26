<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	//where?
	System.out.println("------------------------------");
	System.out.println("addDiaryForm.jsp");

	String checkDate = request.getParameter("checkDate");
	String ck = request.getParameter("ck");
	String dateCkMsg = request.getParameter("dateCkMsg");
	String errorMsg = request.getParameter("errorMsg");
	
	System.out.println("checkDate: " + checkDate);
	System.out.println("dateCkMsg: " + dateCkMsg);
	System.out.println("ck: " + ck);

	
	Class.forName("org.mariadb.jdbc.Driver");

	// 변수 초기화
	Connection conn = null;
	PreparedStatement stmt1 = null;
	
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String loginMember = (String)(session.getAttribute("loginMember"));
	if(loginMember == null) {
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해 주세요.", "utf-8");
		// 에러 메시지(한글) 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		return;
	 }

	// -------------------------------------------------------
	
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
					<legend>일기 쓰기</legend>
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
							<td>
								<%
									if(dateCkMsg != null){
								%>
										<div><%=msg%></div>
								<%
									}
								%>
							</td>
						</tr>
					</table>
					</form>
					<form method="get" action="/diary/addDiaryAction.jsp">
					<table class="center">
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
							<td class="table-box"
								style="font-size: 30px;">
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
							<td class="table-box" style="font-size: 30px;">
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
						<tr>
							<td>
								&nbsp;
							</td>
							<td>
								<button class="btn btn-outline-dark font table-link-container" type="submit" id="btn">작성</button>
								<button class="btn btn-outline-dark font table-link-container" type="reset">초기화</button>
							</td>
						</tr>
					</table>
					</form>
					<%
						if(errorMsg != null) {
					%>
							<div><%=checkDate%></div>
					<%		
						}
					%>
				</fieldset>
			</div>
			<div class="col"></div>
		</div>
	</div>
	<script>	
		window.addEventListener('load', function() {
		    let btn = document.querySelector('#btn');
		    btn.addEventListener('click', function(event) {
		        let diaryDate = document.querySelector('[name="diaryDate"]').value.trim();
		        let feeling = document.querySelector('[name="feeling"]:checked');
		        let title = document.querySelector('[name="title"]').value.trim();
		        let weather = document.querySelector('[name="weather"]').value.trim();
		        let content = document.querySelector('[name="content"]').value.trim();
		
		        if (diaryDate === '') {
		            alert('날짜를 확인해 주세요.');
		            event.preventDefault(); // 폼 제출 막기
		            return;
		        }
		        
		        if (!feeling) {
		            alert('기분을 선택해 주세요.');
		            event.preventDefault();
		            return;
		        }
		        
		        if (title === '') {
		            alert('제목을 입력해 주세요.');
		            event.preventDefault();
		            return;
		        }
		
		        if (weather === '') {
		            alert('날씨를 선택해 주세요.');
		            event.preventDefault();
		            return;
		        }
		
		        if (content === '') {
		            alert('내용을 입력해 주세요.');
		            event.preventDefault();
		            return;
		        }
		    });
		});
	</script>
</body>
</html>