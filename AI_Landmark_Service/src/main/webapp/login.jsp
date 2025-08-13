<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
    <h1>로그인</h1>
    <%
        // 서블릿에서 전달된 오류 메시지가 있으면 표시
        String error = (String) request.getAttribute("loginError");
        if (error != null) {
    %>
        <p style="color: red;"><%= error %></p>
    <%
        }
    %>
    <form action="login" method="post">
        아이디: <input type="text" name="id"><br>
        비밀번호: <input type="password" name="password"><br>
        <input type="submit" value="로그인">
    </form>
    
    <br>
    
    <button onclick="location.href='register.jsp'">회원가입</button>
</body>
</html>