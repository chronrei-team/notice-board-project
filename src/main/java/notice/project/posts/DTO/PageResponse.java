package notice.project.posts.DTO;

import java.util.List;

public class PageResponse<T> {
    private List<T> data;       // 여기 BoardResponse 리스트가 들어감
    private int currentPage;
    private int startPage;
    private int endPage;
    private int totalButtons;

    public PageResponse(List<T> data, int currentPage, int startPage, int endPage, int totalButtons) {
        this.data = data;
        this.currentPage = currentPage;
        this.startPage = startPage;
        this.endPage = endPage;
        this.totalButtons = totalButtons;
    }

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
}
