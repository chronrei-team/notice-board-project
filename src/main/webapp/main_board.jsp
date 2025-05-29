<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%

%>
<!DOCTYPE html>
<html>
<head>
    <title>메인 페이지</title>
    <script src="https://cdn.jsdelivr.net/npm/@tailwindcss/browser@4"></script>
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
<%@ include file="common/header.jspf" %>
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
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">325</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >오늘 날씨가 정말 좋네요! 다들 주말 계획은 어떻게
                            되시나요?</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[8]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">김민준</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-13</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">42</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">324</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >맛집 추천 부탁드립니다! 강남역 근처 회식하기 좋은 곳
                            있을까요?</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[15]</span>
                        <div class="inline-block ml-1">
                            <i class="ri-attachment-2 text-gray-400 text-sm"></i>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">박서연</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-13</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">87</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">323</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >신입 개발자 취업 준비 중인데 포트폴리오 조언
                            부탁드립니다.</a
                        >
                        <span class="ml-2 text-red-500 text-xs">NEW</span>
                        <span class="ml-1 text-gray-500 text-xs">[4]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">이지훈</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-12</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">36</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">322</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >여름 휴가 계획 공유해요! 제주도 vs 강원도 어디가
                            좋을까요?</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[21]</span>
                        <div class="inline-block ml-1">
                            <i class="ri-image-line text-gray-400 text-sm"></i>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">최하은</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-11</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">112</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">321</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >요즘 인기있는 OTT 추천 좀 해주세요. 넷플릭스 다 봤어요.</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[12]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">정도윤</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-10</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">78</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">320</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >재택근무 효율적으로 하는 팁 공유합니다!</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[9]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">김소희</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-09</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">64</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">319</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >주식 초보인데 시작하기 좋은 종목 추천해주세요.</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[18]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">박준혁</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-08</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">95</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">318</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >운동 시작하려고 하는데 헬스장 vs 홈트레이닝 어떤게
                            좋을까요?</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[14]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">이수진</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-07</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">82</td>
                </tr>
                <tr class="border-t border-gray-200 hover:bg-gray-50/50">
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">317</td>
                    <td class="py-3 px-4">
                        <a href="#" class="text-sm hover:text-primary"
                        >이번 주말 개봉하는 영화 추천 부탁드려요!</a
                        >
                        <span class="ml-1 text-gray-500 text-xs">[7]</span>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">최민수</td>
                    <td class="py-3 px-4 text-sm text-gray-500">2025-05-06</td>
                    <td class="py-3 px-4 text-sm text-gray-500 text-center">53</td>
                </tr>
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