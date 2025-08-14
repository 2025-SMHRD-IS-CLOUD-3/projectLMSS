<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>로그인 - Landmark Search</title>
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
    .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:28px;box-shadow:var(--shadow)}
    .title{margin:10px 0 26px;text-align:center;font-size:28px;font-weight:900}
    form{max-width:600px;margin:0 auto;display:grid;gap:18px}
    label{font-weight:700}
    .input{width:100%;padding:14px 16px;border:1px solid #cfcfd2;border-radius:12px;font-size:16px;outline:none}
    .input:focus{border-color:#9acfe0;box-shadow:0 0 0 3px rgba(87,172,203,.15)}
    .row{display:grid;gap:8px}
    .row-inline{display:flex;align-items:center;justify-content:space-between;gap:12px}
    .muted{color:#6a6a6a;font-size:14px}
    .error{color:#c62828;font-size:14px}
    .btn{background:#57ACCB;color:#fff;font-weight:800;border:none;border-radius:12px;padding:14px 20px;font-size:16px;cursor:pointer}
    .btn:disabled{opacity:.6;cursor:not-allowed}
    .link{color:#1466e2;text-decoration:none}
    .pwd-wrap{position:relative}
    .toggle{position:absolute;right:10px;top:50%;transform:translateY(-50%);background:transparent;border:none;cursor:pointer;font-size:13px;color:#2f6a88}
    @media (max-width:720px){
      .board{margin:120px 12px}
      .panel{padding:20px}
    }
  </style>
</head>
<body>
  <!-- ===== 헤더 ===== -->
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
          <li><a href="${pageContext.request.contextPath}/post.jsp">게시판</a></li>
          <li><a href="${pageContext.request.contextPath}/login.jsp">로그인</a></li>
          <li><a href="${pageContext.request.contextPath}/join.jsp">회원가입</a></li>
      </ul>
  </div>

  <!-- Body -->
  <main class="board">
    <section class="panel">
      <h2 class="title">로그인</h2>

      <!-- context path 포함 -->
      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="row">
          <label for="uid">계정 입력</label>
          <input id="uid" name="id" class="input" autocomplete="username" placeholder="이메일 또는 아이디" required/>
        </div>

        <div class="row">
          <label for="pwd">비밀번호 입력</label>
          <div class="pwd-wrap">
            <input id="pwd" name="password" class="input" type="password" autocomplete="current-password" placeholder="••••••••" required/>
            <button type="button" id="togglePwd" class="toggle">표시</button>
          </div>
        </div>

        <div class="row-inline">
          <label class="muted"><input type="checkbox" id="remember"/> 로그인 상태 유지</label>
          <a class="link" href="${pageContext.request.contextPath}/join.jsp">회원가입</a>
        </div>

        <div class="row-inline" style="justify-content:flex-end">
          <button class="btn" type="submit">로그인</button>
        </div>
      </form>
    </section>
  </main>

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

    document.getElementById('togglePwd').addEventListener('click',()=>{
      const pwd = document.getElementById('pwd');
      pwd.type = (pwd.type === 'password') ? 'text' : 'password';
      document.getElementById('togglePwd').textContent = (pwd.type === 'password') ? '표시' : '숨김';
    });
  </script>
</body>
</html>
