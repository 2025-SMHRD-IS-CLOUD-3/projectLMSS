package model;

public class Landmark {

    private int landmarkId;
    private String landmarkName;
    private String location;
    private String description;

    // 기본 생성자
    public Landmark() {
    }

    // 모든 필드를 포함하는 생성자
    public Landmark(int landmarkId, String landmarkName, String location, String description) {
        this.landmarkId = landmarkId;
        this.landmarkName = landmarkName;
        this.location = location;
        this.description = description;
    }

    // Getter와 Setter
    public int getLandmarkId() {
        return landmarkId;
    }

    public void setLandmarkId(int landmarkId) {
        this.landmarkId = landmarkId;
    }

    public String getLandmarkName() {
        return landmarkName;
    }

    public void setLandmarkName(String landmarkName) {
        this.landmarkName = landmarkName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}