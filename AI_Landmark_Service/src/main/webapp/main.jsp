<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Landmark Search</title>
    <style>
<<<<<<< HEAD
        body { margin: 0; font-family: Arial, sans-serif; height: 100vh; display: flex; justify-content: center; align-items: center; background-color: #ffffff; overflow: hidden; }
=======
        /* ====== CSS 원본 그대로 유지 ====== */
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #ffffff;
            overflow: hidden;
        }
>>>>>>> branch 'main' of https://github.com/2025-SMHRD-IS-CLOUD-3/projectLMSS.git
        img { width: 80%; }
        .center-container { position: relative; text-align: center; }
        h1 { font-size: 50px; margin-bottom: 20px; }
        .search-btn { padding: 10px 20px; background-color: #ffffff; border: 7px solid black; color: black; font-size: 50px; cursor: pointer; border-radius: 24px; font-weight: bold; }
        .search-btn:hover { background-color: #f0f0f0; }
        header { position: fixed; top: 0; left: 0; width: 100%; height: 100px; background-color: white; display: flex; justify-content: space-between; align-items: center; padding: 0 20px; z-index: 1003; }
        header h2 { font-size: 18px; margin: 0; font-weight: bold; }
        .side-menu { position: fixed; top: 0; right: -500px; width: 500px; height: 100%; background-color: #57ACCB; color: white; padding: 20px; padding-top: 100px; box-sizing: border-box; transition: right 0.3s ease; font-size: 30px; z-index: 1002; }
        .side-menu li { list-style-type: none; margin-top: 20px; }
        .side-menu a { color: white; text-decoration: none; font-weight: bold; }
        .side-menu.open { right: 0; }
        .menu-btn { position: fixed; top: 20px; right: 20px; font-size: 50px; background: none; border: none; color: black; cursor: pointer; z-index: 1004; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.6); justify-content: center; align-items: center; z-index: 1005; }
        .modal-content { background: white; border-radius: 15px; padding: 20px; width: 500px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); text-align: center; }
        .drop-zone { display: flex; justify-content: center; text-align: center; border: 2px dashed #ccc; border-radius: 15px; padding: 30px; background: #f9f9f9; cursor: pointer; transition: border-color 0.3s; gap: 30px; align-items: center; margin: 0 auto; line-height: 2; }
        .drop-zone:hover { border-color: #6bb8e8; }
        .drop-text { display: flex; flex-direction: column; align-items: flex-start; font-size: 14px; }
        .drop-icon { width: 58px; height: 58px; }
        .file-label { color: #0078d7; cursor: pointer; text-decoration: none; }
        #fileUpload { display: none; }
        .divider { display: flex; align-items: center; text-align: center; margin: 20px 0; }
        .divider::before, .divider::after { content: ""; flex: 1; border-bottom: 1px solid #ccc; }
        .divider span { margin: 0 10px; color: #666; }
        .url-search { display: flex; gap: 10px; }
        .url-search input { flex: 1; padding: 10px; border-radius: 10px; border: 1px solid #ccc; }
        .url-search button { padding: 10px 15px; border: none; border-radius: 10px; background: #6bb8e8; color: white; cursor: pointer; }
        .url-search button:hover { background: #5aa7d4; }
        .preview { margin-top: 18px; display: none; text-align: center; }
        .preview img { max-width: 100%; max-height: 280px; border-radius: 10px; box-shadow: 0 6px 18px rgba(0,0,0,.12); }
        .preview-name { margin: 8px 0 0; color:#666; font-size: 14px; word-break: break-all; }
        .loading { margin-top: 10px; font-size: 14px; color: #333; display: none; }
    </style>
</head>
<body>
    <header>
        <h2>Landmark Search</h2>
        <div><button class="menu-btn" aria-label="open side menu">≡</button></div>
    </header>

    <div class="side-menu" id="sideMenu">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
<<<<<<< HEAD
            <li><a href="<%=request.getContextPath()%>/post.jsp">게시판</a></li>
            <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
            <li><a href="<%=request.getContextPath()%>/join.jsp">회원가입</a></li>
=======
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>
            <% if (loginUser != null) { %>
                <li>
                    <a href="<%=request.getContextPath()%>/logout?redirect=<%=request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "")%>">
                        로그아웃
                    </a>
                </li>
                <li><a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
            <% } else { %>
                <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
            <% } %>
>>>>>>> branch 'main' of https://github.com/2025-SMHRD-IS-CLOUD-3/projectLMSS.git
        </ul>
    </div>

    <div class="center-container">
        <img src="<%=request.getContextPath()%>/data/mainIIllustration.png" alt="일러스트" />
        <h1>LANDMARK SEARCH</h1>
        <button class="search-btn" id="searchBtn">Search</button>
    </div>

    <div class="modal" id="uploadModal" role="dialog" aria-modal="true" aria-label="이미지 검색">
        <div class="modal-content">
            <h2>이미지 검색</h2>

            <div class="drop-zone" id="dropZone">
                <img src="<%=request.getContextPath()%>/data/img-upload.png" class="drop-icon" alt="upload icon"/>
                <div class="drop-text">
                    여기로 이미지를 드래그하거나 <br/>
                    <label for="fileUpload" class="file-label">파일을 업로드 하세요</label>
                </div>
<<<<<<< HEAD
                <input type="file" id="fileUpload" hidden accept="image/*"/>
=======
                <input type="file" id="fileUpload" hidden accept="image/*">
>>>>>>> branch 'main' of https://github.com/2025-SMHRD-IS-CLOUD-3/projectLMSS.git
            </div>

            <div class="divider"><span>또는</span></div>

            <div class="url-search">
                <input type="text" id="imageUrl" placeholder="이미지 링크 붙여넣기"/>
                <button id="urlSearchBtn">검색</button>
            </div>

            <div class="preview">
                <img id="previewImg" alt="미리보기"/>
                <p id="previewName" class="preview-name"></p>
                <p id="loadingText" class="loading">AI가 이미지를 분석 중입니다...</p>
            </div>
        </div>
    </div>

    <script>
        const menuBtn = document.querySelector('.menu-btn');
        const sideMenu = document.getElementById('sideMenu');
        const searchBtn = document.getElementById('searchBtn');
        const uploadModal = document.getElementById('uploadModal');
        const dropZone = document.getElementById('dropZone');
        const fileInput = document.getElementById('fileUpload');
        const urlSearchBtn = document.getElementById('urlSearchBtn');
        const imageUrlInput = document.getElementById('imageUrl');
        const previewWrap = document.querySelector('.preview');
        const previewImg = document.getElementById('previewImg');
        const previewName = document.getElementById('previewName');
        const loadingText = document.getElementById('loadingText');

        const setLoading = (b)=> loadingText.style.display = b ? 'block' : 'none';
        const showPreview = (src, name)=>{ previewImg.src = src; previewName.textContent = name || ''; previewWrap.style.display = 'block'; };
        
        const friendlyAlert = (title, detail) => {
            let message = title;
            if (detail) {
                message += "\n\n상세: " + detail;
            }
            alert(message);
        };

        menuBtn.addEventListener('click', (e) => { e.stopPropagation(); sideMenu.classList.toggle('open'); });
        document.addEventListener('click', (e) => { if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) sideMenu.classList.remove('open'); });
        searchBtn.addEventListener('click', () => uploadModal.style.display = 'flex');
        uploadModal.addEventListener('click', (e) => { if (e.target === uploadModal) uploadModal.style.display = 'none'; });

<<<<<<< HEAD
        function handleFile(file) {
            if (!file) return;
            if (!file.type || !file.type.startsWith('image/')) { friendlyAlert('이미지 파일만 업로드 할 수 있습니다.'); return; }
=======
        uploadModal.addEventListener('click', (e) => {
            if (e.target === uploadModal) {
                uploadModal.style.display = 'none';
            }
        });

        // 파일 업로드 처리 (Flask 연동 추가)
        function handleFile(file){
            if(!file) return;
            if(!file.type || !file.type.startsWith('image/')){
                alert('이미지 파일만 업로드 할 수 있습니다.');
                return;
            }
>>>>>>> branch 'main' of https://github.com/2025-SMHRD-IS-CLOUD-3/projectLMSS.git
            const reader = new FileReader();
<<<<<<< HEAD
            reader.onload = () => { showPreview(reader.result, file.name); sendImageToAI(file); };
=======
            reader.onload = () => {
                showPreview(reader.result, file.name);
                // ✅ Flask AI 서버 전송
                sendImageToAI(file);
            };
>>>>>>> branch 'main' of https://github.com/2025-SMHRD-IS-CLOUD-3/projectLMSS.git
            reader.readAsDataURL(file);
        }

<<<<<<< HEAD
        async function sendImageToAI(file) {
            const formData = new FormData();
            formData.append('image', file);
            setLoading(true);
            try {
                const response = await fetch('http://127.0.0.1:5000/predict', { method: 'POST', body: formData });
                const text = await response.text();
                let result;
                try { result = JSON.parse(text); } catch(e) { throw new Error("서버가 JSON이 아닌 응답을 반환했습니다: " + text.slice(0,200) + "..."); }
                if (!response.ok) throw new Error(result.error || "서버 오류(" + response.status + ")");
                
                const name = result.predicted_landmark;
                const conf = (result.confidence * 100).toFixed(2);
                
                // ❗ [수정] JSP와 충돌하지 않도록 문자열 합치기 방식으로 변경
                alert("분석 결과: " + name + "\n신뢰도: " + conf + "%");
                window.location.href = "landmarkInfo.jsp?name=" + encodeURIComponent(name);

            } catch (err) {
=======
        // Flask AI 서버 전송 함수
        async function sendImageToAI(file) {
            const formData = new FormData();
            formData.append('image', file);

            alert('AI가 이미지를 분석 중입니다... 잠시만 기다려주세요.');

            try {
                const response = await fetch('http://127.0.0.1:5000/predict', {
                    method: 'POST',
                    body: formData
                });

                if (!response.ok) {
                    throw new Error(`서버 에러: ${response.status}`);
                }

                const result = await response.json();
                const landmarkName = result.predicted_landmark;
                const confidence = (result.confidence * 100).toFixed(2);

                alert(`분석 결과: ${landmarkName}\n신뢰도: ${confidence}%`);

                // ✅ JSP 상세 페이지로 이동
                window.location.href = "<%=request.getContextPath()%>/landmarkInfo.jsp?name=" + encodeURIComponent(landmarkName);

            } catch (error) {
                console.error('AI 서버 통신 오류:', error);
                alert('이미지 분석에 실패했습니다. AI 서버가 실행 중인지 확인해주세요.');
            }
        }

        async function handleUrl(url){
            try{
                const clean = url.trim();
                if(!clean) return;
                await loadImage(clean);
                showPreview(clean, clean);
            }catch(err){
                alert('이미지 URL을 불러오지 못했습니다. 주소를 확인해 주세요.');
>>>>>>> branch 'main' of https://github.com/2025-SMHRD-IS-CLOUD-3/projectLMSS.git
                console.error(err);
                friendlyAlert('이미지 분석에 실패했습니다.', err.message);
            } finally { setLoading(false); }
        }

        async function handleUrl(rawUrl) {
            const url = (rawUrl || '').trim();
            if (!url) { friendlyAlert('이미지 링크를 입력하세요.'); return; }
            showPreview(url, 'URL 이미지');
            try {
                const resp = await fetch(url, { mode: 'cors' });
                if (!resp.ok) throw new Error("원격 서버 응답 오류: " + resp.status);
                const blob = await resp.blob();
                const guessedName = url.split('/').pop()?.split('?')[0] || 'image_from_url';
                const file = new File([blob], guessedName, { type: blob.type || 'application/octet-stream' });
                await sendImageToAI(file);
                return;
            } catch (e) {
                console.warn('브라우저 직접 다운로드 실패(CORS 가능성):', e);
            }

            setLoading(true);
            try {
                const resp2 = await fetch('http://127.0.0.1:5000/predict_url', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ image_url: url })
                });
                const text = await resp2.text();
                let data;
                try { data = JSON.parse(text); } catch(e) { throw new Error("서버가 JSON이 아닌 응답을 반환했습니다: " + text.slice(0,200) + "..."); }
                if (!resp2.ok) {
                    throw new Error(data.error ? (resp2.status + " " + data.error) : "서버 오류(" + resp2.status + ")");
                }
                const name = data.predicted_landmark, conf = (data.confidence * 100).toFixed(2);

                // ❗ [수정] JSP와 충돌하지 않도록 문자열 합치기 방식으로 변경
                alert("분석 결과: " + name + "\n신뢰도: " + conf + "%");
                window.location.href = "landmarkInfo.jsp?name=" + encodeURIComponent(name);

            } catch (err) {
                console.error('URL 분석 실패:', err);
                friendlyAlert('이미지 링크 분석에 실패했습니다.', err.message);
            } finally { setLoading(false); }
        }

        ;['dragenter','dragover'].forEach(evt => {
            dropZone.addEventListener(evt, (e) => { e.preventDefault(); e.stopPropagation(); dropZone.classList.add('dragover'); });
        });
        ;['dragleave','drop'].forEach(evt => {
            dropZone.addEventListener(evt, (e) => { e.preventDefault(); e.stopPropagation(); dropZone.classList.remove('dragover'); });
        });
        dropZone.addEventListener('drop', (e) => { const files = e.dataTransfer?.files; if (files && files.length) handleFile(files[0]); });
        fileInput.addEventListener('change', () => { if (fileInput.files && fileInput.files.length) handleFile(fileInput.files[0]); });

        urlSearchBtn.addEventListener('click', () => handleUrl(imageUrlInput.value));
        imageUrlInput.addEventListener('keydown', (e) => { if (e.key === 'Enter') handleUrl(imageUrlInput.value); });
    </script>
</body>
</html>
