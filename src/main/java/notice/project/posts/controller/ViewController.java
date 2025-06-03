package notice.project.posts.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/board/view")
public class ViewController extends HttpServlet {
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String markdownFromDb = "" +
                "넷플릭스 다 봤다면 이제 다른 OTT 서비스를 알아볼 때가 된 것 같네요.\n" +
                "요즘 디즈니플러스와 애플TV+에서 정말 재미있는 오리지널 콘텐츠가 많이 나오고 있어요. " +
                "특히 애플TV+의 '세베란스'와 '테드 래소'는 꼭 봐야 할 명작입니다!\n\n" +
                "디즈니플러스는 마블, 스타워즈 팬이라면 필수고, 웨이브는 한국 드라마와 예능을 좋아하신다면 추천드립니다. " +
                "아래 제가 정리한 표를 참고해보세요.\n\n" +
                "![OTT 서비스 비교](https://readdy.ai/api/search-image?query=A%20modern%20infographic%20comparing%20different%20OTT%20streaming%20services%20like%20Disney+%2C%20Apple%20TV+%2C%20Wavve%2C%20and%20Tving.%20The%20image%20shows%20logos%2C%20pricing%2C%20and%20popular%20content%20for%20each%20platform.%20Clean%20design%20with%20blue%20and%20white%20color%20scheme%2C%20professional%20looking%20comparison%20chart&width=800&height=500&seq=1&orientation=landscape)\n\n" +
                "개인적으로는 애플TV+가 가성비 최고인 것 같아요. 콘텐츠 수는 적지만 퀄리티가 정말 좋습니다. 다들 어떤 OTT 서비스 이용하시나요?";

        request.setAttribute("postContentMarkdown", markdownFromDb);
        request.getRequestDispatcher("/text.jsp").forward(request, response);
    }
}
