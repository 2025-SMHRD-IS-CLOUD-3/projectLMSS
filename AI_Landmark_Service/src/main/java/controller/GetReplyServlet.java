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

		// 1. URL에서 'id' 파라미터 값을 받습니다. (예: /getReply?id=1)
		String referenceIdStr = request.getParameter("id");

		if (referenceIdStr == null || referenceIdStr.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID is required.");
			return;
		}

		try {
			int referenceId = Integer.parseInt(referenceIdStr);

			// 2. DAO를 생성하고, ID를 넘겨주어 해당 댓글 목록만 가져옵니다.
			ReplyDAO dao = new ReplyDAO();
			List<Reply> replyList = dao.getReplyContent(referenceId);

			// 3. 결과를 JSON으로 변환하여 응답합니다.
			String json = new Gson().toJson(replyList);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(json);

		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format.");
		}
	}
}
