<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원정보 수정</title>
</head>
<body>
    <h1>회원정보 수정</h1>
    <%
        Member memberInfo = (Member) request.getAttribute("memberInfo");
        if (memberInfo != null) {
    %>
        <form action="updateProfile" method="post">
            아이디: <%= memberInfo.getId() %><br>
            <input type="hidden" name="id" value="<%= memberInfo.getId() %>">
            이름: <input type="text" name="name" value="<%= memberInfo.getName() %>"><br>
            닉네임: <input type="text" name="nickname" value="<%= memberInfo.getNickname() %>"><br>
            이메일: <input type="text" name="email" value="<%= memberInfo.getEmail() %>"><br>
            <input type="submit" value="수정 완료">
        </form>
    <%
        } else {
    %>
        <p>회원 정보를 찾을 수 없습니다.</p>
    <%
        }
    %>
</body>
</html>