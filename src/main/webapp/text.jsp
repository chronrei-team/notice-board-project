<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>요즘 인기있는 OTT 추천 좀 해주세요. 넷플릭스 다 봤어요.</title>
    <%@ include file="common/tailwind.jspf" %>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.6.0/remixicon.min.css"
    />
    <style>
        :where([class^="ri-"])::before { content: "\f3c2"; }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
        }
        .comment-input:focus {
            outline: none;
        }
        .reply-form {
            display: none;
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
<!-- 상단 네비게이션 바 -->
<%@ include file="common/header.jspf" %>

<main class="container mx-auto px-4 py-6 max-w-4xl">
    <!-- 목록으로 돌아가기 링크 -->
    <div class="mb-4">
        <a
                href="https://readdy.ai/home/557a148f-5a49-413d-8b99-ea592936ab91/fad9ebf2-a518-4655-bb76-bc5dac337c03"
                data-readdy="true"
                class="inline-flex items-center text-gray-600 hover:text-primary transition-colors"
        >
            <div class="w-5 h-5 flex items-center justify-center mr-1">
                <i class="ri-arrow-left-line"></i>
            </div>
            <span>목록으로 돌아가기</span>
        </a>
    </div>
    <!-- 게시글 본문 카드 -->
    <div class="bg-white rounded shadow-sm p-6 mb-6">
        <!-- 게시글 헤더 -->
        <div class="flex justify-between items-start mb-6">
            <h1 class="text-2xl font-bold text-gray-900 mb-4">
                요즘 인기있는 OTT 추천 좀 해주세요. 넷플릭스 다 봤어요.
            </h1>
            <div class="flex space-x-2">
                <button class="text-gray-500 hover:text-primary transition-colors">
                    <div class="w-6 h-6 flex items-center justify-center">
                        <i class="ri-edit-line"></i>
                    </div>
                </button>
                <button class="text-gray-500 hover:text-red-500 transition-colors">
                    <div class="w-6 h-6 flex items-center justify-center">
                        <i class="ri-delete-bin-line"></i>
                    </div>
                </button>
            </div>
        </div>
        <!-- 작성자 정보 및 메타데이터 -->
        <div class="flex items-center mb-6">
            <div
                    class="w-10 h-10 rounded-full bg-gray-200 overflow-hidden flex items-center justify-center mr-3"
            >
                <i class="ri-user-line text-gray-500"></i>
            </div>
            <div>
                <div class="font-medium text-gray-900">김태호</div>
                <div class="flex items-center text-sm text-gray-500 space-x-3">
                    <span>2025-05-24 13:55:11</span>
                    <span class="flex items-center">
                <div class="w-4 h-4 flex items-center justify-center mr-1">
                  <i class="ri-eye-line"></i>
                </div>
                조회 238
              </span>
                </div>
            </div>
        </div>
        <!-- 게시글 본문 -->
        <div class="mb-8">
            <p class="text-gray-800 mb-4">
                넷플릭스 다 봤다면 이제 다른 OTT 서비스를 알아볼 때가 된 것 같네요.
                요즘 디즈니플러스와 애플TV+에서 정말 재미있는 오리지널 콘텐츠가 많이
                나오고 있어요. 특히 애플TV+의 '세베란스'와 '테드 래소'는 꼭 봐야 할
                명작입니다!
            </p>
            <p class="text-gray-800 mb-6">
                디즈니플러스는 마블, 스타워즈 팬이라면 필수고, 웨이브는 한국
                드라마와 예능을 좋아하신다면 추천드립니다. 아래 제가 정리한 표를
                참고해보세요.
            </p>
            <!-- 이미지 -->
            <div class="flex flex-col items-center mb-6">
                <img
                        src="https://readdy.ai/api/search-image?query=A%20modern%20infographic%20comparing%20different%20OTT%20streaming%20services%20like%20Disney+%2C%20Apple%20TV+%2C%20Wavve%2C%20and%20Tving.%20The%20image%20shows%20logos%2C%20pricing%2C%20and%20popular%20content%20for%20each%20platform.%20Clean%20design%20with%20blue%20and%20white%20color%20scheme%2C%20professional%20looking%20comparison%20chart&width=800&height=500&seq=1&orientation=landscape"
                        alt="OTT 서비스 비교"
                        class="w-4/5 object-cover rounded shadow-sm mb-2"
                />
                <button
                        class="flex items-center gap-2 text-sm text-gray-600 hover:text-primary transition-colors"
                        onclick="downloadImage(this)"
                >
                    <i class="ri-download-line"></i>
                    <span>이미지 다운로드</span>
                </button>
            </div>
            <p class="text-gray-800">
                개인적으로는 애플TV+가 가성비 최고인 것 같아요. 콘텐츠 수는 적지만
                퀄리티가 정말 좋습니다. 다들 어떤 OTT 서비스 이용하시나요?
            </p>
            <!-- 첨부파일 다운로드 섹션 -->
            <div class="mt-8 border-t border-gray-100 pt-6">
                <h4 class="text-sm font-medium text-gray-900 mb-3">첨부파일</h4>
                <div class="space-y-2">
                    <a
                            href="#"
                            class="flex items-center p-3 bg-gray-50 rounded hover:bg-gray-100 transition-colors group"
                    >
                        <div
                                class="w-10 h-10 flex items-center justify-center bg-gray-200 rounded mr-3"
                        >
                            <i class="ri-file-excel-2-line text-green-600 text-xl"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">
                                OTT_서비스_비교표.xlsx
                            </p>
                            <p class="text-xs text-gray-500">2.4MB</p>
                        </div>
                        <div
                                class="w-8 h-8 flex items-center justify-center text-gray-400 group-hover:text-primary"
                        >
                            <i class="ri-download-line"></i>
                        </div>
                    </a>
                    <a
                            href="#"
                            class="flex items-center p-3 bg-gray-50 rounded hover:bg-gray-100 transition-colors group"
                    >
                        <div
                                class="w-10 h-10 flex items-center justify-center bg-gray-200 rounded mr-3"
                        >
                            <i class="ri-file-pdf-line text-red-600 text-xl"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">
                                OTT_콘텐츠_추천_가이드.pdf
                            </p>
                            <p class="text-xs text-gray-500">1.8MB</p>
                        </div>
                        <div
                                class="w-8 h-8 flex items-center justify-center text-gray-400 group-hover:text-primary"
                        >
                            <i class="ri-download-line"></i>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!-- 댓글 섹션 -->
    <div class="bg-white rounded shadow-sm p-6">
        <div class="flex justify-between items-center mb-6">
            <h3 class="text-lg font-medium text-gray-900">댓글 5개</h3>
            <div class="flex items-center space-x-2">
                <select
                        id="comment-sort"
                        class="text-sm border border-gray-200 rounded-button py-1.5 px-3 pr-8 text-gray-700 focus:outline-none focus:border-primary"
                >
                    <option value="latest">최신순</option>
                    <option value="oldest">오래된순</option>
                    <option value="replies">답글순</option>
                </select>
            </div>
        </div>
        <!-- 댓글 목록 -->
        <div class="space-y-6 mb-8">
            <!-- 댓글 1 -->
            <div class="comment">
                <div class="flex items-start gap-3">
                    <div
                            class="w-10 h-10 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                    >
                        <i class="ri-user-line text-gray-500"></i>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center mb-1">
                            <span class="font-medium text-gray-900 mr-2">박지민</span>
                            <span class="text-sm text-gray-500">2025-05-24 14:23</span>
                        </div>
                        <p class="text-gray-800 mb-2">
                            저는 요즘 디즈니플러스 보고 있는데 정말 좋아요! 마블 시리즈
                            팬이라면 꼭 봐야할 것 같아요. '로키'랑 '완다비전' 강추합니다!
                        </p>
                        <button
                                class="text-sm text-primary hover:text-primary/80 reply-toggle"
                                data-comment-id="1"
                        >
                            답글달기
                        </button>
                        <!-- 답글 작성 폼 -->
                        <div
                                class="reply-form mt-3 pl-4 border-l-2 border-gray-200"
                                id="reply-form-1"
                        >
                            <div class="flex items-start gap-3">
                                <div
                                        class="w-8 h-8 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                                >
                                    <i class="ri-user-line text-gray-500"></i>
                                </div>
                                <div class="flex-1">
                                    <div class="text-sm text-gray-500 mb-2">
                                        박지민님에게 답글 작성중
                                    </div>
                                    <div class="flex flex-col gap-2">
                                        <input
                                                type="text"
                                                class="comment-input w-full border border-gray-200 rounded-button py-2 px-3 text-gray-800"
                                                placeholder="답글을 입력하세요..."
                                        />
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center gap-2">
                                                <label class="relative cursor-pointer">
                                                    <input
                                                            type="file"
                                                            class="hidden"
                                                            accept=".jpg,.jpeg,.png,.gif,.pdf,.doc,.docx,.xls,.xlsx"
                                                    />
                                                    <div
                                                            class="flex items-center gap-1 text-sm text-gray-600 hover:text-primary"
                                                    >
                                                        <i class="ri-attachment-2"></i>
                                                        <span>파일첨부</span>
                                                    </div>
                                                </label>
                                                <span
                                                        class="selected-file text-sm text-gray-500"
                                                ></span>
                                            </div>
                                            <div class="flex gap-2">
                                                <button class="text-sm text-gray-500 cancel-reply">
                                                    취소
                                                </button>
                                                <button
                                                        class="bg-primary text-white px-4 py-2 rounded-button whitespace-nowrap"
                                                >
                                                    등록
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- 대댓글 -->
                        <div class="mt-4 pl-4 border-l-2 border-gray-200">
                            <div class="flex items-start gap-3 mb-4">
                                <div
                                        class="w-8 h-8 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                                >
                                    <i class="ri-user-line text-gray-500"></i>
                                </div>
                                <div class="flex-1">
                                    <div class="flex items-center mb-1">
                        <span class="font-medium text-gray-900 mr-2"
                        >김태호</span
                        >
                                        <span class="text-sm text-gray-500"
                                        >2025-05-24 15:10</span
                                        >
                                    </div>
                                    <p class="text-gray-800 mb-2">
                                        저도 '로키' 정말 재밌게 봤어요! 시즌2도 기대됩니다.
                                    </p>
                                    <button
                                            class="text-sm text-primary hover:text-primary/80 reply-toggle"
                                            data-comment-id="1-1"
                                    >
                                        답글달기
                                    </button>
                                    <!-- 답글 작성 폼 -->
                                    <div class="reply-form mt-3" id="reply-form-1-1">
                                        <div class="flex items-start gap-3">
                                            <div
                                                    class="w-8 h-8 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                                            >
                                                <i class="ri-user-line text-gray-500"></i>
                                            </div>
                                            <div class="flex-1">
                                                <div class="text-sm text-gray-500 mb-2">
                                                    김태호님에게 답글 작성중
                                                </div>
                                                <div class="flex">
                                                    <input
                                                            type="text"
                                                            class="comment-input flex-1 border border-gray-200 rounded-l-button py-2 px-3 text-gray-800"
                                                            placeholder="답글을 입력하세요..."
                                                    />
                                                    <button
                                                            class="bg-primary text-white px-4 py-2 rounded-r-button whitespace-nowrap"
                                                    >
                                                        등록
                                                    </button>
                                                </div>
                                                <button
                                                        class="text-sm text-gray-500 mt-2 cancel-reply"
                                                >
                                                    취소
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 댓글 2 -->
            <div class="comment">
                <div class="flex items-start gap-3">
                    <div
                            class="w-10 h-10 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                    >
                        <i class="ri-user-line text-gray-500"></i>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center mb-1">
                            <span class="font-medium text-gray-900 mr-2">이수진</span>
                            <span class="text-sm text-gray-500">2025-05-24 16:45</span>
                        </div>
                        <p class="text-gray-800 mb-2">
                            애플TV+ 정말 좋아요! '테드 래소'는 제가 본 드라마 중에
                            최고예요. 웃음과 감동이 있어서 힐링됩니다. '세베란스'도
                            미스터리한 분위기가 매력적이에요.
                        </p>
                        <button
                                class="text-sm text-primary hover:text-primary/80 reply-toggle"
                                data-comment-id="2"
                        >
                            답글달기
                        </button>
                        <!-- 답글 작성 폼 -->
                        <div
                                class="reply-form mt-3 pl-4 border-l-2 border-gray-200"
                                id="reply-form-2"
                        >
                            <div class="flex items-start gap-3">
                                <div
                                        class="w-8 h-8 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                                >
                                    <i class="ri-user-line text-gray-500"></i>
                                </div>
                                <div class="flex-1">
                                    <div class="text-sm text-gray-500 mb-2">
                                        이수진님에게 답글 작성중
                                    </div>
                                    <div class="flex">
                                        <input
                                                type="text"
                                                class="comment-input flex-1 border border-gray-200 rounded-l-button py-2 px-3 text-gray-800"
                                                placeholder="답글을 입력하세요..."
                                        />
                                        <button
                                                class="bg-primary text-white px-4 py-2 rounded-r-button whitespace-nowrap"
                                        >
                                            등록
                                        </button>
                                    </div>
                                    <button class="text-sm text-gray-500 mt-2 cancel-reply">
                                        취소
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 댓글 3 -->
            <div class="comment">
                <div class="flex items-start gap-3">
                    <div
                            class="w-10 h-10 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                    >
                        <i class="ri-user-line text-gray-500"></i>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center mb-1">
                            <span class="font-medium text-gray-900 mr-2">최준호</span>
                            <span class="text-sm text-gray-500">2025-05-25 09:12</span>
                        </div>
                        <p class="text-gray-800 mb-2">
                            웨이브도 괜찮아요. 한국 드라마와 예능을 주로 보신다면
                            추천합니다. 특히 JTBC, TVN 프로그램이 많아서 좋더라고요. 다만
                            해외 콘텐츠는 좀 부족한 편이에요.
                        </p>
                        <button
                                class="text-sm text-primary hover:text-primary/80 reply-toggle"
                                data-comment-id="3"
                        >
                            답글달기
                        </button>
                        <!-- 답글 작성 폼 -->
                        <div
                                class="reply-form mt-3 pl-4 border-l-2 border-gray-200"
                                id="reply-form-3"
                        >
                            <div class="flex items-start gap-3">
                                <div
                                        class="w-8 h-8 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                                >
                                    <i class="ri-user-line text-gray-500"></i>
                                </div>
                                <div class="flex-1">
                                    <div class="text-sm text-gray-500 mb-2">
                                        최준호님에게 답글 작성중
                                    </div>
                                    <div class="flex">
                                        <input
                                                type="text"
                                                class="comment-input flex-1 border border-gray-200 rounded-l-button py-2 px-3 text-gray-800"
                                                placeholder="답글을 입력하세요..."
                                        />
                                        <button
                                                class="bg-primary text-white px-4 py-2 rounded-r-button whitespace-nowrap"
                                        >
                                            등록
                                        </button>
                                    </div>
                                    <button class="text-sm text-gray-500 mt-2 cancel-reply">
                                        취소
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 댓글 4 -->
            <div class="comment">
                <div class="flex items-start gap-3">
                    <div
                            class="w-10 h-10 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                    >
                        <i class="ri-user-line text-gray-500"></i>
                    </div>
                    <div class="flex-1">
                        <div class="flex items-center mb-1">
                            <span class="font-medium text-gray-900 mr-2">정민수</span>
                            <span class="text-sm text-gray-500">2025-05-25 10:30</span>
                        </div>
                        <p class="text-gray-800 mb-2">
                            티빙도 요즘 오리지널 콘텐츠에 투자를 많이 하고 있어요. '유미의
                            세포들' 같은 작품이 인기가 많더라고요. 그리고 미국 HBO
                            콘텐츠도 많이 들어와서 볼거리가 많습니다.
                        </p>
                        <button
                                class="text-sm text-primary hover:text-primary/80 reply-toggle"
                                data-comment-id="4"
                        >
                            답글달기
                        </button>
                        <!-- 답글 작성 폼 -->
                        <div
                                class="reply-form mt-3 pl-4 border-l-2 border-gray-200"
                                id="reply-form-4"
                        >
                            <div class="flex items-start gap-3">
                                <div
                                        class="w-8 h-8 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
                                >
                                    <i class="ri-user-line text-gray-500"></i>
                                </div>
                                <div class="flex-1">
                                    <div class="text-sm text-gray-500 mb-2">
                                        정민수님에게 답글 작성중
                                    </div>
                                    <div class="flex">
                                        <input
                                                type="text"
                                                class="comment-input flex-1 border border-gray-200 rounded-l-button py-2 px-3 text-gray-800"
                                                placeholder="답글을 입력하세요..."
                                        />
                                        <button
                                                class="bg-primary text-white px-4 py-2 rounded-r-button whitespace-nowrap"
                                        >
                                            등록
                                        </button>
                                    </div>
                                    <button class="text-sm text-gray-500 mt-2 cancel-reply">
                                        취소
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- 댓글 작성 폼 -->
        <div class="flex items-start gap-3">
            <div
                    class="w-10 h-10 rounded-full bg-gray-200 overflow-hidden flex-shrink-0 flex items-center justify-center"
            >
                <i class="ri-user-line text-gray-500"></i>
            </div>
            <div class="flex-1">
                <div class="flex flex-col gap-2">
                    <input
                            type="text"
                            class="comment-input w-full border border-gray-200 rounded-button py-2 px-3 text-gray-800"
                            placeholder="댓글을 입력하세요..."
                    />
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <label class="relative cursor-pointer">
                                <input
                                        type="file"
                                        class="hidden"
                                        id="comment-file"
                                        accept=".jpg,.jpeg,.png,.gif,.pdf,.doc,.docx,.xls,.xlsx"
                                />
                                <div
                                        class="flex items-center gap-1 text-sm text-gray-600 hover:text-primary"
                                >
                                    <i class="ri-attachment-2"></i>
                                    <span>파일첨부</span>
                                </div>
                            </label>
                            <span id="selected-file" class="text-sm text-gray-500"></span>
                        </div>
                        <button
                                class="bg-primary text-white px-4 py-2 rounded-button whitespace-nowrap"
                        >
                            등록
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- 이전글/다음글 네비게이션 -->
    <div class="mt-6 flex flex-col sm:flex-row justify-between gap-3">
        <div class="flex space-x-3">
            <a
                    href="#"
                    class="inline-flex items-center text-gray-600 hover:text-primary transition-colors"
            >
                <div class="w-5 h-5 flex items-center justify-center mr-1">
                    <i class="ri-arrow-left-line"></i>
                </div>
                <span>이전글</span>
            </a>
            <a
                    href="#"
                    class="inline-flex items-center text-gray-600 hover:text-primary transition-colors"
            >
                <span>다음글</span>
                <div class="w-5 h-5 flex items-center justify-center ml-1">
                    <i class="ri-arrow-right-line"></i>
                </div>
            </a>
        </div>
        <a
                href="https://readdy.ai/home/557a148f-5a49-413d-8b99-ea592936ab91/fad9ebf2-a518-4655-bb76-bc5dac337c03"
                data-readdy="true"
                class="bg-gray-100 hover:bg-gray-200 text-gray-800 px-4 py-2 rounded-button text-center whitespace-nowrap transition-colors"
        >
            목록으로 돌아가기
        </a>
    </div>
</main>
<script id="comment-reply-script">
    document.addEventListener("DOMContentLoaded", function () {
        // 이미지 다운로드 함수
        function downloadImage(button) {
            const img = button.parentElement.querySelector("img");
            const link = document.createElement("a");
            link.href = img.src;
            link.download = "OTT_서비스_비교.png";
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
        window.downloadImage = downloadImage;

        // 파일 선택 처리 - 모든 파일 입력에 대해
        document.querySelectorAll('input[type="file"]').forEach((fileInput) => {
            fileInput.addEventListener("change", function () {
                const selectedFileSpan =
                    this.closest(".flex-1").querySelector(".selected-file");
                if (this.files.length > 0) {
                    const file = this.files[0];
                    const fileName = file.name;
                    const fileSize = (file.size / 1024 / 1024).toFixed(2);
                    selectedFileSpan.textContent = `${fileName} (${fileSize}MB)`;
                } else {
                    selectedFileSpan.textContent = "";
                }
            });
        });
        // 파일 선택 처리
        const fileInput = document.getElementById("comment-file");
        const selectedFileSpan = document.getElementById("selected-file");
        fileInput.addEventListener("change", function () {
            if (this.files.length > 0) {
                const file = this.files[0];
                const fileName = file.name;
                const fileSize = (file.size / 1024 / 1024).toFixed(2); // MB로 변환
                selectedFileSpan.textContent = `${fileName} (${fileSize}MB)`;
            } else {
                selectedFileSpan.textContent = "";
            }
        });
        // 댓글 정렬 처리
        const sortSelect = document.getElementById("comment-sort");
        const commentsList = document.querySelector(".space-y-6");
        sortSelect.addEventListener("change", function () {
            const comments = Array.from(commentsList.children);
            const sortValue = this.value;
            comments.sort((a, b) => {
                const dateA = new Date(a.querySelector(".text-gray-500").textContent);
                const dateB = new Date(b.querySelector(".text-gray-500").textContent);
                const repliesA = a.querySelectorAll(".border-l-2").length;
                const repliesB = b.querySelectorAll(".border-l-2").length;
                switch (sortValue) {
                    case "latest":
                        return dateB - dateA;
                    case "oldest":
                        return dateA - dateB;
                    case "replies":
                        return repliesB - repliesA;
                    default:
                        return 0;
                }
            });
            comments.forEach((comment) => commentsList.appendChild(comment));
        });
        const profileButton = document.getElementById("profile-menu-button");
        const profileDropdown = document.getElementById("profile-dropdown");
        let isDropdownOpen = false;
        profileButton.addEventListener("click", (e) => {
            e.stopPropagation();
            isDropdownOpen = !isDropdownOpen;
            profileDropdown.classList.toggle("hidden");
        });
        document.addEventListener("click", (e) => {
            if (isDropdownOpen && !profileDropdown.contains(e.target)) {
                profileDropdown.classList.add("hidden");
                isDropdownOpen = false;
            }
        });
        // 답글달기 버튼 클릭 이벤트
        const replyToggleButtons = document.querySelectorAll(".reply-toggle");
        replyToggleButtons.forEach((button) => {
            button.addEventListener("click", function () {
                const commentId = this.getAttribute("data-comment-id");
                const replyForm = document.getElementById(`reply-form-${commentId}`);
                // 다른 답글 폼 모두 닫기
                document.querySelectorAll(".reply-form").forEach((form) => {
                    if (form !== replyForm) {
                        form.style.display = "none";
                    }
                });
                // 현재 답글 폼 토글
                replyForm.style.display =
                    replyForm.style.display === "block" ? "none" : "block";
            });
        });
        // 취소 버튼 클릭 이벤트
        const cancelButtons = document.querySelectorAll(".cancel-reply");
        cancelButtons.forEach((button) => {
            button.addEventListener("click", function () {
                const replyForm = this.closest(".reply-form");
                replyForm.style.display = "none";
            });
        });
    });
</script>
</body>
</html>
