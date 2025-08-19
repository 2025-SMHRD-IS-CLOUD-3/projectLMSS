<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Optional" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="com.google.gson.Gson" %>
<%
    // 서블릿에서 전달받은 데이터
    Map<String, Object> landmarkData = (Map<String, Object>) request.getAttribute("landmarkData");
    List<Map<String, Object>> imageDataList = (List<Map<String, Object>>) request.getAttribute("imageDataList");
    List<Map<String, Object>> hotspotDataList = (List<Map<String, Object>>) request.getAttribute("hotspotDataList");
    List<String> userFavList = (List<String>) request.getAttribute("userFavList");

    // JSP에서 직접 사용할 데이터 준비
    String landmarkName = Optional.ofNullable(landmarkData).map(d -> (String) d.get("LANDMARK_NAME")).orElse("알 수 없는 랜드마크");
    String landmarkLocation = Optional.ofNullable(landmarkData).map(d -> (String) d.get("LOCATION")).orElse("위치 정보 없음");
    String landmarkDesc = Optional.ofNullable(landmarkData).map(d -> (String) d.get("DESCRIPTION")).orElse("설명 정보 없음");
    String completionTime = Optional.ofNullable(landmarkData).map(d -> (String) d.get("COMPLETION_TIME")).orElse("정보 없음");
    String archStyle = Optional.ofNullable(landmarkData).map(d -> (String) d.get("ARCHITECTURAL_STYLE")).orElse("정보 없음");
    String architect = Optional.ofNullable(landmarkData).map(d -> (String) d.get("ARCHITECT")).orElse("정보 없음");
    String history = Optional.ofNullable(landmarkData).map(d -> (String) d.get("HISTORY")).orElse("정보 없음");
    String tmi = Optional.ofNullable(landmarkData).map(d -> (String) d.get("TMI")).orElse("정보 없음");
    String website = Optional.ofNullable(landmarkData).map(d -> (String) d.get("WEBSITE")).orElse("#");
    String hours = Optional.ofNullable(landmarkData).map(d -> (String) d.get("HOURS")).orElse("정보 없음");
    String usage = Optional.ofNullable(landmarkData).map(d -> (String) d.get("USAGE")).orElse("정보 없음");
    String fee = Optional.ofNullable(landmarkData).map(d -> (String) d.get("FEE")).orElse("정보 없음");
    String trafficInfo = Optional.ofNullable(landmarkData).map(d -> (String) d.get("TRAFFIC_INFO")).orElse("정보 없음");
    String tags = Optional.ofNullable(landmarkData).map(d -> (String) d.get("TAGS")).orElse("정보 없음");
    String landmarkNameEn = Optional.ofNullable(landmarkData).map(d -> (String) d.get("LANDMARK_NAME_EN")).orElse("Unknown Landmark");
    boolean isFavorite = Optional.ofNullable(userFavList).orElse(java.util.Collections.emptyList()).contains(landmarkName);

    // JavaScript에 전달할 JSON 데이터 준비
    Gson gson = new Gson();
    String allHotspotsJson = Optional.ofNullable(hotspotDataList).map(gson::toJson).orElse("[]");
    String imageUrlsJson = Optional.ofNullable(imageDataList)
        .orElse(java.util.Collections.emptyList())
        .stream()
        .map(img -> (String) img.get("IMAGE_URL"))
        .collect(Collectors.collectingAndThen(Collectors.toList(), gson::toJson));

    // JavaScript 변수에 직접 할당될 데이터들
    Double landmarkLat = Optional.ofNullable(landmarkData).map(d -> (Double) d.get("LATITUDE")).orElse(37.5665);
    Double landmarkLong = Optional.ofNullable(landmarkData).map(d -> (Double) d.get("LONGITUDE")).orElse(126.9780);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="referrer" content="no-referrer">
    <title>Landmark Info</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>
    <style>
        /* CSS 스타일은 변경 없이 그대로 유지 */
        :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08); }
        *{box-sizing:border-box}
        body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}
        header{position:fixed;top:0;left:0;width:100%;height:86px;background:#fff;display:flex;align-items:center;justify-content:space-between;padding:0 20px;z-index:1000;box-shadow:0 1px 0 rgba(0,0,0,.06)}
        header h1{margin:0;font-size:18px;font-weight:900}
        .menu-btn{width:44px;height:44px;border:none;background:transparent;cursor:pointer;font-size:28px;line-height:44px}
        .side{position:fixed;top:0;right:-320px;width:320px;height:100%;background:var(--brand);color:#fff;padding:100px 20px 20px;transition:right .25s ease;z-index:1100}
        .side.open{right:0}
        .side a{color:#fff;text-decoration:none;font-weight:700;display:block;margin:14px 0}
        .board{max-width:1100px;margin:120px auto 48px;background:var(--muted);border-radius:28px;padding:22px}
        .card{background:var(--soft);border:1px solid var(--line);border-radius:22px;padding:22px}
        .title-row{position:relative;display:flex;align-items:center;justify-content:center;gap:12px;margin-bottom:10px}
        .title{margin:0;font-size:22px;font-weight:900}
        .fav{position:absolute;right:6px;top:-4px;border:none;background:transparent;cursor:pointer}
        .fav svg{width:28px;height:28px;fill:#ffd24d;stroke:#caa400}
        .fav[aria-pressed="false"] svg{fill:#fff;stroke:#caa400}
        .hero{width:100%;max-height:520px;object-fit:cover;border-radius:10px;border:1px solid var(--line)}
        .info-grid{display:grid;grid-template-columns:1.2fr 1fr;gap:20px;margin-top:16px}
        .spec{border:1px solid var(--line);border-radius:12px;padding:14px;background:#fff}
        .spec dl{margin:0;display:grid;grid-template-columns:110px 1fr;gap:10px}
        .spec dt{color:#666}
        .spec dd{margin:0}
        .note{border:1px solid var(--line);border-radius:12px;padding:14px;background:#fff;box-shadow:0 10px 20px rgba(0,0,0,.06)}
        .note h3{margin:0 0 8px;font-size:16px}
        .note .line{border-top:1px dashed #d7d7da;margin:10px 0}
        #map{width:100%;height:420px;border:1px solid var(--line);border-radius:10px}
        .warn{color:#c00;font-weight:800;margin:10px 0}
        .gallery{margin:12px 0 8px}
        .thumbs-wrap{display:grid;grid-template-columns:40px 1fr 40px;align-items:center;gap:8px;margin-top:12px}
        .thumb-nav{height:90px;border:1px solid #e6e6e8;background:#fff;border-radius:8px;font-size:28px;line-height:1;cursor:pointer;box-shadow:0 2px 6px rgba(0,0,0,.05)}
        .thumb-nav:disabled{opacity:.4;cursor:not-allowed}
        .thumb-viewport{overflow:hidden;height:96px;padding:8px}
        .thumb-track{display:flex;gap:10px;align-items:center;transition:transform .28s ease;will-change:transform}
        .thumb-btn{border:1px solid #e6e6e8;border-radius:8px;padding:0;background:#fff;width:140px;height:80px;cursor:pointer;overflow:hidden;box-shadow:0 1px 4px rgba(0,0,0,.04); flex-shrink: 0;}
        .thumb-btn img{width:100%;height:100%;object-fit:cover;display:block}
        .thumb-btn[aria-current="true"]{outline:3px solid #57ACCB}
        .hint{font-size:12px;color:#777;margin:8px 0 0}
        @media (max-width:980px){.info-grid{grid-template-columns:1fr}}
        
        /* 지도 탭 스타일 */
        .map-tabs {
            margin: 20px 0;
        }
        
        .tab-buttons {
            display: flex;
            gap: 8px;
            margin-bottom: 12px;
        }
        
        .tab-btn {
            padding: 10px 20px;
            border: 2px solid var(--line);
            background: #fff;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            color: #666;
        }
        
        .tab-btn:hover {
            border-color: var(--brand);
            color: var(--brand);
        }
        
        .tab-btn.active {
            background: var(--brand);
            border-color: var(--brand);
            color: #fff;
        }
    </style>
</head>
<body>
    <header>
        <h1>Landmark Search</h1>
        <button class="menu-btn" aria-label="메뉴">≡</button>
    </header>

    <aside id="side" class="side" aria-hidden="true">
        <a href="./main.html">사진으로 찾기</a>
        <a href="./mapSearch.html">지도로 찾기</a>
        <a href="./howLandmark.html">Landmark Search란?</a>
        <a href="./postList.html">게시판</a>
        <a href="./login.jsp">로그인</a>
    </aside>

    <main class="board">
        <section class="card">
            <div class="title-row">
                <h2 id="title" class="title"><%= landmarkName %></h2>
                <button id="fav" class="fav" aria-pressed="<%= isFavorite %>" title="즐겨찾기">
                    <svg viewBox="0 0 24 24"><path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                </button>
            </div>

            <div class="gallery">
                <%-- JSP 스크립트릿으로 이미지 URL을 가져와서 JavaScript에서 사용하도록 변경 --%>
                <%-- 이미지 URL 목록을 JavaScript 변수로 전달하는 것이 더 효율적 --%>
                <img id="hero" class="hero" src="" alt="대표 이미지">
                <div class="thumbs-wrap">
                    <button id="thumbPrev" class="thumb-nav" aria-label="이전 이미지">&lsaquo;</button>
                    <div id="thumbViewport" class="thumb-viewport">
                        <div id="thumbTrack" class="thumb-track">
                            <%-- 갤러리 썸네일은 JavaScript에서 동적으로 생성 --%>
                        </div>
                    </div>
                    <button id="thumbNext" class="thumb-nav" aria-label="다음 이미지">&rsaquo;</button>
                </div>
                <p class="hint">썸네일을 클릭하면 큰 이미지가 바뀝니다.</p>
            </div>

            <div class="info-grid">
                <section class="spec">
                    <dl>
                        <dt>랜드마크</dt> <dd id="spec-name"><%= landmarkName %></dd>
                        <dt>위치</dt> <dd id="spec-location"><%= landmarkLocation %></dd>
                        <dt>건립 목적</dt> <dd id="spec-desc"><%= landmarkDesc %></dd>
                        <dt>완공시기</dt> <dd id="spec-complete"><%= completionTime %></dd>
                        <dt>건축양식</dt> <dd id="spec-style"><%= archStyle %></dd>
                        <dt>건축가</dt> <dd id="spec-architect"><%= architect %></dd>
                        <dt>역사</dt> <dd id="spec-history"><%= history %></dd>
                        <dt>TMI</dt> <dd id="spec-tmi"><%= tmi %></dd>
                    </dl>
                </section>

                <aside class="note">
                    <h3>방문 정보</h3>
                    <div class="line"></div>
                    <div><b>공식 웹사이트</b><br><span id="info-website"><a href="<%= website %>" target="_blank"><%= website %></a></span></div>
                    <div class="line"></div>
                    <div><b>영업시간</b><br><span id="info-hours"><%= hours %></span></div>
                    <div class="line"></div>
                    <div><b>용도</b><br><span id="info-usage"><%= usage %></span></div>
                    <div class="line"></div>
                    <div><b>이용요금</b><br><span id="info-fee"><%= fee %></span></div>
                    <div class="line"></div>
                    <div><b>교통정보</b><br><span id="info-traffic"><%= trafficInfo %></span></div>
                    <div class="line"></div>
                    <div><b>태그</b><br><span id="info-tags"><%= tags %></span></div>
                </aside>
            </div>

            <div class="map-tabs">
                <div class="tab-buttons">
                    <button class="tab-btn active" data-type="PHOTOSPOT">포토 스팟</button>
                    <button class="tab-btn" data-type="FOOD">주변 맛집</button>
                    <button class="tab-btn" data-type="PLACE">주변 명소</button>
                </div>
                <div id="map"></div>
            </div>
            
            <% if (landmarkData == null) { %>
            <p id="warn" class="warn">
                현재 랜드마크 데이터가 없습니다. 디자인 미리보기용 **더미데이터**가 표시되고 있습니다.
            </p>
            <% } %>
        </section>
    </main>

    <script>
        /* ===========================================================
        * 1. 전역 변수 및 설정
        * =========================================================== */
        const $ = (sel) => document.querySelector(sel);
        const qs = new URLSearchParams(location.search);
        
        const allHotspots = <%= allHotspotsJson %>;
        const imageUrls = <%= imageUrlsJson %>;
        const landmarkLat = <%= landmarkLat %>;
        const landmarkLong = <%= landmarkLong %>;

        let currentTabType = 'PHOTOSPOT';
        let currentHotspotMarkers = [];
        
        /* ===========================================================
        * 2. 페이지 초기화 로직
        * =========================================================== */
        document.addEventListener('DOMContentLoaded', async () => {
            initializeSideMenu();
            initMap();
            initializeTabEvents();
            initializeGallery();
        });

        /* ===========================================================
        * 3. 갤러리 및 지도 기능
        * =========================================================== */
        let currentSlide = 0;
        let isMoving = false;
        const THUMB_WIDTH = 140 + 10;
        const VISIBLE_THUMBS = 5;

        function initializeGallery() {
            const trackEl = $('#thumbTrack');
            if (!trackEl || imageUrls.length === 0) {
                $('#hero').src = "https://placehold.co/1200x700?text=No+Image";
                updateNavButtons(0);
                return;
            }

            $('#hero').src = imageUrls[0];

            imageUrls.forEach(url => {
                const thumbBtn = document.createElement('button');
                thumbBtn.className = 'thumb-btn';
                thumbBtn.type = 'button';
                thumbBtn.onclick = () => $('#hero').src = url;
                thumbBtn.innerHTML = `<img src="${url}" alt="썸네일">`;
                trackEl.appendChild(thumbBtn);
            });

            const subImagesCount = imageUrls.length;
            if (subImagesCount > VISIBLE_THUMBS) {
                const clonesStart = imageUrls.slice(-VISIBLE_THUMBS).map(url => createThumbBtn(url));
                const clonesEnd = imageUrls.slice(0, VISIBLE_THUMBS).map(url => createThumbBtn(url));
                
                clonesStart.reverse().forEach(node => trackEl.prepend(node));
                clonesEnd.forEach(node => trackEl.append(node));
                
                currentSlide = VISIBLE_THUMBS;
                trackEl.style.transition = 'none';
                trackEl.style.transform = `translateX(-${currentSlide * THUMB_WIDTH}px)`;
                trackEl.addEventListener('transitionend', handleTransitionEnd);
            }
            $('#thumbPrev').onclick = () => moveThumbs(-1, subImagesCount);
            $('#thumbNext').onclick = () => moveThumbs(1, subImagesCount);
            updateNavButtons(subImagesCount);
        }

        function createThumbBtn(url) {
            const btn = document.createElement('button');
            btn.className = 'thumb-btn';
            btn.type = 'button';
            btn.onclick = () => $('#hero').src = url;
            btn.innerHTML = `<img src="${url}" alt="썸네일">`;
            return btn;
        }

        function moveThumbs(direction, totalSubImages) {
            if (isMoving || totalSubImages <= VISIBLE_THUMBS) return;
            isMoving = true;
            
            currentSlide += direction;
            const trackEl = $('#thumbTrack');
            trackEl.style.transition = 'transform .3s ease-in-out';
            trackEl.style.transform = `translateX(-${currentSlide * THUMB_WIDTH}px)`;
        }

        function handleTransitionEnd() {
            const trackEl = $('#thumbTrack');
            if (!trackEl) return;
            const totalSubImages = imageUrls.length;
            if (currentSlide >= totalSubImages + VISIBLE_THUMBS) {
                trackEl.style.transition = 'none';
                currentSlide = VISIBLE_THUMBS;
                trackEl.style.transform = `translateX(-${currentSlide * THUMB_WIDTH}px)`;
            }
            if (currentSlide < VISIBLE_THUMBS) {
                trackEl.style.transition = 'none';
                currentSlide = totalSubImages + VISIBLE_THUMBS - 1;
                trackEl.style.transform = `translateX(-${currentSlide * THUMB_WIDTH}px)`;
            }
            isMoving = false;
        }
        
        function updateNavButtons(totalSubImages) {
            const shouldDisable = totalSubImages <= VISIBLE_THUMBS;
            $('#thumbPrev').disabled = shouldDisable;
            $('#thumbNext').disabled = shouldDisable;
        }

        /* ===========================================================
        * 4. 기타 유틸리티 및 부가 기능
        * =========================================================== */
        function initializeSideMenu() {
            const side = $('#side');
            const menuBtn = $('.menu-btn');
            menuBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                side.classList.toggle('open');
            });
            document.addEventListener('click', (e) => {
                if (!side.contains(e.target) && !menuBtn.contains(e.target)) {
                    side.classList.remove('open');
                }
            });
        }
        
        let map, marker;
        function initMap() {
            const lat = landmarkLat;
            const lng = landmarkLong;
            
            if (!map) {
                map = L.map('map').setView([lat, lng], 15);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; OpenStreetMap contributors'
                }).addTo(map);
            } else {
                map.setView([lat, lng], 15);
            }
            if (marker) map.removeLayer(marker);
            marker = L.marker([lat, lng]).addTo(map).bindPopup($('#title').textContent).openPopup();
            setTimeout(() => map.invalidateSize(), 50);
            
            updateHotspotsOnMap();
        }
        
        /* ===========================================================
        * 5. 탭 기능 및 핫스팟 표시
        * =========================================================== */
        function initializeTabEvents() {
            const tabBtns = document.querySelectorAll('.tab-btn');
            
            tabBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    tabBtns.forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');
                    currentTabType = btn.dataset.type;
                    updateHotspotsOnMap();
                });
            });
        }
        
        function updateHotspotsOnMap() {
            currentHotspotMarkers.forEach(marker => {
                if (map && marker) {
                    map.removeLayer(marker);
                }
            });
            currentHotspotMarkers = [];
            
            const filteredHotspots = allHotspots.filter(hotspot => {
                const hotspotType = hotspot.hotspot_type || hotspot.HOTSPOT_TYPE;
                return hotspotType === currentTabType;
            });
            
            filteredHotspots.forEach(hotspot => {
                const get = (key) => hotspot[key] || hotspot[key.toLowerCase()] || hotspot[key.toUpperCase()] || 0;
                const lat = Number(get('hotspot_lati'));
                const lng = Number(get('hotspot_long'));
                const name = get('hotspot_name') || '알 수 없는 장소';
                const info = get('hotspot_info') || '';
                
                if (lat && lng && map) {
                    let iconColor = '#57ACCB';
                    if (currentTabType === 'FOOD') iconColor = '#FF6B6B';
                    else if (currentTabType === 'PHOTOSPOT') iconColor = '#4ECDC4';
                    else if (currentTabType === 'PLACE') iconColor = '#45B7D1';
                    
                    const hotspotIcon = L.divIcon({
                        className: 'hotspot-marker',
                        html: `<div style="background-color: ${iconColor}; width: 12px; height: 12px; border-radius: 50%; border: 2px solid white; box-shadow: 0 2px 4px rgba(0,0,0,0.3);"></div>`,
                        iconSize: [12, 12],
                        iconAnchor: [6, 6]
                    });
                    
                    const marker = L.marker([lat, lng], { icon: hotspotIcon })
                        .addTo(map)
                        .bindPopup(`
                            <div style="min-width: 200px;">
                                <h4 style="margin: 0 0 8px; color: ${iconColor};">${name}</h4>
                                ${info ? `<p style="margin: 0; font-size: 14px; color: #666;">${info}</p>` : ''}
                            </div>
                        `);
                    
                    currentHotspotMarkers.push(marker);
                }
            });
        }
        
        $('#fav').addEventListener('click', (e) => {
            const pressed = e.currentTarget.getAttribute('aria-pressed') === 'true';
            e.currentTarget.setAttribute('aria-pressed', String(!pressed));
            // TODO: AJAX를 이용하여 서버에 즐겨찾기 상태 변경 요청을 보내는 로직을 추가해야 합니다.
            if (!pressed) {
                console.log('즐겨찾기에 추가합니다.');
            } else {
                console.log('즐겨찾기에서 제거합니다.');
            }
        });
        
    </script>
</body>
</html>