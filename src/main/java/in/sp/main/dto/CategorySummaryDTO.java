package in.sp.main.dto;

public class CategorySummaryDTO {
    private String name;
    private String superCategory;
    private int count;
    private String iconClass;

    public CategorySummaryDTO(String name, String superCategory, int count, String iconClass) {
        this.name = name;
        this.superCategory = superCategory;
        this.count = count;
        this.iconClass = iconClass;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSuperCategory() {
        return superCategory;
    }

    public void setSuperCategory(String superCategory) {
        this.superCategory = superCategory;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public String getIconClass() {
        return iconClass;
    }

    public void setIconClass(String iconClass) {
        this.iconClass = iconClass;
    }
}
