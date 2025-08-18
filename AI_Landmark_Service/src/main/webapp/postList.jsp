<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>게시판 - Landmark Search</title>
<style>
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
  .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:26px;box-shadow:var(--shadow)}
  .title{margin:4px 0 16px;text-align:center;font-size:28px;font-weight:900}
  .table-wrap{overflow:auto;border:1px solid var(--line);border-radius:10px}
  table{width:100%;border-collapse:collapse;font-size:15px;min-width:800px}
  thead th{background:#5fa8c6;color:#fff;padding:10px;border-bottom:1px solid var(--line);text-align:left}
  thead th:nth-child(1){width:70px;text-align:center}
  thead th:nth-child(2){width:140px}
  thead th:nth-child(4){width:90px;text-align:center}
  thead th:nth-child(5){width:110px;text-align:center}
  thead th:nth-child(6){width:110px;text-align:center}
  tbody td{padding:10px;border-top:1px solid #edf0f2}
  tbody td:nth-child(1),tbody td:nth-child(4),tbody td:nth-child(5),tbody td:nth-child(6){text-align:center}
  tbody tr:hover{background:#f9fcff}
  .title-link{color:#0e5a76;text-decoration:none;font-weight:700}
  .title-link:hover{text-decoration:underline}
  .footer-bar{display:flex;justify-content:space-between;align-items:center;margin-top:14px}
  .pager{display:flex;gap:14px;align-items:center;color:#777}
  .pager button{background:none;border:none;cursor:pointer;font-size:18px;color:#345}
  .write-btn{background:#57ACCB;color:#fff;border:none;border-radius:12px;padding:12px 18px;font-weight:800;cursor:pointer}
</style>
</head>
<body>
  <!-- Header -->
  <header>
      <h2>Landmark Search</h2>
      <div>
          <button class="menu-btn">≡</button>
      </div>    
  </header>
  
  <!-- Side Menu -->
  <div class="side-menu" id="sideMenu">
      <ul>
          <li><a href="${pageContext.request.contextPath}/howLandmark.jsp">Landmark Search란?</a></li>
          <li><a href="${pageContext.request.contextPath}/main.jsp">사진으로  랜드마크 찾기</a></li>
          <li><a href="${pageContext.request.contextPath}/mapSearch.jsp">지도로  랜드마크 찾기</a></li>
		  <li><a href="${pageContext.request.contextPath}/postList">게시판</a></li>
          <!-- ✅ 로그인 상태에 따라 다르게 표시 -->
          <c:choose>
            <c:when test="${not empty sessionScope.loginUser}">
                <li><a href="${pageContext.request.contextPath}/logout">로그아웃</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login.jsp?redirect=postList">로그인</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp">회원가입</a></li>
            </c:otherwise>
          </c:choose>
      </ul>
  </div>

  <!-- Body -->
  <main class="board">
    <section class="panel">
      <h2 class="title">게시판</h2>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>목록</th>
              <th>카테고리</th>
              <th>제목</th>
              <th>조회수</th>
              <th>작성일자</th>
              <th>작성자</th>
            </tr>
          </thead>
          <tbody id="postTbody">
			<c:forEach var="post" items="${postList}">
			  <tr>
			    <td>${post.postId}</td>
			    <td>${post.categories}</td>
			    <td>
			      <a class="title-link" href="${pageContext.request.contextPath}/postView.jsp?id=${post.postId}">
			        ${post.title}
			      </a>
			    </td>
			    <td>${post.views}</td>
			    <td>${post.postDate}</td>
			    <td>${post.memberId}</td>
			  </tr>
			</c:forEach>
          </tbody>
        </table>
      </div>

      <div class="footer-bar">
        <div class="pager">
          <button aria-label="이전 페이지">&lt;</button>
          <strong>1</strong>
          <button aria-label="다음 페이지">&gt;</button>
        </div>
        <button class="write-btn" id="goWrite">게시글 작성</button>
      </div>
    </section>
  </main>

<script>
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

  document.getElementById('goWrite').addEventListener('click', ()=>{
    location.href = '${pageContext.request.contextPath}/postWrite';
  });
</script>
</body>
</html>
