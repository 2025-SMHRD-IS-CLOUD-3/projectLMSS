package model;

import java.sql.Date;

public class Reply {
	private int reply_id;
	private int member_id;
	private String reply_content;
	private Date reply_date;
	private int reference_id; // 기존 호환성을 위해 유지
	private int landmark_id;  // 랜드마크 ID 추가
	private int post_id;      // 게시글 ID 추가
	private String member_nickname;
	
	public String getMember_nickname() {
		return member_nickname;
	}
	public void setMember_nickname(String member_nickname) {
		this.member_nickname = member_nickname;
	}
	public int getReply_id() {
		return reply_id;
	}
	public void setReply_id(int reply_id) {
		this.reply_id = reply_id;
	}
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public String getReply_content() {
		return reply_content;
	}
	public void setReply_content(String reply_content) {
		this.reply_content = reply_content;
	}
	public Date getReply_date() {
		return reply_date;
	}
	public void setReply_date(Date reply_date) {
		this.reply_date = reply_date;
	}
	public int getReference_id() {
		return reference_id;
	}
	public void setReference_id(int reference_id) {
		this.reference_id = reference_id;
	}
	public int getLandmark_id() {
		return landmark_id;
	}
	public void setLandmark_id(int landmark_id) {
		this.landmark_id = landmark_id;
	}
	public int getPost_id() {
		return post_id;
	}
	public void setPost_id(int post_id) {
		this.post_id = post_id;
	}
}
