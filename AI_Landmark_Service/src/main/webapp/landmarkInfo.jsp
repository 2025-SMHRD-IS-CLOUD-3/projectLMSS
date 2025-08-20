<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>랜드마크 정보</title>
    <style>
        .landmark-card {
            border: 1px solid #ddd;
            padding: 16px;
            margin-bottom: 16px;
            border-radius: 8px;
        }
        .landmark-card img {
            max-width: 300px;
            display: block;
            margin-top: 8px;
        }
    </style>
</head>
<body>
    <h1>랜드마크 정보</h1>
    <div id="landmark-container"></div>

    <script>
        // JSON 불러오기
        fetch("<%=request.getContextPath()%>/getLandmarks")
            .then(response => response.json())
            .then(data => {
                const container = document.getElementById("landmark-container");
                container.innerHTML = "";

                data.forEach(landmark => {
                    const card = document.createElement("div");
                    card.className = "landmark-card";

                    card.innerHTML = `
                        <h2>${landmark.name}</h2>
                        <p>${landmark.description}</p>
                        <img src="${landmark.imageUrl}" alt="랜드마크 이미지"/>
                    `;
                    container.appendChild(card);
                });
            })
            .catch(err => console.error("에러:", err));
    </script>
</body>
</html>
