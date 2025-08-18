<%-- src/main/webapp/myProfile.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member" %>
<%
    // 로그인 여부 확인
    String loginUser = (String) session.getAttribute("loginUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>내 정보</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f3f4f6;
        }
        /* 상단 헤더 */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            background: #fff;
        }
        .logo {
            font-weight: bold;
            font-size: 18px;
        }
        .menu-btn {
            font-size: 24px;
            cursor: pointer;
            border: none;
            background: none;
        }

        /* 메인 컨텐츠 */
        .main-content {
            display: flex;
            justify-content: center;
            padding: 40px 20px;
        }
        .container {
            background-color: #ffffff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }
        h1 { color: #1f2937; margin-bottom: 1.5rem; font-size: 2rem; }
        h2 { color: #1f2937; margin-top: 2rem; margin-bottom: 1.5rem; font-size: 1.5rem; }
        p { margin-bottom: 0.8rem; color: #374151; }
        strong { color: #111827; }
        .form-group { margin-bottom: 1.5rem; text-align: left; }
        label { display: block; margin-bottom: 0.5rem; color: #4b5563; font-weight: bold; }
        input[type="password"] { width: calc(100% - 20px); padding: 0.75rem; border: 1px solid #d1d5db; border-radius: 8px; font-size: 1rem; }
        .button-group { display: flex; justify-content: space-between; gap: 1rem; margin-top: 1.5rem; }
        .btn { padding: 0.75rem 1.5rem; border: none; border-radius: 8px; cursor: pointer; font-size: 1rem; font-weight: bold; transition: background-color 0.2s, box-shadow 0.2s; }
        .btn-danger { background-color: #ef4444; color: white; }
        .btn-danger:hover { background-color: #dc2626; box-shadow: 0 4px 8px rgba(239, 68, 68, 0.3); }
        .btn-secondary { background-color: #6b7280; color: white; }
        .btn-secondary:hover { background-color: #4b5563; box-shadow: 0 4px 8px rgba(107, 114, 128, 0.3); }
        .btn-link { display: inline-block; margin-top: 1rem; color: #2563eb; text-decoration: none; font-weight: bold; }
        .btn-link:hover { text-decoration: underline; }

        /* 오른쪽 사이드 메뉴 */
        .sidebar {
            position: fixed;
            top: 0;
            right: -300px; /* 처음에는 숨겨진 상태 */
            width: 300px;
            height: 100%;
            background-color: #4da3c7;
            color: white;
            padding: 40px 20px;
            transition: right 0.3s ease;
            z-index: 1000;
        }
        .sidebar.active {
            right: 0; /* 열렸을 때 */
        }
        .sidebar h2 {
            font-size: 20px;
            margin-bottom: 30px;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar li {
            margin-bottom: 20px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
        }
        .sidebar li:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <!-- 상단 헤더 -->
    <header>
        <div class="logo">Landmark Search</div>
        <button class="menu-btn" onclick="toggleMenu()">≡</button>
    </header>

    <!-- 본문 -->
    <div class="main-content">
        <div class="container">
            <h1>내 정보</h1>
            <%
                if (loginUser != null) {   // 로그인 상태일 때만 출력
                    Member memberInfo = (Member) request.getAttribute("memberInfo");
                    if (memberInfo != null) {
            %>
                <p><strong>아이디:</strong> <%= memberInfo.getId() %></p>
                <p><strong>이름:</strong> <%= memberInfo.getName() %></p>
                <p><strong>닉네임:</strong> <%= memberInfo.getNickname() %></p>
                <p><strong>이메일:</strong> <%= memberInfo.getEmail() %></p>
                <br>

                <form action="deleteMember" method="post" id="deleteForm">
                    <div class="form-group">
                        <label for="passwordConfirm">비밀번호 확인:</label>
                        <input type="password" id="passwordConfirm" name="password" required placeholder="비밀번호를 입력하세요">
                        <%-- 로그인된 사용자 ID를 숨겨서 전달 --%>
                        <input type="hidden" name="id" value="<%= memberInfo.getId() %>">
                    </div>
                    <div class="button-group">
                        <button type="submit" class="btn btn-danger" onclick="return confirm('정말로 회원 탈퇴하시겠습니까?');">탈퇴하기</button>
                        <a href="index.jsp" class="btn btn-secondary">홈으로</a>
                    </div>
                </form>
            <%
                    }
                } else {   // 비로그인 상태일 경우
            %>
                <p>회원 정보를 보려면 로그인 해주세요.</p>
                <a href="login.jsp" class="btn btn-link">로그인</a>
            <%
                }
            %>
        </div>
    </div>

    <!-- 오른쪽 사이드 메뉴 -->
    <div class="sidebar" id="sidebar">
        <h2>Landmark Search란?</h2>
        <ul>
            <li onclick="location.href='<%=contextPath%>/photoSearch.jsp'">사진으로 랜드마크 찾기</li>
            <li onclick="location.href='<%=contextPath%>/mapSearch.jsp'">지도로 랜드마크 찾기</li>
            <li onclick="location.href='<%=contextPath%>/postList'">게시판</li>
            <li onclick="location.href='<%=contextPath%>/logout'">로그아웃</li>
        </ul>
    </div>

    <script>
        function toggleMenu() {
            document.getElementById("sidebar").classList.toggle("active");
        }
    </script>
</body>
</html>
