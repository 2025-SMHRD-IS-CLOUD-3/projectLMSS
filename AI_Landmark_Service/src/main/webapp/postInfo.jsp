<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="model.Post" %>
<%@ page import="java.sql.*" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    Post post = (Post) request.getAttribute("post");
    String postIdStr = request.getParameter("id");

    if(post == null && postIdStr != null){
        int postId = Integer.parseInt(postIdStr);
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@project-db-campus.smhrd.com:1524:xe",
                "campus_24IS_CLOUD3_p2_2",
                "smhrd2"
            );

            String sql = "SELECT POST_ID, TITLE, POST_CONTENT, VIEWS, MEMBER_ID, POST_DATE, CATEGORIES FROM POST WHERE POST_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();

            if(rs.next()){
                post = new Post();
                post.setPostId(rs.getInt("POST_ID"));
                post.setTitle(rs.getString("TITLE"));
                post.setPostContent(rs.getString("POST_CONTENT"));
                post.setViews(rs.getInt("VIEWS"));
                post.setMemberId(rs.getInt("MEMBER_ID"));
                post.setPostDate(rs.getTimestamp("POST_DATE"));
                post.setCategories(rs.getString("CATEGORIES"));
            }

        } catch(Exception e){
            e.printStackTrace();
        } finally {
            if(rs != null) try{ rs.close(); } catch(Exception e){}
            if(pstmt != null) try{ pstmt.close(); } catch(Exception e){}
            if(conn != null) try{ conn.close(); } catch(Exception e){}
        }
    }

    // 로그인한 유저와 글 작성자 비교
    boolean isOwner = false;
    if (post != null) {
        Object loginMemberObj = session.getAttribute("memberId"); // 로그인 세션
        if (loginMemberObj != null) {
            String loginMemberId = loginMemberObj.toString();
            String postMemberId = String.valueOf(post.getMemberId());
            isOwner = loginMemberId.equals(postMemberId);
        }
    }
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

  /* 댓글 스타일 추가 */
  .comments{margin-top:28px;background:#fff;border:1px solid var(--line);border-radius:12px;padding:16px}
  .comments h3{margin:0 0 12px;font-size:18px}
  .comment-form{display:flex;flex-direction:column;gap:10px;margin-bottom:14px}
  .comment-form textarea{width:100%;border:1px solid var(--line);border-radius:8px;padding:10px;font-family:inherit;resize:vertical}
  .comment-form button{align-self:flex-end;padding:8px 14px;border:none;border-radius:8px;background:var(--brand);color:#fff;cursor:pointer;font-weight:700}
  .comment-item{border-top:1px dashed #d7d7da;padding:10px 0}
  .comment-meta{font-size:12px;color:#777;margin-bottom:6px}
  .comment-text{white-space:pre-wrap;line-height:1.5}
  .login-required{text-align:center;padding:20px;color:#666;background:#f8f9fa;border-radius:8px;border:1px solid #e9ecef}
  .login-required a{color:var(--brand);text-decoration:none;font-weight:600}
</style>
</head>
<body>
<header>
    <h2 onclick="location.href='postList.jsp'">Landmark Search</h2>
    <div><button class="menu-btn">≡</button></div>
</header>

<div class="side-menu" id="sideMenu">
    <ul>
        <li><a href="howLandmark.jsp">Landmark Search란?</a></li>
        <li><a href="main.jsp">사진으로 랜드마크 찾기</a></li>
        <li><a href="mapSearch.jsp">지도로 랜드마크 찾기</a></li>
        <li><a href="postList">게시판</a></li>
        <c:choose>
          <c:when test="${not empty sessionScope.loginUser}">
            <li><a href="logout.jsp">로그아웃</a></li>
            <li><a href="myProfile.jsp">마이페이지</a></li>
          </c:when>
          <c:otherwise>
            <li><a href="login.jsp?redirect=postList">로그인</a></li>
            <li><a href="register.jsp">회원가입</a></li>
          </c:otherwise>
        </c:choose>
    </ul>
</div>

<main class="board">
  <section class="panel">
    <h2 class="title"><%= (post != null ? post.getTitle() : "게시글") %></h2>

    <% if(post != null){ %>
      <div class="post-meta">
        <div><strong>카테고리</strong> : <%= post.getCategories() %></div>
        <div><strong>조회수</strong> : <%= post.getViews() %></div>
        <div><strong>작성일자</strong> : <%= post.getPostDate() %></div>
        <div><strong>작성자</strong> : <%= post.getMemberId() %></div>
      </div>
      <div class="post-content"><%= post.getPostContent() %></div>
    <% } else { %>
      <p>해당 게시글을 찾을 수 없습니다.</p>
    <% } %>

    <div class="footer-bar">
      <button class="btn" onclick="location.href='myProfile.jsp'">목록으로</button>
      <% if (post != null && isOwner) { %>
		<button class="btn" 
        onclick="location.href='${pageContext.request.contextPath}/postEdit?id=<%= post.getPostId() %>'">
    	수정
		</button>
        <form action="<%= request.getContextPath() %>/postEdit" method="post" style="display:inline;">
    	<input type="hidden" name="id" value="<%= post.getPostId() %>">
    	<input type="hidden" name="action" value="delete">
    	<button type="submit" class="btn" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
		</form>
      <% } %>
    </div>
  </section>

  <!-- 댓글 섹션 추가 -->
  <% if (post != null) { %>
  <section class="panel">
    <div id="commentSection" class="comments">
      <h3>댓글</h3>
      
      <% if (session.getAttribute("loginUser") != null) { %>
        <!-- 로그인한 사용자: 댓글 작성 폼 표시 -->
        <form id="commentForm" class="comment-form">
          <input type="hidden" name="referenceId" value="<%= post.getPostId() %>">
          <input type="hidden" name="replyType" value="post">
          <textarea name="commentText" id="commentText" rows="3" placeholder="댓글을 입력하세요" required></textarea>
          <button type="submit">댓글 작성</button>
        </form>
      <% } else { %>
        <!-- 로그인하지 않은 사용자: 로그인 안내 -->
        <div class="login-required">
          댓글을 작성하려면 <a href="<%=request.getContextPath()%>/login.jsp?redirect=postInfo.jsp?id=<%=post.getPostId()%>">로그인</a>이 필요합니다.
        </div>
      <% } %>
      
      <div id="commentsList"></div>
    </div>
  </section>
  <% } %>
</main>

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

// 댓글 기능 추가
<% if (post != null) { %>
const CONTEXT_PATH = "<%=request.getContextPath()%>";
const postId = <%= post.getPostId() %>;

// 댓글 로드
async function loadComments() {
  const listEl = document.getElementById('commentsList');
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
  if (!replies.length) {
    listEl.innerHTML = '<div style="color:#777">첫 댓글을 남겨보세요.</div>';
    return;
  }
  
  listEl.innerHTML = '';
  replies.forEach(r => {
    const get = (key) => r[key.toLowerCase()] || r[key.toUpperCase()] || '';
    const userName = get('MEMBER_NICKNAME') || '익명';
    const text = get('REPLY_CONTENT');
    const createdAt = (get('REPLY_DATE') || '').split(' ')[0]; // 날짜 부분만 사용
    
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
  messageDiv.style.cssText = `
    position: fixed; top: 20px; right: 20px; padding: 15px 20px; 
    border-radius: 8px; color: white; font-weight: 600; z-index: 10000;
    background-color: ${type === 'success' ? '#4CAF50' : '#f44336'};
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  `;
  messageDiv.textContent = message;
  document.body.appendChild(messageDiv);
  
  setTimeout(() => {
    messageDiv.remove();
  }, 3000);
}

// 댓글 폼 이벤트 리스너
const commentForm = document.getElementById('commentForm');
if (commentForm) {
  commentForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    
    const formData = new URLSearchParams({
      referenceId: postId,
      replyType: 'post',
      commentText: document.getElementById('commentText').value
    }).toString();

    try {
      const res = await fetch(`${CONTEXT_PATH}/addReply`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: formData
      });
      
      if (!res.ok) {
        const errorText = await res.text();
        throw new Error(errorText || '댓글 작성 실패');
      }
      
      commentForm.reset();
      await loadComments();
      
      // 성공 메시지 표시
      showMessage('댓글이 성공적으로 작성되었습니다.', 'success');
      
    } catch (err) {
      showMessage(err.message, 'error');
    }
  });
}

// 페이지 로드 시 댓글 로드
document.addEventListener('DOMContentLoaded', () => {
  loadComments();
});
<% } %>
</script>
</body>
</html>
