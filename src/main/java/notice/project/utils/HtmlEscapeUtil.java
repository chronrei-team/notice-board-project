package notice.project.utils;

public class HtmlEscapeUtil {
    /**
     * HTML 태그 문자 등을 이스케이프 처리하여 XSS를 방지합니다.
     * @param input 원본 문자열
     * @return 이스케이프된 문자열
     */
    public static String escapeHtml(String input) {
        if (input == null) return null;

        return input.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#x27;");
    }
}
