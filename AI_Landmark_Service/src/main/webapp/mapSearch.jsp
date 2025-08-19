<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%
    // 세션에서 로그인 사용자 확인 (없으면 null)
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>mapSearch — 지도에서 랜드마크 찾기</title>

  <!-- Leaflet (타일 지도) -->
  <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
  <script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>

  <!-- Turf.js -->
  <script src="https://unpkg.com/@turf/turf@6.5.0/turf.min.js" defer></script>

  <style>
    :root { --ink:#111; --muted:#f4f4f4; --line:#e5e5e5; --brand:#57ACCB; }
    * { box-sizing:border-box; }
    body { margin:0; font-family:system-ui,-apple-system, Segoe UI, Roboto, Arial, sans-serif; color:var(--ink); background:#fff; }

    /* ===== 헤더 & 사이드메뉴 ===== */
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

    /* ===== 본문(보드+지도+카드) ===== */
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
    .leaflet-container .leaflet-interactive:focus,
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
  <!-- ===== 헤더 ===== -->
  <header>
    <h2>Landmark Search</h2>
    <button class="menu-btn" aria-label="메뉴 열기">≡</button>
  </header>

  <!-- ===== 사이드 메뉴 ===== -->
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

  <!-- ===== 본문 ===== -->
  <section class="board">
    <h1 class="title">지도에서 랜드마크 찾기</h1>
    <div class="map-wrap">
      <div id="map" aria-label="세계 지도"></div>
      <div id="cardList" class="card-list" aria-live="polite"></div>
    </div>
  </section>

  <!-- 메뉴 토글 -->
  <script>
    const menuBtn=document.querySelector('.menu-btn'), sideMenu=document.getElementById('sideMenu');
    if(menuBtn && sideMenu){
      menuBtn.addEventListener('click',e=>{e.stopPropagation(); sideMenu.classList.toggle('open'); sideMenu.setAttribute('aria-hidden',sideMenu.classList.contains('open')?'false':'true');});
      document.addEventListener('click',e=>{ if(!sideMenu.contains(e.target) && !menuBtn.contains(e.target)){ sideMenu.classList.remove('open'); sideMenu.setAttribute('aria-hidden','true'); }});
    }
  </script>

  <!-- ===== 지도 및 데이터 로직 ===== -->
  <script>
    const GET_ALL_URL = 'http://localhost:8081/AI_Landmark_Service/getLandmarks';
    const GET_IMG_URL = 'http://localhost:8081/AI_Landmark_Service/getImage';
    const GEOJSON_URL = 'https://raw.githubusercontent.com/johan/world.geo.json/master/countries.geo.json';
    const PLACEHOLDER = 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=640';

    let map, markersLayer;

    function toDirectImageUrl(url) {
      try {
        if (!url) return PLACEHOLDER;
        const u = new URL(url);
        if (u.hostname.startsWith('i.')) return url;
        if (u.hostname.includes('imgur.com')) {
          const id = u.pathname.split('/').filter(Boolean).pop();
          return id ? `https://i.imgur.com/${id}.jpeg` : PLACEHOLDER;
        }
        return url;
      } catch { return PLACEHOLDER; }
    }

    async function buildMainImageLookup() {
      try {
        const res = await fetch(GET_IMG_URL);
        if (!res.ok) throw new Error('이미지 목록 로드 실패');
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
        console.warn('[image] fallback: no images', e);
        return new Map();
      }
    }

    function showMarkers(items){
      if (!markersLayer) markersLayer = L.layerGroup().addTo(map); else markersLayer.clearLayers();
      items.forEach(it=>{
        const lat=Number(it.latitude), lng=Number(it.longitude);
        if(!isFinite(lat)||!isFinite(lng)) return;
        // ✅ landmark_name_en 없으면 <em>태그 자체 안 찍음
        const pop=`<strong>${it.landmark_name||''}</strong><br>`
                 + (it.landmark_name_en ? `<em>${it.landmark_name_en}</em><br>` : '')
                 + (it.landmark_location||'');
        L.marker([lat,lng]).bindPopup(pop).addTo(markersLayer);
      });
    }

    function addLegend(){
      const div=document.createElement('div'); div.className='legend';
      div.innerHTML=`<div class="key"><span class="sw"></span>클릭 가능 (랜드마크 있음)</div><div class="key"><span class="sw off"></span>클릭 불가 (없음)</div>`;
      document.body.appendChild(div);
    }
  </script>

  <script>
    let imageLookup = new Map();

    function renderCards(root, countryName, items) {
      root.innerHTML = '';
      if (!items || items.length === 0) {
        const empty = document.createElement('div');
        empty.className = 'card';
        empty.innerHTML = `
          <div class="thumb"></div>
          <div>
            <h3 class="card-title">${countryName}</h3>
            <p class="card-desc">등록된 랜드마크가 없습니다.</p>
            <div class="card-meta">0 places</div>
          </div>`;
        root.appendChild(empty);
        return;
      }

      items.slice(0, 3).forEach(item => {
        const a = document.createElement('a');
        a.className = 'card';
        const linkName = encodeURIComponent(item.landmark_name_en || item.landmark_name || '');
        a.href = `./landmarkInfo.jsp?name=${linkName}`;
        const imgSrc = imageLookup.get(item.landmark_id) || PLACEHOLDER;

        a.innerHTML = `
          <img class="thumb"
               src="${imgSrc}"
               alt="${item.landmark_name || ''}"
               loading="lazy"
               referrerpolicy="no-referrer"
               onerror="this.onerror=null; this.src='${PLACEHOLDER}'" />
          <div>
            <h3 class="card-title">${item.landmark_name || ''}</h3>
            <p class="card-desc">${item.landmark_desc || ''}</p>
            <div class="card-meta">${countryName}</div>
          </div>`;
        root.appendChild(a);
      });
    }
  </script>

  <script>
    document.addEventListener('DOMContentLoaded', async () => {
      const listRoot = document.getElementById('cardList');
      map = L.map('map', { worldCopyJump:false }).setView([20,0], 2);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution:'&copy; OpenStreetMap', noWrap:true }).addTo(map);
      const resizeMap = () => map.invalidateSize();
      window.addEventListener('load', resizeMap);
      window.addEventListener('resize', resizeMap);

      try {
        const [landmarks, world, imgMap] = await Promise.all([
          fetch(GET_ALL_URL).then(r => r.json()),
          fetch(GEOJSON_URL).then(r => r.json()),
          buildMainImageLookup()
        ]);
        imageLookup = imgMap;

        const groupedByCountry = {};
        const countryCounts = {};
        const features = world.features;

        landmarks.forEach(it => {
          const lat = Number(it.latitude), lng = Number(it.longitude);
          if (!isFinite(lat) || !isFinite(lng)) return;
          const point = turf.point([lng, lat]);
          for (const f of features) {
            if (turf.booleanPointInPolygon(point, f)) {
              const name = (f.properties.name || f.properties.ADMIN);
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
              ? { color:'#ff2d20', weight:1.6, fillColor:'#9fbfff', fillOpacity:0.18 }
              : { color:'#9aa3aa', weight:0.9,  fillOpacity:0.02 };
          },
          onEachFeature: (f, layer) => {
            const name = (f.properties.name || f.properties.ADMIN);
            const count = countryCounts[name] || 0;
            layer.on('mouseover', () => {
              layer.bindTooltip(`${name} • ${count} place${count>1?'s':''}`, { sticky:true }).openTooltip();
              layer.setStyle({ weight: 2.2 });
            });
            layer.on('mouseout', () => {
              layer.closeTooltip();
              layer.setStyle(clickableCountries.has(name) ? { weight:1.6 } : { weight:0.9 });
            });
            if (clickableCountries.has(name)) {
              layer.on('click', () => {
                map.fitBounds(layer.getBounds(), { padding:[20,20] });
                const items = groupedByCountry[name] || [];
                renderCards(listRoot, name, items);
                showMarkers(items);
              });
            }
          }
        }).addTo(map);

        addLegend();
      } catch (err) {
        console.error(err);
        listRoot.innerHTML = `
          <div class="card">
            <div class="thumb"></div>
            <div>
              <h3 class="card-title">오류</h3>
              <p class="card-desc">데이터나 지도 리소스를 불러오지 못했습니다. 서버/CORS를 확인해 주세요.</p>
              <div class="card-meta">network error</div>
            </div>
          </div>`;
      }
    });
  </script>
</body>
</html>
