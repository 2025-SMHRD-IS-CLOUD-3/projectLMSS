package model;

public class Favorite {
    private int favorites_id;
    private int member_id;
    private int landmark_id;
    private String landmark_name;
    private String landmark_location;
    private String landmark_name_en;
    
	public int getFavorites_id() {
		return favorites_id;
	}
	public void setFavorites_id(int favorites_id) {
		this.favorites_id = favorites_id;
	}
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public int getLandmark_id() {
		return landmark_id;
	}
	public void setLandmark_id(int landmark_id) {
		this.landmark_id = landmark_id;
	}
	public String getLandmark_name() {
		return landmark_name;
	}
	public void setLandmark_name(String landmark_name) {
		this.landmark_name = landmark_name;
	}
	public String getLandmark_location() {
		return landmark_location;
	}
	public void setLandmark_location(String landmark_location) {
		this.landmark_location = landmark_location;
	}
	public String getLandmark_name_en() {
		return landmark_name_en;
	}
	public void setLandmark_name_en(String landmark_name_en) {
		this.landmark_name_en = landmark_name_en;
	}
    
    

}
