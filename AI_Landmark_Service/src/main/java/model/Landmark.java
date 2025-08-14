package model;

public class Landmark {

    private int landmark_id;
    private String landmark_name;
    private String landmark_location;
    private String landmark_desc;
    private String architect;
    private String landmark_hours;
    private String fee;
    private String traffic_info;
    private String tmi;
    private String arch_style;
    private String website;
    private String landmark_usage;
    private String completion_time;
    private String longitude;
    private String latitude;
    private String landmark_name_en;
    
	public String getLandmark_name_en() {
		return landmark_name_en;
	}
	public void setLandmark_name_en(String landmark_name_en) {
		this.landmark_name_en = landmark_name_en;
	}
	public Landmark(int landmark_id, String landmark_name, String landmark_location, String landmark_desc,
			String architect, String landmark_hours, String fee, String traffic_info, String tmi, String arch_style,
			String website, String landmark_usage, String completion_time, String longitude, String latitude,
			String landmark_name_en) {
		super();
		this.landmark_id = landmark_id;
		this.landmark_name = landmark_name;
		this.landmark_location = landmark_location;
		this.landmark_desc = landmark_desc;
		this.architect = architect;
		this.landmark_hours = landmark_hours;
		this.fee = fee;
		this.traffic_info = traffic_info;
		this.tmi = tmi;
		this.arch_style = arch_style;
		this.website = website;
		this.landmark_usage = landmark_usage;
		this.completion_time = completion_time;
		this.longitude = longitude;
		this.latitude = latitude;
		this.landmark_name_en = landmark_name_en;
	}
	
	public Landmark() {
		// TODO Auto-generated constructor stub
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
	public String getLandmark_desc() {
		return landmark_desc;
	}
	public void setLandmark_desc(String landmark_desc) {
		this.landmark_desc = landmark_desc;
	}
	public String getArchitect() {
		return architect;
	}
	public void setArchitect(String architect) {
		this.architect = architect;
	}
	public String getLandmark_hours() {
		return landmark_hours;
	}
	public void setLandmark_hours(String landmark_hours) {
		this.landmark_hours = landmark_hours;
	}
	public String getFee() {
		return fee;
	}
	public void setFee(String fee) {
		this.fee = fee;
	}
	public String getTraffic_info() {
		return traffic_info;
	}
	public void setTraffic_info(String traffic_info) {
		this.traffic_info = traffic_info;
	}
	public String getTmi() {
		return tmi;
	}
	public void setTmi(String tmi) {
		this.tmi = tmi;
	}
	public String getArch_style() {
		return arch_style;
	}
	public void setArch_style(String arch_style) {
		this.arch_style = arch_style;
	}
	public String getWebsite() {
		return website;
	}
	public void setWebsite(String website) {
		this.website = website;
	}
	public String getLandmark_usage() {
		return landmark_usage;
	}
	public void setLandmark_usage(String landmark_usage) {
		this.landmark_usage = landmark_usage;
	}
	public String getCompletion_time() {
		return completion_time;
	}
	public void setCompletion_time(String completion_time) {
		this.completion_time = completion_time;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
    

    
}