package notice.project.utils;

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

    public static String highlight(String text, String keywordInput) {
        if (text == null || keywordInput == null || keywordInput.isBlank()) return escapeHtml(text);

        String escapedText = escapeHtml(text);
        String[] words = keywordInput.trim().split("\\s+");

        for (String word : words) {
            if (!word.isBlank()) {
                String escapedWord = escapeHtml(word);
                // (?i) = 대소문자 무시, Pattern.quote = 특수문자 이스케이프
                escapedText = escapedText.replaceAll("(?i)(" + java.util.regex.Pattern.quote(escapedWord) + ")", "<mark>$1</mark>");
            }
        }

        return escapedText;
    }
}
