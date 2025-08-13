<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Post" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판 목록</title>
</head>
<body>
    <h1>게시글 목록</h1>
    <table border="1">
        <thead>
            <tr>
                <th>ID</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
                <th>조회수</th>
            </tr>
        </thead>
        <tbody>
            <% List<Post> postList = (List<Post>) request.getAttribute("postList"); %>
            <% if (postList != null) { %>
                <% for (Post post : postList) { %>
                    <tr>
                        <td><%= post.getPostId() %></td>
                        <td><%= post.getTitle() %></td>
                        <td><%= post.getMemberId() %></td>
                        <td><%= post.getPostDate() %></td>
                        <td><%= post.getViews() %></td>
                    </tr>
                <% } %>
            <% } %>
        </tbody>
    </table>
    <br>
    <a href="postWrite.jsp">글쓰기</a>
</body>
</html>