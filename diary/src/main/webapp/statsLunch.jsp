<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%
	// login 
	
	// ON -> OFF로 변경
	// 당연히 OFF 상태로는 logout.jsp 접근 안 됨.
	
	// where?
	System.out.println("------------------------------");
	System.out.println("statsLunch.jsp");		
		
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
	
	// 차트 쿼리문
	String sql = "select menu, count(*) cnt from lunch group by menu";
	
	PreparedStatement stmt = null;
	
	stmt = conn.prepareStatement(sql);
	ResultSet rs = null;
	
	rs = stmt.executeQuery();
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
		.main {
			justify-content: center;
		 	text-align: center;
		}
		.tottal {
			justify-content: center;
		 	text-align: center;
		}
		.table-container {
			justify-content: center;
		 	text-align: center;
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
	<div class="link-container">
		<a href="/diary/diary.jsp" style="font-size: 50px;">&#128197;</a>
		<a href="/diary/diaryList.jsp" style="font-size: 50px;">&#128203;</a>
	</div>
	<main class="font main">
		<h2 style="font-size:50px;">점심 메뉴 투표 결과</h2>
		<div class="main-container font">
		<%
			int maxHeight = 300; // 300 * 퍼센테이지를 하면 개별 크기 구할 수 있음
			double totalCnt = 0; //
			while(rs.next()) {
				totalCnt = totalCnt + rs.getInt("cnt");
			}
			rs.beforeFirst();
		%>			
	
		<table class="table-container">
			<tr>
				<%	
					String[] c = {"red","orange","yellow", "green", "blue", "navy", "violet" };			
					int i = 0;
					while(rs.next()){
						double h = (int)(maxHeight * (rs.getInt("cnt") / totalCnt));
				%>
					<td style="vertical-align: bottom;">
						<div style="height: <%=h%>px; 
									background-color:<%=c[i]%>;
									text-align: center;
									width: 150px;">
							<%=rs.getInt("cnt")%>
						</div>
					</td>			
				<%
						i = i + 1;
					}
				%>
			</tr>
			<tr>	
				<%					
					rs.beforeFirst(); // rs를 원래 자리로 돌림
					while(rs.next()){
				%>
						<td><%=rs.getString("menu")%></td>
				<%		
					}
				%>
			</tr>
		
		</table>
		<div>
			전체 투표수 : <%=(int)totalCnt%>
		</div>	
		</div>
	</main>
</body>
</html>