package notice.project.entity;

import java.io.File;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.Objects;

public class PostFiles {

    /** 첨부파일 ID (PK) */
    public Integer id;

    /** 게시글 ID (FK, posts.id 참조) */
    public Integer postId;

    /** 원본 파일 이름 */
    public String name;

    /** 파일 저장 위치/URL */
    public String url;

    /** 파일 용량 */
    public long size;

    /** 업로드 시간 */
    public LocalDateTime uploadedAt;

    public Posts post;

    public String getFormattedSize() {
        if (size <= 0) {
            return "0B";
        }

        // 단위를 나타내는 문자열 배열
        final String[] units = new String[] { "B", "KB", "MB", "GB", "TB" };

        // 1024로 몇 번 나눌 수 있는지 계산 (log 연산)
        int digitGroups = (int) (Math.log10(size) / Math.log10(1024));

        // 해당 단위로 파일 크기를 계산하고, 소수점 첫째 자리까지 포맷팅
        return new DecimalFormat("#,##0.#").format(size / Math.pow(1024, digitGroups))
                + units[digitGroups];
    }

    public String getExtension() {
        return name.lastIndexOf('.') >= 0
                ? name.toLowerCase().substring(name.lastIndexOf('.') + 1)
                : null;
    }

    public void remove(String rootPath, String uploadDirPath) {
        var file = new File(rootPath + File.separator + uploadDirPath + File.separator
                + url.substring(url.lastIndexOf('/') + 1));

        if (file.exists()) {
            file.delete();
        }
    }
}