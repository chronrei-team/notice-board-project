package notice.project.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class HighlightUtil {

    // HTML 특수문자 이스케이프
    private static String escapeHtml(String str) {
        if (str == null) return null;
        return str.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    public static String highlight(String text, String keyword) {
        if (text == null || keyword == null || keyword.trim().isEmpty()) {
            return escapeHtml(text);
        }

        String escapedText = escapeHtml(text);

        // 다중 키워드 처리
        String[] words = keyword.trim().split("\\s+"); // 공백 기준 분리
        StringBuilder patternBuilder = new StringBuilder();

        for (int i = 0; i < words.length; i++) {
            if (i > 0) patternBuilder.append("|");
            patternBuilder.append(Pattern.quote(escapeHtml(words[i]))); // HTML 이스케이프된 단어
        }

        Pattern pattern = Pattern.compile("(" + patternBuilder.toString() + ")", Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(escapedText);
        StringBuffer result = new StringBuffer();

        while (matcher.find()) {
            matcher.appendReplacement(result, "<mark>" + Matcher.quoteReplacement(matcher.group(1)) + "</mark>");
        }
        matcher.appendTail(result);

        return result.toString();
    }
}
