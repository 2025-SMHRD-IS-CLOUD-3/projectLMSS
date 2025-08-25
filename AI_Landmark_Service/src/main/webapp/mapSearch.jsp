<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>mapSearch — 지도에서 랜드마크 찾기</title>

    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>
    <script src="https://unpkg.com/@turf/turf@6.5.0/turf.min.js" defer></script>
    
    <style>
    	h2 a {
		  text-decoration: none;
		  color: inherit;
		}
        :root { --ink:#111; --muted:#f4f4f4; --line:#e5e5e5; --brand:#57ACCB; }
        * { box-sizing:border-box; }
        body { margin:0; font-family:system-ui,-apple-system, Segoe UI, Roboto, Arial, sans-serif; color:var(--ink); background:#fff; }
        header { 
        	position:fixed; top:0; left:0; width:100%; 
        	height:100px; background:#fff; display:flex; 
        	justify-content:space-between; align-items:center; 
        	padding:0 20px; z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04);
        	}
        .menu-btn {
        	position:fixed; top:20px; right:20px; 
        	font-size:50px; background:none; border:none; 
        	color:#000; cursor:pointer; z-index:1002; }
        .side-menu { position:fixed; top:0; right:-500px; width:500px; height:100%; background:var(--brand); color:#fff; padding:20px; padding-top:100px; transition:right .3s ease; z-index:1001; font-size:30px; }
        .side-menu.open { right:0; }
        .side-menu ul { margin:0; padding:0; }
        .side-menu li { list-style:none; margin-top:20px; }
        .side-menu a { color:#fff; text-decoration:none; font-weight:bold; }
        .board { max-width:1200px; margin:140px auto 40px; background:var(--muted); border-radius:28px; padding:28px; }
        .title { margin:0 0 18px; text-align:center; font-weight:900; font-size:32px; }
        .map-wrap { border-radius:18px; overflow:hidden; background:#e9eef3; padding:24px; }
        #map { width:100%; height:560px; border-radius:8px; }
        .card-list { margin-top:16px; display:flex; flex-direction:column; gap:12px; }
        .card { display:grid; grid-template-columns:120px 1fr; gap:14px; background:#fff; border:1px solid var(--line); border-radius:12px; box-shadow:0 6px 20px rgba(0,0,0,.08); padding:12px; text-decoration:none; color:inherit; }
        .thumb { width:120px; height:86px; border-radius:8px; background:#ddd; object-fit:cover; }
        .card-title { margin:0 0 4px; font-size:14px; font-weight:900; }
        .card-desc { margin:0; font-size:12px; color:#555; line-height:1.5; display:-webkit-box; -webkit-box-orient:vertical; overflow:hidden; }
        .card-meta { margin-top:6px; font-size:11px; color:#888; }
        .leaflet-popup-content-wrapper { border-radius:12px; }
        .leaflet-interactive { cursor:pointer; }
        .leaflet-container .leaflet-interactive:focus, .leaflet-container .leaflet-interactive:focus-visible { outline: none; }
        .legend{ position:absolute; right:28px; bottom:28px; background:#fff; border:1px solid var(--line); border-radius:10px; padding:8px 10px; font-size:12px; box-shadow:0 6px 18px rgba(0,0,0,.06); }
        .key{ display:flex; align-items:center; gap:8px; margin:4px 0; }
        .sw{ width:14px; height:10px; border:2px solid #ff2d20; background:#9fbfff33; }
        .sw.off{ border-color:#9aa3aa; background:transparent; }
        @media (max-width:960px){ #map { height:420px; } .card { grid-template-columns:100px 1fr; } .thumb { width:100px; height:76px; } }
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
                <li><a href="<%=request.getContextPath()%>/login.jsp?redirect=<%=request.getRequestURI()%>">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </aside>

    <section class="board">
        <h1 class="title">지도에서 랜드마크 찾기</h1>
        <div class="map-wrap">
            <div id="map" aria-label="세계 지도"></div>
            <div id="cardList" class="card-list" aria-live="polite"></div>
        </div>
    </section>

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
        
        // 사이드 메뉴 토글
        const menuBtn = document.querySelector('.menu-btn');
        const sideMenu = document.getElementById('sideMenu');
        if (menuBtn && sideMenu) {
            menuBtn.addEventListener('click', e => {
                e.stopPropagation();
                sideMenu.classList.toggle('open');
                sideMenu.setAttribute('aria-hidden', sideMenu.classList.contains('open') ? 'false' : 'true');
            });
            document.addEventListener('click', e => {
                if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
                    sideMenu.classList.remove('open');
                    sideMenu.setAttribute('aria-hidden', 'true');
                }
            });
        }
    </script>

    <script>
        const CTX = '<%=request.getContextPath()%>';
        const GET_ALL_URL = CTX + '/getLandmarks';
        const GET_IMG_URL = CTX + '/getImage';
        const GEOJSON_URL = 'https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json';
        const PLACEHOLDER = 'https://placehold.co/120x86?text=No+Image';

        let map, markersLayer;
        let imageLookup = new Map();

        const getData = (item, key) => item[key.toLowerCase()] || item[key.toUpperCase()] || '';

        function convertImgurUrl(url) {
            if (!url) return url;
            const imgurPattern = /https?:\/\/imgur\.com\/([a-zA-Z0-9]+)/;
            const match = url.match(imgurPattern);
            if (match) return 'https://i.imgur.com/' + match[1] + '.jpg';
            return url;
        }

        function testImageUrl(url) {
            return new Promise((resolve) => {
                const img = new Image();
                img.onload = () => resolve(true);
                img.onerror = () => resolve(false);
                img.src = url;
            });
        }

        async function tryMultipleImageFormats(baseUrl) {
            const imgurPattern = /https?:\/\/i\.imgur\.com\/([a-zA-Z0-9]+)\./;
            const match = baseUrl.match(imgurPattern);
            if (!match) return baseUrl;

            const imageId = match[1];
            const extensions = ['jpg', 'jpeg', 'png', 'gif'];
            for (const ext of extensions) {
                const testUrl = 'https://i.imgur.com/' + imageId + '.' + ext;
                if (await testImageUrl(testUrl)) return testUrl;
            }
            return baseUrl;
        }
        
        async function getValidImageUrl(originalUrl) {
            if (!originalUrl) return null;
            let convertedUrl = convertImgurUrl(originalUrl);
            return await tryMultipleImageFormats(convertedUrl);
        }

        async function buildMainImageLookup() {
            try {
                const res = await fetch(GET_IMG_URL);
                if (!res.ok) throw new Error('이미지 목록 로드 실패');
                const rows = await res.json();
                
                const lookup = new Map();
                for (const img of rows) {
                    const type = getData(img, 'IMAGE_TYPE')?.toLowerCase();
                    const lid = getData(img, 'LANDMARK_ID');
                    const url = getData(img, 'IMAGE_URL');

                    if (type === 'main' && lid != null && url && !lookup.has(lid)) {
                        lookup.set(lid, await getValidImageUrl(url));
                    }
                }
                return lookup;
            } catch (e) {
                console.error('이미지 맵 생성 중 오류 발생:', e);
                return new Map();
            }
        }

        function showMarkers(items) {
            if (!markersLayer) {
                markersLayer = L.layerGroup().addTo(map);
            } else {
                markersLayer.clearLayers();
            }
            
            items.forEach(it => {
                const lat = Number(getData(it, 'LATITUDE'));
                const lng = Number(getData(it, 'LONGITUDE'));
                if (!isFinite(lat) || !isFinite(lng)) return;
                
                let popContent = '<strong>' + getData(it, 'LANDMARK_NAME') + '</strong><br>';
                if (getData(it, 'LANDMARK_NAME_EN')) {
                    popContent += '<em>' + getData(it, 'LANDMARK_NAME_EN') + '</em><br>';
                }
                popContent += getData(it, 'LANDMARK_LOCATION');
                
                L.marker([lat, lng]).bindPopup(popContent).addTo(markersLayer);
            });
        }

        function addLegend() {
            const div = document.createElement('div');
            div.className = 'legend';
            div.innerHTML = '<div class="key"><span class="sw"></span>클릭 가능 (랜드마크 있음)</div><div class="key"><span class="sw off"></span>클릭 불가 (없음)</div>';
            document.body.appendChild(div);
        }
        
        function renderCards(root, countryName, items) {
            root.innerHTML = '';

            if (!items || items.length === 0) {
                const empty = document.createElement('div');
                empty.className = 'card';
                empty.innerHTML = 
                    '<img class="thumb" src="' + PLACEHOLDER + '" alt="랜드마크 없음">' +
                    '<div>' +
                        '<h3 class="card-title">' + countryName + '</h3>' +
                        '<p class="card-desc">등록된 랜드마크가 없습니다.</p>' +
                        '<div class="card-meta">0 places</div>' +
                    '</div>';
                root.appendChild(empty);
                return;
            }

            items.forEach(item => {
                const a = document.createElement('a');
                a.className = 'card';
                
                const linkName = encodeURIComponent(getData(item, 'LANDMARK_NAME_EN') || getData(item, 'LANDMARK_NAME'));
                const linkId = encodeURIComponent(getData(item, 'LANDMARK_ID'));
                a.href = CTX + '/landmarkInfo.jsp?name=' + linkName + '&id=' + linkId;
                
                const imgSrc = imageLookup.get(getData(item, 'LANDMARK_ID')) || PLACEHOLDER;
                const landmarkName = getData(item, 'LANDMARK_NAME');
                const landmarkDesc = getData(item, 'LANDMARK_DESC');
                
                a.innerHTML = 
                    '<img class="thumb" src="' + imgSrc + '" alt="' + landmarkName + '" loading="lazy" referrerpolicy="no-referrer" onerror="this.onerror=null; this.src=\'' + PLACEHOLDER + '\'">' +
                    '<div>' +
                        '<h3 class="card-title">' + landmarkName + '</h3>' +
                        '<p class="card-desc">' + landmarkDesc + '</p>' +
                        '<div class="card-meta">' + countryName + '</div>' +
                    '</div>';
                root.appendChild(a);
            });
        }

        document.addEventListener('DOMContentLoaded', async () => {
            const listRoot = document.getElementById('cardList');

            map = L.map('map', { worldCopyJump:false }).setView([20,0], 2);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                attribution:'&copy; OpenStreetMap', noWrap:true
            }).addTo(map);
            const resizeMap = () => map.invalidateSize();
            window.addEventListener('load', resizeMap);
            window.addEventListener('resize', resizeMap);

            try {
                const [landmarks, world, imgMap] = await Promise.all([
                    fetch(GET_ALL_URL).then(r => r.ok ? r.json() : Promise.reject('랜드마크 목록 로드 실패')),
                    fetch(GEOJSON_URL).then(r => r.ok ? r.json() : Promise.reject('GeoJSON 로드 실패')),
                    buildMainImageLookup()
                ]);
                imageLookup = imgMap;

                const groupedByCountry = {};
                const countryCounts = {};
                const features = world.features;

                landmarks.forEach(it => {
                    const lat = Number(getData(it, 'LATITUDE'));
                    const lng = Number(getData(it, 'LONGITUDE'));
                    if (!isFinite(lat) || !isFinite(lng)) return;
                    const point = turf.point([lng, lat]);
                    for (const f of features) {
                        const name = (f.properties.name || f.properties.ADMIN);
                        if (name && turf.booleanPointInPolygon(point, f)) {
                            (groupedByCountry[name] ||= []).push(it);
                            countryCounts[name] = (countryCounts[name] || 0) + 1;
                            break;
                        }
                    }
                });

                const clickableCountries = new Set(Object.keys(groupedByCountry));

                L.geoJSON(world, {
                    style: f => {
                        const name = (f.properties.name || f.properties.ADMIN);
                        return clickableCountries.has(name)
                            ? { color: '#ff2d20', weight: 1.6, fillColor: '#9fbfff', fillOpacity: 0.18 }
                            : { color: '#9aa3aa', weight: 0.9, fillOpacity: 0.02 };
                    },
                    onEachFeature: (f, layer) => {
                        const name = (f.properties.name || f.properties.ADMIN);
                        const count = countryCounts[name] || 0;
                        layer.on('mouseover', () => {
                            layer.bindTooltip(name + ' • ' + count + ' place' + (count > 1 ? 's' : ''), { sticky: true }).openTooltip();
                            layer.setStyle({ weight: 2.2 });
                        });
                        layer.on('mouseout', () => {
                            layer.closeTooltip();
                            layer.setStyle(clickableCountries.has(name) ? { weight: 1.6 } : { weight: 0.9 });
                        });

                        if (clickableCountries.has(name)) {
                            layer.on('click', () => {
                                map.fitBounds(layer.getBounds(), { padding: [20, 20] });
                                const items = groupedByCountry[name] || [];
                                renderCards(listRoot, name, items);
                                showMarkers(items);
                            });
                        }
                    }
                }).addTo(map);
                addLegend();
            } catch (err) {
                console.error("데이터 로딩 중 오류 발생:", err);
                listRoot.innerHTML = 
                    '<div class="card">' +
                        '<img class="thumb" src="' + PLACEHOLDER + '" alt="네트워크 오류">' +
                        '<div>' +
                            '<h3 class="card-title">오류</h3>' +
                            '<p class="card-desc">데이터나 지도 리소스를 불러오지 못했습니다. 서버/CORS를 확인해 주세요.</p>' +
                            '<div class="card-meta">network error</div>' +
                        '</div>' +
                    '</div>';
            }
        });
    </script>
</body>
</html>