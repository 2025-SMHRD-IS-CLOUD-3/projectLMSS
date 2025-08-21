<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  <%-- ★ 서버에서 전달한 값(formTitle, formCategory, formContent, alertMsg) 사용 --%>
<%
    // 로그인 체크는 Servlet(PostWriteServlet)에서 처리
    String loginUser = (String) session.getAttribute("loginUser");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>게시글 작성 - Landmark Search</title>
<style>
    :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08); }
    *{box-sizing:border-box}
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}
    header {
            position:fixed; top:0; left:0; width:100%; height:100px; background:#fff;
            display:flex; justify-content:space-between; align-items:center; padding:0 20px;
            z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04);
        }
    h2 a {
		  text-decoration: none;
		  color: inherit;
		}
    .side-menu { 
        	position: fixed; top: 0; right: -500px; width: 500px;
        	height: 100%; background-color: #57ACCB; color: white; 
        	padding: 20px; padding-top: 100px; box-sizing: border-box; 
        	transition: right 0.3s ease; font-size: 30px; z-index: 1001; }
    .side-menu li { list-style-type: none; margin-top: 20px; }
    .side-menu a { color: white; text-decoration: none; font-weight: bold; }
    .side-menu.open { right: 0; }
    .menu-btn { position: fixed; top: 20px; right: 20px; font-size: 50px; background: none; border: none; color: black; cursor: pointer; z-index: 1002; }
  .board{max-width:1000px;margin:140px auto 40px;background:var(--muted);border-radius:28px;padding:22px}
  .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:26px;box-shadow:var(--shadow)}
  .title{margin:8px 0 22px;text-align:center;font-size:28px;font-weight:900}
  .form{max-width:760px;margin:0 auto;display:grid;gap:18px}
  label{font-weight:800}
  .input,.textarea{width:100%;border:1px solid #cfcfd2;border-radius:12px;padding:12px 14px;font-size:16px;outline:none}
  .textarea{min-height:320px;resize:vertical;line-height:1.6}
  .input:focus,.textarea:focus{border-color:#9acfe0;box-shadow:0 0 0 3px rgba(87,172,203,.15)}
  .select-wrap{position:relative}
  .select-display{
    width:100%;border:1px solid #cfcfd2;border-radius:12px;padding:12px 44px 12px 14px;font-size:16px;
    cursor:pointer;user-select:none;white-space:nowrap;overflow:hidden;text-overflow:ellipsis
  }
  .select-wrap:focus-within .select-display{border-color:#9acfe0;box-shadow:0 0 0 3px rgba(87,172,203,.15)}
  .select-caret{
    position:absolute;top:0;right:0;height:100%;width:44px;border-left:1px solid #cfcfd2;
    display:grid;place-items:center;pointer-events:auto;cursor:pointer
  }
  .select-caret::after{ content:"▾"; font-size:16px; color:#2d5d72; }
  .options{
    position:absolute;left:0;right:0;top:calc(100% + 6px);background:#fff;border:1px solid var(--line);
    border-radius:12px;box-shadow:var(--shadow);display:none;max-height:260px;overflow:auto;z-index:10
  }
  .options.open{display:block}
  .option{padding:12px 14px;cursor:pointer}
  .option:hover{background:#f2fbff}
  .row2{display:grid;grid-template-columns:1fr 240px;gap:16px}
  @media (max-width:820px){ .row2{grid-template-columns:1fr} }
  .btns{display:flex;gap:10px;justify-content:flex-end;margin-top:10px}
  .btn{background:#57ACCB;color:#fff;border:none;border-radius:12px;padding:12px 18px;font-weight:800;cursor:pointer}
  .btn.sub{background:#e9eef1;color:#234}
</style>
</head>
<body>
  <header>
        <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
    </header>
        <button class="menu-btn" aria-label="open side menu">≡</button>
    
  <!-- Side Menu -->
  <div class="side-menu" id="sideMenu">
      <ul>
          <li><a href="<%=contextPath%>/howLandmark.html">Landmark Search란?</a></li>
          <li><a href="<%=contextPath%>/main.html">사진으로  랜드마크 찾기</a></li>
          <li><a href="<%=contextPath%>/mapSearch.html">지도로  랜드마크 찾기</a></li>
          <li><a href="<%=contextPath%>/postList">게시판</a></li>
          <% if (loginUser != null) { %>
              <li><a href="<%=contextPath%>/logout">로그아웃</a></li>
          <% } else { %>
              <li><a href="<%=contextPath%>/login.jsp">로그인</a></li>
              <li><a href="<%=contextPath%>/join.jsp">회원가입</a></li>
          <% } %>
      </ul>
  </div>
  
  <!-- Body -->
  <main class="board">
    <section class="panel">
      <h2 class="title">게시글 작성</h2>

      <!-- JSP용 폼 -->
      <form class="form" id="postForm" method="post" action="<%=contextPath%>/postWrite" autocomplete="off">
        <div class="row2">
          <!-- 제목 -->
          <div>
            <label for="postTitle">제목 입력</label>
            <!-- ★ 서버에서 되돌려준 제목 값 유지 -->
            <input id="postTitle" name="title" class="input" placeholder="제목을 입력하세요" maxlength="120"
                   value="<c:out value='${formTitle}'/>" />
          </div>

          <!-- 카테고리 -->
          <div>
            <label>카테고리</label>
            <div class="select-wrap" id="categoryWrap" data-init-category="<c:out value='${formCategory}'/>"><!-- ★ 복원값 data로 보관 -->
              <div id="postCategory" class="select-display" tabindex="0">카테고리 선택</div>
              <div class="select-caret" id="categoryCaret"></div>
              <div id="categoryOptions" class="options">
                <div class="option" data-value="여행 후기">여행 후기</div>
                <div class="option" data-value="여행 꿀팁">여행 꿀팁</div>
                <div class="option" data-value="랜드마크 정보">랜드마크 정보</div>
                <div class="option" data-value="자유게시판">자유게시판</div>
              </div>
            </div>
            <input type="hidden" id="categoryValue" name="category" value="<c:out value='${formCategory}'/>"/><!-- ★ hidden 값 유지 -->
          </div>
        </div>

        <!-- 내용 -->
        <div>
          <label for="postContent">내용 입력</label>
          <!-- ★ textarea는 value 속성이 아닌 태그 본문으로 값 유지 -->
          <textarea id="postContent" name="content" class="textarea" placeholder="내용을 입력하세요"><c:out value='${formContent}'/></textarea>
        </div>

        <div class="btns">
          <button type="button" class="btn sub" id="goList">게시글 목록</button>
          <button type="submit" class="btn">게시글 작성</button>
        </div>
      </form>
    </section>
  </main>

<!-- ★ 서버 유효성 실패 시 alert 메시지 -->
<c:if test="${not empty alertMsg}">
  <script>
    alert('<c:out value="${alertMsg}"/>');
  </script>
</c:if>

<script>
  /* ===== 사이드메뉴 ===== */
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

  /* ===== 카테고리 선택 ===== */
  const wrap = document.getElementById('categoryWrap');
  const display = document.getElementById('postCategory');
  const caret = document.getElementById('categoryCaret');
  const options = document.getElementById('categoryOptions');
  const hiddenInput = document.getElementById('categoryValue');

  function openOptions(open){
    options.classList.toggle('open', open);
  }

  function selectCategory(value){
    display.textContent = value || '카테고리 선택';
    hiddenInput.value = value || '';
    openOptions(false);
  }

  display.addEventListener('click', ()=> openOptions(!options.classList.contains('open')));
  caret.addEventListener('click', (e)=>{ e.stopPropagation(); openOptions(!options.classList.contains('open')); });
  document.addEventListener('click', (e)=> {
    if(!wrap.contains(e.target)) openOptions(false);
  });
  options.addEventListener('click', (e)=>{
    const opt = e.target.closest('.option');
    if(!opt) return;
    selectCategory(opt.dataset.value);
  });

  // ★ 초기 로드 시, 서버가 준 formCategory로 표시/값 복원
  document.addEventListener('DOMContentLoaded', () => {
    const initCat = (wrap.dataset.initCategory || '').trim();
    if (initCat) { selectCategory(initCat); } // 표시/hidden 동시 세팅
  });

  /* ===== 목록 버튼 ===== */
  document.getElementById('goList').addEventListener('click', ()=> {
    location.href = '<%=contextPath%>/postList';
  });

  /* ===== 클라이언트 측 제출 전 검증 (alert + 제출 차단) =====
     - 제목/카테고리/내용 중 하나라도 비면 alert을 띄우고 submit 중단
     - 값은 그대로 유지됨(페이지 리로드 X) */
  document.getElementById('postForm').addEventListener('submit', function(e) {
    const title = this.title.value.trim();
    const category = this.category.value.trim();   // hidden input 값
    const content = this.content.value.trim();

    if (!title)   { alert('제목을 입력하세요.');     e.preventDefault(); return; }
    if (!category){ alert('카테고리를 선택하세요.'); e.preventDefault(); return; }
    if (!content) { alert('내용을 입력하세요.');     e.preventDefault(); return; }
  });
</script>
</body>
</html>
