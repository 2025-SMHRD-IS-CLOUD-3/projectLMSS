<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
</head>
<body>
    <h1>회원가입</h1>
    <form action="register" method="post">
        아이디: <input type="text" name="id"><br>
        비밀번호: <input type="password" name="password"><br>
        이메일: <input type="email" name="email"><br>
        이름: <input type="text" name="name"><br>
        닉네임: <input type="text" name="nickname"><br>
        <input type="submit" value="회원가입">
    </form>
</body>
</html>