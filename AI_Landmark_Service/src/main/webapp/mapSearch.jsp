<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>mapSearch — 지도에서 랜드마크 찾기</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Leaflet -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>
    <!-- 실제 데이터 -->
    <script src="mapmark/landmark.js" defer></script>

    <style>
        :root { --ink:#111; --muted:#f4f4f4; --line:#e5e5e5; --brand:#57ACCB; }
        *{box-sizing:border-box}
        body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}

        header{position:fixed;top:0;left:0;width:100%;height:100px;background:#fff;display:flex;justify-content:space-between;align-items:center;padding:0 20px;z-index:1000;box-shadow:0 1px 0 rgba(0,0,0,.04);}
        header h2{margin:0;font-size:20px;font-weight:900;}
        .menu-btn{position:fixed;top:20px;right:20px;font-size:50px;background:none;border:none;color:#000;cursor:pointer;z-index:1001;}
        .side-menu{position:fixed;top:0;right:-500px;width:500px;height:100%;background:var(--brand);color:#fff;padding:20px;padding-top:100px;transition:right .3s ease;z-index:1002;font-size:30px;}
        .side-menu.open{right:0;}
        .side-menu ul{margin:0;padding:0;}
        .side-menu li{list-style:none;margin-top:20px;}
        .side-menu a{color:#fff;text-decoration:none;font-weight:bold;}

        .board{max-width:1200px;margin:140px auto 40px;background:var(--muted);border-radius:28px;padding:28px;}
        .title{margin:0 0 18px;text-align:center;font-weight:900;font-size:32px;}

        .map-wrap{position:relative;border-radius:18px;overflow:hidden;background:#e9eef3;}
        #map{width:100%;height:560px;border-radius:8px;}

        /* 지도 위 버튼 */
        .category-btns {
            position:absolute;
            bottom:20px;
            right:20px;
            display:flex;
            gap:8px;
            z-index:1003;
        }
        .category-btns button {
            background:#fff;
            border:1px solid var(--line);
            border-radius:20px;
            padding:6px 12px;
            font-size:14px;
            cursor:pointer;
            box-shadow:0 4px 10px rgba(0,0,0,.15);
            transition:background 0.2s;
        }
        .category-btns button:hover {background:#f0f0f0;}

        .card-list{margin-top:16px;display:flex;flex-direction:column;gap:12px;}
        .card{display:grid;grid-template-columns:120px 1fr;gap:14px;background:#fff;border:1px solid var(--line);border-radius:12px;box-shadow:0 6px 20px rgba(0,0,0,.08);padding:12px;text-decoration:none;color:inherit;}
        .card img{width:120px;height:86px;object-fit:cover;border-radius:8px;background:#ddd;}
        .card-title{margin:0 0 4px;font-size:14px;font-weight:900;}
        .card-desc{margin:0;font-size:12px;color:#555;}
        .leaflet-popup-content-wrapper{border-radius:12px;}

        @media (max-width:960px){
            #map{height:420px;}
            .card{grid-template-columns:100px 1fr;}
            .card img{width:100px;height:76px;}
        }
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
            <div class="category-btns">
                <button data-category="landmark">랜드마크</button>
                <button data-category="restaurant">맛집</button>
                <button data-category="photospot">포토스팟</button>
            </div>
        </div>
        <div id="cardList" class="card-list" aria-live="polite"></div>
    </section>

    <script>
        const menuBtn=document.querySelector('.menu-btn');
        const sideMenu=document.getElementById('sideMenu');
        if(menuBtn && sideMenu){
            menuBtn.addEventListener('click',(e)=>{
                e.stopPropagation();
                sideMenu.classList.toggle('open');
                sideMenu.setAttribute('aria-hidden',sideMenu.classList.contains('open')?'false':'true');
            });
            document.addEventListener('click',(e)=>{
                if(!sideMenu.contains(e.target)&&!menuBtn.contains(e.target)){
                    sideMenu.classList.remove('open');
                    sideMenu.setAttribute('aria-hidden','true');
                }
            });
        }

        document.addEventListener("DOMContentLoaded", () => {
            const map = L.map("map", {
                worldCopyJump: false,   // 지도 복제 점프 방지
                maxBoundsViscosity: 1.0 // 경계 바깥으로 못 나가게
            }).setView([37.5665, 126.9780], 12);

            // OSM 타일 (반복 방지 적용)
            L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
                attribution: '&copy; OpenStreetMap contributors',
                noWrap: true, // 반복 금지
                bounds: [[-85, -180], [85, 180]]
            }).addTo(map);

            // 지도 최대 경계 제한
            map.setMaxBounds([[-85, -180], [85, 180]]);

            let markers = [];
            const cardList=document.getElementById("cardList");

            // ✅ 마커 & 카드 목록 렌더링
            const renderCategory = (category) => {
                markers.forEach(m => map.removeLayer(m));
                markers = [];
                cardList.innerHTML = "";

                const filtered = landmarkData.filter(d => d.category === category);
                filtered.forEach(d => {
                    const marker = L.marker([d.lat, d.lng]).addTo(map).bindPopup(d.name);
                    markers.push(marker);

                    const card=document.createElement("a");
                    card.href="#";
                    card.className="card";
                    card.innerHTML=`
                        <img src="${d.image || 'https://via.placeholder.com/120x86'}" alt="${d.name}">
                        <div>
                            <h2 class="card-title">${d.name}</h2>
                            <p class="card-desc">${d.desc || ""}</p>
                        </div>
                    `;
                    card.addEventListener("click",(e)=>{
                        e.preventDefault();
                        map.setView([d.lat,d.lng],15);
                        marker.openPopup();
                    });
                    cardList.appendChild(card);
                });
            };

            // 버튼 클릭 이벤트
            document.querySelectorAll(".category-btns button").forEach(btn=>{
                btn.addEventListener("click",()=>{
                    renderCategory(btn.dataset.category);
                });
            });
        });
    </script>
</body>
</html>
