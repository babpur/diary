<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>

<%
	// session 사용
	// login 성공 시 session에 loginMember라는 변수 생성하고 값으로 login id를 저장
	String loginMember = (String)session.getAttribute("loginMember");
	// loginMember라는 변수를 가져와서 String으로 형 변환
	// session.getAttribute는 찾는 변수가 없다면 null을 반환한다. == login한 적이 없다.
	// null == 로그아웃, null != 로그인 
	System.out.println("loginMember: " + loginMember);
	
	// loginForm 페이지는 로그아웃 상태일 때만 출력됨.
	if(loginMember != null){
		// login 성공 시 diary.jsp로 redirect
		response.sendRedirect("/diary/diary.jsp");
		return;
	}
	
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
								<button class="btn btn-outline-dark font" id="loginBtn" type="submit">로그인</button>
							</td>
						</tr>
					
						<tr>
							<td><label for="memberPw">비밀번호</label></td>
							<td>
								<input type="password" id="memberPw" name=memberPw placeholder="비밀번호를 입력해 주세요">
							</td>
						</tr>
					</tbody>
					<div>
						<%
							if(errMsg != null){
						%>
								&#128204 <%=errMsg%> 
						<%		
							}
						%>
					</div>
				</table>
			</fieldset>
			</form>	
		</div>	
	</form>
	
	<script>
		window.addEventListenener('load', function() {
			let loginBtn = document.querySelector('#loginBtn'); 
			let memberId = document.querySelector('[name=:memberId]').value.trim();
			let memberPw = document.querySelector('[name=:memberPw]').value.trim();
			if(memberId === '') {
				alert('로그인 ID를 입력해 주세요.');
				event.preventDefault();
				return;
			}
			if(memberPw === '') {
				alert('로그인 PW를 입력해 주세요.');
				event.preventDefault();
				return;
			}
		})
		}
	</script>
</body>
</html>