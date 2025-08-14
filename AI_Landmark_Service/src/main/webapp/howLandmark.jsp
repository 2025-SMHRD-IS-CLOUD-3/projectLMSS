<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>howLandmark — 랜드마크란?</title>

    <!-- ====== 페이지 스타일(단일 파일) ====== -->
    <style>
        :root {
            --ink: #111;
            --muted: #f6f6f8;
            --line: #e6e6e8;
            --brand: #57ACCB;
        }

        * {
            box-sizing: border-box;
        }

        html,
        body {
            height: 100%;
        }

        body {
            margin: 0;
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            color: var(--ink);
            background: #fff;
        }

        /* ===== 헤더 & 사이드 메뉴 ===== */
        /* 해더 */
        header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background-color: white;
            display: flex;
            /* 같은 줄 배치 */
            justify-content: space-between;
            /* 좌우 끝으로 배치 */
            align-items: center;
            /* 세로 중앙 정렬 */
            padding: 0 20px;
            /* box-shadow: 0 2px 5px rgba(0,0,0,0.1); */
            /* z-index: 1003; */
        }

        header h1 {
            font-size: 18px;
            margin: 0;
            font-weight: bold;
        }

        /* 우측 배너 */
        .side-menu {
            position: fixed;
            top: 0;
            right: -500px;
            width: 500px;
            height: 100%;
            background-color: #57ACCB;
            color: white;
            padding: 20px;
            padding-top: 100px;
            box-sizing: border-box;
            transition: right 0.3s ease;
            font-size: 30px;
            z-index: 1002;
        }

        .side-menu li {
            list-style-type: none;
            margin-top: 20px;
        }

        .side-menu a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .side-menu h2 {
            margin-top: 10px;
        }

        .side-menu.open {
            right: 0;
        }

        /* 메뉴 버튼 */
        .menu-btn {
            position: fixed;
            top: 20px;
            right: 20px;
            font-size: 50px;
            background: none;
            border: none;
            color: black;
            cursor: pointer;
            z-index: 1001;
        }

        /* ===== 본문 컨테이너 ===== */
        .paper {
            max-width: 760px;
            margin: 12px auto 60px;
            background: var(--muted);
            border-radius: 28px;
            padding: 28px;
        }

        .paper h1 {
            text-align: center;
            margin: 0 0 18px;
            font-size: 28px;
            font-weight: 900;
        }

        .paper p {
            line-height: 1.7;
            margin: 10px 2px;
        }

        .section {
            margin: 22px 0 10px;
        }

        .section h2 {
            text-align: center;
            font-size: 22px;
            font-weight: 900;
            margin: 6px 0 14px;
        }

        /* 아이콘 래퍼 + 이미지 크기 상향 */
        .icon {
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 6px 0 10px;
        }

        /* ── 아이콘 그리드: 카드가 3열로 시원하게 배치되도록  */
        .icon-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            /* 카드 최소 폭 보장 */
            gap: 20px;
            /* align-items: stretch; */
        }

        /* 카드: 아이콘 위, 텍스트 2줄, 모두 가운데 정렬 */
        .icon-card {
            display: flex;
            flex-direction: column;
            align-items: center;
            /* 가운데 정렬 */
            text-align: center;
            /* 가운데 정렬 */
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 16px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, .06);
            padding: 20px 16px;
            min-height: 170px;
        }

        .icon-img {
            width: 72px;
            /* ← 아이콘 크게 */
            height: 72px;
            object-fit: contain;
        }

        /* 텍스트 가독성 */
        .icon-card strong {
            display: block;
            margin-top: 4px;
            font-size: 15px;
            font-weight: 800;
            line-height: 1.3;
        }

        .icon-card span {
            display: block;
            margin-top: 4px;
            font-size: 13px;
            color: #555;
            line-height: 1.4;
            word-break: keep-all;
            /* 한국어 단어 쪼개짐 방지 */
        }

        /* 모바일: 1열로 내려오기 */
        @media (max-width: 720px) {
            .icon-grid {
                grid-template-columns: 1fr;
            }
        }


        /* ===== 본문 블록 ===== */
        .blk {
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 16px;
            box-shadow: 0 4px 14px rgba(0, 0, 0, .05);
        }

        .blk+.blk {
            margin-top: 12px;
        }

        /* ===== 푸터 여백 */
        .footspace {
            height: 24px;
        }

        @media (max-width: 920px) {
            .side-menu {
                width: 85vw;
                right: -85vw;
            }
        }

        @media (max-width: 720px) {

            .paper {
                border-radius: 20px;
            }
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
            <li><a href="./howLandmark.html">Landmark Search란?</a></li>
            <li><a href="./main.html">사진으로 랜드마크 찾기</a></li>
            <li><a href="./mapSearch.html">지도로 랜드마크 찾기</a></li>
            <li><a href="./post.html">게시판</a></li>
            <li><a href="./login.html">로그인</a></li>
            <li><a href="./join.html">회원가입</a></li>
        </ul>

    </div>

    <!-- ===== 일러스트 리본 ===== -->
    <div class="ribbon" aria-hidden="true">
        <!-- 간단한 도심 실루엣 SVG -->
        <svg viewBox="0 0 600 80" fill="none" xmlns="http://www.w3.org/2000/svg">

        </svg>
    </div>

    <!-- ===== 본문 ===== -->
    <main class="paper" role="main">
        <h1>랜드마크란?</h1>
        <div class="blk">
            <p>
                랜드마크는 특정 지역을 대표하거나 식별할 수 있는 지형지물이나 구조물로, 역사적·문화적·건축학적·상징적인 의미를 지닌다. ‘landmark’는 ‘land(땅)’와 ‘mark(이정표)’의
                합성어로, 고대에는 산, 나무, 바위 등이 표식 역할을 했다.
            </p>
            <p>
                역사적으로는 탐험가나 여행자가 경로를 기억하기 위해 사용했으며, 피라미드·중국의 탑·유럽의 성당 등이 대표적이다. 현대에는 건물, 조각상, 문화재, 지형 등 다양한 형태로 지역을
                상징하며, 그 지역의 브랜드로 자리 잡아 관광과 경제에 큰 영향을 준다.
            </p>
        </div>

        <section class="section">
            <h2>랜드마크 종류</h2>
            <div class="icon-grid">
                <div class="icon-card">
                    <div class="icon">
                        <!-- 역사적 건물 -->
                        <img class="icon-img" src="./data/역사적 건물.png" alt="역사적 건축 아이콘">
                    </div>

                    <strong>역사적 건축</strong>
                    <span>궁궐·사원·기념비 등</span>
                </div>
                <div class="icon-card">
                    <div class="icon">
                        <!-- 자연경관 -->
                        <img class="icon-img" src="./data/자연 경관.png" alt="자연경관">
                    </div>

                    <strong>자연경관</strong>
                    <span>산·계곡·협곡·섬</span>
                </div>
                <div class="icon-card">
                    <div class="icon">
                        <!-- 현대 건축 -->
                        <img class="icon-img" src="./data/현대적 건축물.png" alt="현대적 건축물">
                    </div>

                    <strong>현대 건축물</strong>
                    <span>타워·브리지·오페라하우스</span>
                </div>
            </div>

        </section>

        <section class="section">
            <h2>랜드마크는 왜 중요할까요?</h2>
            <div class="icon-grid">
               <div class="icon-card">
                <div class="icon">
                    <!-- 문화 -->
                    <img class="icon-img" src="./data/문화적 가치.png" alt="문화적가치">

                </div>
                <strong>문화적 가치</strong>
                <span>정체성과 기억을 강화</span>
            </div>
            <div class="icon-card">
                <div class="icon">
                    <!-- 경제 -->
                    <img class="icon-img" src="./data/경제적 가치.png" alt="경제적 가치">

                </div>
                <strong>경제적 가치</strong>
                <span>관광·상권 활성화</span>
            </div>
            <div class="icon-card">
                <div class="icon">
                    <!-- 정책 -->
                    <img class="icon-img" src="./data/지역 정체성.png" alt="지역정체성">

                </div>
                <strong>지역 정체성</strong>
                <span>보존·활용 전략 수립</span>
            </div> 
            </div>
            
        </section>

        <section class="section">
            <h2>Landmark Search 란?</h2>
            <div class="blk">
                <p>
                    <b>Landmark Search</b>는 사용자가 입력한 텍스트·사진·지도 상의 위치를 분석해 해당 지역의 랜드마크 정보를
                    <b>한눈에</b> 보여주는 서비스입니다.
                </p>
            </div>

            <div class="blk">
                <p><b>주요 기능</b></p>
                <p>① 사진/텍스트 업로드 → AI가 랜드마크 후보를 추출하고, 이름·설명·좌표·관련 팁을 카드로 요약</p>
                <p>② 지도 탐색 → 국가/도시/구역을 클릭하면 대표 랜드마크 3개 카드가 즉시 출력</p>
                <p>③ 커뮤니티 → 게시글·댓글·리스트로 경험을 공유
            </div>

            <div class="blk">
                <p><b>기술 스택</b></p>
                <p>• 프론트엔드: HTML/CSS/JavaScript + Leaflet(지도)</p>
                <p>• 백엔드/AI: 추후 확장</p>
                <p>• 데이터: 국가/도시/랜드마크 기본 데이터셋과 사용자 생성 콘텐츠</p>
            </div>

            <div class="blk">
                <p><b>기대 효과</b></p>
                <p>• 여행 계획 시간 단축</p>
                <p>• 지역 문화/역사 접근성 향상</p>
                <p>• 데이터 기반 관광 의사결정 보조</p>
            </div>
        </section>

        <div class="footspace"></div>
    </main>

    <!-- ===== 사이드 메뉴 스크립트(단일 파일) ===== -->
    <script>
        const menuBtn = document.querySelector('.menu-btn');
        const sideMenu = document.getElementById('sideMenu');

        if (menuBtn && sideMenu) {
            menuBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                sideMenu.classList.toggle('open');
                sideMenu.setAttribute(
                    'aria-hidden',
                    sideMenu.classList.contains('open') ? 'false' : 'true'
                );
            });

            document.addEventListener('click', (e) => {
                if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
                    sideMenu.classList.remove('open');
                    sideMenu.setAttribute('aria-hidden', 'true');
                }
            });
        }
    </script>
</body>

</html>