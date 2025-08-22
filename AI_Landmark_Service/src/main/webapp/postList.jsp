<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>게시판</title>
    <style>
        :root{ --ink:#111; --muted:#f6f7f9; --line:#e5e7eb; --brand:#57ACCB; --ink2:#555; }
        *{ box-sizing:border-box; }
        body { margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; height: 100vh; background-color: #ffffff; }

        header {
            position:fixed; top:0; left:0; width:100%; height:100px; background:#fff;
            display:flex; justify-content:space-between; align-items:center; padding:0 20px;
            z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04);
            font-size: 15px;
        }
        h2 a { text-decoration: none; color: inherit; }
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
    	.side-menu {
            position: fixed; top: 0; right: -500px; width: 500px;
            height: 100%; background-color: #57ACCB; color: white;
            padding: 20px; padding-top: 100px; box-sizing: border-box;
            transition: right 0.3s ease; font-size: 30px; z-index: 1001;
        }
    	.side-menu li { list-style-type: none; margin-top: 20px; }
    	.side-menu a { color: white; text-decoration: none; font-weight: bold; }
    	.side-menu.open { right: 0; }
    	.menu-btn { position: fixed; top: 20px; right: 20px; font-size: 50px; background: none; border: none; color: black; cursor: pointer; z-index: 1002; }

        .board {
            max-width:1080px;
            margin:130px auto 50px;
            background:var(--muted);
            border-radius:28px;
            padding:20px;
        }
        .paper{ background:#fff; border:1px solid var(--line); border-radius:22px; padding:16px; }
        .title{ text-align:center; font-size:22px; font-weight:900; margin:4px 0 18px; }
        .toolbar{ display:flex; gap:8px; align-items:center; justify-content:space-between; margin:4px 0 10px; }
        .searchbox{ display:flex; gap:8px; align-items:center; }
        .searchbox input{ width:240px; padding:8px 10px; border:1px solid var(--line); border-radius:8px; }
        .btn{ background:var(--brand); color:#fff; border:none; border-radius:20px; padding:10px 16px; font-weight:800; cursor:pointer; }
        .btn:disabled{ opacity:.55; cursor:not-allowed; }
        .table-wrap{ overflow:auto; border:1px solid var(--line); border-radius:12px; }
        table{ width:100%; border-collapse:collapse; }
        thead th{ background:#eef7fb; border-bottom:1px solid var(--line); padding:12px 10px; white-space:nowrap; font-size:14px; }
        tbody td{ border-bottom:1px solid var(--line); padding:12px 10px; font-size:14px; color:#222; }
        tbody tr:hover{ background:#f9fbfc; cursor:pointer; }
        .col-no{ width:70px; text-align:center; color:#444; }
        .col-cat{ width:140px; text-align:center; color:#444; }
        .col-title{ min-width:340px; }
        .col-views{ width:90px; text-align:right; color:#444; }
        .col-date{ width:130px; text-align:center; color:#444; white-space:nowrap; }
        .col-writer{ width:120px; text-align:center; color:#444; }
        .pager{ display:flex; justify-content:center; align-items:center; gap:10px; margin:14px 0 4px; }
        .pager button{ min-width:36px; height:36px; border:1px solid var(--line); background:#fff; border-radius:10px; cursor:pointer; }
        .pager button[aria-current="true"]{ background:var(--brand); color:#fff; border-color:var(--brand); font-weight:800; }
        @media (max-width: 680px){
            .searchbox input{ width:170px; }
            .col-cat{ display:none; }
            .col-writer{ display:none; }
            .side-menu{ width:100%; right:-100%; }
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
    <button class="menu-btn" aria-label="open side menu">≡</button>

    <div class="side-menu" id="sideMenu">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>
            <% if (loginUser != null) { %>
                <li><a href="<%=request.getContextPath()%>/logout">로그아웃</a></li>
                <li><a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
            <% } else { %>
                <li><a href="<%=request.getContextPath()%>/login.jsp">로그인</a></li>
                <li><a href="<%=request.getContextPath()%>/register.jsp">회원가입</a></li>
            <% } %>
        </ul>
    </div>
    <main class="board">
        <div class="paper">
            <h1 class="title">게시판</h1>

            <div class="toolbar">
                <div class="searchbox">
                    <input id="keyword" placeholder="제목/내용/작성자 검색" value="${keyword}" />
                    <button class="btn" id="btnSearch">검색</button>
                    <button id="btnReset" style="border:1px solid var(--line); background:#fff; border-radius:20px; padding:8px 14px; cursor:pointer;">초기화</button>
                </div>
                <c:choose>
                    <c:when test="${empty sessionScope.loginUser}">
                        <button class="btn" id="btnWrite" onclick="location.href='${pageContext.request.contextPath}/login.jsp'">로그인 후 글쓰기</button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn" id="btnWrite" onclick="location.href='${pageContext.request.contextPath}/postWrite'">게시글 작성</button>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th class="col-no">목록</th>
                            <th class="col-cat">카테고리</th>
                            <th class="col-title">제목</th>
                            <th class="col-views">조회수</th>
                            <th class="col-date">작성일자</th>
                            <th class="col-writer">작성자</th>
                        </tr>
                    </thead>
                    <tbody id="tbody">
                        <c:choose>
                            <c:when test="${empty postList}">
                                <tr><td colspan="6" style="text-align:center; color:var(--ink2); padding:22px;">게시글이 없습니다.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="post" items="${postList}" varStatus="status">
                                    <tr onclick="location.href='${pageContext.request.contextPath}/postInfo?postId=${post.postId}'">
                                        <td class="col-no">${postList.size() - status.index}</td>
                                        <td class="col-cat">${post.categories}</td>
                                        <td class="col-title">${post.title}</td>
                                        <td class="col-views">${post.views}</td>
                                        <td class="col-date">
                                            <fmt:formatDate value="${post.postDate}" pattern="yyyy/MM/dd"/>
                                        </td>
                                        <td class="col-writer">${post.nickname}</td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <div class="pager" id="pager" aria-label="페이지네이션"></div>
        </div>
    </main>

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

        const CONTEXT_PATH = "<%=request.getContextPath()%>";

        function getWritePageUrl() {
            return CONTEXT_PATH + '/postWrite';
        }

        function getReadPageUrl(id) {
            return CONTEXT_PATH + '/postInfo?postId=' + encodeURIComponent(id);
        }

        function initializeSideMenu() {
            const menuBtn  = document.querySelector('.menu-btn');
            const sideMenu = document.getElementById('sideMenu');
            if (!menuBtn || !sideMenu) return;

            menuBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                sideMenu.classList.toggle('open');
            });

            document.addEventListener('click', (e) => {
                if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
                    sideMenu.classList.remove('open');
                }
            });
        }

        function performSearch() {
            const keyword = (document.querySelector('#keyword')?.value || '').trim();
            if (keyword) {
                location.href = CONTEXT_PATH + '/postList?keyword=' + encodeURIComponent(keyword);
            } else {
                location.href = CONTEXT_PATH + '/postList';
            }
        }

        function paginateBoard(tbodyId, pagerId, rowsPerPage) {
            const tbody = document.getElementById(tbodyId);
            const pager = document.getElementById(pagerId);
            if (!tbody || !pager) return;

            const allRows = Array.from(tbody.querySelectorAll('tr'));

            const isEmptyList =
                allRows.length === 1 &&
                allRows[0].querySelector('td[colspan]');

            if (isEmptyList || allRows.length === 0) {
                pager.style.display = 'none';
                return;
            }

            let currentPage = 1;
            const totalPages = Math.ceil(allRows.length / rowsPerPage);

            if (totalPages <= 1) {
                pager.style.display = 'none';
                return;
            } else {
                pager.style.display = '';
            }

            function renderPage() {
                allRows.forEach(tr => (tr.style.display = 'none'));

                const start = (currentPage - 1) * rowsPerPage;
                const end   = Math.min(start + rowsPerPage, allRows.length);
                for (let i = start; i < end; i++) {
                    allRows[i].style.display = '';
                }

                drawPager();
            }

            function button(label, page, { disabled = false, current = false } = {}) {
                const b = document.createElement('button');
                b.type = 'button';
                b.textContent = label;
                if (disabled) b.disabled = true;
                if (current)  b.setAttribute('aria-current', 'true');
                b.addEventListener('click', () => {
                    if (page < 1 || page > totalPages) return;
                    currentPage = page;
                    renderPage();
                });
                return b;
            }

            function drawPager() {
                pager.innerHTML = '';

                pager.appendChild(button('≪', 1, { disabled: currentPage === 1 }));
                pager.appendChild(button('〈', currentPage - 1, { disabled: currentPage === 1 }));

                const windowSize = 7;
                let start = Math.max(1, currentPage - Math.floor(windowSize / 2));
                let end   = start + windowSize - 1;
                if (end > totalPages) {
                    end = totalPages;
                    start = Math.max(1, end - windowSize + 1);
                }
                for (let p = start; p <= end; p++) {
                    pager.appendChild(button(String(p), p, { current: p === currentPage }));
                }

                pager.appendChild(button('〉', currentPage + 1, { disabled: currentPage === totalPages }));
                pager.appendChild(button('≫', totalPages, { disabled: currentPage === totalPages }));
            }

            renderPage();
        }

        document.addEventListener('DOMContentLoaded', () => {
            initializeSideMenu();

            document.getElementById('btnSearch')?.addEventListener('click', performSearch);
            document.getElementById('keyword')?.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') performSearch();
            });
            document.getElementById('btnReset')?.addEventListener('click', () => {
                const $kw = document.getElementById('keyword');
                if ($kw) $kw.value = '';
                location.href = CONTEXT_PATH + '/postList';
            });
            document.getElementById('btnWrite')?.addEventListener('click', () => {
                location.href = getWritePageUrl();
            });

            const urlParams = new URLSearchParams(window.location.search);
            const keyword = urlParams.get('keyword');
            if (keyword && document.getElementById('keyword')) {
                document.getElementById('keyword').value = keyword;
            }

            paginateBoard('tbody', 'pager', 10);
        });
    </script>
</body>
</html>