<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 현재 로그인 상태 확인
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
        :root { --ink:#111; --muted:#f4f4f4; --line:#e5e5e5; --brand:#57ACCB; }
        * { box-sizing:border-box; }
        body { margin:0; font-family:system-ui,-apple-system, Segoe UI, Roboto, Arial, sans-serif; color:var(--ink); background:#fff; }

        header {
            position:fixed; top:0; left:0; width:100%; height:100px; background:#fff;
            display:flex; justify-content:space-between; align-items:center; padding:0 20px;
            z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04);
        }
        header h2 { margin:0; font-size:18px; font-weight:bold; }
        .menu-btn { position:fixed; top:20px; right:20px; font-size:50px; background:none; border:none; color:#000; cursor:pointer; z-index:1001; }
        .side-menu { position:fixed; top:0; right:-500px; width:500px; height:100%; background:var(--brand); color:#fff; padding:20px; padding-top:100px; transition:right .3s ease; z-index:1002; font-size:30px; }
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

        .leaflet-container .leaflet-interactive:focus { outline: none; }
        .leaflet-container .leaflet-interactive:focus-visible { outline: none; }

        .legend{ position:absolute; right:28px; bottom:28px; background:#fff; border:1px solid var(--line);
            border-radius:10px; padding:8px 10px; font-size:12px; box-shadow:0 6px 18px rgba(0,0,0,.06); }
        .key{ display:flex; align-items:center; gap:8px; margin:4px 0; }
        .sw{ width:14px; height:10px; border:2px solid #ff2d20; background:#9fbfff33; }
        .sw.off{ border-color:#9aa3aa; background:transparent; }

        @media (max-width:960px){ #map { height:420px; } .card { grid-template-columns:100px 1fr; } .thumb { width:100px; height:76px; } }
    </style>
</head>
<body>
    <header>
        <h2>Landmark Search</h2>
        <button class="menu-btn" aria-label="메뉴 열기">≡</button>
    </header>
    <aside class="side-menu" id="sideMenu" aria-hidden="true">
        <ul>
            <li><a href="${pageContext.request.contextPath}/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="${pageContext.request.contextPath}/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="${pageContext.request.contextPath}/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="${pageContext.request.contextPath}/postList">게시판</a></li>
            <% if (loginUser != null) { %>
                <li><a href="<%=request.getContextPath()%>/logout?redirect=<%=request.getRequestURI()%>">로그아웃</a></li>
                <li><a href="<%=request.getContextPath()%>/myProfile">마이페이지</a></li>
            <% } else { %>
                <li><a href="${pageContext.request.contextPath}/login.jsp">로그인</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp">회원가입</a></li>
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

    <script>
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

    const CTX = '<%=request.getContextPath()%>';
    const GET_ALL_URL = CTX + '/getLandmarks';
    const GET_IMG_URL = CTX + '/getImage';
    const GEOJSON_URL = 'https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json';
    const PLACEHOLDER = 'https://placehold.co/1200x700?text=No+Image';

    let map, markersLayer;
    let imageLookup = new Map();
    let landmarkCache = new Map();

    const getData = (item, key) => item[key.toLowerCase()] || item[key.toUpperCase()] || '';

    // --- 💡 수정 및 추가된 이미지 처리 함수 ---

    /**
     * @brief 이미지 URL이 실제로 유효한지 브라우저에서 확인합니다.
     * @param {string} url - 확인할 이미지 URL
     * @returns {Promise<boolean>} 이미지가 존재하면 true를 반환하는 Promise
     */
    function checkImageExists(url) {
        return new Promise(resolve => {
            const img = new Image();
            img.onload = () => resolve(true);
            img.onerror = () => resolve(false);
            img.src = url;
        });
    }
    
    /**
     * @brief 'imgur.com/ID' 형태의 URL을 직접 이미지 링크('i.imgur.com/ID.jpg')로 변환합니다.
     * @param {string} url - 변환할 URL
     * @returns {string} 변환된 URL 또는 원본 URL
     */
    function convertImgurUrl(url) {
        if (typeof url !== 'string') return '';
        const imgurPattern = /https?:\/\/imgur\.com\/([a-zA-Z0-9]+)/;
        const match = url.match(imgurPattern);
        // 기본 확장자로 .jpg를 가정하고, 이후에 실제 확장자를 검증합니다.
        if (match) return `https://i.imgur.com/${match[1]}.jpg`;
        return url;
    }

    /**
     * @brief Imgur URL의 경우 .jpg, .png 등 올바른 확장자를 찾아내고,
     * 최종적으로 유효한 이미지 URL을 반환하거나 실패 시 플레이스홀더를 반환합니다.
     * @param {string} originalUrl - DB에서 가져온 원본 URL
     * @returns {Promise<string>} 유효한 이미지 URL 또는 플레이스홀더 URL
     */
    async function getValidImageUrl(originalUrl) {
        if (!originalUrl) return PLACEHOLDER;

        const convertedUrl = convertImgurUrl(originalUrl);

        // i.imgur.com URL인지 확인하여 확장자를 테스트합니다.
        const imgurDirectPattern = /https?:\/\/i\.imgur\.com\/([a-zA-Z0-9]+)\./;
        const match = convertedUrl.match(imgurDirectPattern);

        if (match) {
            const imageId = match[1];
            const extensions = ['jpg', 'png', 'gif', 'jpeg'];
            for (const ext of extensions) {
                const testUrl = `https://i.imgur.com/${imageId}.${ext}`;
                if (await checkImageExists(testUrl)) {
                    return testUrl; // 유효한 URL 발견
                }
            }
        }
        
        // Imgur가 아니거나 위에서 확장자를 못 찾은 경우, 변환된 URL 자체를 확인합니다.
        if (await checkImageExists(convertedUrl)) {
            return convertedUrl;
        }
        
        return PLACEHOLDER; // 모든 시도 실패 시 플레이스홀더 반환
    }

    /**
     * @brief 서버에서 받은 이미지 목록 데이터로부터 'main' 타입 이미지에 대한
     * 유효한 URL 룩업 테이블(Map)을 비동기적으로 생성합니다.
     */
    async function buildMainImageLookup(rows) {
        const lookup = new Map();
        if (!Array.isArray(rows) || rows.length === 0) return lookup;

        const promises = [];
        const processedLids = new Set(); // 중복 처리 방지용

        for (const img of rows) {
            if (!img || typeof img !== 'object') continue;

            const type = getData(img, 'IMAGE_TYPE')?.toLowerCase();
            const lid = getData(img, 'LANDMARK_ID');
            const url = getData(img, 'IMAGE_URL');

            if (type === 'main' && lid != null && url && !processedLids.has(lid)) {
                processedLids.add(lid);
                
                const promise = getValidImageUrl(url).then(validUrl => {
                    lookup.set(lid, validUrl);
                });
                promises.push(promise);
            }
        }

        await Promise.all(promises);
        return lookup;
    }

    // --- 이미지 처리 함수 끝 ---

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
        div.innerHTML = `<div class="key"><span class="sw"></span>클릭 가능 (랜드마크 있음)</div><div class="key"><span class="sw off"></span>클릭 불가 (없음)</div>`;
        document.body.appendChild(div);
    }
    
    function renderCards(root, countryName, items) {
        root.innerHTML = '';

        if (!items || items.length === 0) {
            const empty = document.createElement('div');
            empty.className = 'card';
            empty.innerHTML = `
                <img class="thumb" src="${PLACEHOLDER}" alt="랜드마크 없음">
                <div>
                    <h3 class="card-title">${countryName}</h3>
                    <p class="card-desc">등록된 랜드마크가 없습니다.</p>
                    <div class="card-meta">0 places</div>
                </div>`;
            root.appendChild(empty);
            return;
        }

        items.forEach(item => {
            const a = document.createElement('a');
            a.className = 'card';
            
            const landmarkId = getData(item, 'LANDMARK_ID');
            a.href = `${CTX}/AI_Landmark_Service/landmarkInfo.jsp?landmark_id=${landmarkId}`;

            const imgSrc = imageLookup.get(landmarkId) || PLACEHOLDER;
            const landmarkName = getData(item, 'LANDMARK_NAME');
            const landmarkDesc = getData(item, 'LANDMARK_DESC');
            
            a.innerHTML = `
                <img class="thumb"
                     src="${imgSrc}"
                     alt="${landmarkName}"
                     loading="lazy"
                     referrerpolicy="no-referrer"
                     onerror="this.onerror=null; this.src='${PLACEHOLDER}'" />
                <div>
                    <h3 class="card-title">${landmarkName}</h3>
                    <p class="card-desc">${landmarkDesc}</p>
                    <div class="card-meta">${countryName}</div>
                </div>`;
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
            const [world, allLandmarks] = await Promise.all([
                fetch(GEOJSON_URL).then(r => {
                    if (!r.ok) throw new Error('GeoJSON 로드 실패');
                    return r.json();
                }),
                fetch(GET_ALL_URL).then(r => {
                    if (!r.ok) throw new Error('랜드마크 목록 로드 실패');
                    return r.json();
                })
            ]);

            const countryCounts = {};
            allLandmarks.forEach(it => {
                const lat = Number(getData(it, 'LATITUDE'));
                const lng = Number(getData(it, 'LONGITUDE'));
                if (!isFinite(lat) || !isFinite(lng)) return;

                const point = turf.point([lng, lat]);
                for (const f of world.features) {
                    const name = (f.properties.name || f.properties.ADMIN);
                    if (name && turf.booleanPointInPolygon(point, f)) {
                        countryCounts[name] = (countryCounts[name] || 0) + 1;
                        break;
                    }
                }
            });
            
            const clickableCountries = new Set(Object.keys(countryCounts));

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
                        layer.bindTooltip(`${name} • ${count} place${count > 1 ? 's' : ''}`, { sticky: true }).openTooltip();
                        layer.setStyle({ weight: 2.2 });
                    });
                    layer.on('mouseout', () => {
                        layer.closeTooltip();
                        layer.setStyle(clickableCountries.has(name) ? { weight: 1.6 } : { weight: 0.9 });
                    });

                    if (clickableCountries.has(name)) {
                        layer.on('click', async () => {
                            map.fitBounds(layer.getBounds(), { padding: [20, 20] });
                            
                            if (landmarkCache.has(name)) {
                                const { items, imgMap } = landmarkCache.get(name);
                                imageLookup = imgMap;
                                renderCards(listRoot, name, items);
                                showMarkers(items);
                                return;
                            }

                            try {
                                const [landmarks, images] = await Promise.all([
                                    fetch(GET_ALL_URL).then(r => r.json()),
                                    fetch(GET_IMG_URL).then(r => r.json())
                                ]);

                                const imgMap = await buildMainImageLookup(images);
                                const items = [];
                                
                                landmarks.forEach(it => {
                                    const lat = Number(getData(it, 'LATITUDE'));
                                    const lng = Number(getData(it, 'LONGITUDE'));
                                    if (!isFinite(lat) || !isFinite(lng)) return;
                                    
                                    const point = turf.point([lng, lat]);
                                    if (turf.booleanPointInPolygon(point, f)) {
                                        items.push(it);
                                    }
                                });

                                landmarkCache.set(name, { items, imgMap });
                                imageLookup = imgMap;
                                
                                renderCards(listRoot, name, items);
                                showMarkers(items);

                            } catch (err) {
                                console.error("⛔️ 랜드마크 데이터 로딩 중 오류 발생:", err);
                                listRoot.innerHTML = `<div class="card"><p class="card-desc">랜드마크 데이터를 불러오지 못했습니다.</p></div>`;
                            }
                        });
                    }
                }
            }).addTo(map);

            addLegend();

        } catch (err) {
            console.error("⛔️ 초기 데이터 로딩 중 치명적인 오류 발생:", err);
            listRoot.innerHTML = `
                <div class="card">
                    <img class="thumb" src="${PLACEHOLDER}" alt="네트워크 오류">
                    <div>
                        <h3 class="card-title">오류</h3>
                        <p class="card-desc">지도나 국가 데이터를 불러오지 못했습니다. 서버/CORS를 확인해 주세요.</p>
                        <div class="card-meta">network error</div>
                    </div>
                </div>`;
        }
    });
    </script>
</body>
</html>