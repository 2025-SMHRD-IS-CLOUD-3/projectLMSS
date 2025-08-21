package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dao.ReplyDAO;
import model.Reply;

@WebServlet("/getReply")
public class GetReplyServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. URL에서 파라미터 값들을 받습니다.
        String landmarkIdStr = request.getParameter("landmarkId");
        String postIdStr = request.getParameter("postId");
        String referenceIdStr = request.getParameter("id"); // 기존 호환성
        String memberIdStr = request.getParameter("memberId"); // 마이페이지용

        ReplyDAO dao = new ReplyDAO();
        List<Reply> replyList = null;

        try {
            if (landmarkIdStr != null && !landmarkIdStr.trim().isEmpty()) {
                // 랜드마크 댓글 조회
                int landmarkId = Integer.parseInt(landmarkIdStr);
                replyList = dao.getReplyByLandmarkId(landmarkId);
            } else if (postIdStr != null && !postIdStr.trim().isEmpty()) {
                // 게시글 댓글 조회
                int postId = Integer.parseInt(postIdStr);
                replyList = dao.getReplyByPostId(postId);
            } else if (referenceIdStr != null && !referenceIdStr.trim().isEmpty()) {
                // 기존 reference_id 조회
                int referenceId = Integer.parseInt(referenceIdStr);
                replyList = dao.getReplyContent(referenceId);
            } else if (memberIdStr != null && !memberIdStr.trim().isEmpty()) {
                // 회원이 작성한 댓글 조회 (마이페이지)
                int memberId = Integer.parseInt(memberIdStr);
                replyList = dao.getRepliesByMemberId(memberId);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID parameter is required.");
                return;
            }

            // 2. 결과를 JSON으로 변환하여 응답
            String json = new Gson().toJson(replyList);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(json);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format.");
        }
    }
}
