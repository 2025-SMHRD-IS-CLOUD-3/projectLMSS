<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  	<meta charset="utf-8"/>
  	<meta name="viewport" content="width=device-width, initial-scale=1"/>
  	<title>회원가입 - Landmark Search</title>
  	<style>
	    :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08);}
	    *{box-sizing:border-box}
	    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}
	    header { 
        	position:fixed; top:0; left:0; width:100%; 
        	height:100px; background:#fff; display:flex; 
        	justify-content:space-between; align-items:center; 
        	padding:0 20px; z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04);
        	}
	    h2 a {
			text-decoration: none;
			color: inherit;
			}
	      
	    .menu-btn {
        	position:fixed; top:20px; right:20px; 
        	font-size:50px; background:none; border:none; 
        	color:#000; cursor:pointer; z-index:1002; }
	    .side-menu{position:fixed;top:0;right:-500px;width:500px;height:100%;background:var(--brand);color:#fff;
	      padding:20px;padding-top:100px;transition:right .3s ease;z-index:1001;font-size:30px}
	    .side-menu { position:fixed; top:0; right:-500px; width:500px; height:100%; background:var(--brand); color:#fff; padding:20px; padding-top:100px; transition:right .3s ease; z-index:1001; font-size:30px; }
        .side-menu.open { right:0; }
        .side-menu ul { margin:0; padding:0; }
        .side-menu li { list-style:none; margin-top:20px; }
        .side-menu a { color:#fff; text-decoration:none; font-weight:bold; }
	    .board{max-width:1000px;margin:140px auto 40px;background:var(--muted);border-radius:28px;padding:22px}
	    .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:28px;box-shadow:var(--shadow)}
	    .title{margin:10px 0 26px;text-align:center;font-size:28px;font-weight:900}
	    form{max-width:600px;margin:0 auto;display:grid;gap:18px}
	    label{font-weight:700}
	    .input{width:100%;padding:14px 16px;border:1px solid #cfcfd2;border-radius:12px;font-size:16px;outline:none}
	    .input:focus{border-color:#9acfe0;box-shadow:0 0 0 3px rgba(87,172,203,.15)}
	    .row{display:grid;gap:8px}
	    .row-inline{display:flex;align-items:center;gap:10px}
	    .muted{color:#6a6a6a;font-size:14px}
	    .error{color:#c62828;font-size:14px}
	    .ok{color:#1b7c3c;font-size:14px}
	    .btn{background:#57ACCB;color:#fff;font-weight:800;border:none;border-radius:12px;padding:14px 20px;font-size:16px;cursor:pointer}
	    .btn:disabled{opacity:.6;cursor:not-allowed}
	    .pwd-wrap{position:relative}
	    .toggle{position:absolute;right:10px;top:50%;transform:translateY(-50%);background:transparent;border:none;cursor:pointer;font-size:13px;color:#2f6a88}
	    .meter{height:8px;border-radius:999px;background:#eee;overflow:hidden}
	    .meter > span{display:block;height:100%;width:0;background:#e96a6a;transition:width .2s ease}
	    .terms{border:1px solid var(--line);border-radius:12px;padding:12px}
	    @media (max-width:720px){ .board{margin:120px 12px} .panel{padding:20px} }
	</style>
</head>
<body>
  <header>
    <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
  </header>
    <button class="menu-btn" aria-label="메뉴">≡</button>

  <aside class="side-menu" id="sideMenu" aria-hidden="true">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>
            <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
            <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
        </ul>
  </aside>

  <main class="board">
    <section class="panel">
      <h2 class="title">회원가입</h2>

      <!-- RegisterServlet로 전송 -->
      <form id="registerForm" action="<%=request.getContextPath()%>/register" method="post">
        <div class="row">
          <label for="id">계정 입력</label>
          <input id="id" name="id" class="input" placeholder="아이디(영문/숫자 4~20자)" minlength="4" maxlength="20" required pattern="^[a-zA-Z0-9_]{4,20}$"/>
        </div>

        <div class="row">
          <label for="pwd">비밀번호 입력</label>
          <div class="pwd-wrap">
            <input id="pwd" name="pwd" class="input" type="password" placeholder="영문, 숫자, 특수문자 포함 8자 이상" minlength="8" required/>
            <button type="button" id="togglePwd" class="toggle">표시</button>
          </div>
          <div class="meter" aria-hidden="true"><span id="pwdStrength"></span></div>
        </div>

        <div class="row">
          <label for="pwd2">비밀번호 확인</label>
          <input id="pwd2" name="pwd2" class="input" type="password" placeholder="비밀번호 다시 입력" required/>
          <div id="pwdMsg" class="muted"></div>
        </div>

        <div class="row">
          <label for="name">이름</label>
          <input id="name" name="name" class="input" placeholder="이름" required/>
        </div>

        <div class="row">
          <label for="nickname">닉네임</label>
          <input id="nickname" name="nickname" class="input" placeholder="닉네임" required/>
        </div>

        <div class="row">
          <label for="email">이메일</label>
          <input id="email" name="email" class="input" type="email" placeholder="name@example.com" required/>
        </div>

        <div class="terms">
          <label class="row-inline">
            <input type="checkbox" id="agree" required/>
            <span class="muted">서비스 이용약관 및 개인정보 처리방침에 동의합니다.</span>
          </label>
        </div>

        <!-- 에러 메시지 출력 -->
        <div id="err" class="error" role="alert" aria-live="polite">
            ${errorMsg}
        </div>
        <div id="ok" class="ok" aria-live="polite"></div>

        <div class="row-inline" style="justify-content:flex-end">
          <button id="submitBtn" class="btn" type="submit">회원가입</button>
        </div>
      </form>
    </section>
  </main>

  <script>
    const menuBtn=document.querySelector('.menu-btn');
    const sideMenu=document.getElementById('sideMenu');
    menuBtn.addEventListener('click',e=>{
      e.stopPropagation(); sideMenu.classList.toggle('open');
      sideMenu.setAttribute('aria-hidden', sideMenu.classList.contains('open')?'false':'true');
    });
    document.addEventListener('click',e=>{
      if(!sideMenu.contains(e.target) && !menuBtn.contains(e.target)){
        sideMenu.classList.remove('open'); sideMenu.setAttribute('aria-hidden','true');
      }
    });

    document.getElementById('togglePwd').addEventListener('click',()=>{
      const pwd=document.getElementById('pwd');
      pwd.type = (pwd.type==='password')?'text':'password';
      document.getElementById('togglePwd').textContent = pwd.type==='password' ? '표시' : '숨김';
    });

    const meter=document.getElementById('pwdStrength');
    document.getElementById('pwd').addEventListener('input',()=>{
      const v = document.getElementById('pwd').value;
      let score = 0;
      if(v.length>=8) score++;
      if(/[A-Z]/.test(v)) score++;
      if(/[0-9]/.test(v)) score++;
      if(/[^A-Za-z0-9]/.test(v)) score++;
      meter.style.width = (score*25)+'%';
      meter.style.background = score>=3 ? '#1b7c3c' : '#e96a6a';
    });

    function checkMatch(){
      const m = document.getElementById('pwd').value &&
                document.getElementById('pwd2').value &&
                (document.getElementById('pwd').value === document.getElementById('pwd2').value);
      document.getElementById('pwdMsg').textContent = m? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.';
      document.getElementById('pwdMsg').className = m ? 'ok' : 'error';
      return m;
    }
    document.getElementById('pwd').addEventListener('input', checkMatch);
    document.getElementById('pwd2').addEventListener('input', checkMatch);
  </script>
</body>
</html>
