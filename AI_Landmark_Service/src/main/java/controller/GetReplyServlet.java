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

		ReplyDAO dao = new ReplyDAO();
		List<Reply> replyList = null;

		try {
			// 랜드마크 ID가 있으면 랜드마크 댓글 가져오기
			if (landmarkIdStr != null && !landmarkIdStr.trim().isEmpty()) {
				int landmarkId = Integer.parseInt(landmarkIdStr);
				replyList = dao.getReplyByLandmarkId(landmarkId);
			}
			// 게시글 ID가 있으면 게시글 댓글 가져오기
			else if (postIdStr != null && !postIdStr.trim().isEmpty()) {
				int postId = Integer.parseInt(postIdStr);
				replyList = dao.getReplyByPostId(postId);
			}
			// 기존 호환성을 위한 reference_id 처리
			else if (referenceIdStr != null && !referenceIdStr.trim().isEmpty()) {
				int referenceId = Integer.parseInt(referenceIdStr);
				replyList = dao.getReplyContent(referenceId);
			}
			else {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID parameter is required.");
				return;
			}

			// 2. 결과를 JSON으로 변환하여 응답합니다.
			String json = new Gson().toJson(replyList);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(json);

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format.");
		}
	}
}
