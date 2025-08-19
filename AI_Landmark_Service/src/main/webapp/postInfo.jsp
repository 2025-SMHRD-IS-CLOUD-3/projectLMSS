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
      <% if (isOwner) { %>
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
</script>
</body>
</html>
