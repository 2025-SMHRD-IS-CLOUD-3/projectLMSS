<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Post" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    Post post = (Post) request.getAttribute("post");
    
    // post가 null이면 리다이렉트
    if (post == null) {
        response.sendRedirect(request.getContextPath() + "/postList");
        return;
    }

    // 로그인한 유저와 글 작성자 비교
    boolean isOwner = false;
    Object loginMemberObj = session.getAttribute("memberId");
    if (loginMemberObj != null) {
        String loginMemberId = loginMemberObj.toString();
        String postMemberId = String.valueOf(post.getMemberId());
        isOwner = loginMemberId.equals(postMemberId);
    }
    
    // 로그인 상태 확인
    String loginUser = (String) session.getAttribute("loginUser");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<title>게시글 상세 - Landmark Search</title>
<style>
  :root{ --ink:#111; --muted:#f6f7f9; --line:#e6e6e8; --brand:#57ACCB; --shadow:0 10px 30px rgba(0,0,0,.08);}
  *{box-sizing:border-box}
  body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;color:var(--ink);background:#fff}

  header{position:fixed;top:0;left:0;width:100%;height:100px;background:#fff;
    display:flex;align-items:center;justify-content:space-between;padding:0 20px;z-index:1000;
    box-shadow:0 1px 0 rgba(0,0,0,.04)}
  header h2{margin:0;font-size:22px; cursor:pointer;}
  .menu-btn{position:fixed;top:20px;right:20px;font-size:50px;background:none;border:none;cursor:pointer}
  .side-menu{position:fixed;top:0;right:-500px;width:500px;height:100%;background:var(--brand);color:#fff;
    padding:20px;padding-top:100px;transition:right .3s ease;z-index:1001;font-size:30px}
  .side-menu.open{right:0}
  .side-menu ul{margin:0;padding:0}
  .side-menu li{list-style:none;margin:18px 0}
  .side-menu a{color:#fff;text-decoration:none;font-weight:700}

  .board{max-width:1000px;margin:140px auto 40px;background:var(--muted);border-radius:28px;padding:22px}
  .panel{background:#fff;border:1px solid var(--line);border-radius:22px;padding:26px;box-shadow:var(--shadow)}
  .title{margin:4px 0 16px;text-align:center;font-size:28px;font-weight:900}

  .post-meta{display:grid;grid-template-columns: repeat(4, 1fr);gap:10px;
    border:1px solid var(--line);border-radius:10px;padding:12px;margin-bottom:14px;font-size:14px;color:#555}
  .post-content{border:1px solid var(--line);border-radius:10px;padding:16px;line-height:1.8;color:#222;white-space:pre-wrap}

  .footer-bar{display:flex;justify-content:flex-end;align-items:center;margin-top:14px;gap:10px}
  .btn{background:#57ACCB;color:#fff;border:none;border-radius:12px;padding:12px 18px;font-weight:800;cursor:pointer}

  /* 댓글 스타일 */
  .comments{margin-top:28px;background:#fff;border:1px solid var(--line);border-radius:12px;padding:16px}
  .comments h3{margin:0 0 12px;font-size:18px}
  .comment-form{display:flex;flex-direction:column;gap:10px;margin-bottom:14px}
  .comment-form textarea{width:100%;border:1px solid var(--line);border-radius:8px;padding:10px;font-family:inherit;resize:vertical}
  .comment-form button{align-self:flex-end;padding:8px 14px;border:none;border-radius:8px;background:var(--brand);color:#fff;cursor:pointer;font-weight:700}
  .comment-item{border-top:1px dashed #d7d7da;padding:10px 0}
  .comment-meta{font-size:12px;color:#666;margin-bottom:4px}
  .comment-text{color:#222;line-height:1.5}
</style>
</head>
<body>
  <!-- Header -->
  <header>
      <h2 onclick="location.href='<%=request.getContextPath()%>/postList'">Landmark Search</h2>
      <div>
          <button class="menu-btn">≡</button>
      </div>    
  </header>
    
  <!-- Side Menu -->
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
  
  <!-- Body -->
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

    <!-- 댓글 섹션 -->
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
  </main>

<!-- JSP에서 JavaScript 변수 설정 -->
<script>
const CONTEXT_PATH = "<%=request.getContextPath()%>";
const POST_ID = <%= post.getPostId() %>;
const IS_LOGGED_IN = <%= session.getAttribute("loginUser") != null ? "true" : "false" %>;
</script>

<script>
// 사이드 메뉴
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

// 댓글 기능
const postId = POST_ID;

// 댓글 로드
async function loadComments() {
  const listEl = document.getElementById('commentsList');
  if (!listEl) return;
  
  listEl.innerHTML = '<div style="color:#777">불러오는 중...</div>';
  
  try {
    const res = await fetch(`${CONTEXT_PATH}/getReply?postId=${postId}`);
    if (!res.ok) throw new Error('댓글 로딩 실패');
    const replies = await res.json();
    renderComments(Array.isArray(replies) ? replies : []);
  } catch (err) {
    listEl.innerHTML = '<div style="color:#c00">댓글을 불러오지 못했습니다.</div>';
    console.error(err);
  }
}

// 댓글 렌더링
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
    const userName = get('MEMBER_NICKNAME') || '익명';
    const text = get('REPLY_CONTENT');
    const createdAt = (get('REPLY_DATE') || '').split(' ')[0];
    
    const item = document.createElement('div');
    item.className = 'comment-item';
    item.innerHTML = 
      '<div class="comment-meta">' + userName + (createdAt ? ' · <span>' + createdAt + '</span>' : '') + '</div>' +
      '<div class="comment-text">' + escapeHtml(text) + '</div>';
    listEl.appendChild(item);
  });
}

// HTML 이스케이프
function escapeHtml(str) {
  return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&#039;');
}

// 메시지 표시
function showMessage(message, type) {
  const messageDiv = document.createElement('div');
  let backgroundColor = '#4CAF50';
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

// 댓글 폼 제출
const commentForm = document.getElementById('commentForm');
if (commentForm) {
  commentForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const formData = new FormData(commentForm);
    const commentText = formData.get('commentText').trim();
    
    if (!commentText) {
      showMessage('댓글 내용을 입력해주세요.', 'error');
      return;
    }
    
    try {
      const params = new URLSearchParams();
      params.append('commentText', commentText);
      params.append('replyType', 'post');
      params.append('referenceId', postId);
      
      const res = await fetch(`${CONTEXT_PATH}/addReply`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
      });
      
      if (res.ok) {
        showMessage('댓글이 작성되었습니다.', 'success');
        commentForm.reset();
        loadComments();
      } else {
        const errorText = await res.text();
        showMessage('댓글 작성에 실패했습니다: ' + errorText, 'error');
      }
    } catch (err) {
      showMessage('댓글 작성 중 오류가 발생했습니다.', 'error');
      console.error(err);
    }
  });
}

// 게시글 삭제
function deletePost() {
  if (confirm('정말로 이 게시글을 삭제하시겠습니까?')) {
    // 삭제 로직 구현 필요
    alert('삭제 기능은 아직 구현되지 않았습니다.');
  }
}

// 페이지 로드 시 댓글 로드
document.addEventListener('DOMContentLoaded', () => {
  loadComments();
});
</script>
</body>
</html>
