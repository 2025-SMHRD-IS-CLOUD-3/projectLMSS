<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%
    // 현재 로그인 상태 확인
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Landmark Search</title>
    <style>
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
        img {
            width: 80%;
        }
        .center-container { position: relative; text-align: center; }
        h1 { font-size: 50px; margin-bottom: 20px; }
        .search-btn {
            padding: 10px 20px;
            background-color: #ffffff;
            border: 7px;
            border-style: solid;
            color: black;
            font-size: 50px;
            cursor: pointer;
            border-radius: 24px;
            font-weight: bold;
        }
        .search-btn:hover { background-color: #f0f0f0; }
        header {
            position: fixed; top: 0; left: 0; width: 100%; height: 100px;
            background-color: white;
            display: flex; justify-content: space-between; align-items: center;
            padding: 0 20px;
        }
        header h1 { font-size: 18px; margin: 0; font-weight: bold; }
        .side-menu {
            position: fixed; top: 0; right: -500px; width: 500px; height: 100%;
            background-color: #57ACCB; color: white;
            padding: 20px; padding-top: 100px; box-sizing: border-box;
            transition: right 0.3s ease; font-size: 30px; z-index: 1002;
        }
        .side-menu li { list-style-type: none; margin-top: 20px; }
        .side-menu a { color: white; text-decoration: none; font-weight: bold; }
        .side-menu h2 { margin-top: 10px; }
        .side-menu.open { right: 0; }
        .menu-btn {
            position: fixed; top: 20px; right: 20px;
            font-size: 50px; background: none; border: none;
            color: black; cursor: pointer; z-index: 1001;
        }
        .modal {
            display: none; position: fixed; top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.6);
            justify-content: center; align-items: center;
        }
        .modal-content {
            background: white; border-radius: 15px; padding: 20px;
            width: 500px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); text-align: center;
        }
        .drop-zone {
            display: flex; justify-content: center; text-align: center;
            border: 2px dashed #ccc; border-radius: 15px;
            padding: 30px; background: #f9f9f9; cursor: pointer;
            transition: border-color 0.3s; gap: 30px; align-items: center;
            margin: 0 auto; line-height: 2;
        }
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
        .url-search button {
            padding: 10px 15px; border: none; border-radius: 10px;
            background: #6bb8e8; color: white; cursor: pointer;
        }
        .url-search button:hover { background: #5aa7d4; }
        .modal-content button {
            padding: 8px 16px; border: none; background-color: #6bb8e8;
            color: white; border-radius: 5px; cursor: pointer;
        }
        .modal-content button:hover { background-color: #5aa7d4; }
        .drop-zone.dragover { border-color: #6bb8e8; background: #f0f8ff; }
        .preview { margin-top: 18px; display: none; text-align: center; }
        .preview img {
            max-width: 100%; max-height: 280px; border-radius: 10px;
            box-shadow: 0 6px 18px rgba(0,0,0,.12);
        }
        .preview-name {
            margin: 8px 0 0; color:#666; font-size: 14px; word-break: break-all;
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
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList.jsp">게시판</a></li>
            <% if (loginUser != null) { %>
                <li>
                    <a href="<%=request.getContextPath()%>/logout?redirect=<%=request.getRequestURI() + (request.getQueryString() != null ? "?" + request.getQueryString() : "")%>">
                        로그아웃
                    </a>
                </li>
            <% } else { %>
                <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </div>

    <div class="center-container">
        <img src="<%=request.getContextPath()%>/data/mainIIllustration.png" alt="일러스트">
        <h1>LANDMARK SEARCH</h1>
        <button class="search-btn" id="searchBtn">Search</button>
    </div>

    <!-- 업로드 모달 -->
    <div class="modal" id="uploadModal">
        <div class="modal-content">
            <h2>이미지 검색</h2>
            <div class="drop-zone" id="dropZone">
                <img src="<%=request.getContextPath()%>/data/img-upload.png" class="drop-icon">
                <div class="drop-text">
                    여기로 이미지를 드래그하거나 <br>
                    <label for="fileUpload" class="file-label">파일을 업로드 하세요</label>
                </div>
                <input type="file" id="fileUpload" hidden>
            </div>

            <div class="divider">
                <span>또는</span>
            </div>

            <div class="url-search">
                <input type="text" id="imageUrl" placeholder="이미지 링크 붙여넣기">
                <button id="urlSearchBtn">검색</button>
            </div>

            <div class="preview">
                <img id="previewImg" alt="미리보기" />
                <p id="previewName" class="preview-name"></p>
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

        menuBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            sideMenu.classList.toggle('open');
        });

        document.addEventListener('click', (e) => {
            if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
                sideMenu.classList.remove('open');
            }
        });

        searchBtn.addEventListener('click', () => {
            uploadModal.style.display = 'flex';
        });

        uploadModal.addEventListener('click', (e) => {
            if (e.target === uploadModal) {
                uploadModal.style.display = 'none';
            }
        });

        function handleFile(file){
            if(!file) return;
            if(!file.type || !file.type.startsWith('image/')){
                alert('이미지 파일만 업로드 할 수 있습니다.');
                return;
            }
            const reader = new FileReader();
            reader.onload = () => {
                showPreview(reader.result, file.name);
            };
            reader.readAsDataURL(file);
        }

        async function handleUrl(url){
            try{
                const clean = url.trim();
                if(!clean) return;
                await loadImage(clean);
                showPreview(clean, clean);
            }catch(err){
                alert('이미지 URL을 불러오지 못했습니다. 주소를 확인해 주세요.');
                console.error(err);
            }
        }

        function loadImage(src){
            return new Promise((resolve, reject)=>{
                const img = new Image();
                img.onload = () => resolve();
                img.onerror = reject;
                img.crossOrigin = 'anonymous';
                img.src = src;
            });
        }

        function showPreview(src, name){
            previewImg.src = src;
            previewName.textContent = name || '';
            previewWrap.style.display = 'block';
        }

        ['dragenter','dragover'].forEach(evt=>{
            dropZone.addEventListener(evt, (e)=>{
                e.preventDefault(); e.stopPropagation();
                dropZone.classList.add('dragover');
            });
        });
        ['dragleave','drop'].forEach(evt=>{
            dropZone.addEventListener(evt, (e)=>{
                e.preventDefault(); e.stopPropagation();
                dropZone.classList.remove('dragover');
            });
        });
        dropZone.addEventListener('drop', (e)=>{
            const files = e.dataTransfer?.files;
            if(files && files.length) handleFile(files[0]);
        });

        fileInput.addEventListener('change', ()=>{
            if(fileInput.files && fileInput.files.length) handleFile(fileInput.files[0]);
        });

        urlSearchBtn.addEventListener('click', ()=>{
            handleUrl(imageUrlInput.value);
        });
    </script>
</body>
</html>
