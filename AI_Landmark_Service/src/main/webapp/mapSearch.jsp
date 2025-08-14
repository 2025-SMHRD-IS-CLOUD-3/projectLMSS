<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // 세션에서 로그인 사용자 가져오기
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>지도 검색 - Landmark Search</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <style>
        /* 기존 디자인 CSS 그대로 유지 */
        :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08);}
        *{box-sizing:border-box}
        body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}
        header{position:fixed;top:0;left:0;width:100%;height:100px;background:#fff;
          display:flex;align-items:center;justify-content:space-between;padding:0 20px;z-index:1000;
          box-shadow:0 1px 0 rgba(0,0,0,.04)}
        header h1{margin:0;font-size:22px}
        .menu-btn{position:fixed;top:20px;right:20px;font-size:50px;background:none;border:none;cursor:pointer}
        .side-menu{position:fixed;top:0;right:-500px;width:500px;height:100%;background:var(--brand);color:#fff;
          padding:20px;padding-top:100px;transition:right .3s ease;z-index:1001;font-size:30px}
        .side-menu.open{right:0}
        .side-menu ul{margin:0;padding:0}
        .side-menu li{list-style:none;margin:18px 0}
        .side-menu a{color:#fff;text-decoration:none;font-weight:700}
        .board{max-width:1000px;margin:140px auto 40px;background:var(--muted);border-radius:28px;padding:22px}
        .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:28px;box-shadow:var(--shadow)}
    </style>
</head>
<body>
<header>
    <h2>Landmark Search</h2>
    <div>
        <button class="menu-btn">≡</button>
    </div>
</header>

<!-- ===== 사이드 메뉴 ===== -->
<div class="side-menu" id="sideMenu">
    <ul>
        <li><a href="${pageContext.request.contextPath}/howLandmark.jsp">Landmark Search란?</a></li>
        <li><a href="${pageContext.request.contextPath}/main.jsp">사진으로 랜드마크 찾기</a></li>
        <li><a href="${pageContext.request.contextPath}/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
        <li><a href="${pageContext.request.contextPath}/postList.jsp">게시판</a></li>
        <% if (loginUser != null) { %>
            <li>
                <a href="<%=request.getContextPath()%>/logout?redirect=<%=request.getRequestURI()%>">
                    로그아웃
                </a>
            </li>
        <% } else { %>
            <li><a href="${pageContext.request.contextPath}/login.jsp">로그인</a></li>
            <li><a href="${pageContext.request.contextPath}/register.jsp">회원가입</a></li>
        <% } %>
    </ul>
</div>

<!-- ===== 지도 표시 영역 ===== -->
<main class="board">
    <section class="panel">
        <h2>지도에서 랜드마크 찾기</h2>
        <div id="map" style="width:100%;height:500px;"></div>
    </section>
</main>

<!-- ===== 기존 지도 API 스크립트 (예: Kakao Maps) ===== -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_APP_KEY"></script>
<script>
    var mapContainer = document.getElementById('map');
    var mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780), // 서울 좌표
        level: 3
    };
    var map = new kakao.maps.Map(mapContainer, mapOption);
</script>

<!-- ===== 메뉴 토글 스크립트 ===== -->
<script>
    const menuBtn=document.querySelector('.menu-btn');
    const sideMenu=document.getElementById('sideMenu');
    menuBtn.addEventListener('click',e=>{
      e.stopPropagation();
      sideMenu.classList.toggle('open');
    });
    document.addEventListener('click',e=>{
      if(!sideMenu.contains(e.target) && !menuBtn.contains(e.target)){
        sideMenu.classList.remove('open');
      }
    });
</script>
</body>
</html>
