<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Post" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    Post post = (Post) request.getAttribute("post");

    if (post == null) {
        response.sendRedirect(request.getContextPath() + "/postList");
        return;
    }

    boolean isOwner = false;
    Object loginMemberObj = session.getAttribute("memberId");
    String loginMemberId = null;

    if (loginMemberObj != null) {
        // memberId가 int 타입이라고 가정하고 String으로 변환하여 사용합니다.
        // 자바스크립트와의 일관성을 위해 String으로 변환
        loginMemberId = String.valueOf(loginMemberObj);
        String postMemberId = String.valueOf(post.getMemberId());
        isOwner = loginMemberId.equals(postMemberId);
    }

    String loginUser = (String) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>게시글 상세 - Landmark Search</title>
    <style>
        /* 기존 스타일과 main.jsp 스타일 통합 */
        :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08);}
        *{box-sizing:border-box}
        body { margin: 0; font-family:system-ui,-apple-system, Segoe UI, Roboto, Arial, sans-serif; background-color: #ffffff; }
        header { position:fixed; top:0; left:0; width:100%; height:100px; background:#fff; display:flex; justify-content:space-between; align-items:center; padding:0 20px; z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04); }
        h2 a { text-decoration: none; color: inherit; }
        .side-menu { position: fixed; top: 0; right: -500px; width: 500px; height: 100%; background-color: #57ACCB; color: white; padding: 20px; padding-top: 100px; box-sizing: border-box; transition: right 0.3s ease; font-size: 30px; z-index: 1001; }
        .side-menu li { list-style-type: none; margin-top: 20px; }
        .side-menu a { color: white; text-decoration: none; font-weight: bold; }
        .side-menu.open { right: 0; }
        .menu-btn { position: fixed; top: 20px; right: 20px; font-size: 50px; background: none; border: none; color: black; cursor: pointer; z-index: 1002; }
        .board{ max-width:1000px; margin:140px auto 40px; background:var(--muted); border-radius:28px; padding:22px; }
        .panel{ background:#fff; border:1px solid var(--line); border-radius:22px; padding:26px; box-shadow:var(--shadow); }
        .title{ margin:4px 0 16px; text-align:center; font-size:28px; font-weight:900; }
        .post-meta{ display:grid; grid-template-columns: repeat(4, 1fr); gap:10px; border:1px solid var(--line); border-radius:10px; padding:12px; margin-bottom:14px; font-size:14px; color:#555; }
        .post-content{ border:1px solid var(--line); border-radius:10px; padding:16px; line-height:1.8; color:#222; white-space:pre-wrap; }
        .footer-bar{ display:flex; justify-content:flex-end; align-items:center; margin-top:14px; gap:10px; }
        .btn{ background:#57ACCB; color:#fff; border:none; border-radius:12px; padding:12px 18px; font-weight:800; cursor:pointer; }
        .comments{ margin-top:28px; background:#fff; border:1px solid var(--line); border-radius:12px; padding:16px; }
        .comments h3{ margin:0 0 12px; font-size:18px; }
        .comment-form{ display:flex; flex-direction:column; gap:10px; margin-bottom:14px; }
        .comment-form textarea{ width:100%; border:1px solid var(--line); border-radius:8px; padding:10px; font-family:inherit; resize:vertical; }
        .comment-form button{ align-self:flex-end; padding:8px 14px; border:none; border-radius:8px; background:var(--brand); color:#fff; cursor:pointer; font-weight:700; }
        .comment-item{ border-top:1px dashed #d7d7da; padding:10px 0; position: relative; }
        .comment-meta{ font-size:12px; color:#666; margin-bottom:4px; }
        .comment-text{ color:#222; line-height:1.5; }
        .comment-delete-btn{ position:absolute; top:10px; right:0; padding:2px 6px; font-size:12px; background:#f44336; color:#fff; border:none; border-radius:4px; cursor:pointer; }
        #headerImage{ height: 80%; width: auto; display: flex; justify-content: center; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }

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
    <section class="panel">
        <h1 class="title"><%= post.getTitle() %></h1>

        <div class="post-meta">
            <div>카테고리: <%= post.getCategories() %></div>
            <div>작성자: <%= post.getNickname() != null ? post.getNickname() : "익명" %></div>
            <div>조회수: <%= post.getViews() %></div>
            <div>작성일: <fmt:formatDate value="<%= post.getPostDate() %>" pattern="yyyy/MM/dd HH:mm"/></div>
        </div>

        <div class="post-content"><%= post.getPostContent() %></div>

        <div class="footer-bar">
            <button class="btn" onclick="location.href='<%=request.getContextPath()%>/postList'">목록</button>
            <% if (isOwner) { %>
            <button class="btn" onclick="location.href='<%=request.getContextPath()%>/postEdit?postId=<%= post.getPostId() %>'">수정</button>
            <button class="btn" onclick="deletePost()">삭제</button>
            <% } %>
        </div>
    </section>

    <section class="comments">
        <h3>댓글</h3>
        <% if (loginUser != null) { %>
        <form class="comment-form" id="commentForm">
            <textarea name="commentText" placeholder="댓글을 입력하세요..." rows="3" required></textarea>
            <input type="hidden" name="replyType" value="post" />
            <input type="hidden" name="referenceId" value="<%= post.getPostId() %>" />
            <button type="submit">댓글 작성</button>
        </form>
        <% } else { %>
        <p style="text-align:center;color:#666;margin:20px 0;">
            댓글을 작성하려면 <a href="<%=request.getContextPath()%>/login.jsp" style="color:var(--brand);">로그인</a>이 필요합니다.
        </p>
        <% } %>
        <div id="commentsList"></div>
    </section>

    <form id="deleteForm" action="<%=request.getContextPath()%>/postEdit" method="post" style="display:none">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="postId" value="<%= post.getPostId() %>">
    </form>
</main>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
<script>
    const CONTEXT_PATH = "<%=request.getContextPath()%>";
    const POST_ID = <%= post.getPostId() %>;
    const IS_LOGGED_IN = <%= session.getAttribute("memberId") != null ? "true" : "false" %>;
    const LOGIN_MEMBER_ID = "<%= loginMemberId != null ? loginMemberId : "" %>";

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

    const menuBtn = document.querySelector('.menu-btn');
    const sideMenu = document.getElementById('sideMenu');
    menuBtn.addEventListener('click', e => {
        e.stopPropagation();
        sideMenu.classList.toggle('open');
    });
    document.addEventListener('click', e => {
        if (!sideMenu.contains(e.target) && !menuBtn.contains(e.target)) {
            sideMenu.classList.remove('open');
        }
    });

    async function loadComments() {
        const listEl = document.getElementById('commentsList');
        if (!listEl) return;
        listEl.innerHTML = '<div style="color:#777">불러오는 중...</div>';

        try {
            const res = await fetch(CONTEXT_PATH + '/getReply?postId=' + POST_ID);
            if (!res.ok) throw new Error('댓글 로딩 실패');
            const replies = await res.json();
            renderComments(Array.isArray(replies) ? replies : []);
        } catch(err) {
            listEl.innerHTML = '<div style="color:#c00">댓글을 불러오지 못했습니다.</div>';
            console.error(err);
        }
    }

    function renderComments(replies) {
        const listEl = document.getElementById('commentsList');
        if (!listEl) return;

        if (!replies.length) {
            listEl.innerHTML = '<div style="color:#777">첫 댓글을 남겨보세요.</div>';
            return;
        }

        listEl.innerHTML = '';
        replies.forEach(r => {
            const get = (key) => r[key.toLowerCase()] || r[key.toUpperCase()] || '';
            const commentId = get('REPLY_ID');
            const memberId = get('MEMBER_ID');
            const userName = get('MEMBER_NICKNAME') || '익명';
            const text = get('REPLY_CONTENT');
            const createdAt = (get('REPLY_DATE') || '').split(' ')[0];

            const item = document.createElement('div');
            item.className = 'comment-item';
            let html = '<div class="comment-meta">' + userName;
            if(createdAt) html += ' · <span>' + createdAt + '</span>';
            html += '</div>';
            html += '<div class="comment-text">' + escapeHtml(text) + '</div>';

            if(IS_LOGGED_IN && LOGIN_MEMBER_ID === String(memberId)){
                html += '<button class="comment-delete-btn" onclick="deleteComment(' + commentId + ')">삭제</button>';
            }

            item.innerHTML = html;
            listEl.appendChild(item);
        });
    }

    function escapeHtml(str) {
        return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#039;');
    }

    function showMessage(message, type){
        const messageDiv = document.createElement('div');
        let backgroundColor = type === 'error' ? '#f44336' : '#4CAF50';
        messageDiv.style.cssText = 'position: fixed; top: 20px; right: 20px; padding: 15px 20px; border-radius: 8px; color: white; font-weight: 600; z-index: 10000; background-color:' + backgroundColor + '; box-shadow: 0 4px 12px rgba(0,0,0,0.15);';
        messageDiv.textContent = message;
        document.body.appendChild(messageDiv);
        setTimeout(() => { messageDiv.remove() }, 3000);
    }

    const commentForm = document.getElementById('commentForm');
    if(commentForm){
        commentForm.addEventListener('submit', async e => {
            e.preventDefault();
            const formData = new FormData(commentForm);
            const commentText = formData.get('commentText').trim();
            if(!commentText){ showMessage('댓글 내용을 입력해주세요.', 'error'); return; }
            try{
                const params = new URLSearchParams();
                params.append('commentText', commentText);
                params.append('replyType', 'post');
                params.append('referenceId', POST_ID);
                const res = await fetch(CONTEXT_PATH + '/addReply', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params });
                if(res.ok){ showMessage('댓글이 작성되었습니다.', 'success'); commentForm.reset(); loadComments(); }
                else { const errorText = await res.text(); showMessage('댓글 작성에 실패했습니다: ' + errorText, 'error'); }
            } catch(err){ showMessage('댓글 작성 중 오류가 발생했습니다.', 'error'); console.error(err); }
        });
    }

    function deletePost(){
        if(!confirm('정말로 이 게시글을 삭제하시겠습니까?')) return;
        document.getElementById('deleteForm').submit();
    }

    async function deleteComment(commentId){
        if(!confirm('정말로 이 댓글을 삭제하시겠습니까?')) return;
        try{
            const params = new URLSearchParams();
            params.append('commentId', commentId);
            const res = await fetch(CONTEXT_PATH + '/deleteReply', { method: 'POST', headers: { 'Content-Type': 'application/x-www-form-urlencoded' }, body: params });
            if(res.ok){ showMessage('댓글이 삭제되었습니다.', 'success'); loadComments(); }
            else { const errorText = await res.text(); showMessage('댓글 삭제에 실패했습니다: ' + errorText, 'error'); }
        } catch(err){ showMessage('댓글 삭제 중 오류가 발생했습니다.', 'error'); console.error(err); }
    }

    document.addEventListener('DOMContentLoaded', () => { loadComments(); });
</script>
</body>
</html>