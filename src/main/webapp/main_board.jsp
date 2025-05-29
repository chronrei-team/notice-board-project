<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, notice.project.example.DTO.ExampleBoardResponse" %>
<%
    List<ExampleBoardResponse> posts = (List<ExampleBoardResponse>) request.getAttribute("posts");
%>
<!DOCTYPE html>
<html>
<head>
    <title>메인 페이지</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: "#4F46E5",
                        secondary: "#8B5CF6",
                    },
                    borderRadius: {
                        none: "0px",
                        sm: "4px",
                        DEFAULT: "8px",
                        md: "12px",
                        lg: "16px",
                        xl: "20px",
                        "2xl": "24px",
                        "3xl": "32px",
                        full: "9999px",
                        button: "8px",
                    },
                },
            },
        };
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
            href="https://fonts.googleapis.com/css2?family=Pacifico&family=Noto+Sans+KR:wght@300;400;500;700&display=swap"
            rel="stylesheet"
    />
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
<header class="bg-white shadow-sm">
    <div class="container mx-auto px-4 py-4">
        <div class="flex items-center justify-between">
            <!-- 로고 -->
            <div class="flex items-center">
                <a href="#" class="flex items-center">
                    <span class="text-2xl font-['Pacifico'] text-primary">logo</span>
                </a>
                <!-- 네비게이션 메뉴 -->
                <nav class="hidden md:flex ml-10">
                    <ul class="flex space-x-8">
                        <li>
                            <a
                                    href="#"
                                    class="text-gray-700 hover:text-primary font-medium"
                            >홈</a
                            >
                        </li>
                        <li>
                            <a
                                    href="#"
                                    class="text-gray-700 hover:text-primary font-medium"
                            >게시판</a
                            >
                        </li>
                        <li>
                            <a
                                    href="#"
                                    class="text-gray-700 hover:text-primary font-medium"
                            >갤러리</a
                            >
                        </li>
                        <li>
                            <a
                                    href="#"
                                    class="text-gray-700 hover:text-primary font-medium"
                            >공지사항</a
                            >
                        </li>
                    </ul>
                </nav>
            </div>
            <!-- 검색창 -->
            <div
                    class="hidden md:flex items-center justify-center flex-1 max-w-md mx-4"
            >
                <form class="relative w-full flex items-center">
                    <div class="relative flex-1">
                        <div
                                class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 flex items-center justify-center text-gray-400"
                        >
                            <i class="ri-search-line"></i>
                        </div>
                        <input
                                type="text"
                                placeholder="검색어를 입력하세요"
                                class="custom-search w-full py-2 pl-10 pr-24 border border-gray-300 rounded-button text-sm focus:border-primary transition-colors"
                        />
                        <div
                                class="absolute right-2 top-1/2 transform -translate-y-1/2"
                        >
                            <button
                                    type="button"
                                    id="searchTypeButton"
                                    class="flex items-center justify-center px-3 py-1 text-sm text-gray-600 hover:text-primary"
                            >
                                <span id="selectedSearchType">제목</span>
                                <i class="ri-arrow-down-s-line ml-1"></i>
                            </button>
                            <div
                                    id="searchTypeDropdown"
                                    class="hidden absolute right-0 top-full mt-1 w-24 bg-white border border-gray-200 rounded-lg shadow-lg z-50"
                            >
                                <div class="py-1">
                                    <button
                                            type="button"
                                            class="search-type-option w-full px-4 py-2 text-left text-sm hover:bg-gray-50 hover:text-primary"
                                            data-value="title"
                                    >
                                        제목
                                    </button>
                                    <button
                                            type="button"
                                            class="search-type-option w-full px-4 py-2 text-left text-sm hover:bg-gray-50 hover:text-primary"
                                            data-value="content"
                                    >
                                        내용
                                    </button>
                                    <button
                                            type="button"
                                            class="search-type-option w-full px-4 py-2 text-left text-sm hover:bg-gray-50 hover:text-primary"
                                            data-value="author"
                                    >
                                        작성자
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <button
                            type="submit"
                            class="ml-2 bg-primary bg-blue-700 text-white px-4 py-2 rounded-lg text-sm hover:bg-primary/90 whitespace-nowrap"
                    >
                        검색
                    </button>
                </form>
            </div>
            <!-- 로그인/회원가입 버튼 -->
            <div class="flex items-center space-x-3">
                <button
                        id="loginButton"
                        class="text-gray-700 hover:text-primary whitespace-nowrap text-sm"
                >
                    로그인
                </button>
                <div
                        id="loginModal"
                        class="fixed inset-0 bg-black/30 bg-opacity-50 flex items-center justify-center hidden z-50"
                >
                    <div class="bg-white rounded-lg w-full max-w-md p-6 relative">
                        <button
                                id="closeLoginModal"
                                class="absolute right-4 top-4 text-gray-400 hover:text-gray-600"
                        >
                            <div class="w-6 h-6 flex items-center justify-center">
                                <i class="ri-close-line"></i>
                            </div>
                        </button>
                        <h2 class="text-2xl font-bold text-gray-800 mb-6 text-center">
                            로그인
                        </h2>
                        <form id="loginForm" class="space-y-4">
                            <div>
                                <label
                                        for="userName"
                                        class="block text-sm font-medium text-gray-700 mb-1"
                                >닉네임</label
                                >
                                <input
                                        type="text"
                                        id="userName"
                                        name="userName"
                                        required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-button focus:border-primary focus:ring-1 focus:ring-primary text-sm"
                                        placeholder="닉네임을 입력하세요"
                                />
                            </div>
                            <div>
                                <label
                                        for="password"
                                        class="block text-sm font-medium text-gray-700 mb-1"
                                >비밀번호</label
                                >
                                <input
                                        type="password"
                                        id="password"
                                        name="password"
                                        required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-button focus:border-primary focus:ring-1 focus:ring-primary text-sm"
                                        placeholder="비밀번호를 입력하세요"
                                />
                            </div>
                            <div class="flex items-center justify-between text-sm mb-1">
                                <a href="#" class="text-gray-600 hover:text-primary">
                                    아이디/비밀번호 찾기
                                </a>
                                <button
                                        type="submit"
                                        class="bg-primary bg-gray-100 text-gray-700 px-4 py-2 rounded-lg">
                                    로그인
                                </button>
                            </div>
                        </form>
                        <div class="text-center mt-4 text-sm text-gray-600">
                            아직 회원이 아니신가요?
                            <a
                                    href="#"
                                    class="text-primary hover:text-primary/90 font-medium"
                            >회원가입</a
                            >
                        </div>
                    </div>
                </div>
                <button
                        class="bg-primary text-white bg-blue-700 px-4 py-2 rounded-lg text-sm hover:bg-primary/90 whitespace-nowrap inline-block"
                >회원가입</button
                >
                <!-- 모바일 메뉴 버튼 -->
                <button
                        class="md:hidden w-10 h-10 flex items-center justify-center text-gray-700"
                >
                    <i class="ri-menu-line ri-lg"></i>
                </button>
            </div>
        </div>
        <!-- 모바일 검색창 -->
        <div class="mt-4 md:hidden">
            <div class="relative">
                <input
                        type="text"
                        placeholder="게시글 검색"
                        class="custom-search w-full py-2 pl-10 pr-4 border border-gray-300 rounded-button text-sm focus:border-primary transition-colors"
                />
                <div
                        class="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 flex items-center justify-center text-gray-400"
                >
                    <i class="ri-search-line"></i>
                </div>
            </div>
        </div>
    </div>
