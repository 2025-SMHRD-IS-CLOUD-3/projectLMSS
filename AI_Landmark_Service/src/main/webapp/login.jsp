<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body {
            font-family: sans-serif;
            background-color: #ffffff;
            margin: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }
        .header-top {
            width: 100%;
            max-width: 400px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            box-sizing: border-box;
        }
        .logo {
            font-size: 1.5rem;
            font-weight: bold;
            color: #333;
        }
        .menu-icon {
            font-size: 1.5rem;
            cursor: pointer;
        }
        .outer-box { /* 바깥 박스 */
            width: 100%;
            max-width: 400px;
        }
        .top-image {
            width: 100%;
            height: 80px;
            background-image: url('images/landmark_header.png');
            background-size: cover;
            background-position: center;
        }
        .inner-box {
            background-color: #f8f9fa; /* 회색 배경의 안쪽 박스 */
            padding: 1.5rem;
            border-radius: 10px; /* 둥근 모서리 */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
            text-align: center;
            margin-top: 20px; /* 상단 이미지와의 간격 */
        }
        h1 {
            color: #333;
            font-size: 1.5rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        .form-group {
            margin-bottom: 1.5rem;
            text-align: left;
        }
        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
            font-weight: bold;
            font-size: 0.9rem;
        }
        input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 1rem;
        }
        .buttons {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1.5rem;
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-link {
            color: #007bff;
            background: none;
            padding: 0;
            font-weight: normal;
        }
        .btn-link:hover {
            text-decoration: underline;
        }
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        .btn-primary:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="header-top">
        <span class="logo">Landmark Search</span>
        <span class="menu-icon">&#x2630;</span>
    </div>
    <div class="outer-box">
        <div class="top-image"></div>
        <div class="inner-box">
            <h1>로그인</h1>
            <%
                String error = (String) request.getAttribute("loginError");
                if (error != null) {
            %>
                <p style="color: red; margin-bottom: 1rem;"><%= error %></p>
            <%
                }
            %>
            <form action="login" method="post">
                <div class="form-group">
                    <label for="id">계정 입력</label>
                    <input type="text" id="id" name="id" required>
                </div>
                <div class="form-group">
                    <label for="password">비밀번호 입력</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <div class="buttons">
                    <a href="register.jsp" class="btn btn-link">회원가입</a>
                    <button type="submit" class="btn btn-primary">로그인</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>