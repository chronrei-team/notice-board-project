package notice.project.posts.DTO;

public class File {
    private final String name;
    private final String url;
    private final String size;

    public File(String name, String url, String size) {
        this.name = name;
        this.url = url;
        this.size = size;
    }

    public String getUrl() {
        return url;
    }

    public String getName() {
        return name;
    }

    public String getSize() {
        return size;
    }
}
