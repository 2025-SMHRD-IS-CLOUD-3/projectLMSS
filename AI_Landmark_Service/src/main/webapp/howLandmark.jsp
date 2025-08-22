<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 로그인 세션 불러오기 (없으면 null)
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>howLandmark — 랜드마크란?</title>

    <style>
        :root {
            --ink: #111;
            --muted: #f6f6f8;
            --line: #e6e6e8;
            --brand: #57ACCB;
        }
        * { box-sizing: border-box; }
        html, body { height: 100%; margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; color: var(--ink); background: #fff; }

        header {
            position: fixed; top: 0; left: 0; width: 100%; height: 100px;
            background-color: white; display: flex; justify-content: space-between; align-items: center;
            padding: 0 20px;
        }
        h2 a {
		  text-decoration: none;
		  color: inherit;
		}
        .user-info { font-size: 14px; color: #555; margin-right: 10px; }

        .side-menu {
            position: fixed; top: 0; right: -500px; width: 500px; height: 100%;
            background-color: #57ACCB; color: white; padding: 20px; padding-top: 100px;
            transition: right 0.3s ease; font-size: 30px; z-index: 1001;
        }
        .side-menu li { list-style-type: none; margin-top: 20px; }
        .side-menu a { color: white; text-decoration: none; font-weight: bold; }
        .side-menu.open { right: 0; }
        .menu-btn { position: fixed; top: 20px; right: 20px; font-size: 50px; background: none; border: none; color: black; cursor: pointer; z-index: 1002; }

        .paper { max-width: 760px; margin: 120px auto 60px; background: var(--muted); border-radius: 28px; padding: 28px; }
        .paper h1 { text-align: center; margin: 0 0 18px; font-size: 28px; font-weight: 900; }
        .paper p { line-height: 1.7; margin: 10px 2px; }

        .section { margin: 22px 0 10px; }
        .section h2 { text-align: center; font-size: 22px; font-weight: 900; margin: 6px 0 14px; }

        .icon { display: flex; justify-content: center; align-items: center; margin: 6px 0 10px; }
        .icon-grid { display: grid; grid-template-columns: repeat(3, minmax(220px, 1fr)); gap: 20px; }
        .icon-card {
            display: flex; flex-direction: column; align-items: center; text-align: center;
            background: #fff; border: 1px solid var(--line); border-radius: 16px;
            box-shadow: 0 4px 14px rgba(0,0,0,.06); padding: 20px 16px; min-height: 170px;
        }
        .icon-img { width: 72px; height: 72px; object-fit: contain; }
        .icon-card strong { display: block; margin-top: 4px; font-size: 15px; font-weight: 800; line-height: 1.3; }
        .icon-card span { display: block; margin-top: 4px; font-size: 13px; color: #555; line-height: 1.4; word-break: keep-all; }

        @media (max-width: 720px) { .icon-grid { grid-template-columns: 1fr; } }
        .blk { background: #fff; border: 1px solid var(--line); border-radius: 16px; padding: 16px; box-shadow: 0 4px 14px rgba(0,0,0,.05); }
        .blk + .blk { margin-top: 12px; }
        .footspace { height: 24px; }
        @media (max-width: 920px) { .side-menu { width: 85vw; right: -85vw; } }
        @media (max-width: 720px) { .paper { border-radius: 20px; } }
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
            <button class="menu-btn">≡</button>

    <div class="side-menu" id="sideMenu">
        <ul>
            <li><a href="<%= request.getContextPath() %>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="postList">게시판</a></li>
            <% if (loginUser == null) { %>
                <li><a href="login.jsp">로그인</a></li>
                <li><a href="register.jsp">회원가입</a></li>
            <% } else { %>
                <li>
                    <a href="<%= request.getContextPath() %>/logout?redirect=<%= request.getRequestURI() %>">
                        로그아웃
                    </a>
                </li>
                <li>
                	<a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
                </li>
            <% } %>
        </ul>
    </div>

    <main class="paper" role="main">
        <h1>랜드마크란?</h1>
        <div class="blk">
            <p>랜드마크는 특정 지역을 대표하거나 식별할 수 있는 지형지물이나 구조물로, 역사적·문화적·건축학적·상징적인 의미를 지닌다.</p>
            <p>역사적으로는 탐험가나 여행자가 경로를 기억하기 위해 사용했으며, 현대에는 건물, 조각상, 문화재, 지형 등 다양한 형태로 지역을 상징하며 관광과 경제에 영향을 준다.</p>
        </div>

        <section class="section">
            <h2>랜드마크 종류</h2>
            <div class="icon-grid">
                <div class="icon-card">
                    <div class="icon"><img class="icon-img" src="./data/역사적 건물.png" alt="역사적 건축 아이콘"></div>
                    <strong>역사적 건축</strong><span>궁궐·사원·기념비 등</span>
                </div>
                <div class="icon-card">
                    <div class="icon"><img class="icon-img" src="./data/자연 경관.png" alt="자연경관"></div>
                    <strong>자연경관</strong><span>산·계곡·협곡·섬</span>
                </div>
                <div class="icon-card">
                    <div class="icon"><img class="icon-img" src="./data/현대적 건축물.png" alt="현대적 건축물"></div>
                    <strong>현대 건축물</strong><span>타워·브리지·오페라하우스</span>
                </div>
            </div>
        </section>

        <section class="section">
            <h2>랜드마크는 왜 중요할까요?</h2>
            <div class="icon-grid">
               <div class="icon-card">
                    <div class="icon"><img class="icon-img" src="./data/문화적 가치.png" alt="문화적 가치"></div>
                    <strong>문화적 가치</strong><span>정체성과 기억을 강화</span>
               </div>
               <div class="icon-card">
                    <div class="icon"><img class="icon-img" src="./data/경제적 가치.png" alt="경제적 가치"></div>
                    <strong>경제적 가치</strong><span>관광·상권 활성화</span>
               </div>
               <div class="icon-card">
                    <div class="icon"><img class="icon-img" src="./data/지역 정체성.png" alt="지역정체성"></div>
                    <strong>지역 정체성</strong><span>보존·활용 전략 수립</span>
               </div> 
            </div>
        </section>

        <section class="section">
            <h2>Landmark Search 란?</h2>
            <div class="blk">
                <p><b>Landmark Search</b>는 사용자가 입력한 텍스트·사진·지도 상의 위치를 분석해 해당 지역의 랜드마크 정보를 <b>한눈에</b> 보여주는 서비스입니다.</p>
            </div>
            <div class="blk">
                <p><b>주요 기능</b></p>
                <p>① 사진/텍스트 업로드 → AI가 랜드마크 후보를 추출</p>
                <p>② 지도 탐색 → 국가/도시 클릭 시 대표 랜드마크 3개 출력</p>
                <p>③ 커뮤니티 → 게시글·댓글·리스트 공유</p>
            </div>
            <div class="blk">
                <p><b>기술 스택</b></p>
                <p>• 프론트엔드: HTML/CSS/JavaScript + Leaflet(지도)</p>
                <p>• 백엔드/AI: 추후 확장</p>
                <p>• 데이터: 국가/도시/랜드마크 기본 데이터셋</p>
            </div>
        </section>
        <div class="footspace"></div>
    </main>

    <script>
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
    </script>
</body>
</html>
