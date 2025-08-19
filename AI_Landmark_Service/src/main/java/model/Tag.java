package model;

public class Tag {
	private int tag_id;
	private String tag_content;
	private int landmark_id;
	
	public Tag(int tag_id, String tag_content, int landmark_id) {
		super();
		this.tag_id = tag_id;
		this.tag_content = tag_content;
		this.landmark_id = landmark_id;
	}
	
	public Tag() {
		// TODO Auto-generated constructor stub
	}

	public int getTag_id() {
		return tag_id;
	}
	public void setTag_id(int tag_id) {
		this.tag_id = tag_id;
	}
	public String getTag_content() {
		return tag_content;
	}
	public void setTag_content(String tag_content) {
		this.tag_content = tag_content;
	}
	public int getLandmark_id() {
		return landmark_id;
	}
	public void setLandmark_id(int landmark_id) {
		this.landmark_id = landmark_id;
	}
}
