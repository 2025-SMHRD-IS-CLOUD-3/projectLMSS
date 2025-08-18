<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Landmark Info</title>

<!-- Leaflet -->
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css">
<script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>

<style>
:root {
  --ink: #111;
  --muted: #f6f7f9;
  --line: #e6e6e8;
  --brand: #57ACCB;
  --soft: #f3f3f5;
}
* { box-sizing: border-box; }
body {
  margin: 0;
  font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
  color: var(--ink);
  background: #fff;
}
/* ===== Header / Side Menu ===== */
header {
  position: fixed; top: 0; left: 0; width: 100%; height: 100px;
  background: #fff; display: flex; justify-content: space-between;
  align-items: center; padding: 0 20px; z-index: 1000;
  box-shadow: 0 1px 0 rgba(0,0,0,.04);
}
header h2 { margin: 0; font-size: 18px; font-weight: 700; }
.menu-btn {
  position: fixed; top: 20px; right: 20px; font-size: 50px;
  background: none; border: none; color: #000; cursor: pointer; z-index: 1001;
}
.side-menu {
  position: fixed; top: 0; right: -500px; width: 500px; height: 100%;
  background: var(--brand); color: #fff; padding: 20px; padding-top: 100px;
  transition: right .3s ease; z-index: 1002; font-size: 30px;
}
.side-menu.open { right: 0; }
.side-menu ul { margin: 0; padding: 0; }
.side-menu li { list-style: none; margin-top: 20px; }
.side-menu a { color: #fff; text-decoration: none; font-weight: bold; }
/* ===== Board ===== */
.board {
  max-width: 1100px;
  margin: 140px auto 40px;
  background: var(--muted);
  border-radius: 28px;
  padding: 22px;
}
.board-inner {
  background: #fff;
  border: 1px solid var(--line);
  border-radius: 22px;
  padding: 22px;
}
/* ===== 여기에 landmarkInfo.html의 모든 CSS 그대로 붙여넣으시면 됩니다 ===== */
</style>
</head>

<body>
<!-- Header -->
<header>
  <h2>Landmark Search</h2>
  <button class="menu-btn" aria-label="메뉴 열기">≡</button>
</header>

<!-- Side Menu -->
<aside class="side-menu" id="sideMenu" aria-hidden="true">
  <ul>
    <li><a href="<%= request.getContextPath() %>/howLandmark.jsp">Landmark Search란?</a></li>
    <li><a href="<%= request.getContextPath() %>/main.jsp">사진으로 랜드마크 찾기</a></li>
    <li><a href="<%= request.getContextPath() %>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
    <li><a href="<%= request.getContextPath() %>/postList">게시판</a></li>
    <li><a href="<%= request.getContextPath() %>/login.jsp">로그인</a></li>
    <li><a href="<%= request.getContextPath() %>/join.jsp">회원가입</a></li>
  </ul>
</aside>

<!-- Main Content -->
<main class="board">
  <div class="board-inner" id="contentRoot" hidden>
    <!-- landmarkInfo.html의 본문 콘텐츠 (제목, 이미지, 정보, 지도, 탭, 댓글) 그대로 붙여넣기 -->
  </div>
</main>

<!-- Overlay -->
<div class="overlay" id="picker">
  <!-- landmarkInfo.html의 오버레이 HTML 그대로 -->
</div>

<!-- JS: Header & Side Menu -->
<script>
const menuBtn = document.querySelector('.menu-btn');
const sideMenu = document.getElementById('sideMenu');
if (menuBtn && sideMenu) {
  menuBtn.addEventListener('click', e => {
    e.stopPropagation();
    sideMenu.classList.toggle('open');
    sideMenu.setAttribute('aria-hidden', sideMenu.classList.contains('open') ? 'false' : 'true');
  });
  document.addEventListener('click', e => {
    if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
      sideMenu.classList.remove('open');
      sideMenu.setAttribute('aria-hidden', 'true');
    }
  });
}
</script>

<!-- JS: Main Logic -->
<script>
// ===== Utils =====
const $ = (sel, p=document) => p.querySelector(sel);
const $$ = (sel, p=document) => Array.from(p.querySelectorAll(sel));
const qs = new URLSearchParams(location.search);
let currId = qs.get('id') || null;
let currName = qs.get('name') || null;

// ===== API Endpoints =====
const API = {
  list: (q='') => '<%= request.getContextPath() %>/api/landmarks?limit=20&q=' + encodeURIComponent(q),
  byId: id => '<%= request.getContextPath() %>/api/landmarks/' + encodeURIComponent(id),
  byName: name => '<%= request.getContextPath() %>/api/landmarks/by-name/' + encodeURIComponent(name),
  comments: id => '<%= request.getContextPath() %>/api/landmarks/' + encodeURIComponent(id) + '/comments',
  addComment: id => '<%= request.getContextPath() %>/api/landmarks/' + encodeURIComponent(id) + '/comments'
};

const PLACEHOLDER = 'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?q=80&w=1200';

// ===== 여기에 landmarkInfo.html의 JS 로직(fetchLandmark, renderAll, initMap, initTabs, initFav, renderComments, initPicker, fallbackSample 등) 그대로 붙여넣기 =====
</script>
</body>
</html>
