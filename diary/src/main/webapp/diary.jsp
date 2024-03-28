<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*"%>
<%@ page import="java.util.*" %>
<%
	//where?
	System.out.println("------------------------------");
	System.out.println("diary.jsp");
	

	//인증 분기
	// ㄴ login
	
	// diary.login.my_session => 'ON' -> ON or 'OFF' -> redirect("loginForm.jsp")
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
	if(mySession.equals("OFF")){
		String errMsg = URLEncoder.encode("잘못된 접근입니다. 로그인 먼저 해 주세요.", "utf-8");
		// 에러 메시지(한글) 인코딩
		response.sendRedirect("/diary/loginForm.jsp?errMsg=" + errMsg);
		// 에러 메시지 출력
		return; 
		// 해당 코드 내 return 사용: off일 시 코드를 더 이상 진행하지 말 것. ex) 메서드 종료 시 'return' 사용해 종료.
	}
	
	// ------------------------------------------------
	// 달력 
	// 출력하고자 하는 연도, 월의 값
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	
	Calendar target = Calendar.getInstance();
	
	if(targetYear != null && targetMonth != null){
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
	}
	
	// 시작 공백의 개수: 1일의 요일이 필요함.
	// 타겟 날짜 1일로 변경
	target.set(Calendar.DATE, 1);
	
	// TITLE에 출력할 변수
	int tYear = target.get(Calendar.YEAR);
	int tMonth = target.get(Calendar.MONTH);
	
	System.out.println("tYear: " + tYear);
	System.out.println("tMonth: " + tMonth);
	
	// 일요일:1 ~ 토요일: 7 // 일요일이 1일일 시 공백 x
	int dayNum = target.get(Calendar.DAY_OF_WEEK);
	System.out.println("dayNum: " + dayNum);
	
	int startBlank = dayNum -1;
	System.out.println(startBlank);
	// 공백의 개수
	
	int lastDate = target.getActualMaximum(Calendar.DATE);
	// Actual: 해당 월의 마지막 날짜
	System.out.println("lastDate: " + lastDate);
	
	int countDiv = startBlank + lastDate;
	// Div의 개수
	
	
	// DB 내에서 tYear와 tMonth에 해당되는 diary 목록을 추출
	String sql2 = "select diary_date diaryDate, day(diary_date) day, feeling, left(title,5) title from diary where year(diary_date)=? AND month(diary_date)=?";
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, tYear);
	stmt2.setInt(2, tMonth+1);
	
	System.out.println(stmt2);
	
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
	</style>
</head>

<body>
	
	<nav class="navbar navbar-dark bg-dark">
		<div class="navbar-nav">
		    <a class="nav-link active font" aria-current="page" href="diary/diary.jsp" 
		    	style="color: #FFFFFF;">DIARY</a>
	    </div>
	</nav><br>

	<div class="logout-container">
		<a class="btn btn-outline-dark font right" href="/diary/logout.jsp">로그아웃</a>
	</div>
	<div class="link-container">
		<a class="btn btn-outline-dark font" href="/diary/diary.jsp">다이어리 모양으로 보기</a>
		<a class="btn btn-outline-dark font" href="/diary/diaryList.jsp">게시판 모양으로 보기</a>
		<a class="btn btn-outline-dark font" href="/diary/addDiaryForm.jsp">일기 쓰기</a>
	</div>
	<div class="head-container">	
		<h1 class="font"
			style="font-size: 70px;">일기장 &#9997;</h1>
		
		<h1 class="font"
			style="font-size: 50px;"><%=tYear%>년 <%=tMonth+1%>월</h1>
	
		<div>
			<a class="btn btn-outline-dark font" href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth-1%>">이전 달</a>
			<a class="btn btn-outline-dark font" href="/diary/diary.jsp?targetYear=<%=tYear%>&targetMonth=<%=tMonth+1%>">다음 달</a>
		</div>
	</div>	
		<br>
		<div class="calendar-container font"><!--  -->
		
			<!-- 요일 -->
			<div class="day sun rounded" style="color: #FF0000">일요일</div>
			<div class="day rounded">월요일</div>
			<div class="day rounded">화요일</div>
			<div class="day rounded">수요일</div>
			<div class="day rounded">목요일</div>
			<div class="day rounded">금요일</div>
			<div class="day rounded">토요일</div>
			
			<!-- data -->
			<%
				for(int i = 1; i <= countDiv; i++){
					if(i % 7 == 1) {
			%>
						<div class="cell sun rounded">
						
			<%			
					} else {
			%>			
						<div class="cell rounded">
			<%			
					}
			
							if(i-startBlank > 0) {
						%>
								<%=i-startBlank%><br>
								
						<%		
								// 현재 날짜(i-startBlank)의 일기가 rs2 목록에 있는지 비교
								while(rs2.next()){
									// 해당 날짜에 일기가 존재한다 -> 출력한다
									if(rs2.getInt("day") == (i-startBlank)){
						%>
										<div>
											<span><%=rs2.getString("feeling")%></span>
											<a href='/diary/diaryOne.jsp?diaryDate=<%=rs2.getString("diaryDate")%>'>
												<%=rs2.getString("title")%>...
											</a>
										</div>
						<%				
										break; 
									}
								}
								
								rs2.beforeFirst(); // ResultSet의 커스 위치를 처음으로 이동
							} else {
						%>
								&nbsp;
						<%
							}
						%>	
			
						</div>
						
						<%		
							}
						%>
						</div>
		</div><!--  -->
</html>