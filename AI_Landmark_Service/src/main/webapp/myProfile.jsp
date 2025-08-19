<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
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
        }
    } catch(Exception e){ 
        e.printStackTrace(); 
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
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
    header{position:fixed; top:0; left:0; width:100%; height:100px; background:#fff; display:flex; justify-content:space-between; align-items:center; padding:0 20px;}
    header h2{font-size:18px; margin:0; font-weight:bold;}
    .menu-btn{position:fixed; top:20px; right:20px; font-size:50px; background:none; border:none; color:#000; cursor:pointer; z-index:1001;}
    .side-menu{position:fixed; top:0; right:-500px; width:500px; height:100vh; background:var(--brand); color:#fff; padding:20px; padding-top:100px; transition:right .3s ease; font-size:30px; z-index:1002;}
    .side-menu.open{ right:0; }
    .side-menu li{ list-style:none; margin-top:20px; }
    .side-menu a{ color:#fff; text-decoration:none; font-weight:bold; }
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
  </style>
</head>
<body>
  <header>
    <h2>Landmark Search</h2>
    <button class="menu-btn">≡</button>
  </header>

  <div class="side-menu" id="sideMenu">
    <ul>
      <li><a href="./howLandmark.jsp">Landmark Search란?</a></li>
      <li><a href="./main.jsp">사진으로 랜드마크 찾기</a></li>
      <li><a href="./mapSearch.jsp">지도로 랜드마크 찾기</a></li>
      <li><a href="./postList">게시판</a></li>
      <li><a href="logout.jsp">로그아웃</a></li>
    </ul>
  </div>

  <main class="paper">
    <nav class="tabs" role="tablist" aria-label="마이페이지 상단 탭">
      <button id="tab-activity" role="tab" aria-selected="true">활동 내역</button>
      <button id="tab-profile"  role="tab" aria-selected="false">회원 정보 수정</button>
    </nav>

    <!-- 활동 내역 -->
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
            <td><a href="postInfo.jsp?id=<%= post.get("id") %>"><%= post.get("title") %></a></td>
            <td class="num"><%= post.get("views") %></td>
            <td class="num"><%= post.get("post_date") %></td>
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
            <th class="num">작성일자</th>
            <th class="num">작성자</th>
          </tr>
        </thead>
        <tbody>
          <!-- DB 연동 후 댓글 목록 삽입 -->
        </tbody>
      </table>

      <h3 style="margin-top:28px;">즐겨찾기</h3>
      <div id="favGrid" class="fav-grid">
        <!-- DB 연동 후 즐겨찾기 삽입 -->
      </div>
      <p class="hint">카드를 클릭하면 해당 랜드마크 상세로 이동합니다.</p>
    </section>

    <!-- 회원 정보 수정 -->
    <section id="panel-profile" role="tabpanel" aria-labelledby="tab-profile" class="blk" hidden>
      <form class="form" action="updateProfile.jsp" method="post">
        <div class="form-row">
          <label class="label" for="newPw">새 비밀번호 입력</label>
          <input id="newPw" name="newPw" type="password" class="input" autocomplete="new-password" />
        </div>
        <div class="form-row">
          <label class="label" for="newPw2">새 비밀번호 확인</label>
          <input id="newPw2" name="newPw2" type="password" class="input" autocomplete="new-password" />
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
