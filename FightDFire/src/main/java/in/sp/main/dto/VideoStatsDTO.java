package in.sp.main.dto;

import in.sp.main.Entities.Videoupload;

public class VideoStatsDTO {
    private Videoupload video;
    private int viewCount;
    private int likeCount;
    public Videoupload getVideo() {
		return video;
	}
	public void setVideo(Videoupload video) {
		this.video = video;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public int getCommentCount() {
		return commentCount;
	}
	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}
	public int getScore() {
		return score;
	}
	public void setScore(int score) {
		this.score = score;
	}
	private int commentCount;
    private int score;

    // getters & setters
}
