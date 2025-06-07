<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <title>메인 페이지</title>
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
        .pagination-btn:hover {
            background-color: #f3f4f6;
        }
        .pagination-btn.active {
            background-color: #4F46E5;
            color: white;
        }
        .custom-checkbox {
            appearance: none;
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid #d1d5db;
            border-radius: 4px;
            position: relative;
            cursor: pointer;
            transition: all 0.2s;
        }
        .custom-checkbox:checked {
            background-color: #4F46E5;
            border-color: #4F46E5;
        }
        .custom-checkbox:checked::after {
            content: '';
            position: absolute;
            left: 6px;
            top: 2px;
            width: 6px;
            height: 10px;
            border: solid white;
            border-width: 0 2px 2px 0;
            transform: rotate(45deg);
        }
        .custom-search:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.2);
        }
        @media (max-width: 768px) {
            .board-table {
                display: none;
            }
            .board-cards {
                display: block;
            }
        }
        @media (min-width: 769px) {
            .board-table {
                display: table;
            }
            .board-cards {
                display: none;
            }
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">
<!-- 헤더 영역 -->
<%@ include file="common/header.jspf" %>
<!-- 메인 컨텐츠 영역 -->
<main class="flex-1 container mx-auto px-4 py-8">
    <div class="bg-white rounded shadow-sm p-6">
        <c:if test="${param.message eq 'withdraw_success'}">
            <script>alert("회원탈퇴가 되었습니다.");</script>
        </c:if>
        <!-- 게시판 제목 및 글쓰기 버튼 -->
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800">
                <c:choose>
                    <c:when test="${param.category eq 'Normal'}">자유 게시판</c:when>
                    <c:when test="${param.category eq 'Notice'}">공지사항</c:when>
                    <c:when test="${param.category eq 'Qna'}">질문/답변 게시판</c:when>
                    <c:when test="${param.category eq 'Information'}">정보공유 게시판</c:when>
                    <c:otherwise>전체 게시판</c:otherwise>
                </c:choose>
            </h1>
            <a
                    href="${pageContext.request.contextPath}/board/write"
                    class="bg-primary text-white px-4 py-2 !rounded-button flex items-center whitespace-nowrap hover:bg-primary/90"
            >
                <div class="w-5 h-5 flex items-center justify-center mr-1">
                    <i class="ri-pencil-line"></i>
                </div>
                글쓰기
            </a>
        </div>
        <!-- 카테고리 탭 -->
        <div class="flex overflow-x-auto mb-6 pb-2">
            <div class="bg-gray-100 p-1 rounded-full flex space-x-1">
                <button
                        class="px-4 py-2 !rounded-full bg-primary text-white whitespace-nowrap
                        ${empty param.category ? 'bg-primary text-white' : 'text-gray-700'}"
                        data-category=""
                        onclick="filterByCategory(this)"
                >
                    전체
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 whitespace-nowrap
                        ${param.category eq 'Normal' ? 'bg-primary text-white' : 'text-gray-700'}"
                        data-category="Normal"
                        onclick="filterByCategory(this)"
                >
                    자유
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 whitespace-nowrap
                        ${param.category eq 'Notice' ? 'bg-primary text-white' : 'text-gray-700'}"
                        data-category="Notice"
                        onclick="filterByCategory(this)"
                >
                    공지사항
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 whitespace-nowrap
                        ${param.category eq 'Qna' ? 'bg-primary text-white' : 'text-gray-700'}"
                        data-category="Qna"
                        onclick="filterByCategory(this)"
                >
                    질문/답변
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 whitespace-nowrap
                        ${param.category eq 'Information' ? 'bg-primary text-white' : 'text-gray-700'}"
                        data-category="Information"
                        onclick="filterByCategory(this)"
                >
                    정보공유
                </button>
            </div>
        </div>
        <!-- 게시글 테이블 (데스크톱) -->
        <div class="overflow-x-auto mb-6">
            <c:choose>
                <c:when test="${postStatus eq 'error'}">
                    <div style="background-color:#fee2e2; color:#b91c1c; padding: 12px; margin-bottom: 16px; border-radius: 4px; font-weight:bold;">
                        오류: <c:choose>
                        <c:when test="${not empty errorMessage}">${fn:escapeXml(errorMessage)}</c:when>
                        <c:otherwise>알 수 없는 오류가 발생했습니다.</c:otherwise>
                    </c:choose>
                    </div>
                </c:when>
                <c:when test="${postStatus eq 'empty'}">
                    <div style="background-color:#fee2e2; color:#b91c1c; padding: 12px; margin-bottom: 16px; border-radius: 4px; font-weight:bold;">
                        게시글이 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="board-table w-full min-w-full border-collapse">
                        <thead>
                            <tr class="bg-gray-50 text-left">
                                <th class="py-3 px-4 text-sm font-medium text-gray-500 w-16">
                                    번호
                                </th>
                                <th class="py-3 px-4 text-sm font-medium text-gray-500 w-24">
                                    카테고리
                                </th>
                                <th class="py-3 px-4 text-sm font-medium text-gray-500">
                                    제목
                                </th>
                                <th class="py-3 px-4 text-sm font-medium text-gray-500 w-32">
                                    작성자
                                </th>
                                <th class="py-3 px-4 text-sm font-medium text-gray-500 w-32">
                                    작성일
                                </th>
                                <th class="py-3 px-4 text-sm font-medium text-gray-500 w-24 text-center">
                                    조회수
                                </th>
                                <th class="py-3 px-4 text-sm font-medium text-gray-500 w-24 text-center">
                                    추천수
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- 공지사항 -->
                            <c:forEach var="notice" items="${notices}">
                                <tr class="bg-gray-50/50" onclick="window.location.href='${pageContext.request.contextPath}/board/view?postId=${notice.id}'">
                                    <td class="py-3 px-4 text-sm text-gray-500 font-medium text-center">
                                            ${fn:escapeXml(notice.id)}
                                    </td>
                                    <td class="py-3 px-4 text-sm text-center font-medium">공지</td>
                                    <td class="py-3 px-4">
                                        <a href="#" class="text-sm font-medium hover:text-primary"
                                        >${fn:escapeXml(notice.title)}</a
                                        >
                                        <span class="ml-1 text-gray-500 text-xs">[${fn:escapeXml(notice.commentCount)}]</span>
                                    </td>
                                    <td class="py-3 px-4 text-sm text-gray-600">${fn:escapeXml(notice.userName)}</td>
                                    <td class="py-3 px-4 text-sm text-gray-500">${fn:escapeXml(notice.createdAtFormatted)}</td>
                                    <td class="py-3 px-4 text-sm text-gray-500 text-center">
                                            ${fn:escapeXml(notice.viewCount)}
                                    </td>
                                    <td class="py-3 px-4 text-sm text-gray-500 text-center">${fn:escapeXml(notice.recommendCount)}
                                    </td>
                                </tr>
                            </c:forEach>
                            <!-- 일반 게시글 -->
                            <c:forEach var="post" items="${posts}">
                                <tr class="border-t border-gray-200 hover:bg-gray-50/50"
                                    onclick="window.location.href='${pageContext.request.contextPath}/board/view?postId=${post.id}'">

                                    <td class="py-3 px-4 text-sm text-gray-500 text-center">${fn:escapeXml(post.id)}
                                    </td>
                                    <td class="py-3 px-4 text-sm text-gray-500 text-center">${fn:escapeXml(post.postCategory.displayName)}</td>
                                    <td class="py-3 px-4">
                                        <a href="#" class="text-sm hover:text-primary">
                                            <c:choose>
                                                <c:when test="${type == 'title'}">
                                                    <c:out value="${post.highlightedTitle}" escapeXml="false" />
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${fn:escapeXml(post.title)}" />
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        <span class="ml-1 text-gray-500 text-xs">[${fn:escapeXml(post.commentCount)}]</span>
                                    </td>
                                    <td class="py-3 px-4 text-sm text-gray-600">
                                        <c:choose>
                                            <c:when test="${type == 'author'}">
                                                <c:out value="${post.highlightedUserName}" escapeXml="false" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${fn:escapeXml(post.userName)}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="py-3 px-4 text-sm text-gray-500">${fn:escapeXml(post.createdAtFormatted)}
                                    </td>
                                    <td class="py-3 px-4 text-sm text-gray-500 text-center">${fn:escapeXml(post.viewCount)}
                                    </td>
                                    <td class="py-3 px-4 text-sm text-gray-500 text-center">${fn:escapeXml(post.recommendCount)}
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
        <!-- 페이지네이션 -->
        <c:set var="queryString" value="${pageResult.queryString}" />

        <c:set var="leftArrowPage" value="${currentPage - 5}" />
        <c:if test="${leftArrowPage < 1}">
            <c:set var="leftArrowPage" value="1" />
        </c:if>

        <c:set var="startPage" value="${pageResult.startPage}" />
        <c:set var="endPage" value="${pageResult.endPage}" />
        <c:set var="totalButtons" value="${pageResult.totalButtons}" />
        <div class="flex items-center mt-8">
            <div class="flex-1 flex justify-center">

                <nav class="flex items-center space-x-1">

                    <a
                            href="?page=${leftArrowPage}${queryString}"
                            class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-500"
                    >
                        <i class="ri-arrow-left-s-line"></i>
                    </a>
                    <c:forEach begin="${startPage}" end="${endPage}" var="i">
                        <c:set var="isActive" value="${i == currentPage}" />
                        <a
                            href="?page=${i}${queryString}"
                            class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full ${isActive ? 'active' : 'text-gray-500'}"
                        >${fn:escapeXml(i)}</a>
                    </c:forEach>

                    <a
                            href="?page=${pageResult.rightArrowPage}${queryString}"
                            class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-500"
                    >
                        <i class="ri-arrow-right-s-line"></i>
                    </a>
                </nav>
            </div>
        </div>
    </div>
</main>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const menuButton = document.querySelector(".ri-menu-line").parentElement;
        const mobileNav = document.querySelector("nav");
        menuButton.addEventListener("click", function () {
            mobileNav.classList.toggle("hidden");
            mobileNav.classList.toggle("flex");
            mobileNav.classList.toggle("flex-col");
            mobileNav.classList.toggle("absolute");
            mobileNav.classList.toggle("top-16");
            mobileNav.classList.toggle("right-4");
            mobileNav.classList.toggle("bg-white");
            mobileNav.classList.toggle("shadow-lg");
            mobileNav.classList.toggle("p-4");
            mobileNav.classList.toggle("rounded");
            mobileNav.classList.toggle("z-50");
            if (mobileNav.classList.contains("absolute")) {
                mobileNav.querySelector("ul").classList.remove("flex");
                mobileNav.querySelector("ul").classList.add("flex-col");
                mobileNav.querySelector("ul").classList.remove("space-x-8");
                mobileNav.querySelector("ul").classList.add("space-y-4");
            } else {
                mobileNav.querySelector("ul").classList.add("flex");
                mobileNav.querySelector("ul").classList.remove("flex-col");
                mobileNav.querySelector("ul").classList.add("space-x-8");
                mobileNav.querySelector("ul").classList.remove("space-y-4");
            }
        });
    });

    function filterByCategory(button) {
        const category = button.getAttribute('data-category');

        // 선택된 버튼 스타일 갱신
        document.querySelectorAll('[data-category]').forEach(btn => {
            btn.classList.remove('bg-primary', 'text-white');
            btn.classList.add('text-gray-700');
        });
        button.classList.add('bg-primary', 'text-white');
        button.classList.remove('text-gray-700');

        // 카테고리를 URL 파라미터로 붙여 페이지 이동
        const url = new URL(window.location.href);
        url.searchParams.set("page", "1"); // 카테고리 변경 시 페이지 1로 초기화
        if (category) {
            url.searchParams.set("category", category);
        } else {
            url.searchParams.delete("category");
        }
        window.location.href = url.toString();
    }

    // 페이지 로드시 선택된 카테고리에 해당하는 버튼 강조 유지
    window.addEventListener('DOMContentLoaded', () => {
        const currentCategory = new URL(window.location.href).searchParams.get("category") || "";
        document.querySelectorAll('[data-category]').forEach(btn => {
            if (btn.getAttribute("data-category") === currentCategory) {
                btn.classList.add('bg-primary', 'text-white');
                btn.classList.remove('text-gray-700');
            } else {
                btn.classList.remove('bg-primary', 'text-white');
                btn.classList.add('text-gray-700');
            }
        });
    });
</script>
</body>
</html>