</header>
<!-- 메인 컨텐츠 영역 -->
<main class="flex-1 container mx-auto px-4 py-8">
    <div class="bg-white rounded shadow-sm p-6">
        <!-- 게시판 제목 및 글쓰기 버튼 -->
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800">자유게시판</h1>
            <button
                    class="bg-primary text-white px-4 py-2 !rounded-button flex items-center whitespace-nowrap hover:bg-primary/90"
            >
                <div class="w-5 h-5 flex items-center justify-center mr-1">
                    <i class="ri-pencil-line"></i>
                </div>
                글쓰기
            </button>
        </div>
        <!-- 카테고리 탭 -->
        <div class="flex overflow-x-auto mb-6 pb-2">
            <div class="bg-gray-100 p-1 rounded-full flex space-x-1">
                <button
                        class="px-4 py-2 !rounded-full bg-primary text-gray-700 font-bold whitespace-nowrap"
                >
                    전체
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 hover:bg-gray-200 whitespace-nowrap"
                >
                    인기글
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 hover:bg-gray-200 whitespace-nowrap"
                >
                    공지사항
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 hover:bg-gray-200 whitespace-nowrap"
                >
                    질문/답변
                </button>
                <button
                        class="px-4 py-2 !rounded-full text-gray-700 hover:bg-gray-200 whitespace-nowrap"
                >
                    정보공유
                </button>
            </div>
        </div>
        <!-- 필터 및 정렬 옵션 -->
        <div class="flex flex-wrap justify-between items-center mb-4">
            <div class="flex items-center space-x-2 mb-2 sm:mb-0">
                <div class="flex items-center">
                    <input type="checkbox" id="notice-only" class="custom-checkbox" />
                    <label for="notice-only" class="ml-2 text-sm text-gray-700"
                    >공지만 보기</label
                    >
                </div>
            </div>
            <div class="flex items-center">
                <span class="text-sm text-gray-600 mr-2">정렬:</span>
                <div class="relative">
                    <button
                            class="flex items-center text-sm text-gray-700 border border-gray-300 rounded-button px-3 py-1.5 !rounded-button"
                    >
                        <span>최신순</span>
                        <div class="w-4 h-4 flex items-center justify-center ml-2">
                            <i class="ri-arrow-down-s-line"></i>
                        </div>
                    </button>
                </div>
            </div>
        </div>
        <!-- 게시글 테이블 (데스크톱) -->
        <div class="overflow-x-auto mb-6">
            <table class="board-table w-full min-w-full border-collapse">
                <thead>
                <tr class="bg-gray-50 text-left">
                    <th class="py-3 px-4 text-sm font-medium text-gray-500 w-16">
                        번호
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
                    <th
                            class="py-3 px-4 text-sm font-medium text-gray-500 w-24 text-center"
                    >
                        조회수
                    </th>
                    <th
                            class="py-3 px-4 text-sm font-medium text-gray-500 w-24 text-center"
                    >
                        추천수
                    </th>
                </tr>
                </thead>
                <tbody>
                <!-- 공지사항 -->
                <tr class="bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-center">
                  <span
                          class="inline-block bg-primary text-white px-2 py-0.5 rounded text-xs"
                  >공지</span
                  >
                    </td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm font-medium hover:text-primary"
                        >커뮤니티 이용 규칙 안내 (필독)</a
                        >
                        <span class="ml-2 text-red-500 text-xs">NEW</span>
                        <span class="ml-1 text-gray-500 text-xs">[23]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">관리자</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-12</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">
                        1,245
                    </td>
                </tr>
                <!-- 일반 게시글 -->
                <%
                    if (posts != null) {
                        for (ExampleBoardResponse post : posts) {

                %>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center"><%= post.getId() %></td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        ><%= post.getTitle() %></a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[8]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600"><%= post.getUserName() %></td>
                    <td class="py-3 px-4 text-sm text-gray-500"><%= post.getCreatedAtFormatted() %></td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center"><%= post.getViewCount() %></td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center"><%= post.getRecommendCount() %></td>
                </tr>
                <%      }
                    } %>
                </tbody>
            </table>
        </div>
        <!-- 게시글 카드 (모바일) -->
        <div class="board-cards space-y-4 mb-6">
            <!-- 공지사항 -->
            <div class="bg-gray-50/50 p-4 rounded">
                <div class="flex justify-between items-start mb-2">
                    <div>
                <span
                        class="inline-block bg-primary text-white px-2 py-0.5 rounded text-xs mr-2"
                >공지</span
                >
                        <a href="#" class="font-medium hover:text-primary"
                        >커뮤니티 이용 규칙 안내 (필독)</a
                        >
                        <span class="ml-2 text-red-500 text-xs">NEW</span>
                    </div>
                </div>
                <div class="flex justify-between text-sm">
                    <div class="text-gray-600">관리자</div>
                    <div class="flex items-center space-x-3 text-gray-500">
                        <span>2025-05-12</span>
                        <div class="flex items-center">
                            <i class="ri-eye-line mr-1 text-gray-400"></i>
                            <span>1,245</span>
                        </div>
                        <div class="flex items-center">
                            <i class="ri-chat-1-line mr-1 text-gray-400"></i>
                            <span>23</span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 일반 게시글 -->
            <div class="border border-gray-200 p-4 rounded bg-white">
                <div class="mb-2">
                    <a href="#" class="font-medium hover:text-primary"
                    >오늘 날씨가 정말 좋네요! 다들 주말 계획은 어떻게 되시나요?</a
                    >
                </div>
                <div class="flex justify-between text-sm">
                    <div class="text-gray-600">김민준</div>
                    <div class="flex items-center space-x-3 text-gray-500">
                        <span>2025-05-13</span>
                        <div class="flex items-center">
                            <i class="ri-eye-line mr-1 text-gray-400"></i>
                            <span>42</span>
                        </div>
                        <div class="flex items-center">
                            <i class="ri-chat-1-line mr-1 text-gray-400"></i>
                            <span>8</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="border border-gray-200 p-4 rounded bg-white">
                <div class="mb-2">
                    <a href="#" class="font-medium hover:text-primary"
                    >맛집 추천 부탁드립니다! 강남역 근처 회식하기 좋은 곳
                        있을까요?</a
                    >
                    <i class="ri-attachment-2 text-gray-400 text-sm ml-1"></i>
                </div>
                <div class="flex justify-between text-sm">
                    <div class="text-gray-600">박서연</div>
                    <div class="flex items-center space-x-3 text-gray-500">
                        <span>2025-05-13</span>
                        <div class="flex items-center">
                            <i class="ri-eye-line mr-1 text-gray-400"></i>
                            <span>87</span>
                        </div>
                        <div class="flex items-center">
                            <i class="ri-chat-1-line mr-1 text-gray-400"></i>
                            <span>15</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="border border-gray-200 p-4 rounded bg-white">
                <div class="mb-2">
                    <a href="#" class="font-medium hover:text-primary"
                    >신입 개발자 취업 준비 중인데 포트폴리오 조언 부탁드립니다.</a
                    >
                    <span class="ml-2 text-red-500 text-xs">NEW</span>
                </div>
                <div class="flex justify-between text-sm">
                    <div class="text-gray-600">이지훈</div>
                    <div class="flex items-center space-x-3 text-gray-500">
                        <span>2025-05-12</span>
                        <div class="flex items-center">
                            <i class="ri-eye-line mr-1 text-gray-400"></i>
                            <span>36</span>
                        </div>
                        <div class="flex items-center">
                            <i class="ri-chat-1-line mr-1 text-gray-400"></i>
                            <span>4</span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="border border-gray-200 p-4 rounded bg-white">
                <div class="mb-2">
                    <a href="#" class="font-medium hover:text-primary"
                    >여름 휴가 계획 공유해요! 제주도 vs 강원도 어디가 좋을까요?</a
                    >
                    <i class="ri-image-line text-gray-400 text-sm ml-1"></i>
                </div>
                <div class="flex justify-between text-sm">
                    <div class="text-gray-600">최하은</div>
                    <div class="flex items-center space-x-3 text-gray-500">
                        <span>2025-05-11</span>
                        <div class="flex items-center">
                            <i class="ri-eye-line mr-1 text-gray-400"></i>
                            <span>112</span>
                        </div>
                        <div class="flex items-center">
                            <i class="ri-chat-1-line mr-1 text-gray-400"></i>
                            <span>21</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- 페이지네이션 -->
        <div class="flex justify-center mt-8">
            <nav class="flex items-center space-x-1">
                <a
                        href="#"
                        class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-500"
                >
                    <i class="ri-arrow-left-s-line"></i>
                </a>
                <a
                        href="#"
                        class="pagination-btn active w-9 h-9 flex items-center justify-center rounded-full"
                >1</a
                >
                <a
                        href="#"
                        class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-700"
                >2</a
                >
                <a
                        href="#"
                        class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-700"
                >3</a
                >
                <a
                        href="#"
                        class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-700"
                >4</a
                >
                <a
                        href="#"
                        class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-700"
                >5</a
                >
                <span class="w-9 h-9 flex items-center justify-center text-gray-500"
                >...</span
                >
                <a
                        href="#"
                        class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-700"
                >10</a
                >
                <a
                        href="#"
                        class="pagination-btn w-9 h-9 flex items-center justify-center rounded-full text-gray-500"
                >
                    <i class="ri-arrow-right-s-line"></i>
                </a>
            </nav>
        </div>
    </div>
