<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 현재 로그인 상태 확인
    String loginUser = (String) session.getAttribute("loginUser");
    String userRole = (String) session.getAttribute("role");
%>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">

<div id="header">
    <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
    <img src="<%=request.getContextPath()%>/image/headerImage.png" alt="MySite Logo" id="headerImage">

    <!-- Google 번역 위젯 자리 -->
    <div id="google_translate_element"></div>

    <!-- 커스텀 언어 선택 드롭다운 -->
    <div class="language-selector">
        <select id="languageSelect" class="custom-select">
            <option value="ko">한국어</option>
            <option value="en">English</option>
            <option value="ja">日本語</option>
            <option value="zh-CN">中文(简体)</option>
        </select>
    </div>

    <!-- 사이드 메뉴 버튼 -->
    <button class="menu-btn" aria-label="open side menu">≡</button>

    <!-- 사이드 메뉴 -->
    <aside class="side-menu" id="sideMenu">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>

            <% if (loginUser != null) { %>
                <li><a href="<%=request.getContextPath()%>/logout">로그아웃</a></li>
                <li><a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
                <% if ("ADMIN".equals(userRole)) { %>
                    <li><a href="<%=request.getContextPath()%>/admin" style="color: #ffd24d;">👑 관리자 페이지</a></li>
                <% } %>
            <% } else { %>
                <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </aside>
</div>

<!-- Google 번역 스크립트 (캐시 무효화 버전) -->
<script src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit&v=<%=System.currentTimeMillis()%>"></script>

<script>
// 1. 사이드 메뉴 기능
const menuBtn = document.querySelector('.menu-btn');
const sideMenu = document.getElementById('sideMenu');
if (menuBtn && sideMenu) {
    menuBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        sideMenu.classList.toggle('open');
    });
    document.addEventListener('click', (e) => {
        if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
            sideMenu.classList.remove('open');
        }
    });
}

// 2. Google 번역 초기화 및 커스텀 드롭다운 연동
function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'ko',
        autoDisplay: false
    }, 'google_translate_element');

    const select = document.getElementById('languageSelect');

    function applyLanguage(lang) {
        const combo = document.querySelector('.goog-te-combo');
        if (combo) {
            combo.value = lang;
            combo.dispatchEvent(new Event('change'));
        }
    }

    // 구글 번역 콤보박스 로드 대기 후 연결
    const interval = setInterval(() => {
        const combo = document.querySelector('.goog-te-combo');
        if (combo) {
            applyLanguage(select.value);
            clearInterval(interval);

            // 커스텀 select 이벤트 연결
            select.addEventListener('change', () => {
                applyLanguage(select.value);
            });
        }
    }, 500);
}

</script>
