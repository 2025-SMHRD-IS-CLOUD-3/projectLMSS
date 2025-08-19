package model;

public class Image {
	private int image_id;
	private String image_url;
	private String image_type;
	private int landmark_id;
	public int getImage_id() {
		return image_id;
	}
	public void setImage_id(int image_id) {
		this.image_id = image_id;
	}
	public String getImage_url() {
		return image_url;
	}
	public void setImage_url(String image_url) {
		this.image_url = image_url;
	}
	public String getImage_type() {
		return image_type;
	}
	public void setImage_type(String image_type) {
		this.image_type = image_type;
	}
	public int getLandmark_id() {
		return landmark_id;
	}
	public void setLandmark_id(int landmark_id) {
		this.landmark_id = landmark_id;
	}
	public Image(int image_id, String image_url, String image_type, int landmark_id) {
		super();
		this.image_id = image_id;
		this.image_url = image_url;
		this.image_type = image_type;
		this.landmark_id = landmark_id;
	}
	public Image() {
		// TODO Auto-generated constructor stub
	}
	
	
	
	
}
