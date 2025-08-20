<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // 로그인 상태 확인
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
        body{ margin:0; font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; color:var(--ink); background:#fff; }
        header{ position:sticky; top:0; background:#fff; border-bottom:1px solid var(--line); z-index:10; }
        .hd-inner{ max-width:1080px; margin:0 auto; height:72px; display:flex; align-items:center; justify-content:space-between; padding:0 16px; }
        .logo{ font-weight:900; }
        .menu{ font-size:28px; }
        
        /* 사이드 메뉴 스타일 */
        .menu-btn{ 
            background:none; 
            border:none; 
            font-size:28px; 
            cursor:pointer; 
            padding:0; 
            margin:0; 
            color:var(--ink);
        }
        .side-menu{ 
            position:fixed; 
            top:0; 
            right:-500px; 
            width:500px; 
            height:100%; 
            background:var(--brand); 
            color:#fff; 
            padding:20px; 
            padding-top:100px; 
            transition:right .3s ease; 
            z-index:1001; 
            font-size:30px;
        }
        .side-menu.open{ right:0; }
        .side-menu ul{ margin:0; padding:0; }
        .side-menu li{ list-style:none; margin:18px 0; }
        .side-menu a{ color:#fff; text-decoration:none; font-weight:700; }
        
        .board{ max-width:1080px; margin:24px auto 40px; background:var(--muted); border-radius:28px; padding:20px; }
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
    </style>
</head>
<body>
    <header>
        <div class="hd-inner">
            <div class="logo">Landmark Search</div>
            <div><button class="menu-btn" aria-label="open side menu">≡</button></div>
        </div>
    </header>
    
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

    <script>
        /* ==============================
         * 0) 설정
         * ============================== */
        const CONTEXT_PATH = "<%=request.getContextPath()%>";

        // ❗ [수정] PostWriteServlet 경로로 수정
        function getWritePageUrl() {
            return CONTEXT_PATH + '/postWrite';
        }

        function getReadPageUrl(id) {
            return CONTEXT_PATH + '/postInfo?postId=' + encodeURIComponent(id);
        }

        /* ==============================
         * 1) 상태값
         * ============================== */
        let state = { page: 1, pageSize: 10, total: 0, keyword: '' };

        /* ==============================
         * 2) 도우미
         * ============================== */
        const $ = sel => document.querySelector(sel);
        function formatDate(d) {
            if(!d) return '';
            if(d.length>=10) return d.slice(0,10).replaceAll('-', '/');
            return d;
        }

        /* ==============================
         * 3) 사이드 메뉴 기능
         * ============================== */
        function initializeSideMenu() {
            const menuBtn = document.querySelector('.menu-btn');
            const sideMenu = document.getElementById('sideMenu');
            
            if (menuBtn && sideMenu) {
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
        }

        /* ==============================
         * 4) 검색 기능
         * ============================== */
        function performSearch() {
            const keyword = $('#keyword').value.trim();
            if (keyword) {
                // 검색어가 있으면 서버로 검색 요청
                location.href = CONTEXT_PATH + '/postList?keyword=' + encodeURIComponent(keyword);
            } else {
                // 검색어가 없으면 전체 목록으로
                location.href = CONTEXT_PATH + '/postList';
            }
        }

        /* ==============================
         * 5) 이벤트
         * ============================== */
        $('#btnSearch').addEventListener('click', performSearch);
        
        $('#keyword').addEventListener('keydown', (e) => {
            if(e.key==='Enter') performSearch();
        });
        
        $('#btnReset').addEventListener('click', () => {
            $('#keyword').value = '';
            location.href = CONTEXT_PATH + '/postList';
        });
        
        $('#btnWrite').addEventListener('click', () => {
            // 로그인 체크는 JSP에서 이미 처리됨
            location.href = getWritePageUrl();
        });

        /* ==============================
         * 6) 시작
         * ============================== */
        document.addEventListener('DOMContentLoaded', () => {
            // 사이드 메뉴 초기화
            initializeSideMenu();
            
            // 페이지 로드 시 검색어가 있으면 input에 표시
            const urlParams = new URLSearchParams(window.location.search);
            const keyword = urlParams.get('keyword');
            if (keyword) {
                $('#keyword').value = keyword;
            }
        });
    </script>
</body>
</html>