</main>
<!-- 푸터 영역 -->
<%--<footer class="bg-gray-800 text-white py-6">--%>
<%--    <div class="container mx-auto px-4">--%>
<%--        <div class="text-center text-gray-400 text-sm">--%>
<%--            © 2025 커뮤니티 주식회사. All rights reserved.--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</footer>--%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const loginButton = document.getElementById("loginButton");
        const loginModal = document.getElementById("loginModal");
        const closeLoginModal = document.getElementById("closeLoginModal");
        const loginForm = document.getElementById("loginForm");
        loginButton.addEventListener("click", () => {
            loginModal.classList.remove("hidden");
            document.body.style.overflow = "hidden";
        });
        closeLoginModal.addEventListener("click", () => {
            loginModal.classList.add("hidden");
            document.body.style.overflow = "";
        });
        loginModal.addEventListener("click", (e) => {
            if (e.target === loginModal) {
                loginModal.classList.add("hidden");
                document.body.style.overflow = "";
            }
        });
        loginForm.addEventListener("submit", (e) => {
            e.preventDefault();
            const userName = document.getElementById("userName").value;
            const password = document.getElementById("password").value;
            if (!userName || !password) {
                return;
            }
            console.log("Login attempt:", { email: userName, password });
            // Here you would typically make an API call to your backend
        });
        const searchTypeButton = document.getElementById("searchTypeButton");
        const searchTypeDropdown = document.getElementById("searchTypeDropdown");
        const selectedSearchType = document.getElementById("selectedSearchType");
        const searchTypeOptions = document.querySelectorAll(".search-type-option");
        searchTypeButton.addEventListener("click", function (e) {
            e.stopPropagation();
            searchTypeDropdown.classList.toggle("hidden");
        });
        searchTypeOptions.forEach((option) => {
            option.addEventListener("click", function () {
                selectedSearchType.textContent = this.textContent;
                searchTypeDropdown.classList.add("hidden");
            });
        });
        document.addEventListener("click", function (e) {
            if (!searchTypeButton.contains(e.target)) {
                searchTypeDropdown.classList.add("hidden");
            }
        });
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
    document.addEventListener("DOMContentLoaded", function () {
        // 체크박스 커스텀 기능
        const checkbox = document.querySelector(".custom-checkbox");
        checkbox.addEventListener("change", function () {
            if (this.checked) {
                this.classList.add("bg-primary", "border-primary");
            } else {
                this.classList.remove("bg-primary", "border-primary");
            }
        });
    });
</script>
</body>
</html>