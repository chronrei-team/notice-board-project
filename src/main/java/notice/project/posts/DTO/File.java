package notice.project.posts.DTO;

public class File {
    private final String name;
    private final String url;
    private final String size;
    private final String extension;

    public File(String name, String url, String size, String extension) {
        this.name = name;
        this.url = url;
        this.size = size;
        this.extension = extension;
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

    public String getExtension() {
        return extension;
    }
}
