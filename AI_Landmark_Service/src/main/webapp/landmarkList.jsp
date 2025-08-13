<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Landmark" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>랜드마크 목록</title>
</head>
<body>
    <h1>랜드마크 목록</h1>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>위치</th>
                <th>설명</th>
            </tr>
        </thead>
        <tbody>
            <% List<Landmark> landmarkList = (List<Landmark>) request.getAttribute("landmarkList"); %>
            <% if (landmarkList != null) { %>
                <% for (Landmark landmark : landmarkList) { %>
                    <tr>
                        <td><%= landmark.getLandmarkId() %></td>
                        <td><%= landmark.getLandmarkName() %></td>
                        <td><%= landmark.getLocation() %></td>
                        <td><%= landmark.getDescription() %></td>
                    </tr>
                <% } %>
            <% } %>
        </tbody>
    </table>
</body>
</html>