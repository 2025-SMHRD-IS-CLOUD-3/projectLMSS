<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, java.text.SimpleDateFormat" %>
<%
    // AdminServlet이 전달한 제안 목록을 받습니다.
    List<Map<String, Object>> suggestions = (List<Map<String, Object>>) request.getAttribute("suggestions");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 페이지 - 핫스팟 제안 관리</title>
    <style>
        :root { --brand:#57ACCB; --line:#e5e5e5; --ink:#333; }
        body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 20px; color: var(--ink); }
        .container { max-width: 1200px; margin: auto; margin-top: 100px;
        			background: #fff; padding: 20px; border-radius: 12px; 
        			box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        h1 { color: var(--brand); text-align: center; }
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 12px 15px; border: 1px solid var(--line); text-align: left; }
        th { background-color: #f8f9fa; font-weight: 600; }
        .actions { display: flex; gap: 8px; }
        .btn { padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; }
        .btn-approve { background-color: #28a745; color: white; }
        .btn-reject { background-color: #dc3545; color: white; }
        .no-data { text-align: center; color: #777; padding: 40px 0; }
    </style>
</head>
<body>
	<%@ include file="header.jsp" %>
    <div class="container">
        <h1>핫스팟 제안 관리</h1>
        <p>사용자들이 제안한 핫스팟 목록입니다. 각 항목을 검토하고 승인 또는 거절할 수 있습니다.</p>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>제안 ID</th>
                        <th>랜드마크</th>
                        <th>제안 장소</th>
                        <th>종류</th>
                        <th>제안자</th>
                        <th>제안일</th>
                        <th>처리</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (suggestions == null || suggestions.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="no-data">대기 중인 제안이 없습니다.</td>
                        </tr>
                    <% } else { %>
                        <% for (Map<String, Object> suggestion : suggestions) { %>
                            <tr>
                                <td><%= suggestion.get("suggestion_id") %></td>
                                <td><%= suggestion.get("landmark_name") %></td>
                                <td><%= suggestion.get("hotspot_name") %></td>
                                <td><%= suggestion.get("hotspot_type") %></td>
                                <td><%= suggestion.get("suggester_nickname") %></td>
                                <td><%= sdf.format(suggestion.get("suggested_at")) %></td>
                                <td class="actions">
                                    <!-- 승인 버튼 폼 -->
                                    <form action="<%=request.getContextPath()%>/processSuggestion" method="post" style="display:inline;">
                                        <input type="hidden" name="suggestionId" value="<%= suggestion.get("suggestion_id") %>">
                                        <input type="hidden" name="action" value="approve">
                                        <button type="submit" class="btn btn-approve">승인</button>
                                    </form>
                                    <!-- 거절 버튼 폼 -->
                                    <form action="<%=request.getContextPath()%>/processSuggestion" method="post" style="display:inline;">
                                        <input type="hidden" name="suggestionId" value="<%= suggestion.get("suggestion_id") %>">
                                        <input type="hidden" name="action" value="reject">
                                        <button type="submit" class="btn btn-reject">거절</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
