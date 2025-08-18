<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>지도 검색 - Landmark Search</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
    <style>
        :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08);}
        *{box-sizing:border-box}
        body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}
        header{position:fixed;top:0;left:0;width:100%;height:100px;background:#fff;
          display:flex;align-items:center;justify-content:space-between;padding:0 20px;z-index:1000;
          box-shadow:0 1px 0 rgba(0,0,0,.04)}
        header h1{margin:0;font-size:22px}
        .menu-btn{position:fixed;top:20px;right:20px;font-size:50px;background:none;border:none;cursor:pointer}
        .side-menu{position:fixed;top:0;right:-500px;width:500px;height:100%;background:var(--brand);color:#fff;
          padding:20px;padding-top:100px;transition:right .3s ease;z-index:1001;font-size:30px}
        .side-menu.open{right:0}
        .side-menu ul{margin:0;padding:0}
        .side-menu li{list-style:none;margin:18px 0}
        .side-menu a{color:#fff;text-decoration:none;font-weight:700}
        .board{max-width:1000px;margin:140px auto 40px;background:var(--muted);border-radius:28px;padding:22px}
        .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:28px;box-shadow:var(--shadow); position: relative;}
        #map { width: 100%; height: 500px; border-radius: 12px; position: relative; }

        /* ===== Landmark Sidebar Styles ===== */
        .landmark-sidebar {
            position: absolute;
            top: 0;
            right: -300px; /* Initially hidden */
            width: 300px;
            height: 100%;
            background-color: #f8f9fa;
            border-left: 1px solid var(--line);
            z-index: 999;
            transition: right 0.3s ease-in-out;
            overflow-y: auto;
            padding: 20px;
            border-radius: 0 22px 22px 0;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .landmark-sidebar.open {
            right: 0; /* Slide in */
        }
        .landmark-sidebar h3 {
            margin-top: 0;
            font-size: 1.5em;
            border-bottom: 1px solid var(--line);
            padding-bottom: 10px;
        }
        .landmark-sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .landmark-sidebar li {
            padding: 10px 0;
            border-bottom: 1px solid var(--line);
            font-size: 1.2em;
        }
        .landmark-sidebar li:last-child {
            border-bottom: none;
        }
    </style>
</head>
<body>
<header>
    <h2>Landmark Search</h2>
    <div>
        <button class="menu-btn">≡</button>
    </div>
</header>

<div class="side-menu" id="sideMenu">
    <ul>
        <li><a href="${pageContext.request.contextPath}/howLandmark.jsp">Landmark Search란?</a></li>
        <li><a href="${pageContext.request.contextPath}/main.jsp">사진으로 랜드마크 찾기</a></li>
        <li><a href="${pageContext.request.contextPath}/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
        <li><a href="${pageContext.request.contextPath}/postList">게시판</a></li>
        <% if (loginUser != null) { %>
            <li>
                <a href="<%=request.getContextPath()%>/logout?redirect=<%=request.getRequestURI()%>">로그아웃</a>
            </li>
        <% } else { %>
            <li><a href="${pageContext.request.contextPath}/login.jsp">로그인</a></li>
            <li><a href="${pageContext.request.contextPath}/register.jsp">회원가입</a></li>
        <% } %>
    </ul>
</div>

<main class="board">
    <section class="panel">
        <h2>지도에서 랜드마크 찾기</h2>
        <div id="map">
            <aside class="landmark-sidebar" id="landmarkSidebar"></aside>
        </div>
    </section>
</main>

<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<script src="<%=request.getContextPath()%>/mapmark/landmarks.js"></script>
<script>
    var map = L.map('map', {
        worldCopyJump: false
    }).setView([20, 0], 2);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        maxZoom: 19,
        noWrap: true,
        attribution: '© OpenStreetMap'
    }).addTo(map);

    var bounds = L.latLngBounds([-90, -180], [90, 180]);
    map.setMaxBounds(bounds);
    map.on('drag', function () {
        map.panInsideBounds(bounds, { animate: false });
    });
    
    const landmarkSidebar = document.getElementById('landmarkSidebar');
    let lastClickedLayer = null;

    function hideLandmarkSidebar() {
        landmarkSidebar.classList.remove('open');
        lastClickedLayer = null;
    }

    function showLandmarks(countryName) {
        const countryLandmarks = landmarks.filter(l => l.country?.trim() === countryName);
        
        landmarkSidebar.innerHTML = '';
        if (countryLandmarks.length > 0) {
            const title = document.createElement('h3');
            title.textContent = `${countryName}의 랜드마크`;
            landmarkSidebar.appendChild(title);
            
            const ul = document.createElement('ul');
            countryLandmarks.forEach(l => {
                const li = document.createElement('li');
                li.textContent = l.name;
                ul.appendChild(li);
            });
            landmarkSidebar.appendChild(ul);
            landmarkSidebar.classList.add('open');
        } else {
            hideLandmarkSidebar();
        }
    }

    const landmarkCountries = new Set(
        landmarks.map(l => l.country?.trim()).filter(Boolean)
    );

    fetch('<%=request.getContextPath()%>/mapmark/countries.geojson')
        .then(res => res.json())
        .then(data => {
            L.geoJSON(data, {
                filter: function (feature) {
                    return landmarkCountries.has(feature.properties.name);
                },
                style: {
                    color: "#ff7800",
                    weight: 2,
                    fillOpacity: 0.2
                },
                onEachFeature: function (feature, layer) {
                    layer.on('click', function (e) {
                        e.stopPropagation();
                        const countryName = feature.properties.name;
                        if (lastClickedLayer === layer) {
                            hideLandmarkSidebar();
                        } else {
                            map.fitBounds(layer.getBounds());
                            showLandmarks(countryName);
                            lastClickedLayer = layer;
                        }
                    });
                }
            }).addTo(map);
        });

    landmarks.forEach(l => {
        if (l.lat && l.lng) {
            L.marker([l.lat, l.lng])
                .addTo(map)
                .bindPopup(`<b>${l.name}</b><br>${l.country || ''}`);
        }
    });

    map.on('click', function(e) {
        hideLandmarkSidebar();
    });
    
    landmarkSidebar.addEventListener('click', e => e.stopPropagation());
</script>

<script>
    const menuBtn=document.querySelector('.menu-btn');
    const sideMenu=document.getElementById('sideMenu');
    menuBtn.addEventListener('click',e=>{
        e.stopPropagation();
        sideMenu.classList.toggle('open');
    });
    document.addEventListener('click',e=>{
        if(!sideMenu.contains(e.target) && !menuBtn.contains(e.target)){
            sideMenu.classList.remove('open');
        }
    });
</script>
</body>
</html>