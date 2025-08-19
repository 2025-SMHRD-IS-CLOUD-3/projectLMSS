package model;

public class Hotspot {
	private int hotspot_id;
	private String hotspot_name;
	private String hotspot_type;
	private String hotspot_info;
	private double hotspot_lati;
	private double hotspot_long;
	
	public Hotspot(int hotspot_id, String hotspot_name, String hotspot_type, String hotspot_info, double hotspot_lati,
			double hotspot_long) {
		super();
		this.hotspot_id = hotspot_id;
		this.hotspot_name = hotspot_name;
		this.hotspot_type = hotspot_type;
		this.hotspot_info = hotspot_info;
		this.hotspot_lati = hotspot_lati;
		this.hotspot_long = hotspot_long;
	}
	public Hotspot() {
		// TODO Auto-generated constructor stub
	}
	public int getHotspot_id() {
		return hotspot_id;
	}
	public void setHotspot_id(int hotspot_id) {
		this.hotspot_id = hotspot_id;
	}
	public String getHotspot_name() {
		return hotspot_name;
	}
	public void setHotspot_name(String hotspot_name) {
		this.hotspot_name = hotspot_name;
	}
	public String getHotspot_type() {
		return hotspot_type;
	}
	public void setHotspot_type(String hotspot_type) {
		this.hotspot_type = hotspot_type;
	}
	public String getHotspot_info() {
		return hotspot_info;
	}
	public void setHotspot_info(String hotspot_info) {
		this.hotspot_info = hotspot_info;
	}
	public double getHotspot_lati() {
		return hotspot_lati;
	}
	public void setHotspot_lati(double hotspot_lati) {
		this.hotspot_lati = hotspot_lati;
	}
	public double getHotspot_long() {
		return hotspot_long;
	}
	public void setHotspot_long(double hotspot_long) {
		this.hotspot_long = hotspot_long;
	}
}
