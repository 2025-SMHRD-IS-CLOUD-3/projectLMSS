<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Post" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Post post = (Post) request.getAttribute("post");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>게시글 상세 - Landmark Search</title>
<style>
  :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08);}
  *{box-sizing:border-box}
  body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}

  /* === postList.jsp와 동일 헤더/메뉴 === */
  header{position:fixed;top:0;left:0;width:100%;height:100px;background:#fff;
    display:flex;align-items:center;justify-content:space-between;padding:0 20px;z-index:1000;
    box-shadow:0 1px 0 rgba(0,0,0,.04)}
  header h2{margin:0;font-size:22px}
  .menu-btn{position:fixed;top:20px;right:20px;font-size:50px;background:none;border:none;cursor:pointer}
  .side-menu{position:fixed;top:0;right:-500px;width:500px;height:100%;background:var(--brand);color:#fff;
    padding:20px;padding-top:100px;transition:right .3s ease;z-index:1001;font-size:30px}
  .side-menu.open{right:0}
  .side-menu ul{margin:0;padding:0}
  .side-menu li{list-style:none;margin:18px 0}
  .side-menu a{color:#fff;text-decoration:none;font-weight:700}

  /* === postList.jsp와 동일 바깥 레이아웃 === */
  .board{max-width:1000px;margin:140px auto 40px;background:var(--muted);border-radius:28px;padding:22px}
  .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:26px;box-shadow:var(--shadow)}
  .title{margin:4px 0 16px;text-align:center;font-size:28px;font-weight:900}

  /* === 상세 본문 표시용(디자인 영향 최소화) === */
  .post-meta{display:grid;grid-template-columns: repeat(4, 1fr);gap:10px;
    border:1px solid var(--line);border-radius:10px;padding:12px;margin-bottom:14px;font-size:14px;color:#555}
  .post-content{border:1px solid var(--line);border-radius:10px;padding:16px;line-height:1.8;color:#222;white-space:pre-wrap}

  .footer-bar{display:flex;justify-content:flex-end;align-items:center;margin-top:14px}
  .write-btn{background:#57ACCB;color:#fff;border:none;border-radius:12px;padding:12px 18px;font-weight:800;cursor:pointer}
</style>
</head>
<body>
  <!-- 헤더 (postList.jsp와 동일) -->
  <header>
      <h2 onclick="location.href='${pageContext.request.contextPath}/postList'" style="cursor:pointer">Landmark Search</h2>
      <div>
          <button class="menu-btn">≡</button>
      </div>
  </header>

  <!-- 사이드 메뉴 (postList.jsp와 동일) -->
  <div class="side-menu" id="sideMenu">
      <ul>
          <li><a href="${pageContext.request.contextPath}/howLandmark.jsp">Landmark Search란?</a></li>
          <li><a href="${pageContext.request.contextPath}/main.jsp">사진으로  랜드마크 찾기</a></li>
          <li><a href="${pageContext.request.contextPath}/mapSearch.jsp">지도로  랜드마크 찾기</a></li>
          <li><a href="${pageContext.request.contextPath}/postList">게시판</a></li>
          <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <li><a href="${pageContext.request.contextPath}/logout">로그아웃</a></li>
                <li>
                	<a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
                </li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login.jsp?redirect=postList">로그인</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp">회원가입</a></li>
            </c:otherwise>
          </c:choose>
      </ul>
  </div>

  <!-- 본문 (바깥 골격은 postList.jsp와 동일: board > panel) -->
  <main class="board">
    <section class="panel">
      <h2 class="title"><%= (post != null ? post.getTitle() : "게시글") %></h2>

      <% if (post != null) { %>
        <div class="post-meta">
          <div><strong>카테고리</strong> : <%= post.getCategories() %></div>
          <div><strong>조회수</strong> : <%= post.getViews() %></div>
          <div><strong>작성일자</strong> : <%= post.getPostDate() %></div>
          <div><strong>작성자</strong> : <%= post.getMemberId() %></div>
        </div>
        <div class="post-content"><%= post.getPostContent() %></div>
      <% } else { %>
        <p>해당 게시글을 찾을 수 없습니다.</p>
      <% } %>

      <div class="footer-bar">
        <button class="write-btn" onclick="location.href='${pageContext.request.contextPath}/postList'">목록으로</button>
      </div>
    </section>
  </main>

<script>
  // postList.jsp와 동일한 토글 스크립트
  const menuBtn=document.querySelector('.menu-btn');
  const sideMenu=document.getElementById('sideMenu');
  menuBtn.addEventListener('click',e=>{
    e.stopPropagation();
    sideMenu.classList.toggle('open');
    sideMenu.setAttribute('aria-hidden', sideMenu.classList.contains('open')?'false':'true');
  });
  document.addEventListener('click',e=>{
    if(!sideMenu.contains(e.target) && !menuBtn.contains(e.target)){
      sideMenu.classList.remove('open'); sideMenu.setAttribute('aria-hidden','true');
    }
  });
</script>
</body>
</html>
