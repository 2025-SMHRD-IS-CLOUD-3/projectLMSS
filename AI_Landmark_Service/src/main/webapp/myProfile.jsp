<%-- src/main/webapp/myProfile.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내 정보</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f3f4f6; display: flex; justify-content: center; align-items: flex-start; min-height: 100vh; padding: 2rem; }
        .container { background-color: #ffffff; padding: 2rem; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); width: 100%; max-width: 500px; text-align: center; }
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
    </style>
</head>
<body>
    <div class="container">
        <h1>내 정보</h1>
        <%
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
            } else {
        %>
            <p>회원 정보를 찾을 수 없습니다. 다시 로그인 해주세요.</p>
            <a href="login.jsp" class="btn btn-link">로그인</a>
        <%
            }
        %>
    </div>
</body>
</html>