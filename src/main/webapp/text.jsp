<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- fn:escapeXml 사용을 위해 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>요즘 인기있는 OTT 추천 좀 해주세요. 넷플릭스 다 봤어요.</title>
    <%@ include file="common/tailwind.jspf" %>
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
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

        #post-content-viewer .toastui-editor-contents { /* Viewer 콘텐츠 전체에 적용 */
            font-family: 'Noto Sans KR', sans-serif; /* 기존 body에 적용된 폰트와 동일하게 */
        }

        /* Toast UI Viewer 콘텐츠 스타일 조정 */
        #post-content-viewer .toastui-editor-contents p { /* Viewer 내부의 p 태그 대상 */
            font-family: inherit; /* 상위 요소의 font-family를 상속받도록 명시 (선택 사항) */
            font-size: 1rem; /* 예: 16px, Tailwind의 text-base와 유사 */
            /* 기존 스타일에서 사용된 Tailwind 클래스를 직접 적용하거나 유사한 CSS 속성 사용 */
            color: #374151; /* Tailwind의 text-gray-800 */
            margin-bottom: 1rem; /* Tailwind의 mb-4 */
            line-height: 1.6; /* 가독성을 위한 줄 간격 (선택 사항) */
        }

        /* 코드 블록은 보통 고정폭 글꼴을 사용하므로 별도 지정 */
        #post-content-viewer .toastui-editor-contents pre code {
            font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace; /* 고정폭 글꼴 유지 */
            font-size: 0.875rem;
            color: #1f2937;
        }

        /* 제목(h1, h2 등) 스타일도 필요하다면 조정 */
        #post-content-viewer .toastui-editor-contents h1 {
            font-size: 1.875rem; /* Tailwind의 text-2xl */
            font-weight: 700; /* Tailwind의 font-bold */
            color: #111827; /* Tailwind의 text-gray-900 */
            margin-bottom: 1.5rem; /* Tailwind의 mb-6 */
        }

        #post-content-viewer .toastui-editor-contents h2 {
            font-size: 1.5rem; /* Tailwind의 text-xl */
            font-weight: 700;
            color: #111827;
            margin-bottom: 1rem;
        }

        /* 이미지 스타일 조정 (마크다운으로 삽입된 이미지) */
        #post-content-viewer .toastui-editor-contents img {
            max-width: 80%; /* 기존 w-4/5 와 유사하게 */
            display: block; /* 중앙 정렬을 위해 */
            margin-left: auto;
            margin-right: auto;
            border-radius: 0.25rem; /* Tailwind의 rounded */
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06); /* Tailwind의 shadow-sm */
            margin-bottom: 0.5rem; /* Tailwind의 mb-2 */
        }

        /* 인용구 스타일 */
        #post-content-viewer .toastui-editor-contents blockquote {
            border-left: 4px solid #e5e7eb; /* Tailwind의 border-gray-200 */
            padding-left: 1rem;
            margin-left: 0;
            margin-bottom: 1rem;
            font-style: italic;
            color: #4b5563; /* Tailwind의 text-gray-600 */
        }
        #post-content-viewer .toastui-editor-contents blockquote p {
            margin-bottom: 0.5rem; /* 인용구 내 문단 간격 조정 */
        }

        /* 코드 블록 스타일 (기본 스타일이 괜찮다면 생략 가능) */
        #post-content-viewer .toastui-editor-contents pre {
            background-color: #f3f4f6; /* Tailwind의 bg-gray-100 */
            padding: 1rem;
            border-radius: 0.25rem;
            overflow-x: auto; /* 가로 스크롤 */
            margin-bottom: 1rem;
        }
        #post-content-viewer .toastui-editor-contents pre code {
            font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;
            font-size: 0.875rem; /* Tailwind의 text-sm */
            color: #1f2937; /* Tailwind의 text-gray-900 */
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
        <!-- 게시글 본문 카드 -->
        <div class="bg-white rounded shadow-sm mb-6">
            <%-- ... 게시글 헤더, 작성자 정보 등은 그대로 유지 ... --%>

            <!-- 게시글 본문 (이 부분을 수정) -->
            <div class="toastui-editor-contents mb-8" id="post-content-viewer">
                <%-- 이 div는 Toast UI Viewer에 의해 내용이 채워집니다. --%>
                <%-- 'toastui-editor-contents' 클래스를 추가하면 TUI Editor의 기본 스타일 일부가 적용될 수 있습니다.
                     디자인 일관성을 위해 필요에 따라 조정하거나 제거할 수 있습니다. --%>
            </div>
            <%-- 서버로부터 전달받은 마크다운 데이터를 저장할 숨겨진 textarea --%>
            <%-- 중요: 서버에서 'postContentMarkdown'라는 이름으로 마크다운 문자열을 request attribute에 담아 전달한다고 가정합니다. --%>
            <%--       JSTL을 사용하기 위해 JSP 상단에 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 와
                        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 가 선언되어 있어야 합니다. --%>
            <textarea id="markdown-data" style="display:none;">${fn:escapeXml(postContentMarkdown)}</textarea>

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
    function downloadImageFromViewer(buttonElement) {
        // 버튼의 부모(buttonWrapper)의 이전 형제 요소가 이미지여야 함.
        // 또는, 버튼 생성 시 data-img-src 속성 등으로 이미지 URL을 버튼에 저장해두고 여기서 가져올 수도 있음.
        const imageWrapper = buttonElement.parentElement; // buttonWrapper div
        if (imageWrapper && imageWrapper.previousElementSibling && imageWrapper.previousElementSibling.tagName === 'IMG') {
            const img = imageWrapper.previousElementSibling;
            const link = document.createElement('a');
            link.href = img.src;

            // 파일명 추출 (URL의 마지막 부분을 사용하거나, alt 속성 등을 활용)
            let filename = 'downloaded_image.png'; // 기본 파일명
            try {
                const urlParts = img.src.split('/');
                const lastPart = urlParts[urlParts.length - 1];
                const queryParamIndex = lastPart.indexOf('?');
                filename = decodeURIComponent(queryParamIndex !== -1 ? lastPart.substring(0, queryParamIndex) : lastPart);
                if (!filename.match(/\.(jpeg|jpg|gif|png)$/i)) { // 확장자가 없으면 기본으로 .png 추가
                    filename += '.png';
                }
            } catch (e) {
                console.warn("Could not generate filename from image src, using default.", e);
            }
            if (img.alt) { // alt 속성이 있다면 파일명에 활용
                filename = img.alt.replace(/[^a-zA-Z0-9ㄱ-힣\s\._-]/g, '') + (filename.match(/\.[0-9a-z]+$/i) ? '' : '.png') || filename;
            }


            link.download = filename;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        } else {
            console.error("Could not find the image to download from this button.", buttonElement);
        }
    }

    document.addEventListener("DOMContentLoaded", function () {


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

        // --- 새로운 코드: 게시글 본문 뷰어 초기화 ---
        const markdownDataTextarea = document.getElementById('markdown-data');
        const viewerElement = document.getElementById('post-content-viewer');

        // 수정된 코드 (toastui.Editor.factory() 사용)
        if (markdownDataTextarea && viewerElement && window.toastui && window.toastui.Editor) { // Viewer 대신 Editor 클래스만 확인
            const markdownContent = markdownDataTextarea.value;

            if (markdownContent.trim() === "") {
                viewerElement.innerHTML = '<p class="text-gray-500">게시글 내용이 없습니다.</p>';
            } else {
                try {
                    const viewer = toastui.Editor.factory({
                        el: viewerElement,
                        viewer: true,
                        initialValue: markdownContent
                    });

                    // --- 중요: Viewer 렌더링 후 이미지에 다운로드 버튼 추가 ---
                    // 약간의 지연을 주어 Viewer가 DOM을 완전히 구성할 시간을 확보 (선택적이지만 안정적일 수 있음)
                    setTimeout(() => {
                        const imagesInViewer = viewerElement.querySelectorAll('.toastui-editor-contents img'); // Viewer 내부의 이미지들 선택
                        imagesInViewer.forEach(img => {
                            // 이미 버튼이 추가되었는지 확인 (중복 방지)
                            if (img.nextElementSibling && img.nextElementSibling.classList.contains('download-image-button-wrapper')) {
                                return;
                            }

                            // 버튼을 감싸는 div (Tailwind 스타일 적용 용이)
                            const buttonWrapper = document.createElement('div');
                            buttonWrapper.className = 'flex flex-col items-center mt-2 download-image-button-wrapper'; // 기존 스타일과 유사하게

                            const downloadButton = document.createElement('button');
                            downloadButton.className = 'flex items-center gap-2 text-sm text-gray-600 hover:text-primary transition-colors';
                            // downloadButton.onclick = function() { downloadImage(this); }; // 이렇게 직접 함수를 할당할 수도 있습니다.
                            // 이 경우 downloadImage 함수가 this (버튼)를 제대로 처리해야 함.
                            // 또는 downloadImage 함수가 전역에 있다면 아래처럼:
                            downloadButton.setAttribute('onclick', 'downloadImageFromViewer(this)');


                            const icon = document.createElement('i');
                            icon.className = 'ri-download-line';

                            const span = document.createElement('span');
                            span.textContent = '이미지 다운로드';

                            downloadButton.appendChild(icon);
                            downloadButton.appendChild(span);
                            buttonWrapper.appendChild(downloadButton);

                            // 이미지를 감싸는 부모 요소 (보통 <p> 태그) 다음에 버튼 삽입
                            // 또는 이미지 바로 다음에 삽입 (img.parentNode.insertBefore(buttonWrapper, img.nextSibling);)
                            // 이미지가 <p> 태그 등으로 감싸여 있을 수 있으므로, img.parentNode를 기준으로 삽입
                            if (img.parentElement) {
                                // 이미지가 <p> 안에 있다면, <p> 태그 다음에 버튼을 추가하는 것이 레이아웃상 더 자연스러울 수 있음
                                // 여기서는 이미지 바로 아래에 버튼을 추가하는 것으로 가정
                                // 만약 img 태그가 figure 태그 등으로 감싸져 있다면, 그 구조에 맞게 조정 필요
                                img.parentNode.insertBefore(buttonWrapper, img.nextSibling);
                            }
                        });
                    }, 100); // 100ms 지연. DOM 렌더링이 복잡하면 더 늘릴 수 있음.
                    // --- 이미지 다운로드 버튼 추가 로직 끝 ---

                } catch (error) {
                    console.error("Error initializing Toast UI Viewer with factory:", error);
                    viewerElement.innerHTML = '<p class="text-red-500">게시글을 불러오는 중 오류가 발생했습니다. (factory)</p>';
                }
            }
        } else {
            // 필요한 요소나 라이브러리가 없는 경우 콘솔에 경고
            if (!markdownDataTextarea) console.warn("Markdown data textarea (#markdown-data) not found.");
            if (!viewerElement) console.warn("Viewer element (#post-content-viewer) not found.");
            if (!(window.toastui && window.toastui.Editor)) { // Editor 클래스 확인
                console.warn("Toast UI Editor library (toastui.Editor) not loaded.");
                if(viewerElement) viewerElement.innerHTML = '<p class="text-red-500">콘텐츠 뷰어를 로드하지 못했습니다. toastui.Editor를 확인해주세요.</p>';
            }
        }
    });
</script>
</body>
</html>
