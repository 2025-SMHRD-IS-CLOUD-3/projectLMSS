<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    // 로그인 체크
    String loginUser = (String) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // DB에서 회원 정보 및 게시글 가져오기
    Integer loginMemberId = null;
    String userEmail = "";
    List<Map<String, Object>> postList = new ArrayList<>();
    List<Map<String, Object>> replyList = new ArrayList<>();
    List<Map<String, Object>> favoriteList = new ArrayList<>(); // 즐겨찾기 리스트 선언

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

        // 회원 정보 가져오기
        String sqlMember = "SELECT MEMBER_ID, EMAIL FROM MEMBER WHERE ID = ?";
        pstmt = conn.prepareStatement(sqlMember);
        pstmt.setString(1, loginUser);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            loginMemberId = rs.getInt("MEMBER_ID");
            userEmail = rs.getString("EMAIL");
        }
        rs.close();
        pstmt.close();

        // 회원이 작성한 게시글 가져오기
        if (loginMemberId != null) {
            String sqlPosts = "SELECT POST_ID, TITLE, VIEWS, POST_DATE FROM POST WHERE MEMBER_ID = ? ORDER BY POST_DATE DESC";
            pstmt = conn.prepareStatement(sqlPosts);
            pstmt.setInt(1, loginMemberId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("POST_ID"));
                row.put("title", rs.getString("TITLE"));
                row.put("views", rs.getInt("VIEWS"));
                row.put("post_date", rs.getTimestamp("POST_DATE"));
                postList.add(row);
            }
            rs.close();
            pstmt.close();
        }

     // 회원이 작성한 댓글 가져오기 (게시판 + 정보페이지 둘 다)
        if (loginMemberId != null) {
        	// 수정된 SQL 쿼리
        	String sqlReplies =
        	    "SELECT * FROM ( " +
        	    "   SELECT R.REPLY_ID, R.REPLY_CONTENT, R.REPLY_DATE, " +
        	    "          P.TITLE AS TARGET_TITLE, R.POST_ID AS TARGET_ID, " +
        	    "          '게시판' AS TARGET_TYPE, " +
        	    "          NULL AS LANDMARK_NAME " + // 랜드마크 이름이 없으므로 NULL 추가
        	    "   FROM REPLY R " +
        	    "   JOIN POST P ON R.POST_ID = P.POST_ID " +
        	    "   WHERE R.MEMBER_ID = ? " +
        	    "   UNION ALL " +
        	    "   SELECT R.REPLY_ID, R.REPLY_CONTENT, R.REPLY_DATE, " +
        	    "          L.LANDMARK_NAME AS TARGET_TITLE, R.LANDMARK_ID AS TARGET_ID, " +
        	    "          '정보페이지' AS TARGET_TYPE, " +
        	    "          L.LANDMARK_NAME AS LANDMARK_NAME " + // 랜드마크 이름 추가
        	    "   FROM REPLY R " +
        	    "   JOIN LANDMARK L ON R.LANDMARK_ID = L.LANDMARK_ID " +
        	    "   WHERE R.MEMBER_ID = ? " +
        	    ") ORDER BY REPLY_DATE DESC";
            pstmt = conn.prepareStatement(sqlReplies);
            pstmt.setInt(1, loginMemberId);
            pstmt.setInt(2, loginMemberId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("reply_id", rs.getInt("REPLY_ID"));
                row.put("reply_content", rs.getString("REPLY_CONTENT"));
                row.put("reply_date", rs.getTimestamp("REPLY_DATE"));
                row.put("post_title", rs.getString("TARGET_TITLE"));
                row.put("post_id", rs.getInt("TARGET_ID"));
                row.put("post_type", rs.getString("TARGET_TYPE")); // 게시판/정보페이지 구분
                row.put("landmark_name", rs.getString("LANDMARK_NAME")); // 랜드마크 이름 추가
                replyList.add(row);
            }
            rs.close();
            pstmt.close();
        }

     // 회원이 즐겨찾기한 랜드마크 가져오기
        if (loginMemberId != null) {
            String sqlFavorites =
                "SELECT * FROM (" +
                "    SELECT L.LANDMARK_ID, L.LANDMARK_NAME, I.IMAGE_URL, " +
                "    ROW_NUMBER() OVER(PARTITION BY L.LANDMARK_ID ORDER BY CASE WHEN I.IMAGE_TYPE = 'thumbnail' THEN 1 ELSE 2 END, I.IMAGE_ID ASC) AS RN " +
                "    FROM FAVORITES F " +
                "    JOIN LANDMARK L ON F.LANDMARK_ID = L.LANDMARK_ID " +
                "    JOIN LANDMARK_IMAGE I ON L.LANDMARK_ID = I.LANDMARK_ID " +
                "    WHERE F.MEMBER_ID = ?" +
                ") WHERE RN = 1";
            
            pstmt = conn.prepareStatement(sqlFavorites);
            pstmt.setInt(1, loginMemberId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("LANDMARK_ID"));
                row.put("name", rs.getString("LANDMARK_NAME"));
                row.put("thumbnail", rs.getString("IMAGE_URL"));
                favoriteList.add(row);
            }
            rs.close();
            pstmt.close();
        }

    } catch(Exception e){ 
        e.printStackTrace(); 
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    // 날짜 포맷 미리 선언
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  	<meta charset="utf-8" />
  	<meta name="viewport" content="width=device-width, initial-scale=1" />
  	<title>마이페이지</title>
  	<style>
	    /* 기존 CSS 그대로 유지 */
	    :root { --ink:#111; --muted:#f6f6f8; --line:#e6e6e8; --brand:#57ACCB; --tab:#cfdfea; --tab-active:#2f87ad; }
	    *{box-sizing:border-box;}
	    html,body{height:100%; margin:0; font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; color:var(--ink); background:#fff;}
	    header {
            position:fixed; top:0; left:0; width:100%; height:100px; background:#fff;
            display:flex; justify-content:space-between; align-items:center; padding:0 20px;
            z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04);
        }
        h2 a {
		  text-decoration: none;
		  color: inherit;
		}
        .menu-btn { position: fixed; top: 20px; right: 20px; font-size: 50px; background: none; border: none; color: black; cursor: pointer; z-index: 1002; }
        .side-menu{ 
        	position: fixed; top: 0; right: -500px; width: 500px;
        	height: 100%; background-color: #57ACCB; color: white; 
        	padding: 20px; padding-top: 100px; box-sizing: border-box; 
        	transition: right 0.3s ease; font-size: 30px; z-index: 1001; }
        .side-menu li { list-style-type: none; margin-top: 20px; }
        .side-menu a { color: white; text-decoration: none; font-weight: bold; }
        .side-menu.open { right: 0; }
        .side-menu a{color:#fff;text-decoration:none;font-weight:700;display:block;margin:14px 0}
	    @media (max-width:920px){.side-menu{ width:85vw; right:-85vw; }}
	    .paper{max-width:760px; margin:140px auto 60px; background:var(--muted); border-radius:28px; padding:28px;}
	    .blk{background:#fff; border:1px solid var(--line); border-radius:16px; padding:22px; margin-bottom:20px; box-shadow:0 4px 14px rgba(0,0,0,.06);}
	    .tabs{display:flex; gap:14px; margin-bottom:16px;}
	    .tabs button{border:0; background:var(--tab); color:#456; padding:12px 18px; border-radius:999px; font-weight:900; cursor:pointer;}
	    .tabs button[aria-selected="true"]{ background:var(--tab-active); color:#fff; }
	    .table{width:100%; border-collapse:collapse; font-size:14px;}
	    .table th,.table td{border:1px solid var(--line); padding:12px 10px; text-align:left; background:#fff;}
	    .table th{background:#a5cfe2; color:#fff; font-weight:900;}
	    .table thead th{background:#74b5cf;}
	    .table td.num, .table th.num{width:80px; text-align:center;}
	    .table td.center{ text-align:center; }
	    .fav-grid{display:grid; grid-template-columns:repeat(5, 1fr); gap:12px;}
	    .fav-card{border:1px solid var(--line); border-radius:12px; background:#fff; padding:10px; cursor:pointer;}
	    .fav-card .thumb{width:100%; height:90px; border-radius:8px; object-fit:cover; background:#eee; border:1px solid var(--line);}
	    .fav-card .name{margin-top:8px; font-weight:700; font-size:14px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;}
	    .form{max-width:680px; margin:10px auto 0;}
	    .form-row{margin:18px 0;}
	    .label{display:block; margin-bottom:8px; font-weight:800;}
	    .input{width:100%; height:48px; border:1px solid var(--line); border-radius:999px; padding:0 16px; font-size:15px;}
	    .actions{display:flex; align-items:center; justify-content:space-between; margin-top:18px;}
	    .link-danger{color:#e14a4a; text-decoration:none; font-weight:800;}
	    .btn{border:0; background:var(--brand); color:#fff; padding:12px 18px; border-radius:999px; font-weight:900; cursor:pointer;}
	    .hint{font-size:12px; color:#666;}
	    [hidden]{display:none !important;}
	
	    /* 날짜 한 줄로 표시 */
	    #tbl-posts th:nth-child(4),
	    #tbl-posts td:nth-child(4),
	    #tbl-comments th:nth-child(4),
	    #tbl-comments td:nth-child(4) {
	        white-space: nowrap;
	    }
	    #headerImage{
			height: 100%;
			width: 500px;
			display: flex;
		    justify-content: center;
		    position: absolute;
		    top: 50%;
		    left: 50%;
		    transform: translate(-50%, -50%);
		}
  	</style>
</head>
<body>
  <header>
        <h2><a href="<%=request.getContextPath()%>/main.jsp">Landmark Search</a></h2>
        <img src="./image/headerImage.png" alt="MySite Logo" id="headerImage">
    </header>
        <button class="menu-btn" aria-label="메뉴">≡</button>

  <aside class="side-menu" id="sideMenu">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/postList">게시판</a></li>
            <li><a href="<%=request.getContextPath()%>/logout">로그아웃</a></li>
            <li><a href="<%=request.getContextPath()%>/myProfile.jsp">마이페이지</a></li>
        </ul>
    </aside>

  <main class="paper">
    <nav class="tabs" role="tablist" aria-label="마이페이지 상단 탭">
      <button id="tab-activity" role="tab" aria-selected="true">활동 내역</button>
      <button id="tab-profile"  role="tab" aria-selected="false">회원 정보 수정</button>
    </nav>

    <section id="panel-activity" role="tabpanel" aria-labelledby="tab-activity" class="blk">
      <h3>내 게시글</h3>
      <table class="table" id="tbl-posts">
        <thead>
          <tr>
            <th class="num">목록</th>
            <th>제목</th>
            <th class="num">조회수</th>
            <th class="num">작성일자</th>
            <th class="num">작성자</th>
          </tr>
        </thead>
        <tbody>
          <%
            int idx = 1;
            for (Map<String, Object> post : postList) {
          %>
          <tr>
            <td class="num"><%= idx++ %></td>
            <td>
              <a href="postInfo?postId=<%= post.get("id") %>&source=mypage">
                <%= post.get("title") %>
              </a>
            </td>
            <td class="num"><%= post.get("views") %></td>
            <td class="num"><%= sdf.format(post.get("post_date")) %></td>
            <td class="num"><%= loginUser %></td>
          </tr>
          <%
            }
            if (postList.size() == 0) {
          %>
          <tr><td colspan="5" class="center">작성한 게시글이 없습니다.</td></tr>
          <%
            }
          %>
        </tbody>
      </table>

      <h3 style="margin-top:28px;">내 댓글</h3>
      <table class="table" id="tbl-comments">
        <thead>
          <tr>
            <th class="num">목록</th>
            <th>제목 / 댓글 내용</th>
            <th>정보</th>
            <th class="num">작성일자</th>
            <th class="num">작성자</th>
          </tr>
        </thead>
        <tbody>
<%
    int cidx = 1;
    for (Map<String, Object> reply : replyList) {
        Integer postId = (Integer) reply.get("post_id");
        String postTitle = (String) reply.get("post_title");
        String postType = (String) reply.get("post_type");
        String landmarkName = (String) reply.get("landmark_name"); // 저장된 랜드마크 이름 가져오기

        if (postId == null || postTitle == null) continue;
%>
<tr>
    <td class="num"><%= cidx++ %></td>
    <td>
        <a href="<%= "정보페이지".equals(postType)
                   ? "landmarkInfo.jsp?name=" + java.net.URLEncoder.encode(landmarkName, "UTF-8")
                   : "postInfo?postId=" + postId + "&source=mypage" %>">
            <%= postTitle %>
        </a> / <%= reply.get("reply_content") %>
    </td>
    <td><%= postType %></td>
    <td class="num"><%= sdf.format(reply.get("reply_date")) %></td>
    <td class="num"><%= loginUser %></td>
</tr>
<%
    }
    if (cidx == 1) {
%>
<tr><td colspan="5" class="center">작성한 댓글이 없습니다.</td></tr>
<%
    }
%>
</tbody>
        
      </table>

      <h3 style="margin-top:28px;">즐겨찾기</h3>
<table class="table" id="tbl-favorites">
  <thead>
    <tr>
      <th class="num">목록</th>
      <th>랜드마크 이름</th>
      <th class="num">썸네일</th>
    </tr>
  </thead>
  <!-- 기존 즐겨찾기 테이블 tbody 부분만 수정 -->
<tbody>
<%
  int favIdx = 1;
  if (favoriteList == null || favoriteList.isEmpty()) {
%>
  <tr><td colspan="3" class="center">즐겨찾기한 랜드마크가 없습니다.</td></tr>
<%
  } else {
    for (Map<String, Object> fav : favoriteList) {
      Integer landmarkId = (Integer) fav.get("id");
      String landmarkName = (String) fav.get("name");
      String thumbnail = (String) fav.get("thumbnail");

      if (landmarkId != null && landmarkName != null && thumbnail != null) {
%>
<tr>
  <td class="num"><%= favIdx++ %></td>
  <td>
    <a href="landmarkInfo.jsp?name=<%= java.net.URLEncoder.encode(landmarkName, "UTF-8") %>">
      <%= landmarkName %>
    </a>
  </td>
  <td class="num">
    <img src="<%= thumbnail.replace("https://imgur.com/", "https://i.imgur.com/") + ".jpg" %>"
     class="thumb" alt="<%= landmarkName %>"
     style="width: 50px; height: 50px; object-fit: cover;">
    
  </td>
</tr>
<%
      } // 널 체크 끝
    }
  }
%>
</tbody>
  
</table>
    </section>

    <section id="panel-profile" role="tabpanel" aria-labelledby="tab-profile" class="blk" hidden>
      <form class="form" action="editProfile" method="post">
        <div class="form-row">
          <label class="label" for="pwd">새 비밀번호 입력</label>
          <input id="pwd" name="pwd" type="password" class="input" autocomplete="new-password" />
        </div>
        <div class="form-row">
          <label class="label" for="pwd2">새 비밀번호 확인</label>
          <input id="pwd2" name="pwd2" type="password" class="input" autocomplete="new-password" />
        </div>
        <div class="form-row">
          <label class="label" for="email">이메일</label>
          <input id="email" name="email" type="email" class="input" value="<%= userEmail %>" />
        </div>
        <div class="actions">
          <a class="link-danger" href="deleteAccount.jsp">회원탈퇴</a>
          <button class="btn" type="submit">정보 저장</button>
        </div>
        <p class="hint">※ 저장 버튼 클릭 시 서버로 변경 사항을 전송합니다.</p>
      </form>
    </section>

  </main>

  <script>
    const menuBtn = document.querySelector('.menu-btn');
    const sideMenu = document.getElementById('sideMenu');
    if(menuBtn && sideMenu){
      menuBtn.addEventListener('click', e=>{
        e.stopPropagation();
        sideMenu.classList.toggle('open');
      });
      document.addEventListener('click', e=>{
        if(!sideMenu.contains(e.target) && !menuBtn.contains(e.target)){
          sideMenu.classList.remove('open');
        }
      });
    }

    const tabActivity = document.getElementById('tab-activity');
    const tabProfile  = document.getElementById('tab-profile');
    const pnlActivity = document.getElementById('panel-activity');
    const pnlProfile  = document.getElementById('panel-profile');
    function selectTab(which){
      const isActivity = which==='activity';
      tabActivity.setAttribute('aria-selected', String(isActivity));
      tabProfile.setAttribute('aria-selected', String(!isActivity));
      pnlActivity.hidden = !isActivity;
      pnlProfile.hidden  = isActivity;
    }
    tabActivity.addEventListener('click', ()=>selectTab('activity'));
    tabProfile.addEventListener('click', ()=>selectTab('profile'));
  </script>
</body>
</html>