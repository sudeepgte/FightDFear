package in.sp.main.dto;
public class QuestionSubmissionDTO {
    private String content;
    private String displayName;
    public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}