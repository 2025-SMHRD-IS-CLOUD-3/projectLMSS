<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Landmark Search — 태그 결과</title>
    <style>
        :root { --ink:#111; --muted:#f4f4f4; --line:#e5e5e5; --brand:#57ACCB; }
        * { box-sizing:border-box; }
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
        .board { max-width:1200px; margin:140px auto 40px; background:var(--muted); border-radius:28px; padding:28px; }
        .title { margin:0 0 18px; text-align:center; font-weight:900; font-size:32px; }
        .wrap { border-radius:18px; overflow:hidden; background:#e9eef3; padding:24px; }
        .card-list { margin-top:0; display:flex; flex-direction:column; gap:12px; }
        .card { display:grid; grid-template-columns:120px 1fr; gap:14px; background:#fff; border:1px solid var(--line);
            border-radius:12px; box-shadow:0 6px 20px rgba(0,0,0,.08); padding:12px; text-decoration:none; color:inherit; }
        .thumb { width:120px; height:86px; border-radius:8px; background:#ddd; object-fit:cover; }
        .card-title { margin:0 0 4px; font-size:14px; font-weight:900; }
        .card-desc { margin:0; font-size:12px; color:#555; line-height:1.5; display:-webkit-box; -webkit-box-orient:vertical; overflow:hidden; }
        .card-meta { margin-top:6px; font-size:11px; color:#888; }
        .state { margin:12px 0 0; font-size:14px; color:#555; }
        @media (max-width:960px){ .card { grid-template-columns:100px 1fr; } .thumb { width:100px; height:76px; } }
        #headerImage{
			height: 100%;
			width: 500px;
			display: flex;
		    justify-content: center;
		    position: absolute;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		}
    </style>
</head>
<body>
    <header>
        <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
        <img src="./image/headerImage.png" alt="MySite Logo" id="headerImage">
    </header>
        <button class="menu-btn" aria-label="메뉴 열기">≡</button>
    <aside class="side-menu" id="sideMenu" aria-hidden="true">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>
            <% if (loginUser != null) { %>
                <li><a href="<%=request.getContextPath()%>/logout?redirect=<%=request.getRequestURI()%>">로그아웃</a></li>
                <li><a href="<%=request.getContextPath()%>/myProfile">마이페이지</a></li>
            <% } else { %>
                <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </aside>

    <section class="board">
        <h1 class="title" id="pageTitle">#태그</h1>
        <div class="wrap">
            <div id="cardList" class="card-list" aria-live="polite"></div>
            <p id="state" class="state"></p>
        </div>
    </section>

    <script>
        (function initMenu(){
            const btn = document.querySelector('.menu-btn');
            const side = document.getElementById('sideMenu');
            if(!btn || !side) return;
            btn.addEventListener('click', (e)=>{ e.stopPropagation(); side.classList.toggle('open'); side.setAttribute('aria-hidden', side.classList.contains('open') ? 'false' : 'true'); });
            document.addEventListener('click', (e)=>{ if(!side.contains(e.target) && !btn.contains(e.target)){ side.classList.remove('open'); side.setAttribute('aria-hidden','true'); }});
        })();
    </script>

    <script>
        /* ======================================================================
         * ✅ 이 파일(tagPage)에서 하는 일
         * 1) URL의 ?name=태그 값을 읽어 상단에 #표기로 표시
         * 2) /getLandmarks 에서 전체 랜드마크를 받아 TAGS 로 필터
         * 3) /getImage 에서 image_type=main 인 항목만 모아 룩업(Map) 생성
         * 4) 카드 렌더 시, 룩업에서 꺼낸 main 이미지를 썸네일로 사용
         ====================================================================== */

        const CONTEXT_PATH = "<%=request.getContextPath()%>";
        const GET_ALL_URL = CONTEXT_PATH + '/getLandmarks';
        const GET_IMG_URL = CONTEXT_PATH + '/getImage';
        const PLACEHOLDER = 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=640';

        const pageTitle = document.getElementById('pageTitle');
        const listRoot  = document.getElementById('cardList');
        const stateBox  = document.getElementById('state');

        function normalizeTags(v){
            if(!v) return [];
            const arr = Array.isArray(v) ? v : String(v).split(',');
            return arr.map(s => String(s).replace(/^#/,'').trim().toLowerCase()).filter(Boolean);
        }

        function toDirectImageUrl(url) {
            try {
                if (!url) return PLACEHOLDER;
                const u = new URL(url);
                if (u.hostname.startsWith('i.')) return url;
                if (u.hostname.includes('imgur.com')) {
                    const id = u.pathname.split('/').filter(Boolean).pop();
                    return id ? 'https://i.imgur.com/' + id + '.jpeg' : PLACEHOLDER;
                }
                return url;
            } catch {
                return PLACEHOLDER;
            }
        }

        async function buildMainImageLookup(){
            try {
                const res = await fetch(GET_IMG_URL);
                if(!res.ok) throw new Error('이미지 목록 로드 실패: HTTP '+res.status);
                const rows = await res.json();

                const lookup = new Map();
                rows.forEach(img => {
                    const type = String(img.image_type || '').toLowerCase();
                    const lid  = img.landmark_id;
                    if (type === 'main' && lid != null && !lookup.has(lid)) {
                        lookup.set(lid, toDirectImageUrl(img.image_url));
                    }
                });
                return lookup;
            } catch (e) {
                console.warn('[image] main 룩업 생성 실패, PLACEHOLDER 사용:', e);
                return new Map();
            }
        }

        function createCard(item, imageLookup){
            const id     = item.LANDMARK_ID || item.landmark_id || item.id;
            const name   = item.LANDMARK_NAME || item.landmark_name || item.name || ('#' + id);
            const nameEn = item.LANDMARK_NAME_EN || item.landmark_name_en || item.name_en || '';
            const desc   = item.DESCRIPTION || item.landmark_desc || item.description || '';
            const country = item.COUNTRY || item.landmark_location || item.country || '';

            const a = document.createElement('a');
            a.className = 'card';
            const linkName = encodeURIComponent(nameEn || name);
            // ❗ [수정] JSP 경로로 변경
            a.href = './landmarkInfo.jsp?name=' + linkName + (id ? '&id=' + id : '');

            const imgSrc = (id != null ? imageLookup.get(Number(id)) : null) || PLACEHOLDER;

            a.innerHTML = 
                '<img class="thumb" src="' + imgSrc + '" alt="' + name + '" loading="lazy" referrerpolicy="no-referrer" onerror="this.onerror=null; this.src=\'' + PLACEHOLDER + '\'">' +
                '<div>' +
                    '<h3 class="card-title">' + name + '</h3>' +
                    '<p class="card-desc">' + desc + '</p>' +
                    '<div class="card-meta">' + country + '</div>' +
                '</div>';
            return a;
        }

        (async function boot(){
            const params = new URLSearchParams(location.search);
            const tagName = (params.get('name') || '').trim();
            pageTitle.textContent = tagName ? '#' + tagName : '태그 결과';

            stateBox.textContent = '불러오는 중…';
            listRoot.innerHTML = '';

            try {
                const [landmarks, imageLookup] = await Promise.all([
                    fetch(GET_ALL_URL).then(r => {
                        if(!r.ok) throw new Error('랜드마크 목록 실패: HTTP ' + r.status);
                        return r.json();
                    }),
                    buildMainImageLookup()
                ]);

                const items = Array.isArray(landmarks) ? landmarks : (landmarks.items || []);
                const q = tagName.replace(/^#/,'').toLowerCase();
                const filtered = items.filter(it => normalizeTags(it.TAGS || it.tags).includes(q));

                if(filtered.length === 0){
                    stateBox.textContent = '#' + tagName + ' 태그로 검색된 랜드마크가 없습니다.';
                    return;
                }

                filtered.forEach(it => listRoot.appendChild(createCard(it, imageLookup)));
                stateBox.textContent = filtered.length + '개 결과';
            } catch (err) {
                console.error(err);
                stateBox.textContent = "데이터를 불러오는 중 오류가 발생했습니다. (" + err.message + ")\n서버의 CORS 설정(Access-Control-Allow-Origin)을 확인하세요.";
            }
        })();
    </script>
</body>
</html>
