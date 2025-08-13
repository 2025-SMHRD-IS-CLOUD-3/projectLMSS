<%-- src/main/webapp/main.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>메인 페이지</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 2rem; flex-direction: column; }
        .container { background-color: #ffffff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); width: 100%; max-width: 600px; text-align: center; }
        h1 { color: #1f2937; margin-bottom: 1.5rem; font-size: 2.5rem; }
        .nav-links { margin-top: 2rem; }
        .nav-links a { display: inline-block; padding: 0.75rem 1.5rem; margin: 0.5rem; background-color: #2563eb; color: white; text-decoration: none; border-radius: 8px; font-weight: bold; transition: background-color 0.2s, box-shadow 0.2s; }
        .nav-links a:hover { background-color: #1d4ed8; box-shadow: 0 4px 8px rgba(37, 99, 235, 0.3); }
        .welcome-message { margin-bottom: 1rem; font-size: 1.25rem; color: #374151; }
    </style>
</head>
<body>
    <div class="container">
        <h1>환영합니다!</h1>
        <%
            // 세션에서 로그인된 사용자 ID 가져오기
            String loggedInUser = (String) session.getAttribute("loggedInUser");
            if (loggedInUser != null) {
        %>
            <p class="welcome-message">안녕하세요, <strong><%= loggedInUser %></strong>님!</p>
            <div class="nav-links">
                <a href="postList.jsp">게시판 목록</a>
                <a href="landmarkList.jsp">랜드마크 목록</a>
                <a href="myProfile">내 정보 보기</a> <%-- MyProfileServlet으로 이동 --%>
                <a href="logout">로그아웃</a> <%-- 로그아웃 서블릿으로 이동 (필요하다면 구현) --%>
            </div>
        <%
            } else {
        %>
            <p class="welcome-message">로그인 해주세요.</p>
            <div class="nav-links">
                <a href="login.jsp">로그인</a>
                <a href="register.jsp">회원가입</a>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>
