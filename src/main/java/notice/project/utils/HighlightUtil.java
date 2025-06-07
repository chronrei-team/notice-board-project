package notice.project.utils;

import java.util.regex.Pattern;

public class HighlightUtil {

    // HTML 특수문자 이스케이프 직접 구현
    private static String escapeHtml(String str) {
        if (str == null) return null;
        return str.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    public static String highlight(String text, String keyword) {
        if (text == null || keyword == null || keyword.isEmpty()) {
            return HtmlEscapeUtil.escapeHtml(text);
        }

        String escapedText = HtmlEscapeUtil.escapeHtml(text);
        String escapedKeyword = HtmlEscapeUtil.escapeHtml(keyword);

        // keyword를 하이라이팅 (대소문자 무시)
        return escapedText.replaceAll("(?i)(" + Pattern.quote(escapedKeyword) + ")", "<mark>$1</mark>");
    }
}
