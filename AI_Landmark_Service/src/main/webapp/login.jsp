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
    header {
        position:fixed; top:0; left:0; width:100%; height:100px; background:#fff;
        display:flex; justify-content:space-between; align-items:center; padding:0 20px;
        z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04);
    }
    h2 a {
		  text-decoration: none;
		  color: inherit;
	}
    .menu-btn { position: fixed; top: 20px; right: 20px; font-size: 50px; background: none; border: none; color: black; cursor: pointer; z-index: 1002; }
    .side-menu {
        position: fixed; top: 0; right: -500px; width: 500px; height: 100%;
        background-color: #57ACCB; color: white; padding: 20px; padding-top: 100px;
        transition: right 0.3s ease; font-size: 30px; z-index: 1001;
    }
    .side-menu.open{ right: 0; }
    .side-menu li { list-style-type: none; margin-top: 20px; }
    .side-menu a { color: white; text-decoration: none; font-weight: bold; }
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
    .error {
        color: #c62828;
        font-size: 14px;
        font-weight: bold;
        text-align: left;
        margin-top: 5px;
    }
    .btn{background:#57ACCB;color:#fff;font-weight:800;border:none;border-radius:12px;padding:14px 20px;font-size:16px;cursor:pointer}
    .btn:disabled{opacity:.6;cursor:not-allowed}
    .link{color:#1466e2;text-decoration:none}
    .pwd-wrap{position:relative}
    .toggle{position:absolute;right:10px;top:50%;transform:translateY(-50%);background:transparent;border:none;cursor:pointer;font-size:13px;color:#2f6a88}
    @media (max-width:720px){
      .board{margin:120px 12px}
      .panel{padding:20px}
    }
    #headerImage{
		height: 80%;
		width: auto;
		display: flex;
	    justify-content: center;
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	}

    /* Google 번역 위젯 숨기기 */
    #google_translate_element { display: none; }

    /* 커스텀 언어 선택 드롭다운 */
    .language-selector {
        position: fixed;
        top: 30px;
        right: 120px;
        z-index: 1003;
    }
    .custom-select {
        padding: 10px 15px;
        font-size: 16px;
        border: 2px solid #57ACCB;
        border-radius: 8px;
        background-color: white;
        color: #333;
        font-weight: bold;
        outline: none;
        cursor: pointer;
        appearance: none;
        -webkit-appearance: none;
        -moz-appearance: none;
        background-image: url('data:image/svg+xml;charset=US-ASCII,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="%2357ACCB"><path d="M4 6l4 4 4-4z"/></svg>');
        background-repeat: no-repeat;
        background-position: right 12px center;
        background-size: 16px;
        transition: all 0.3s ease;
    }
    .custom-select:hover {
        border-color: #3d94b8;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }
    .custom-select:focus {
        border-color: #2a82a1;
        box-shadow: 0 4px 12px rgba(0,0,0,0.2);
    }
  </style>
</head>
<body>
  <header>
      <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
      <img src="<%=request.getContextPath()%>/image/headerImage.png" alt="MySite Logo" id="headerImage">
      <div id="google_translate_element"></div>

      <div class="language-selector">
          <select id="languageSelect" class="custom-select">
              <option value="ko">한국어</option>
              <option value="en">English</option>
              <option value="ja">日本語</option>
              <option value="zh-CN">中文(简体)</option>
          </select>
      </div>
  </header>
  <button class="menu-btn" aria-label="open side menu">≡</button>

  <div class="side-menu" id="sideMenu">
      <ul>
          <li><a href="${pageContext.request.contextPath}/howLandmark.jsp">Landmark Search란?</a></li>
          <li><a href="${pageContext.request.contextPath}/main.jsp">사진으로 랜드마크 찾기</a></li>
          <li><a href="${pageContext.request.contextPath}/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
          <li><a href="${pageContext.request.contextPath}/postList">게시판</a></li>
          <li><a href="${pageContext.request.contextPath}/login.jsp">로그인</a></li>
          <li><a href="${pageContext.request.contextPath}/register.jsp">회원가입</a></li>
      </ul>
  </div>

  <main class="board">
    <section class="panel">
      <h2 class="title">로그인</h2>

      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="row">
          <label for="uid">계정 입력</label>
          <input id="uid" name="ID" class="input" autocomplete="username" placeholder="이메일 또는 아이디" required/>
        </div>

        <div class="row">
          <label for="pwd">비밀번호 입력</label>
          <div class="pwd-wrap">
            <input id="pwd" name="PWD" class="input" type="password" autocomplete="current-password" placeholder="••••••••" required/>
            <button type="button" id="togglePwd" class="toggle">표시</button>
          </div>
        </div>

        <input type="hidden" name="redirect" value="${param.redirect}" />

        <div class="row-inline">
          <label class="muted"><input type="checkbox" id="remember"/> 로그인 상태 유지</label>
          <a class="link" href="${pageContext.request.contextPath}/register.jsp">회원가입</a>
        </div>
        
        <%
            String loginError = (String) request.getAttribute("loginError");
            if (loginError != null) {
        %>
                <p class="error"><%= loginError %></p>
        <%
            }
        %>

        <div class="row-inline" style="justify-content:flex-end">
          <button class="btn" type="submit">로그인</button>
        </div>
      </form>
    </section>
  </main>

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
  <script>
      function googleTranslateElementInit() {
          new google.translate.TranslateElement({
              pageLanguage: 'ko',
              autoDisplay: false
          }, 'google_translate_element');
      }

      document.addEventListener('DOMContentLoaded', () => {
          const select = document.getElementById('languageSelect');

          function applyLanguage(lang) {
              const combo = document.querySelector('.goog-te-combo');
              if (combo) {
                  combo.value = lang;
                  combo.dispatchEvent(new Event('change'));
              }
          }

          const interval = setInterval(() => {
              if (document.querySelector('.goog-te-combo')) {
                  applyLanguage(select.value);
                  clearInterval(interval);
              }
          }, 500);

          select.addEventListener('change', () => {
              applyLanguage(select.value);
          });
      });

    const menuBtn=document.querySelector('.menu-btn');
    const sideMenu=document.getElementById('sideMenu');
    menuBtn.addEventListener('click', (e) => { e.stopPropagation(); sideMenu.classList.toggle('open'); });
    document.addEventListener('click', (e) => { if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) sideMenu.classList.remove('open'); });

    document.getElementById('togglePwd').addEventListener('click',()=>{
      const pwd = document.getElementById('pwd');
      pwd.type = (pwd.type === 'password') ? 'text' : 'password';
      document.getElementById('togglePwd').textContent = (pwd.type === 'password') ? '표시' : '숨김';
    });
  </script>
</body>
</html>