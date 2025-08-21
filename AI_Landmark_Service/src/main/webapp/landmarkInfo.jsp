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
    <meta name="referrer" content="no-referrer">
    <title>Landmark Info</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css">
    <script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>
    <!-- 지도 마커 데이터 파일들 추가 -->
    <script src="<%=request.getContextPath()%>/mapmark/photospots.js" defer></script>
    <script src="<%=request.getContextPath()%>/mapmark/restaurants.js" defer></script>
    <script src="<%=request.getContextPath()%>/mapmark/attractions.js" defer></script>
    <style>
        :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08); }
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
        .side{ 
        	position: fixed; top: 0; right: -500px; width: 500px;
        	height: 100%; background-color: #57ACCB; color: white; 
        	padding: 20px; padding-top: 100px; box-sizing: border-box; 
        	transition: right 0.3s ease; font-size: 30px; z-index: 1001; }
        .side li { list-style-type: none; margin-top: 20px; }
        .side a { color: white; text-decoration: none; font-weight: bold; }
        .side.open { right: 0; }
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
        .map-tabs{margin:20px 0}
        .tab-buttons{display:flex;gap:8px;margin-bottom:12px}
        .tab-btn{padding:10px 20px;border:2px solid var(--line);background:#fff;border-radius:8px;cursor:pointer;font-weight:600;transition:all .2s ease;color:#666}
        .tab-btn:hover{border-color:var(--brand);color:var(--brand)}
        .tab-btn.active{background:var(--brand);border-color:var(--brand);color:#fff}
        .comments{margin-top:28px;background:#fff;border:1px solid var(--line);border-radius:12px;padding:16px}
        .comments h3{margin:0 0 12px;font-size:18px}
        .comment-form{display:flex;flex-direction:column;gap:10px;margin-bottom:14px}
        .comment-form textarea{width:100%;border:1px solid var(--line);border-radius:8px;padding:10px;font-family:inherit;resize:vertical}
        .comment-form button{align-self:flex-end;padding:8px 14px;border:none;border-radius:8px;background:var(--brand);color:#fff;cursor:pointer;font-weight:700}
        .comment-item{border-top:1px dashed #d7d7da;padding:10px 0}
        .comment-meta{font-size:12px;color:#777;margin-bottom:6px}
        .comment-text{white-space:pre-wrap;line-height:1.5}
        .login-required{text-align:center;padding:20px;color:#666;background:#f8f9fa;border-radius:8px;border:1px solid #e9ecef}
        .login-required a{color:var(--brand);text-decoration:none;font-weight:600}
        @media (max-width:980px){.info-grid{grid-template-columns:1fr}}
    </style>
</head>
<body>
    <header>
        <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
    </header>
        <button class="menu-btn" aria-label="메뉴">≡</button>

    <aside class="side" id="side">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>
            <% if (loginUser != null) { %>
                <li>
                    <a href="<%=request.getContextPath()%>/logout">로그아웃</a>
                </li>
                <li><a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
            <% } else { %>
                <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/join.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </aside>

    <main class="board">
        <section class="card">
            <div class="title-row">
                <h2 id="title" class="title">제목 자리</h2>
                <button id="fav" class="fav" aria-pressed="false" title="즐겨찾기">
                    <svg viewBox="0 0 24 24"><path d="M12 17.27 18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
                </button>
            </div>

            <div class="gallery">
                <img id="hero" class="hero" src="" alt="대표 이미지">
                <div class="thumbs-wrap">
                    <button id="thumbPrev" class="thumb-nav" aria-label="이전 이미지">&lsaquo;</button>
                    <div id="thumbViewport" class="thumb-viewport">
                        <div id="thumbTrack" class="thumb-track"></div>
                    </div>
                    <button id="thumbNext" class="thumb-nav" aria-label="다음 이미지">&rsaquo;</button>
                </div>
                <p class="hint">썸네일을 클릭하면 큰 이미지가 바뀝니다.</p>
            </div>

            <div class="info-grid">
                <section class="spec">
                    <dl>
                        <dt>랜드마크</dt> <dd id="spec-name"></dd>
                        <dt>위치</dt> <dd id="spec-location"></dd>
                        <dt>건립 목적</dt> <dd id="spec-desc"></dd>
                        <dt>완공시기</dt> <dd id="spec-complete"></dd>
                        <dt>건축양식</dt> <dd id="spec-style"></dd>
                        <dt>건축가</dt> <dd id="spec-architect"></dd>
                        <dt>역사</dt> <dd id="spec-history"></dd>
                        <dt>TMI</dt> <dd id="spec-tmi"></dd>
                    </dl>
                </section>

                <aside class="note">
                    <h3>방문 정보</h3>
                    <div class="line"></div>
                    <div><b>공식 웹사이트</b><br><span id="info-website"></span></div>
                    <div class="line"></div>
                    <div><b>영업시간</b><br><span id="info-hours"></span></div>
                    <div class="line"></div>
                    <div><b>용도</b><br><span id="info-usage"></span></div>
                    <div class="line"></div>
                    <div><b>이용요금</b><br><span id="info-fee"></span></div>
                    <div class="line"></div>
                    <div><b>교통정보</b><br><span id="info-traffic"></span></div>
                    <div class="line"></div>
                    <div><b>태그</b><br><span id="info-tags"></span></div>
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
            
            <div id="commentSection" class="comments">
			    <h3>댓글</h3>
			    
			    <%-- 세션에 로그인 정보가 있는지 확인 --%>
			    <% if (session.getAttribute("loginUser") != null) { %>
			        <!-- 로그인한 사용자: 댓글 작성 폼 표시 -->
			        <form id="commentForm" class="comment-form">
			            <input type="hidden" name="referenceId" id="referenceId">
			            <input type="hidden" name="replyType" value="landmark">
			            <textarea name="commentText" id="commentText" rows="3" placeholder="댓글을 입력하세요" required></textarea>
			            <button type="submit">댓글 작성</button>
			        </form>
			    <% } else { %>
			        <!-- 로그인하지 않은 사용자: 로그인 안내 -->
			        <div class="login-required">
			            <%-- 👇 [수정] 돌아올 주소에서 프로젝트 이름(ContextPath)을 제거합니다. --%>
			            <%
			                // 1. 현재 페이지의 경로만 가져옵니다. (예: /landmarkInfo.jsp)
			                String pagePath = request.getServletPath();
			                // 2. 현재 페이지의 쿼리 스트링을 가져옵니다. (예: name=Eiffel_Tower)
			                String queryString = request.getQueryString();
			                // 3. 두 정보를 합쳐서 최종 돌아올 주소를 만듭니다.
			                String redirectUrl = pagePath + (queryString != null ? "?" + queryString : "");
			            %>
			            댓글을 작성하려면 <a href="<%=request.getContextPath()%>/login.jsp?redirect=<%=redirectUrl%>">로그인</a>이 필요합니다.
			        </div>
			    <% } %>
			    
			    <div id="commentsList"></div>
			</div>
            
            <p id="warn" class="warn" hidden>
                현재 URL에 <code>?name=랜드마크이름</code> 이 없습니다. 
                디자인 미리보기용 <b>더미데이터</b>가 표시되고 있습니다.
            </p>
        </section>
    </main>

    <script>
        /* ===========================================================
         * 1. 전역 변수 및 설정
         * =========================================================== */
        const $ = (sel) => document.querySelector(sel);
        const qs = new URLSearchParams(location.search);
        const nameParam = qs.get('name');
        let landmarkId = null;

        const CONTEXT_PATH = "<%=request.getContextPath()%>";
        const API = {
            getAllLandmarks: () => CONTEXT_PATH + '/getLandmarks',
            getAllImages: () => CONTEXT_PATH + '/getImage',
            getHotspots: () => CONTEXT_PATH + '/getHotspots',
            getReplies: (id) => CONTEXT_PATH + '/getReply?landmarkId=' + encodeURIComponent(id),
            addReply: () => CONTEXT_PATH + '/addReply'
        };

        let allHotspots = [];
        let currentTabType = 'PHOTOSPOT';
        let currentHotspotMarkers = [];
        let map;
        let landmarkMarker; // 랜드마크 메인 마커

        /* ===========================================================
         * 2. 유틸리티 함수들
         * =========================================================== */
        function showMessage(message, type) {
            // 간단한 메시지 표시 (필요시 더 정교한 UI로 개선 가능)
            const messageDiv = document.createElement('div');
            let backgroundColor = '#4CAF50'; // 기본값
            if (type === 'error') {
                backgroundColor = '#f44336';
            }
            
            messageDiv.style.cssText = 
                'position: fixed; top: 20px; right: 20px; padding: 15px 20px; ' +
                'border-radius: 8px; color: white; font-weight: 600; z-index: 10000; ' +
                'background-color: ' + backgroundColor + '; ' +
                'box-shadow: 0 4px 12px rgba(0,0,0,0.15);';
            messageDiv.textContent = message;
            document.body.appendChild(messageDiv);
            
            setTimeout(() => {
                messageDiv.remove();
            }, 3000);
        }

        /* ===========================================================
         * 3. 페이지 초기화 로직
         * =========================================================== */
        document.addEventListener('DOMContentLoaded', async () => {
            initializeSideMenu();

            if (!nameParam) {
                $('#warn').hidden = false;
                return;
            }

            try {
                const allLandmarksRes = await fetch(API.getAllLandmarks());
                if (!allLandmarksRes.ok) throw new Error('랜드마크 목록 로딩 실패');
                const allLandmarks = await allLandmarksRes.json();

                console.log('검색할 랜드마크명:', nameParam);
                console.log('전체 랜드마크 개수:', allLandmarks.length);
                
                // 랜드마크 검색 로직 개선
                const targetLandmark = allLandmarks.find(lm => {
                    const enName = lm.landmark_name_en || lm.LANDMARK_NAME_EN || '';
                    const krName = lm.landmark_name || lm.LANDMARK_NAME || '';
                    
                    console.log('비교:', {
                        search: nameParam,
                        enName: enName,
                        krName: krName,
                        match: enName === nameParam || krName === nameParam
                    });
                    
                    return enName === nameParam || krName === nameParam;
                });
                
                if (!targetLandmark) {
                    console.log('사용 가능한 랜드마크들:', allLandmarks.map(lm => ({
                        id: lm.landmark_id || lm.LANDMARK_ID,
                        name: lm.landmark_name || lm.LANDMARK_NAME,
                        enName: lm.landmark_name_en || lm.LANDMARK_NAME_EN
                    })));
                    throw new Error("'" + nameParam + "' 랜드마크를 찾을 수 없음");
                }

                landmarkId = targetLandmark.landmark_id || targetLandmark.LANDMARK_ID;
                
                // referenceId 요소가 존재하는지 확인 후 값 설정
                const referenceIdElement = $('#referenceId');
                if (referenceIdElement) {
                    referenceIdElement.value = landmarkId;
                }

                const allImagesRes = await fetch(API.getAllImages());
                if (!allImagesRes.ok) throw new Error('이미지 목록 로딩 실패');
                const allImages = await allImagesRes.json();
                const filteredImages = allImages.filter(img => (img.landmark_id || img.LANDMARK_ID) == landmarkId);

                const allHotspotsRes = await fetch(API.getHotspots());
                if (!allHotspotsRes.ok) throw new Error('핫스팟 목록 로딩 실패');
                allHotspots = await allHotspotsRes.json();
                
                renderPage(targetLandmark, filteredImages);
                initMap(targetLandmark);
                initializeTabEvents();
                initializeComments();

            } catch (err) {
                console.error('데이터 로드 오류:', err);
                showMessage("데이터를 불러오는데 실패했습니다: " + err.message, 'error');
            }
        });
        
        /* ===========================================================
         * 4. 데이터 렌더링 함수
         * =========================================================== */
        function renderPage(d, images) {
            const get = (key) => d[key.toLowerCase()] || d[key.toUpperCase()] || '';

            const title = get('LANDMARK_NAME') + (get('LANDMARK_NAME_EN') ? ', ' + get('LANDMARK_NAME_EN') : '');
            $('#title').textContent = title;

            $('#spec-name').textContent      = title;
            $('#spec-location').textContent  = get('LANDMARK_LOCATION');
            $('#spec-desc').textContent      = get('LANDMARK_DESC');
            $('#spec-complete').textContent  = get('COMPLETION_TIME');
            $('#spec-style').textContent     = get('ARCH_STYLE');
            $('#spec-architect').textContent = get('ARCHITECT');
            $('#spec-history').textContent   = get('HISTORY');
            $('#spec-tmi').textContent       = get('TMI');

            $('#info-website').innerHTML = get('WEBSITE') ? '<a href="' + get('WEBSITE') + '" target="_blank">' + get('WEBSITE') + '</a>' : '—';
            $('#info-hours').textContent = get('LANDMARK_HOURS') || '—';
            $('#info-usage').textContent = get('LANDMARK_USAGE') || '—';
            $('#info-fee').textContent   = get('FEE') || '—';
            $('#info-traffic').textContent = get('TRAFFIC_INFO') || '—';
            
            const tagsString = get('TAGS');
            if (tagsString) {
                $('#info-tags').textContent = tagsString.split(',').map(tag => '#' + tag.trim()).join(' ');
            } else {
                $('#info-tags').textContent = '—';
            }
            
            initializeGallery(images);
        }

        /* ===========================================================
         * 5. 갤러리 및 지도 기능
         * =========================================================== */
        let currentSlide = 0;
        let isMoving = false;
        const THUMB_WIDTH = 140 + 10;
        const VISIBLE_THUMBS = 5;

        async function initializeGallery(images) {
            const heroEl = $('#hero');
            const trackEl = $('#thumbTrack');
            const subImages = images.filter(img => (img.image_type || img.IMAGE_TYPE) === 'sub');
            
            const mainImage = images.find(img => (img.image_type || img.IMAGE_TYPE) === 'main') || images[0];
            heroEl.src = await getValidImageUrl(mainImage) || 'https://placehold.co/1200x700?text=No+Image';

            if (subImages.length > VISIBLE_THUMBS) {
                const clonesStart = subImages.slice(-VISIBLE_THUMBS);
                const clonesEnd = subImages.slice(0, VISIBLE_THUMBS);
                const allThumbData = [...clonesStart, ...subImages, ...clonesEnd];
                
                trackEl.innerHTML = '';
                for (const imgData of allThumbData) {
                    trackEl.appendChild(await createThumbButton(imgData));
                }
                
                currentSlide = VISIBLE_THUMBS;
                trackEl.style.transition = 'none';
                trackEl.style.transform = 'translateX(-' + (currentSlide * THUMB_WIDTH) + 'px)';
                trackEl.addEventListener('transitionend', handleTransitionEnd);

            } else {
                trackEl.innerHTML = '';
                for (const imgData of subImages) {
                    trackEl.appendChild(await createThumbButton(imgData));
                }
            }

            $('#thumbPrev').onclick = () => moveThumbs(-1, subImages.length);
            $('#thumbNext').onclick = () => moveThumbs(1, subImages.length);
            updateNavButtons(subImages.length);
        }

        async function createThumbButton(imgData) {
            const thumbnailUrl = await getValidImageUrl(imgData);
            const btn = document.createElement('button');
            btn.className = 'thumb-btn';
            btn.type = 'button';
            if (thumbnailUrl) {
                btn.innerHTML = '<img src="' + thumbnailUrl + '" alt="썸네일">';
                btn.onclick = () => { $('#hero').src = thumbnailUrl; };
            }
            return btn;
        }

        function moveThumbs(direction, totalSubImages) {
            if (isMoving || totalSubImages <= VISIBLE_THUMBS) return;
            isMoving = true;
            
            currentSlide += direction;
            const trackEl = $('#thumbTrack');
            trackEl.style.transition = 'transform .3s ease-in-out';
            trackEl.style.transform = 'translateX(-' + (currentSlide * THUMB_WIDTH) + 'px)';
        }

        function handleTransitionEnd() {
            const trackEl = $('#thumbTrack');
            const totalSubImages = trackEl.children.length - (2 * VISIBLE_THUMBS);
            if (currentSlide >= totalSubImages + VISIBLE_THUMBS) {
                trackEl.style.transition = 'none';
                currentSlide = VISIBLE_THUMBS;
                trackEl.style.transform = 'translateX(-' + (currentSlide * THUMB_WIDTH) + 'px)';
            }
            if (currentSlide < VISIBLE_THUMBS) {
                trackEl.style.transition = 'none';
                currentSlide = totalSubImages + VISIBLE_THUMBS - 1;
                trackEl.style.transform = 'translateX(-' + (currentSlide * THUMB_WIDTH) + 'px)';
            }
            isMoving = false;
        }
        
        function updateNavButtons(totalSubImages) {
            const shouldDisable = totalSubImages <= VISIBLE_THUMBS;
            $('#thumbPrev').disabled = shouldDisable;
            $('#thumbNext').disabled = shouldDisable;
        }

        /* ===========================================================
         * 6. 기타 유틸리티 및 부가 기능
         * =========================================================== */
        async function getValidImageUrl(imgData) {
            if (!imgData) return null;
            let originalUrl = imgData.image_url || imgData.IMAGE_URL;
            if (!originalUrl) return null;
            
            let convertedUrl = convertImgurUrl(originalUrl);
            return await tryMultipleImageFormats(convertedUrl);
        }

        function convertImgurUrl(url) {
            const imgurPattern = /https?:\/\/imgur\.com\/([a-zA-Z0-9]+)/;
            const match = url.match(imgurPattern);
            if (match) return 'https://i.imgur.com/' + match[1] + '.jpg';
            return url;
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

        function testImageUrl(url) {
            return new Promise((resolve) => {
                const img = new Image();
                img.onload = () => resolve(true);
                img.onerror = () => resolve(false);
                img.src = url;
            });
        }

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
        
        function initMap(d) {
            const get = (key) => d[key.toLowerCase()] || d[key.toUpperCase()] || 0;
            const lat = Number(get('LATITUDE'));
            const lng = Number(get('LONGITUDE'));
            
            if (!map) {
                map = L.map('map').setView([lat, lng], 15);
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '&copy; OpenStreetMap contributors'
                }).addTo(map);
            } else {
                map.setView([lat, lng], 15);
            }
            
            // 기존 랜드마크 마커 제거
            if (landmarkMarker) map.removeLayer(landmarkMarker);
            
            // 랜드마크 메인 마커 추가
            landmarkMarker = L.marker([lat, lng]).addTo(map).bindPopup($('#title').textContent).openPopup();
            
            setTimeout(() => map.invalidateSize(), 50);
            updateHotspotsOnMap();
        }

        function showDummyNotice() {
            $('#warn').hidden = false;
        }
        
        /* ===========================================================
         * 7. 탭 기능 및 핫스팟 표시 (수정된 버전)
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
            // 기존 핫스팟 마커들 제거
            currentHotspotMarkers.forEach(marker => {
                if (map && marker) map.removeLayer(marker);
            });
            currentHotspotMarkers = [];
            
            // 랜드마크 이름 가져오기 (한글 이름 우선)
            const landmarkName = $('#title').textContent.split(',')[0].trim();
            
            let hotspots = [];
            
            // 탭 타입에 따라 적절한 데이터 소스 선택
            if (currentTabType === 'PHOTOSPOT' && typeof photospotInfo !== 'undefined') {
                hotspots = photospotInfo[landmarkName] || [];
            } else if (currentTabType === 'FOOD' && typeof restaurantInfo !== 'undefined') {
                hotspots = restaurantInfo[landmarkName] || [];
            } else if (currentTabType === 'PLACE' && typeof attractionInfo !== 'undefined') {
                hotspots = attractionInfo[landmarkName] || [];
            }
            
            // 서버 API 데이터도 함께 사용 (백업)
            const serverHotspots = allHotspots.filter(hotspot => {
                const hotspotType = hotspot.hotspot_type || hotspot.HOTSPOT_TYPE;
                return hotspotType === currentTabType;
            });
            
            // 클라이언트 데이터와 서버 데이터 병합
            const allHotspotsData = [...hotspots, ...serverHotspots];
            
            allHotspotsData.forEach(hotspot => {
                let lat, lng, name, info;
                
                // 클라이언트 데이터 구조 확인
                if (hotspot.lat && hotspot.lng) {
                    lat = Number(hotspot.lat);
                    lng = Number(hotspot.lng);
                    name = hotspot.name || '알 수 없는 장소';
                    info = hotspot.description || '';
                } else {
                    // 서버 데이터 구조 확인
                    const get = (key) => hotspot[key.toLowerCase()] || hotspot[key.toUpperCase()] || 0;
                    lat = Number(get('HOTSPOT_LATI'));
                    lng = Number(get('HOTSPOT_LONG'));
                    name = get('HOTSPOT_NAME') || '알 수 없는 장소';
                    info = get('HOTSPOT_INFO') || '';
                }
                
                if (lat && lng && map) {
                    let iconColor = '#57ACCB';
                    if (currentTabType === 'FOOD') iconColor = '#FF6B6B';
                    else if (currentTabType === 'PHOTOSPOT') iconColor = '#4ECDC4';
                    else if (currentTabType === 'PLACE') iconColor = '#45B7D1';
                    
                    const hotspotIcon = L.divIcon({
                        className: 'hotspot-marker',
                        html: '<div style="background-color: ' + iconColor + '; width: 12px; height: 12px; border-radius: 50%; border: 2px solid white; box-shadow: 0 2px 4px rgba(0,0,0,0.3);"></div>',
                        iconSize: [12, 12],
                        iconAnchor: [6, 6]
                    });
                    
                    const marker = L.marker([lat, lng], { icon: hotspotIcon })
                        .addTo(map)
                        .bindPopup(
                            '<div style="min-width: 200px;">' +
                                '<h4 style="margin: 0 0 8px; color: ' + iconColor + ';">' + name + '</h4>' +
                                (info ? '<p style="margin: 0; font-size: 14px; color: #666;">' + info + '</p>' : '') +
                            '</div>'
                        );
                    currentHotspotMarkers.push(marker);
                }
            });
        }
        
        /* ===========================================================
         * 8. 댓글 기능 (개선된 버전)
         * =========================================================== */
        function initializeComments() {
            loadComments();

            // 댓글 폼이 있는 경우에만 이벤트 리스너 추가
            const form = document.getElementById('commentForm');
            if (form) {
                form.addEventListener('submit', async (e) => {
                    e.preventDefault();
                    
                    // referenceId 요소가 존재하는지 확인
                    const referenceIdElement = $('#referenceId');
                    if (!referenceIdElement) {
                        showMessage('댓글 작성에 필요한 정보를 찾을 수 없습니다.', 'error');
                        return;
                    }
                    
                    const formData = new URLSearchParams({
                        referenceId: referenceIdElement.value,
                        replyType: 'landmark',
                        commentText: $('#commentText').value
                    }).toString();

                    try {
                        const res = await fetch(API.addReply(), {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: formData
                        });
                        
                        if (!res.ok) {
                            const errorText = await res.text();
                            throw new Error(errorText || '댓글 작성 실패');
                        }
                        
                        form.reset();
                        
                        // referenceId 값 재설정
                        if (referenceIdElement) {
                            referenceIdElement.value = landmarkId;
                        }
                        
                        await loadComments();
                        
                        // 성공 메시지 표시
                        showMessage('댓글이 성공적으로 작성되었습니다.', 'success');
                        
                    } catch (err) {
                        showMessage(err.message, 'error');
                    }
                });
            }
        }

        async function loadComments() {
            const listEl = document.getElementById('commentsList');
            if (!listEl) return;
            
            // landmarkId가 유효한지 확인
            if (!landmarkId) {
                listEl.innerHTML = '<div style="color:#777">댓글을 불러올 수 없습니다.</div>';
                return;
            }
            
            listEl.innerHTML = '<div style="color:#777">불러오는 중...</div>';
            
            try {
                const res = await fetch(API.getReplies(landmarkId));
                if (!res.ok) throw new Error('댓글 로딩 실패');
                const replies = await res.json();
                renderComments(Array.isArray(replies) ? replies : []);
            } catch (err) {
                listEl.innerHTML = '<div style="color:#c00">댓글을 불러오지 못했습니다.</div>';
                console.error(err);
            }
        }

        function renderComments(replies) {
            const listEl = document.getElementById('commentsList');
            if (!replies.length) {
                listEl.innerHTML = '<div style="color:#777">첫 댓글을 남겨보세요.</div>';
                return;
            }
            
            listEl.innerHTML = '';
            replies.forEach(r => {
                const get = (key) => r[key.toLowerCase()] || r[key.toUpperCase()] || '';
                const userName = get('MEMBER_NICKNAME') || '익명';
                const text = get('REPLY_CONTENT');
                const createdAt = (get('REPLY_DATE') || '').split(' ')[0]; // 날짜 부분만 사용
                
                const item = document.createElement('div');
                item.className = 'comment-item';
                item.innerHTML = 
                    '<div class="comment-meta">' + userName + (createdAt ? ' · <span>' + createdAt + '</span>' : '') + '</div>' +
                    '<div class="comment-text">' + escapeHtml(text) + '</div>';
                listEl.appendChild(item);
            });
        }

        function escapeHtml(str) {
            return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
        }

        $('#fav').addEventListener('click', (e) => {
            const pressed = e.currentTarget.getAttribute('aria-pressed') === 'true';
            e.currentTarget.setAttribute('aria-pressed', String(!pressed));
        });
    </script>
</body>
</html>