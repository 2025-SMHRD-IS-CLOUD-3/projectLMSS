<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Landmark Search</title>
    <style>
        :root {
            --brand: #57accb;
            --white: #fff;
            --ink: #111;
        }

        body {
            margin: 0;
            font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif;
            background-color: var(--white);
            color: var(--ink);
            display: flex;
            height: 100vh;
        }
        
        /* Main Content */
        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 20px;
        }
        
        .image-container {
            width: 100%;
            max-width: 600px;
        }
        
        .main-image {
            width: 100%;
            height: auto;
        }

        .main-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-top: 20px;
        }

        .search-button {
            margin-top: 20px;
            padding: 12px 40px;
            font-size: 1.2rem;
            font-weight: 700;
            background-color: var(--white);
            color: var(--brand);
            border: 2px solid var(--brand);
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-button:hover {
            background-color: var(--brand);
            color: var(--white);
        }

        /* Header */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background-color: var(--white);
            z-index: 100;
        }

        .header h1 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .menu-icon {
            font-size: 2.5rem;
            cursor: pointer;
            border: none;
            background: none;
            color: var(--ink);
            margin-right: 10px;
        }

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            right: -300px;
            width: 300px;
            height: 100%;
            background-color: var(--brand);
            color: var(--white);
            box-shadow: -2px 0 5px rgba(0, 0, 0, 0.5);
            transition: right 0.3s ease-in-out;
            z-index: 200;
            padding-top: 100px;
        }

        .sidebar.open {
            right: 0;
        }

        .sidebar ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .sidebar ul li a {
            display: block;
            padding: 15px 30px;
            text-decoration: none;
            color: var(--white);
            font-size: 1.2rem;
            font-weight: 500;
            transition: background-color 0.2s;
        }

        .sidebar ul li a:hover {
            background-color: rgba(255, 255, 255, 0.2);
        }

        @media (max-width: 768px) {
            .sidebar {
                width: 250px;
            }
        }
    </style>
</head>
<body>
    <header class="header">
        <h1>Landmark Search</h1>
        <button class="menu-icon" id="menu-icon">
            &#x2261;
        </button>
    </header>

    <div class="sidebar" id="sidebar">
        <ul>
            <li><a href="<%=request.getContextPath()%>/howLandmark.jsp">Landmark Search란?</a></li>
            <li><a href="<%=request.getContextPath()%>/main.jsp">사진으로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/mapSearch.jsp">지도로 랜드마크 찾기</a></li>
            <li><a href="<%=request.getContextPath()%>/post.jsp">게시판</a></li>
            <li><a href="<%=request.getContextPath()%>/mypage.jsp">마이페이지</a></li>
            <li><a href="<%=request.getContextPath()%>/logout.jsp">로그아웃</a></li>
        </ul>
    </div>

    <main class="main-content">
        <div class="image-container">
            <img src="<%=request.getContextPath()%>/data/mainIllustration.png" alt="Landmarks illustration" class="main-image">
        </div>
        <h1 class="main-title">LANDMARK SEARCH</h1>
        <button class="search-button">Search</button>
    </main>

    <script>
        const menuIcon = document.getElementById('menu-icon');
        const sidebar = document.getElementById('sidebar');

        menuIcon.addEventListener('click', () => {
            sidebar.classList.toggle('open');
        });

        document.addEventListener('click', (event) => {
            if (!sidebar.contains(event.target) && !menuIcon.contains(event.target)) {
                sidebar.classList.remove('open');
            }
        });
    </script>
</body>
</html>
