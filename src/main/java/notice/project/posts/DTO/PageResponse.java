package notice.project.posts.DTO;

import java.util.List;

public class PageResponse<T> {
    private List<T> fixedNotices;
    private List<T> data;       // 여기 BoardResponse 리스트가 들어감
    private int currentPage;
    private int startPage;
    private int endPage;
    private int totalButtons;
    private int rightArrowPage;
    private String queryString;

    public PageResponse(List<T> fixedNotices, List<T> data, int currentPage, int startPage, int endPage, int totalButtons,
                        int rightArrowPage, String queryString) {
        this.fixedNotices = fixedNotices;
        this.data = data;
        this.currentPage = currentPage;
        this.startPage = startPage;
        this.endPage = endPage;
        this.totalButtons = totalButtons;
        this.rightArrowPage = rightArrowPage;
        this.queryString = queryString;
    }

    public List<T> getFixedNotices() { return fixedNotices; }

    public List<T> getData() {
        return data;
    }

    public int getCurrentPage() {
        return currentPage;
    }

    public int getStartPage() {
        return startPage;
    }

    public int getEndPage() {
        return endPage;
    }

    public int getTotalButtons() {
        return totalButtons;
    }

    public int getRightArrowPage() {
        return rightArrowPage;
    }

    public String getQueryString() {
        return queryString;
    }
}
