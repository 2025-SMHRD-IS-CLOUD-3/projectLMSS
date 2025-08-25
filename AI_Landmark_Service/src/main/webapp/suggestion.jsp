<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>핫스팟 제안하기</title>
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js" defer></script>
    <style>
        :root { --brand:#57ACCB; --line:#e5e5e5; }
        body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; padding: 20px; background-color: #f4f4f4; }
        .container { max-width: 800px; margin: 0 auto; background: #fff; padding: 20px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        h1 { text-align: center; color: var(--brand); }
        #map { height: 400px; width: 100%; border-radius: 8px; margin-bottom: 20px; border: 1px solid var(--line); }
        .form-grid { display: grid; gap: 16px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { font-weight: 600; margin-bottom: 6px; }
        .form-group input, .form-group select, .form-group textarea {
            padding: 10px; border: 1px solid var(--line); border-radius: 6px; font-size: 16px;
        }
        .coords-group { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .coords-group input { background-color: #f0f0f0; }
        .form-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; }
        .btn { padding: 10px 20px; border: none; border-radius: 6px; font-weight: 700; cursor: pointer; }
        .btn-primary { background-color: var(--brand); color: white; }
        .btn-secondary { background-color: #e9eef1; color: #333; }
    </style>
</head>
<body>
    <div class="container">
        <h1>핫스팟 제안하기</h1>
        <p>지도에서 제안할 위치를 클릭한 후, 아래 정보를 입력해주세요.</p>
        
        <div id="map"></div>

        <form id="suggestionForm" action="<%=request.getContextPath()%>/submitSuggestion" method="post">
            <input type="hidden" name="landmarkId" id="landmarkId">

            <div class="form-grid">
                <div class="form-group">
                    <label for="hotspotType">종류 선택</label>
                    <select id="hotspotType" name="hotspotType" required>
                        <option value="PHOTOSPOT">📸 포토 스팟</option>
                        <option value="FOOD">🍽️ 주변 맛집</option>
                        <option value="PLACE">🏛️ 주변 명소</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="hotspotName">장소 이름</label>
                    <input type="text" id="hotspotName" name="hotspotName" placeholder="예: 에펠탑이 잘 보이는 카페" required>
                </div>

                <div class="form-group">
                    <label for="hotspotInfo">간단한 설명 (선택)</label>
                    <textarea id="hotspotInfo" name="hotspotInfo" rows="3" placeholder="예: 2층 창가 자리가 명당이에요!"></textarea>
                </div>

                <div class="form-group">
                    <label>지도에서 선택된 위치 (자동 입력)</label>
                    <div class="coords-group">
                        <input type="text" id="latitude" name="latitude" placeholder="위도" readonly required>
                        <input type="text" id="longitude" name="longitude" placeholder="경도" readonly required>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                    <button type="submit" class="btn btn-primary">제안 제출</button>
                </div>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(location.search);
            const landmarkId = urlParams.get('landmarkId');
            const initialLat = parseFloat(urlParams.get('lat'));
            const initialLng = parseFloat(urlParams.get('lng'));

            // URL에서 좌표값이 넘어오지 않았을 경우를 대비한 안전장치
            if (!landmarkId || isNaN(initialLat) || isNaN(initialLng)) {
                alert("잘못된 접근입니다. 정보 페이지에서 '핫스팟 제안하기' 버튼을 통해 접근해주세요.");
                history.back();
                return;
            }

            document.getElementById('landmarkId').value = landmarkId;

            const map = L.map('map').setView([initialLat, initialLng], 15);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

            L.marker([initialLat, initialLng]).addTo(map)
                .bindPopup("현재 랜드마크 위치").openPopup();

            let suggestionMarker;

            map.on('click', function(e) {
                const lat = e.latlng.lat.toFixed(6);
                const lng = e.latlng.lng.toFixed(6);

                document.getElementById('latitude').value = lat;
                document.getElementById('longitude').value = lng;

                if (suggestionMarker) {
                    map.removeLayer(suggestionMarker);
                }
                suggestionMarker = L.marker(e.latlng).addTo(map)
                    .bindPopup("이 위치로 제안합니다.").openPopup();
            });

            document.getElementById('suggestionForm').addEventListener('submit', function(e) {
                if (!document.getElementById('latitude').value) {
                    alert('지도에서 위치를 먼저 클릭해주세요!');
                    e.preventDefault();
                }
            });
        });
    </script>
</body>
</html>