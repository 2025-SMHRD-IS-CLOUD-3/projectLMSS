<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>mapSearch — 지도에서 랜드마크 찾기</title>

    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>

    <style>
        :root {
            --ink: #111;
            --muted: #f4f4f4;
            --line: #e5e5e5;
            --brand: #57ACCB;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            color: var(--ink);
            background: #fff;
        }

        /* ===== 헤더 & 사이드메뉴 ===== */
        header {
            position: fixed; top: 0; left: 0;
            width: 100%; height: 100px;
            background: #fff;
            display: flex; justify-content: space-between; align-items: center;
            padding: 0 20px;
            z-index: 1000;
            box-shadow: 0 1px 0 rgba(0, 0, 0, .04);
        }

        header h1, header h2 {
            margin: 0; font-size: 18px; font-weight: bold;
        }

        .menu-btn {
            position: fixed; top: 20px; right: 20px;
            font-size: 50px; background: none; border: none; color: #000;
            cursor: pointer; z-index: 1001;
        }

        .side-menu {
            position: fixed; top: 0; right: -500px;
            width: 500px; height: 100%;
            background: var(--brand); color: #fff;
            padding: 20px; padding-top: 100px;
            transition: right .3s ease;
            z-index: 1002; font-size: 30px;
        }
        .side-menu.open { right: 0; }
        .side-menu ul { margin: 0; padding: 0; }
        .side-menu li { list-style: none; margin-top: 20px; }
        .side-menu a { color: #fff; text-decoration: none; font-weight: bold; }

        /* ===== 본문 (회색 보드 + 지도 + 하단 카드) ===== */
        .board {
            max-width: 1200px;
            margin: 140px auto 40px;
            background: var(--muted);
            border-radius: 28px;
            padding: 28px;
        }

        .title {
            margin: 0 0 18px;
            text-align: center;
            font-weight: 900;
            font-size: 32px;
        }

        .map-wrap {
            border-radius: 18px;
            overflow: hidden;
            background: #e9eef3;
            padding: 24px;
        }

        #map {
            width: 100%;
            height: 560px;
            border-radius: 8px;
        }

        /* 지도 하단 카드 영역(수직 배치) */
        .card-list {
            margin-top: 16px;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .card {
            display: grid;
            grid-template-columns: 120px 1fr;
            gap: 14px;
            background: #fff;
            border: 1px solid var(--line);
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, .08);
            padding: 12px;
            text-decoration: none;
            color: inherit;
        }

        .card img {
            width: 120px;
            height: 86px;
            object-fit: cover;
            border-radius: 8px;
            background: #ddd;
        }

        .card-title { margin: 0 0 4px; font-size: 14px; font-weight: 900; }
        .card-desc { margin: 0; font-size: 12px; color: #555; }
        .card-meta { margin-top: 6px; font-size: 11px; color: #888; }

        .leaflet-popup-content-wrapper { border-radius: 12px; }

        @media (max-width:960px) {
            #map { height: 420px; }
            .card { grid-template-columns: 100px 1fr; }
            .card img { width: 100px; height: 76px; }
        }
    </style>
</head>

<body>
    <!-- ===== 헤더 ===== -->
    <header>
        <h2>Landmark Search</h2>
        <button class="menu-btn" aria-label="메뉴 열기">≡</button>
    </header>

    <!-- ===== 사이드 메뉴 ===== -->
    <aside class="side-menu" id="sideMenu" aria-hidden="true">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/post.jsp">게시판</a></li>
            <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
            <li><a href="<%=request.getContextPath()%>/join.jsp">회원가입</a></li>
        </ul>
    </aside>

    <!-- ===== 본문 ===== -->
    <section class="board">
        <h1 class="title">지도에서 랜드마크 찾기</h1>

        <div class="map-wrap">
            <!-- 지도 -->
            <div id="map" aria-label="세계 지도"></div>

            <!-- 지도 하단 카드(수직) -->
            <div id="cardList" class="card-list" aria-live="polite"></div>
        </div>
    </section>

    <!-- ===== 헤더/사이드 메뉴 스크립트 ===== -->
    <script>
        const menuBtn = document.querySelector('.menu-btn');
        const sideMenu = document.getElementById('sideMenu');
        if (menuBtn && sideMenu) {
            menuBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                sideMenu.classList.toggle('open');
                sideMenu.setAttribute('aria-hidden', sideMenu.classList.contains('open') ? 'false' : 'true');
            });
            document.addEventListener('click', (e) => {
                if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
                    sideMenu.classList.remove('open');
                    sideMenu.setAttribute('aria-hidden', 'true');
                }
            });
        }
    </script>

    <!-- ===== 랜드마크 데이터 ===== -->
    <script>
        const landmarkInfo = {
            '경복궁': { lat: 37.5796, lng: 126.9770, country: 'South Korea', description: '조선 왕조의 법궁으로, 아름다운 건축미를 자랑합니다.' },
            '남산 서울타워': { lat: 37.5512, lng: 126.9882, country: 'South Korea', description: '서울의 대표적인 랜드마크이자 관광 명소입니다.' },
            '만리장성': { lat: 40.4319, lng: 116.5704, country: 'China', description: '고대 중국의 성벽으로, 인류 역사상 가장 큰 건축물 중 하나입니다.' },
            '자금성': { lat: 39.9163, lng: 116.3972, country: 'China', description: '명청 시대의 궁궐로, 세계에서 가장 큰 고대 궁전입니다.' },
            '도쿄 타워': { lat: 35.6586, lng: 139.7454, country: 'Japan', description: '일본 도쿄 미나토구에 있는 전파탑이자 랜드마크입니다.' },
            '타지마할': { lat: 27.1751, lng: 78.0421, country: 'India', description: '무굴 제국의 아름다운 묘지 건축물.' },
            '에펠탑': { lat: 48.8584, lng: 2.2945, country: 'France', description: '파리의 상징.' },
            '루브르 박물관': { lat: 48.8606, lng: 2.3376, country: 'France', description: '세계적인 박물관.' },
            '피사의 사탑': { lat: 43.7230, lng: 10.3966, country: 'Italy', description: '기울어진 종탑.' },
            '콜로세움': { lat: 41.8902, lng: 12.4922, country: 'Italy', description: '고대 원형 경기장.' },
            '로마 판테온': { lat: 41.8986, lng: 12.4768, country: 'Italy', description: '고대 신전.' },
            '사그라다 파밀리아': { lat: 41.4037, lng: 2.1744, country: 'Spain', description: '가우디의 미완성 대성당.' },
            '빅벤': { lat: 51.5007, lng: -0.1246, country: 'United Kingdom', description: '런던의 시계탑.' },
            '엠파이어 스테이트 빌딩': { lat: 40.7484, lng: -73.9857, country: 'United States of America', description: '뉴욕의 마천루.' },
            '자유의 여신상': { lat: 40.6892, lng: -74.0445, country: 'United States of America', description: '자유의 상징.' },
            '그랜드 캐니언': { lat: 36.1016, lng: -112.1129, country: 'United States of America', description: '웅장한 협곡.' },
            '마추픽추': { lat: -13.1631, lng: -72.5450, country: 'Peru', description: '잉카 고대 도시.' },
            '크라이스트 더 리디머': { lat: -22.9519, lng: -43.2105, country: 'Brazil', description: '리우의 예수상.' },
            '시드니 오페라 하우스': { lat: -33.8568, lng: 151.2153, country: 'Australia', description: '시드니의 상징.' },
            '피라미드': { lat: 29.9792, lng: 31.1342, country: 'Egypt', description: '고대 왕의 무덤.' }
        };

        // 국가별 묶기
        const landmarksByCountry = {};
        for (const name in landmarkInfo) {
            const info = landmarkInfo[name];
            (landmarksByCountry[info.country] ||= []).push({ name, ...info });
        }

        // 국가명 보정
        function normalizeCountry(name) {
            const dict = new Map([
                ['USA', 'United States of America'],
                ['United States', 'United States of America'],
                ['UK', 'United Kingdom'],
                ['Korea, Republic of', 'South Korea'],
                ['Russian Federation', 'Russia'],
                ['Viet Nam', 'Vietnam'],
            ]);
            return dict.get(name) || name;
        }

        // 랜드마크가 있는 국가만 활성
        const activeCountries = new Set(Object.keys(landmarksByCountry).map(normalizeCountry));
    </script>

    <!-- ===== 지도/카드 스크립트 ===== -->
    <script>
        const GEOJSON_URL = 'https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json';

        // 카드 썸네일(없으면 placeholder)
        const THUMBS = {
            '경복궁': 'https://images.unsplash.com/photo-1587479658947-5d3e3f25d4d3?q=80&w=640',
            '남산 서울타워': 'https://images.unsplash.com/photo-1599467558118-409f1c0a19c1?q=80&w=640',
            '만리장성': 'https://images.unsplash.com/photo-1549899593-ec9f8c1f1c28?q=80&w=640',
            '자금성': 'https://images.unsplash.com/photo-1555992336-afc3494c15f1?q=80&w=640',
            '도쿄 타워': 'https://images.unsplash.com/photo-1512972972904-380dbe3dfed3?q=80&w=640',
            '타지마할': 'https://images.unsplash.com/photo-1591104692283-1c2f6afb59f1?q=80&w=640',
            '에펠탑': 'https://images.unsplash.com/photo-1508057198894-247b23fe5ade?q=80&w=640',
            '루브르 박물관': 'https://images.unsplash.com/photo-1543349689-9a4d426f2c87?q=80&w=640',
            '피사의 사탑': 'https://images.unsplash.com/photo-1455587734955-081b22074882?q=80&w=640',
            '콜로세움': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?q=80&w=640',
            '로마 판테온': 'https://images.unsplash.com/photo-1603010367926-3af381bb77eb?q=80&w=640',
            '사그라다 파밀리아': 'https://images.unsplash.com/photo-1508050317348-0f8f9605b097?q=80&w=640',
            '빅벤': 'https://images.unsplash.com/photo-1430760938768-1d2aeaaac77f?q=80&w=640',
            '엠파이어 스테이트 빌딩': 'https://images.unsplash.com/photo-1486325212027-8081e4852553?q=80&w=640',
            '자유의 여신상': 'https://images.unsplash.com/photo-1549923746-c502d488b3ea?q=80&w=640',
            '그랜드 캐니언': 'https://images.unsplash.com/photo-1508264165352-258a6c5a1004?q=80&w=640',
            '마추픽추': 'https://images.unsplash.com/photo-1548793676-bfe4c2f9b4de?q=80&w=640',
            '크라이스트 더 리디머': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=640',
            '시드니 오페라 하우스': 'https://images.unsplash.com/photo-1506976785307-8732e854ad75?q=80&w=640',
            '피라미드': 'https://images.unsplash.com/photo-1518684079-3c830dcef090?q=80&w=640'
        };
        const PLACEHOLDER = 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=640';

        document.addEventListener('DOMContentLoaded', () => {
            const listRoot = document.getElementById('cardList');

            // 지도
            const map = L.map('map', { worldCopyJump: false }).setView([20, 0], 2);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution: '&copy; OpenStreetMap', noWrap: true
            }).addTo(map);

            // 레이아웃 타이밍 보정
            map.invalidateSize();
            window.addEventListener('load', () => map.invalidateSize());
            window.addEventListener('resize', () => map.invalidateSize());

            // 국가 경계
            fetch(GEOJSON_URL)
                .then(r => r.json())
                .then(geo => {
                    L.geoJSON(geo, {
                        // 활성 국가만 색상
                        style: (f) => {
                            const name = normalizeCountry(f.properties.name || f.properties.ADMIN);
                            const active = activeCountries.has(name);
                            return active
                                ? { color: '#ff2d20', weight: 1.5, fillColor: '#9fbfff', fillOpacity: 0.12 }
                                : { color: '#d7d7d7', weight: 0.8, fillOpacity: 0 };
                        },
                        // 활성 국가만 인터랙션
                        onEachFeature: (f, layer) => {
                            const name = normalizeCountry(f.properties.name || f.properties.ADMIN);
                            if (!activeCountries.has(name)) return;

                            layer.on('mouseover', () => layer.setStyle({ fillOpacity: 0.2 }));
                            layer.on('mouseout', () => layer.setStyle({ fillOpacity: 0.12 }));
                            layer.on('click', () => {
                                map.fitBounds(layer.getBounds(), { padding: [20, 20] });
                                renderCardsForCountry(listRoot, name);
                            });
                        }
                    }).addTo(map);
                });
        });

        // 카드 렌더링
        function renderCardsForCountry(root, countryName) {
            const items = (landmarksByCountry[countryName] || []).slice(0, 3);
            root.innerHTML = '';

            if (items.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'card';
                empty.innerHTML = `
          <img src="${PLACEHOLDER}" alt="">
          <div>
            <h3 class="card-title">${countryName}</h3>
            <p class="card-desc">등록된 랜드마크가 없습니다.</p>
          </div>`;
                root.appendChild(empty);
                return;
            }

            items.forEach(lm => {
                const a = document.createElement('a');
                a.className = 'card';
                a.href = '<%=request.getContextPath()%>/landmark.jsp?name=' + encodeURIComponent(lm.name);
                a.innerHTML = `
  <img src="${THUMBS[lm.name] || PLACEHOLDER}" alt="${lm.name}">
  <div>
    <h3 class="card-title">${lm.name}</h3>
    <p class="card-desc">${lm.description || ''}</p>
    <div class="card-meta">${lm.country}</div>
  </div>
`;
                root.appendChild(a);
            });
        }
    </script>
</body>
</html>
