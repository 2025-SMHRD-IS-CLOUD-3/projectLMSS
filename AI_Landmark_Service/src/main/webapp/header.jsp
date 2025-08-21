<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 현재 로그인 상태 확인
    String loginUser = (String) session.getAttribute("loginUser");
%>
<link rel="stylesheet" href="./css/common.css">

<div id="header">
    <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
    <img src="./image/headerImage.png" alt="MySite Logo" id=headerImage>
    <button class="menu-btn" aria-label="open side menu">≡</button>
    <aside class="side-menu" id="sideMenu">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>
            <% if (loginUser != null) { %>
                <li>
                    <a href="<%=request.getContextPath()%>/logout">로그아웃</a>
                </li>
                <li><a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
            <% } else { %>
                <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </aside>
</div>
<script>
	const menuBtn = document.querySelector('.menu-btn');
	const sideMenu = document.getElementById('sideMenu');
	menuBtn.addEventListener('click', (e) => { e.stopPropagation(); sideMenu.classList.toggle('open'); });
    document.addEventListener('click', (e) => { if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) sideMenu.classList.remove('open'); });
</script>