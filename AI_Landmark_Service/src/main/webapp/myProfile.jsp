<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%
    /* -------------------------------------------------------
     * 0) 로그인 체크
     * ----------------------------------------------------- */
    String loginUser = (String) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    /* -------------------------------------------------------
     * 1) DB 조회 준비
     * ----------------------------------------------------- */
    Integer loginMemberId = null;
    String userEmail = "";
    String userNickname = "";
    List<Map<String, Object>> postList = new ArrayList<>();
    List<Map<String, Object>> replyList = new ArrayList<>();
    List<Map<String, Object>> favoriteList = new ArrayList<>();

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

        /* 1-1) 회원 기본정보 */
        String sqlMember = "SELECT MEMBER_ID, EMAIL, NICKNAME FROM MEMBER WHERE ID = ?";
        pstmt = conn.prepareStatement(sqlMember);
        pstmt.setString(1, loginUser);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            loginMemberId = rs.getInt("MEMBER_ID");
            userEmail = rs.getString("EMAIL");
            userNickname = rs.getString("NICKNAME");
        }
        rs.close(); pstmt.close();

        /* 1-2) 내 게시글 (작성자 대신 카테고리를 보여줄 것이므로 CATEGORIES 포함)
           ※ 컬럼명이 다르면 CATEGORIES → 실제 컬럼명으로 변경 */
        if (loginMemberId != null) {
            String sqlPosts =
                "SELECT POST_ID, TITLE, VIEWS, POST_DATE, CATEGORIES " +
                "FROM POST WHERE MEMBER_ID = ? ORDER BY POST_DATE DESC";
            pstmt = conn.prepareStatement(sqlPosts);
            pstmt.setInt(1, loginMemberId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("id", rs.getInt("POST_ID"));
                row.put("title", rs.getString("TITLE"));
                row.put("views", rs.getInt("VIEWS"));
                row.put("post_date", rs.getTimestamp("POST_DATE"));
                row.put("category", rs.getString("CATEGORIES"));
                postList.add(row);
            }
            rs.close(); pstmt.close();
        }

        /* 1-3) 내 댓글 (게시판 + 랜드마크) */
        if (loginMemberId != null) {
            String sqlReplies =
                "SELECT * FROM ( " +
                "  SELECT R.REPLY_ID, R.REPLY_CONTENT, R.REPLY_DATE, " +
                "         P.TITLE AS TARGET_TITLE, R.POST_ID AS TARGET_ID, " +
                "         '게시판' AS TARGET_TYPE, NULL AS LANDMARK_NAME " +
                "  FROM REPLY R JOIN POST P ON R.POST_ID = P.POST_ID " +
                "  WHERE R.MEMBER_ID = ? " +
                "  UNION ALL " +
                "  SELECT R.REPLY_ID, R.REPLY_CONTENT, R.REPLY_DATE, " +
                "         L.LANDMARK_NAME AS TARGET_TITLE, R.LANDMARK_ID AS TARGET_ID, " +
                "         '랜드마크' AS TARGET_TYPE, L.LANDMARK_NAME AS LANDMARK_NAME " +
                "  FROM REPLY R JOIN LANDMARK L ON R.LANDMARK_ID = L.LANDMARK_ID " +
                "  WHERE R.MEMBER_ID = ? " +
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
                row.put("post_id", rs.getObject("TARGET_ID"));  // null 가능성 대비
                row.put("post_type", rs.getString("TARGET_TYPE"));
                row.put("landmark_name", rs.getString("LANDMARK_NAME"));
                replyList.add(row);
            }
            rs.close(); pstmt.close();
        }

        /* 1-4) 즐겨찾기 (썸네일 1장만 선정) */
        if (loginMemberId != null) {
            String sqlFavorites =
                "SELECT * FROM (" +
                "  SELECT L.LANDMARK_ID, L.LANDMARK_NAME, I.IMAGE_URL, " +
                "         ROW_NUMBER() OVER (PARTITION BY L.LANDMARK_ID " +
                "           ORDER BY CASE WHEN I.IMAGE_TYPE='thumbnail' THEN 1 ELSE 2 END, I.IMAGE_ID) RN " +
                "  FROM FAVORITES F " +
                "  JOIN LANDMARK L ON F.LANDMARK_ID = L.LANDMARK_ID " +
                "  JOIN LANDMARK_IMAGE I ON L.LANDMARK_ID = I.LANDMARK_ID " +
                "  WHERE F.MEMBER_ID = ?" +
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
            rs.close(); pstmt.close();
        }

    } catch(Exception e){
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }

    /* 2) 날짜 포맷 */
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>마이페이지</title>
<style>
  :root { --ink:#111; --muted:#f6f6f8; --line:#e6e6e8; --brand:#57ACCB; --tab:#cfdfea; --tab-active:#2f87ad; --ink2:#555; }
  *{box-sizing:border-box;}
  html,body{height:100%; margin:0; font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif; color:var(--ink); background:#fff;}
  header { position:fixed; top:0; left:0; width:100%; height:100px; background:#fff;
           display:flex; justify-content:space-between; align-items:center; padding:0 20px;
           z-index:1000; box-shadow:0 1px 0 rgba(0,0,0,.04); }
  h2 a { text-decoration:none; color:inherit; }
  .menu-btn { position: fixed; top:20px; right:20px; font-size:50px; background:none; border:none; color:#000; cursor:pointer; z-index:1002; }
  .side-menu{ position: fixed; top:0; right:-500px; width:500px; height:100%; background:#57ACCB; color:#fff;
              padding:20px; padding-top:100px; transition:right .3s ease; font-size:30px; z-index:1001; }
  .side-menu.open{ right:0; }
  .side-menu li{ list-style:none; margin-top:20px; }
  .side-menu a{ color:#fff; text-decoration:none; font-weight:700; display:block; margin:14px 0; }
  @media (max-width:920px){ .side-menu{ width:85vw; right:-85vw; } }

  /* 페이지 래퍼 */
  .paper{ max-width:1080px; margin:140px auto 60px; background:var(--muted); border-radius:28px; padding:28px; }
  .blk{ background:#fff; border:1px solid var(--line); border-radius:16px; padding:22px; margin-bottom:20px; box-shadow:0 4px 14px rgba(0,0,0,.06); }

  /* 상단 탭 */
  .tabs{ display:flex; gap:14px; margin-bottom:16px; }
  .tabs button{ border:0; background:var(--tab); color:#456; padding:12px 18px; border-radius:999px; font-weight:900; cursor:pointer; }
  .tabs button[aria-selected="true"]{ background:var(--tab-active); color:#fff; }

  /* ===== 표 공통 ===== */
  .table-wrap{ overflow:auto; border:1px solid var(--line); border-radius:12px; }
  table.table-fixed{ width:100%; border-collapse:collapse; table-layout:fixed; } /* 폭 고정 */
  thead th{
    background:#eef7fb; border-bottom:1px solid var(--line);
    padding:12px 10px; white-space:nowrap; font-size:14px; font-weight:700; color:#1f2937;
  }
  tbody td{
    border-bottom:1px solid var(--line);
    padding:12px 10px; font-size:14px; color:#222; font-weight:500;
  }
  tbody tr:hover{ background:#f9fbfc; cursor:pointer; }

  /* 긴 텍스트 말줄임: TD가 아니라 안쪽 요소에 적용 */
  .cell-ellipsis{ display:block; max-width:100%; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

  /* ── 표별 열폭(%) ───────────────────────── */
  /* ▶ 내 게시글 */
  #tbl-posts .col-no    { width: 8%;  text-align:center; color:#444; }
  #tbl-posts .col-cat   { width:14%;  text-align:center; color:#444; }  /* 카테고리 고정폭 */
  #tbl-posts .col-title { width:48%; }  /* 제목 넓게 */
  #tbl-posts .col-views { width:10%;  text-align:right; color:#444; }
  #tbl-posts .col-date  { width:20%;  text-align:center; color:#444; }

  /* ▶ 내 댓글 (제목 폭 = 카테고리 폭과 동일 14%) */
  #tbl-comments .col-no    { width: 8%;  text-align:center; color:#444; }
  #tbl-comments .col-title { width:14%; }             /* 제목 */
  #tbl-comments .col-reply { width:48%; }             /* 댓글 내용 크게 */
  #tbl-comments .col-kind  { width:14%; text-align:center; color:#444; }
  #tbl-comments .col-date  { width:16%; text-align:center; color:#444; }

  /* ▶ 즐겨찾기 */
  #tbl-favorites .col-no    { width:10%; text-align:center; color:#444; }
  #tbl-favorites .col-title { width:60%; }
  #tbl-favorites .col-thumb { width:30%; text-align:center; }

  .table-thumb{ width:50px; height:50px; object-fit:cover; border-radius:8px; border:1px solid var(--line); }

  /* 페이지네이션 */
  .pager{ display:flex; justify-content:center; align-items:center; gap:8px; margin:14px 0 4px; flex-wrap:wrap; }
  .pager button{ min-width:36px; height:36px; border:1px solid var(--line); background:#fff; border-radius:10px; cursor:pointer; }
  .pager button[aria-current="true"]{ background:var(--brand); color:#fff; border-color:var(--brand); font-weight:800; }
  .pager button:disabled{ opacity:.55; cursor:not-allowed; }

  /* ===== 폼(회원 정보 수정) ===== */
  .form{ max-width:680px; margin:4px auto 0; }
  .form-row{ margin:18px 0; }
  .label{ display:block; margin-bottom:8px; font-weight:800; color:#1f2937; }
  .input{ width:100%; height:48px; border:1px solid var(--line); border-radius:999px; padding:0 16px; font-size:15px; }
  .actions{ display:flex; align-items:center; justify-content:space-between; margin-top:18px; }
  .btn{ border:0; background:var(--brand); color:#fff; padding:12px 18px; border-radius:999px; font-weight:900; cursor:pointer; }
  .link-danger{ color:#e14a4a; text-decoration:none; font-weight:800; }
  .hint{ font-size:12px; color:#666; margin-top:6px; }

  @media (max-width: 680px){
    #tbl-posts .col-views, #tbl-comments .col-kind { display:none; }
  }

  #headerImage{ height:80%; width:auto; display:flex; justify-content:center; position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); }

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
  <img src="./image/headerImage.png" alt="MySite Logo" id="headerImage">
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
    <div class="table-wrap">
      <table id="tbl-posts" class="table-fixed">
        <thead>
          <tr>
            <th class="col-no">목록</th>
            <th class="col-cat">카테고리</th> <th class="col-title">제목</th>
            <th class="col-views">조회수</th>
            <th class="col-date">작성일자</th>
          </tr>
        </thead>
        <tbody>
        <%
          int idx = 1;
          for (Map<String, Object> post : postList) {
              String category = (String) post.get("category");
        %>
          <tr onclick="location.href='postInfo?postId=<%= post.get("id") %>&source=mypage'">
            <td class="col-no"><%= idx++ %></td>
            <td class="col-cat"><%= category == null ? "-" : category %></td>
            <td class="col-title"><span class="cell-ellipsis"><%= post.get("title") %></span></td>
            <td class="col-views"><%= post.get("views") %></td>
            <td class="col-date"><%= sdf.format(post.get("post_date")) %></td>
          </tr>
        <%
          }
          if (postList.size() == 0) {
        %>
          <tr class="is-empty"><td colspan="5" style="text-align:center; color:var(--ink2); padding:22px;">작성한 게시글이 없습니다.</td></tr>
        <% } %>
        </tbody>
      </table>
    </div>
    <div class="pager" id="pager-posts" aria-label="게시글 페이지네이션"></div>

    <h3 style="margin-top:28px;">내 댓글</h3>
    <div class="table-wrap">
      <table id="tbl-comments" class="table-fixed">
        <thead>
          <tr>
            <th class="col-no">목록</th>
            <th class="col-title">제목</th>  <th class="col-reply">댓글 내용</th>
            <th class="col-kind">분류</th>
            <th class="col-date">작성일자</th>
          </tr>
        </thead>
        <tbody>
        <%
          int cidx = 1;
          for (Map<String, Object> reply : replyList) {
              Object postIdObj = reply.get("post_id");
              Integer postId = (postIdObj instanceof Integer) ? (Integer) postIdObj : null;
              String postTitle = (String) reply.get("post_title");
              String postType = (String) reply.get("post_type");
              String landmarkName = (String) reply.get("landmark_name");
              if (postTitle == null) continue;

              String linkUrl = "랜드마크".equals(postType)
                              ? "landmarkInfo.jsp?name=" + java.net.URLEncoder.encode(landmarkName, "UTF-8")
                              : (postId == null ? "#" : "postInfo?postId=" + postId + "&source=mypage");
        %>
          <tr onclick="location.href='<%= linkUrl %>'">
            <td class="col-no"><%= cidx++ %></td>
            <td class="col-title"><span class="cell-ellipsis"><%= postTitle %></span></td>
            <td class="col-reply"><span class="cell-ellipsis"><%= reply.get("reply_content") %></span></td>
            <td class="col-kind"><%= postType %></td>
            <td class="col-date"><%= sdf.format(reply.get("reply_date")) %></td>
          </tr>
        <%
          }
          if (cidx == 1) {
        %>
          <tr class="is-empty"><td colspan="5" style="text-align:center; color:var(--ink2); padding:22px;">작성한 댓글이 없습니다.</td></tr>
        <% } %>
        </tbody>
      </table>
    </div>
    <div class="pager" id="pager-comments" aria-label="댓글 페이지네이션"></div>

    <h3 style="margin-top:28px;">즐겨찾기</h3>
    <div class="table-wrap">
      <table id="tbl-favorites" class="table-fixed">
        <thead>
          <tr>
            <th class="col-no">목록</th>
            <th class="col-title">랜드마크 이름</th>
            <th class="col-thumb">썸네일</th>
          </tr>
        </thead>
        <tbody>
        <%
          int favIdx = 1;
          if (favoriteList == null || favoriteList.isEmpty()) {
        %>
          <tr class="is-empty"><td colspan="3" style="text-align:center; color:var(--ink2); padding:22px;">즐겨찾기한 랜드마크가 없습니다.</td></tr>
        <%
          } else {
            for (Map<String, Object> fav : favoriteList) {
              Integer landmarkId = (Integer) fav.get("id");
              String landmarkName = (String) fav.get("name");
              String thumbnail = (String) fav.get("thumbnail");
              if (landmarkId != null && landmarkName != null && thumbnail != null) {
                String fixedUrl = thumbnail.replace("https://imgur.com/", "https://i.imgur.com/") + ".jpg";
        %>
          <tr onclick="location.href='landmarkInfo.jsp?name=<%= java.net.URLEncoder.encode(landmarkName, "UTF-8") %>'">
            <td class="col-no"><%= favIdx++ %></td>
            <td class="col-title"><span class="cell-ellipsis"><%= landmarkName %></span></td>
            <td class="col-thumb"><img src="<%= fixedUrl %>" alt="<%= landmarkName %>" class="table-thumb"></td>
          </tr>
        <%
              }
            }
          }
        %>
        </tbody>
      </table>
    </div>
    <div class="pager" id="pager-favorites" aria-label="즐겨찾기 페이지네이션"></div>
  </section>

  <section id="panel-profile" role="tabpanel" aria-labelledby="tab-profile" class="blk" hidden>
    <h3>회원 정보 수정</h3>
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
        <label class="label" for="nickname">닉네임</label>
        <input id="nickname" name="nickname"  type="text" class="input" value="<%= userNickname %>" />
      </div>
      <div class="form-row">
        <label class="label" for="email">이메일</label>
        <input id="email" name="email" type="email" class="input" value="<%= userEmail %>" />
      </div>
      <div class="actions">
        <a class="link-danger" href="editProfile?action=delete" onclick="return confirm('정말로 회원 탈퇴를 하시겠습니까?');">회원탈퇴</a>
        <button class="btn" type="submit">정보 저장</button>
      </div>
    </form>
  </section>
</main>

<script>
  /* -------------------------------------------------------
   * 사이드 메뉴 토글 (ES5)
   * ----------------------------------------------------- */
  (function(){
    var menuBtn = document.querySelector('.menu-btn');
    var sideMenu = document.getElementById('sideMenu');
    if(menuBtn && sideMenu){
      menuBtn.addEventListener('click', function(e){
        e.stopPropagation();
        if(sideMenu.classList.contains('open')) sideMenu.classList.remove('open');
        else sideMenu.classList.add('open');
      });
      document.addEventListener('click', function(e){
        if(!sideMenu.contains(e.target) && !menuBtn.contains(e.target)){
          sideMenu.classList.remove('open');
        }
      });
    }
  })();

  /* -------------------------------------------------------
   * 탭 전환 (ES5) — 숨김/노출만, 스타일은 CSS로 통일
   * ----------------------------------------------------- */
  (function(){
    var tabActivity = document.getElementById('tab-activity');
    var tabProfile  = document.getElementById('tab-profile');
    var pnlActivity = document.getElementById('panel-activity');
    var pnlProfile  = document.getElementById('panel-profile');

    function selectTab(which){
      var isActivity = (which==='activity');
      tabActivity.setAttribute('aria-selected', String(isActivity));
      tabProfile.setAttribute('aria-selected', String(!isActivity));
      pnlActivity.hidden = !isActivity;
      pnlProfile.hidden  = isActivity;
    }
    tabActivity.addEventListener('click', function(){ selectTab('activity'); });
    tabProfile.addEventListener('click', function(){ selectTab('profile'); });
  })();

  /* -------------------------------------------------------
   * 표별 페이지네이션 (ES5 / 5행/페이지)
   * - 데이터 없으면 페이저 숨김
   * - 처음/이전/숫자(가변 7칸)/다음/마지막
   * ----------------------------------------------------- */
  function paginateTable(tableId, pagerId, rowsPerPage){
    var tbody = document.querySelector('#' + tableId + ' tbody');
    var pager = document.getElementById(pagerId);
    if(!tbody || !pager) return;

    var allRows = Array.prototype.slice.call(tbody.getElementsByTagName('tr'));
    // "데이터 없음" 안내 행은 .is-empty 로 표기되어 있으므로 제외
    var dataRows = [];
    for (var i=0; i<allRows.length; i++){
      if ((' ' + allRows[i].className + ' ').indexOf(' is-empty ') === -1){
        dataRows.push(allRows[i]);
      }
    }

    if(dataRows.length === 0){ pager.style.display = 'none'; return; }

    var currentPage = 1;
    var totalPages = Math.ceil(dataRows.length / rowsPerPage);

    // 1페이지 뿐이면 페이저 숨김
    if (totalPages <= 1){ pager.style.display = 'none'; }

    function render(){
      // 모든 행 숨김
      for (var i=0; i<allRows.length; i++) allRows[i].style.display = 'none';
      // 현재 페이지의 행만 노출
      var start = (currentPage - 1) * rowsPerPage;
      var end   = Math.min(start + rowsPerPage, dataRows.length);
      for (var i=start; i<end; i++) dataRows[i].style.display = '';
      buildPager();
    }

    function makeBtn(label, page, disabled, current){
      var b = document.createElement('button');
      b.type = 'button';
      b.appendChild(document.createTextNode(label));
      if(disabled) b.disabled = true;
      if(current)  b.setAttribute('aria-current','true');
      b.onclick = function(){
        if(page < 1 || page > totalPages) return;
        currentPage = page;
        render();
      };
      return b;
    }

    function buildPager(){
      // 페이저 초기화
      while (pager.firstChild) pager.removeChild(pager.firstChild);

      if (totalPages <= 1){ pager.style.display = 'none'; return; }
      pager.style.display = '';

      // 처음/이전
      pager.appendChild(makeBtn('≪', 1, currentPage===1, false));
      pager.appendChild(makeBtn('〈', currentPage-1, currentPage===1, false));

      // 숫자창(최대 7칸)
      var windowSize = 7;
      var start = Math.max(1, currentPage - Math.floor(windowSize/2));
      var end   = start + windowSize - 1;
      if(end > totalPages){ end = totalPages; start = Math.max(1, end - windowSize + 1); }
      for (var p=start; p<=end; p++){
        pager.appendChild(makeBtn(String(p), p, false, p===currentPage));
      }

      // 다음/마지막
      pager.appendChild(makeBtn('〉', currentPage+1, currentPage===totalPages, false));
      pager.appendChild(makeBtn('≫', totalPages, currentPage===totalPages, false));
    }

    render(); // 최초 렌더링
  }

  // DOM 준비 후 각 표에 페이징(5행/페이지) 적용
  function initPagination(){
    paginateTable('tbl-posts',     'pager-posts',     5);
    paginateTable('tbl-comments',  'pager-comments',  5);
    paginateTable('tbl-favorites', 'pager-favorites', 5);
  }
  if (document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', initPagination);
  } else {
    initPagination();
  }
</script>
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
</script>
</body>
</html>