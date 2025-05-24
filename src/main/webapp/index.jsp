<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>커뮤니티 게시판</title>
    <script src="https://cdn.tailwindcss.com/3.4.16"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
            href="https://fonts.googleapis.com/css2?family=Pacifico&display=swap"
            rel="stylesheet"
    />
    <link
            href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.6.0/remixicon.min.css"
            rel="stylesheet"
    />
    <style>
        :where([class^="ri-"])::before { content: "\f3c2"; }
        body {
            font-family: 'Noto Sans KR', sans-serif;
        }
        .table-row:hover {
            background-color: rgba(243, 244, 246, 0.8);
            transition: background-color 0.2s ease;
        }
        .custom-checkbox {
            appearance: none;
            width: 1.25rem;
            height: 1.25rem;
            border: 2px solid #e5e7eb;
            border-radius: 4px;
            position: relative;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .custom-checkbox:checked {
            background-color: #3b82f6;
            border-color: #3b82f6;
        }
        .custom-checkbox:checked::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(45deg);
            width: 0.3rem;
            height: 0.6rem;
            border-bottom: 2px solid white;
            border-right: 2px solid white;
        }
        .custom-switch {
            position: relative;
            display: inline-block;
            width: 3rem;
            height: 1.5rem;
        }
        .custom-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #e5e7eb;
            transition: .4s;
            border-radius: 34px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 1.1rem;
            width: 1.1rem;
            left: 0.2rem;
            bottom: 0.2rem;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        input:checked + .slider {
            background-color: #3b82f6;
        }
        input:checked + .slider:before {
            transform: translateX(1.5rem);
        }
        .scroll-to-top {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 50;
        }
        .scroll-to-top.visible {
            opacity: 1;
        }
        @media (max-width: 768px) {
            .mobile-menu {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            .mobile-menu.open {
                transform: translateX(0);
            }
        }
        .notification-badge {
            position: relative;
            animation: pulse 1.5s infinite;
        }
        @keyframes pulse {
            0% {
                box-shadow: 0 0 0 0 rgba(239, 68, 68, 0.7);
            }
            70% {
                box-shadow: 0 0 0 6px rgba(239, 68, 68, 0);
            }
            100% {
                box-shadow: 0 0 0 0 rgba(239, 68, 68, 0);
            }
        }
        .vote-button:active {
            transform: scale(0.95);
            transition: transform 0.1s ease;
        }
    </style>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { primary: "#3b82f6", secondary: "#6366f1" },
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
</head>
<body class="bg-gray-50 min-h-screen">
<!-- 헤더 영역 -->
<header class="bg-white shadow-sm sticky top-0 z-40">
    <div class="container mx-auto">
        <!-- 상단 헤더 -->
        <div class="flex items-center justify-between py-3 px-4 md:px-6">
            <!-- 로고 및 사이트명 -->
            <div class="flex items-center">
                <a href="#" class="flex items-center">
                    <span class="text-2xl font-['Pacifico'] text-primary">logo</span>
                    <span class="ml-2 text-lg font-semibold text-gray-800"
                    >커뮤니티</span
                    >
                </a>
            </div>
            <!-- 검색창 (데스크톱) -->
            <div class="hidden md:flex items-center flex-1 max-w-xl mx-8">
                <div class="relative w-full">
                    <input
                            type="text"
                            placeholder="검색어를 입력하세요"
                            class="w-full py-2 pl-10 pr-4 text-sm border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                    />
                    <div
                            class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none w-10 h-10"
                    >
                        <i class="ri-search-line text-gray-400"></i>
                    </div>
                </div>
            </div>
            <!-- 로그인/회원가입 버튼 -->
            <div class="flex items-center space-x-3">
                <button
                        class="hidden md:block text-gray-700 hover:text-primary text-sm whitespace-nowrap"
                >
                    로그인
                </button>
                <button
                        class="hidden md:block bg-primary text-white px-4 py-2 rounded-button text-sm hover:bg-blue-600 transition duration-200 whitespace-nowrap"
                >
                    회원가입
                </button>
                <!-- 모바일 메뉴 버튼 -->
                <button
                        id="mobileMenuBtn"
                        class="md:hidden w-10 h-10 flex items-center justify-center"
                >
                    <i class="ri-menu-line text-gray-700 text-xl"></i>
                </button>
            </div>
        </div>
        <!-- 검색창 (모바일) -->
        <div class="md:hidden px-4 pb-3">
            <div class="relative">
                <input
                        type="text"
                        placeholder="검색어를 입력하세요"
                        class="w-full py-2 pl-10 pr-4 text-sm border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent"
                />
                <div
                        class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none w-10 h-10"
                >
                    <i class="ri-search-line text-gray-400"></i>
                </div>
            </div>
        </div>
        <!-- 네비게이션 바 -->
        <nav class="bg-gray-100 px-4 py-2 overflow-x-auto whitespace-nowrap">
            <div class="flex space-x-6">
                <a href="#" class="text-primary font-medium text-sm py-1">홈</a>
                <a href="#" class="text-gray-700 hover:text-primary text-sm py-1"
                >인기 게시글</a
                >
                <a href="#" class="text-gray-700 hover:text-primary text-sm py-1"
                >자유 게시판</a
                >
                <a href="#" class="text-gray-700 hover:text-primary text-sm py-1"
                >질문 & 답변</a
                >
                <a href="#" class="text-gray-700 hover:text-primary text-sm py-1"
                >공지사항</a
                >
                <a href="#" class="text-gray-700 hover:text-primary text-sm py-1"
                >이벤트</a
                >
                <a href="#" class="text-gray-700 hover:text-primary text-sm py-1"
                >갤러리</a
                >
            </div>
        </nav>
    </div>
</header>
<!-- 메인 컨텐츠 영역 -->
<main class="container mx-auto px-4 py-6 flex flex-col md:flex-row">
    <!-- 사이드바 (데스크톱) -->
    <aside class="hidden md:block w-64 mr-6 flex-shrink-0">
        <!-- 카테고리 목록 -->
        <div class="bg-white rounded-lg shadow-sm p-4 mb-5">
            <h3 class="text-lg font-semibold mb-3 text-gray-800">
                게시판 카테고리
            </h3>
            <ul class="space-y-2">
                <li>
                    <a
                            href="#"
                            class="flex items-center text-primary font-medium hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-discuss-line"></i>
                        </div>
                        자유 게시판
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-question-answer-line"></i>
                        </div>
                        질문 & 답변
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-information-line"></i>
                        </div>
                        공지사항
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-calendar-event-line"></i>
                        </div>
                        이벤트
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-gallery-line"></i>
                        </div>
                        갤러리
                    </a>
                </li>
            </ul>
        </div>
        <!-- 인기 게시글 위젯 -->
        <div class="bg-white rounded-lg shadow-sm p-4 mb-5">
            <h3 class="text-lg font-semibold mb-3 text-gray-800">인기 게시글</h3>
            <ul class="space-y-3">
                <li>
                    <a href="#" class="block hover:bg-gray-50 p-2 rounded-md">
                        <p class="text-sm font-medium text-gray-800 line-clamp-1">
                            오늘 날씨가 정말 좋네요! 다들 어떻게 보내고 계신가요?
                        </p>
                        <div class="flex items-center mt-1 text-xs text-gray-500">
                            <span>김민준</span>
                            <span class="mx-1">•</span>
                            <span>조회 342</span>
                            <div class="flex items-center ml-2 text-red-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-heart-fill"></i>
                                </div>
                                <span class="ml-1">28</span>
                            </div>
                        </div>
                    </a>
                </li>
                <li>
                    <a href="#" class="block hover:bg-gray-50 p-2 rounded-md">
                        <p class="text-sm font-medium text-gray-800 line-clamp-1">
                            최근 출시된 신제품 리뷰 - 정말 기대 이상이네요!
                        </p>
                        <div class="flex items-center mt-1 text-xs text-gray-500">
                            <span>이서연</span>
                            <span class="mx-1">•</span>
                            <span>조회 287</span>
                            <div class="flex items-center ml-2 text-red-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-heart-fill"></i>
                                </div>
                                <span class="ml-1">24</span>
                            </div>
                        </div>
                    </a>
                </li>
                <li>
                    <a href="#" class="block hover:bg-gray-50 p-2 rounded-md">
                        <p class="text-sm font-medium text-gray-800 line-clamp-1">
                            여름 휴가 계획 공유합니다 - 제주도 3박 4일 코스
                        </p>
                        <div class="flex items-center mt-1 text-xs text-gray-500">
                            <span>박지훈</span>
                            <span class="mx-1">•</span>
                            <span>조회 256</span>
                            <div class="flex items-center ml-2 text-red-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-heart-fill"></i>
                                </div>
                                <span class="ml-1">19</span>
                            </div>
                        </div>
                    </a>
                </li>
            </ul>
            <a
                    href="#"
                    class="block text-center text-primary text-sm mt-3 hover:underline"
            >더보기</a
            >
        </div>
        <!-- 최근 본 게시물 위젯 -->
        <div class="bg-white rounded-lg shadow-sm p-4 mb-5">
            <h3 class="text-lg font-semibold mb-3 text-gray-800">
                최근 본 게시물
            </h3>
            <ul class="space-y-2">
                <li>
                    <a
                            href="#"
                            class="block text-sm text-gray-700 hover:text-primary truncate"
                    >맛집 추천 부탁드립니다 - 강남역 주변</a
                    >
                </li>
                <li>
                    <a
                            href="#"
                            class="block text-sm text-gray-700 hover:text-primary truncate"
                    >주말에 볼만한 영화 추천해주세요</a
                    >
                </li>
                <li>
                    <a
                            href="#"
                            class="block text-sm text-gray-700 hover:text-primary truncate"
                    >개발자 취업 준비 팁 공유합니다</a
                    >
                </li>
            </ul>
        </div>
        <!-- 광고 배너 영역 -->
        <div class="bg-white rounded-lg shadow-sm p-4 mb-5">
            <div class="bg-gray-100 rounded-md p-4 text-center">
                <p class="text-sm text-gray-500 mb-2">광고</p>
                <div
                        class="w-full h-32 bg-gray-200 rounded flex items-center justify-center"
                >
                    <p class="text-gray-400">광고 배너</p>
                </div>
            </div>
        </div>
    </aside>
    <!-- 모바일 사이드바 (햄버거 메뉴) -->
    <div id="mobileSidebar" class="fixed inset-0 z-50 hidden">
        <div
                class="absolute inset-0 bg-gray-900 bg-opacity-50"
                id="sidebarOverlay"
        ></div>
        <div
                class="mobile-menu absolute top-0 left-0 w-64 h-full bg-white shadow-lg p-4 overflow-y-auto"
        >
            <div class="flex justify-between items-center mb-6">
                <span class="text-xl font-['Pacifico'] text-primary">logo</span>
                <button
                        id="closeMobileMenu"
                        class="w-8 h-8 flex items-center justify-center"
                >
                    <i class="ri-close-line text-gray-700 text-xl"></i>
                </button>
            </div>
            <!-- 로그인/회원가입 버튼 (모바일) -->
            <div class="flex space-x-2 mb-6">
                <button
                        class="flex-1 py-2 border border-gray-300 rounded-button text-sm text-gray-700 whitespace-nowrap"
                >
                    로그인
                </button>
                <button
                        class="flex-1 py-2 bg-primary text-white rounded-button text-sm whitespace-nowrap"
                >
                    회원가입
                </button>
            </div>
            <!-- 카테고리 목록 (모바일) -->
            <h3 class="text-lg font-semibold mb-3 text-gray-800">
                게시판 카테고리
            </h3>
            <ul class="space-y-2 mb-6">
                <li>
                    <a
                            href="#"
                            class="flex items-center text-primary font-medium hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-discuss-line"></i>
                        </div>
                        자유 게시판
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-question-answer-line"></i>
                        </div>
                        질문 & 답변
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-information-line"></i>
                        </div>
                        공지사항
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-calendar-event-line"></i>
                        </div>
                        이벤트
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-gallery-line"></i>
                        </div>
                        갤러리
                    </a>
                </li>
            </ul>
            <!-- 추가 메뉴 (모바일) -->
            <h3 class="text-lg font-semibold mb-3 text-gray-800">바로가기</h3>
            <ul class="space-y-2">
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-user-line"></i>
                        </div>
                        마이페이지
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-settings-line"></i>
                        </div>
                        설정
                    </a>
                </li>
                <li>
                    <a
                            href="#"
                            class="flex items-center text-gray-700 hover:text-primary hover:bg-gray-50 p-2 rounded-md"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-2">
                            <i class="ri-customer-service-line"></i>
                        </div>
                        고객센터
                    </a>
                </li>
            </ul>
        </div>
    </div>
    <!-- 메인 컨텐츠 -->
    <div class="flex-1">
        <!-- 게시판 헤더 -->
        <div class="bg-white rounded-lg shadow-sm p-5 mb-5">
            <div
                    class="flex flex-col md:flex-row md:items-center justify-between"
            >
                <div>
                    <h1 class="text-2xl font-bold text-gray-800">자유 게시판</h1>
                    <p class="text-gray-600 mt-1">
                        자유롭게 의견을 나누는 공간입니다.
                    </p>
                </div>
                <div class="mt-4 md:mt-0">
                    <button
                            class="bg-primary text-white px-4 py-2 rounded-button flex items-center hover:bg-blue-600 transition duration-200 whitespace-nowrap"
                    >
                        <div class="w-5 h-5 flex items-center justify-center mr-1">
                            <i class="ri-pencil-line"></i>
                        </div>
                        글쓰기
                    </button>
                </div>
            </div>
        </div>
        <!-- 필터 및 정렬 옵션 -->
        <div class="bg-white rounded-lg shadow-sm p-4 mb-5">
            <div
                    class="flex flex-col md:flex-row md:items-center justify-between space-y-3 md:space-y-0"
            >
                <!-- 필터 옵션 -->
                <div class="flex items-center space-x-3">
                    <div class="flex items-center space-x-2">
                        <label class="text-sm text-gray-700">보기:</label>
                        <div class="relative">
                            <select
                                    class="appearance-none bg-gray-100 border-none rounded-md py-1 pl-3 pr-8 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary cursor-pointer"
                            >
                                <option>전체</option>
                                <option>인기글</option>
                                <option>공지글</option>
                            </select>
                            <div
                                    class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none w-8 h-8"
                            >
                                <i class="ri-arrow-down-s-line text-gray-500"></i>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center space-x-2">
                        <label class="text-sm text-gray-700">정렬:</label>
                        <div class="relative">
                            <select
                                    class="appearance-none bg-gray-100 border-none rounded-md py-1 pl-3 pr-8 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary cursor-pointer"
                            >
                                <option>최신순</option>
                                <option>인기순</option>
                                <option>조회순</option>
                                <option>댓글순</option>
                            </select>
                            <div
                                    class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none w-8 h-8"
                            >
                                <i class="ri-arrow-down-s-line text-gray-500"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- 검색 옵션 -->
                <div class="flex items-center">
                    <div class="relative">
                        <select
                                class="appearance-none bg-gray-100 border-none rounded-l-md py-2 pl-3 pr-8 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-primary cursor-pointer"
                        >
                            <option>전체</option>
                            <option>제목</option>
                            <option>내용</option>
                            <option>작성자</option>
                        </select>
                        <div
                                class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none w-8 h-8"
                        >
                            <i class="ri-arrow-down-s-line text-gray-500"></i>
                        </div>
                    </div>
                    <div class="relative flex-1">
                        <input
                                type="text"
                                placeholder="검색어를 입력하세요"
                                class="w-full py-2 pl-3 pr-10 text-sm border-none border-l border-gray-300 focus:outline-none focus:ring-2 focus:ring-primary"
                        />
                        <button
                                class="absolute inset-y-0 right-0 flex items-center px-3"
                        >
                            <div class="w-5 h-5 flex items-center justify-center">
                                <i class="ri-search-line text-gray-500"></i>
                            </div>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <!-- 게시글 목록 (데스크톱) -->
        <div
                class="bg-white rounded-lg shadow-sm overflow-hidden mb-5 hidden md:block"
        >
            <table class="w-full">
                <thead>
                <tr class="bg-gray-50 text-left">
                    <th class="py-3 px-4 text-sm font-medium text-gray-600 w-16">
                        번호
                    </th>
                    <th class="py-3 px-4 text-sm font-medium text-gray-600 w-[45%]">
                        제목
                    </th>
                    <th class="py-3 px-4 text-sm font-medium text-gray-600 w-28">
                        작성자
                    </th>
                    <th class="py-3 px-4 text-sm font-medium text-gray-600 w-28">
                        작성일
                    </th>
                    <th
                            class="py-3 px-4 text-sm font-medium text-gray-600 w-20 text-center"
                    >
                        조회
                    </th>
                    <th
                            class="py-3 px-4 text-sm font-medium text-gray-600 w-20 text-center"
                    >
                        추천
                    </th>
                </tr>
                </thead>
                <tbody>
                <!-- 공지 게시글 -->
                <tr class="table-row bg-blue-50">
                    <td class="py-3 px-4 text-sm font-medium text-primary">공지</td>
                    <td class="py-3 px-4">
                        <a
                                href="#"
                                class="text-sm font-medium text-gray-800 hover:text-primary"
                        >
                            커뮤니티 이용 규칙 안내 - 꼭 읽어주세요!
                        </a>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">관리자</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">
                        1,245
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">32</td>
                </tr>
                <!-- 새 게시글 (알림 효과) -->
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">15</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2 truncate block max-w-[400px]"
                            >
                                오늘 처음으로 등산에 도전했는데 너무 힘들었어요 ㅠㅠ
                            </a>
                            <div class="flex items-center space-x-1 mr-2 flex-shrink-0">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="이미지 첨부"
                                >
                                    <i class="ri-image-line"></i>
                                </div>
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="파일 첨부"
                                >
                                    <i class="ri-file-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm flex-shrink-0"
                            >[12]</span
                            >
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">강지영</td>
                    <td class="py-3 px-4 text-sm text-gray-600">방금 전</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">42</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">5</td>
                </tr>
                <!-- 일반 게시글 -->
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">14</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                오늘 날씨가 정말 좋네요! 다들 어떻게 보내고 계신가요?
                            </a>
                            <span class="ml-2 text-gray-500 text-sm">[28]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">김민준</td>
                    <td class="py-3 px-4 text-sm text-gray-600">3시간 전</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">342</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">28</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">13</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                최근 출시된 신제품 리뷰 - 정말 기대 이상이네요!
                            </a>
                            <div class="flex items-center space-x-1 mr-2">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="이미지 첨부"
                                >
                                    <i class="ri-image-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm">[15]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">이서연</td>
                    <td class="py-3 px-4 text-sm text-gray-600">어제</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">287</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">24</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">12</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                여름 휴가 계획 공유합니다 - 제주도 3박 4일 코스
                            </a>
                            <div class="flex items-center space-x-1 mr-2">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="파일 첨부"
                                >
                                    <i class="ri-file-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm">[9]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">박지훈</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-22</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">256</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">19</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">11</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                맛집 추천 부탁드립니다 - 강남역 주변
                            </a>
                            <span class="ml-2 text-gray-500 text-sm">[23]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">최예은</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-22</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">312</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">17</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">10</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                주말에 볼만한 영화 추천해주세요
                            </a>
                            <span class="ml-2 text-gray-500 text-sm">[18]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">정도윤</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-21</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">278</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">14</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">9</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                개발자 취업 준비 팁 공유합니다
                            </a>
                            <div class="flex items-center space-x-1 mr-2">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="파일 첨부"
                                >
                                    <i class="ri-file-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm">[31]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">송현우</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-21</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">421</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">35</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">8</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                요즘 즐겨듣는 음악 공유해요~
                            </a>
                            <span class="ml-2 text-gray-500 text-sm">[7]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">한소율</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">187</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">9</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">7</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                취미로 시작한 베이킹, 이제는 제 일상이 되었어요
                            </a>
                            <div class="flex items-center space-x-1 mr-2">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="이미지 첨부"
                                >
                                    <i class="ri-image-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm">[5]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">임하은</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">156</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">12</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">6</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                반려동물과 함께하는 일상 이야기
                            </a>
                            <div class="flex items-center space-x-1 mr-2">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="이미지 첨부"
                                >
                                    <i class="ri-image-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm">[8]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">윤서진</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">198</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">15</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">5</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                재택근무 1년 차의 업무 효율성 팁
                            </a>
                            <span class="ml-2 text-gray-500 text-sm">[11]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">조현우</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">234</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">18</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">4</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                새로운 취미 추천해주세요!
                            </a>
                            <span class="ml-2 text-gray-500 text-sm">[16]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">장수빈</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">245</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">21</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">3</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                주식 투자 초보자의 성장 일기
                            </a>
                            <div class="flex items-center space-x-1 mr-2">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="파일 첨부"
                                >
                                    <i class="ri-file-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm">[19]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">김태호</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">312</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">25</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">2</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                해외여행 준비 체크리스트 공유
                            </a>
                            <div class="flex items-center space-x-1 mr-2">
                                <div
                                        class="w-4 h-4 flex items-center justify-center text-gray-400"
                                        title="파일 첨부"
                                >
                                    <i class="ri-file-line"></i>
                                </div>
                            </div>
                            <span class="ml-2 text-gray-500 text-sm">[14]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">이민지</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">267</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">22</td>
                </tr>
                <tr class="table-row">
                    <td class="py-3 px-4 text-sm text-gray-600">1</td>
                    <td class="py-3 px-4">
                        <div class="flex items-center">
                            <a
                                    href="#"
                                    class="text-sm font-medium text-gray-800 hover:text-primary mr-2"
                            >
                                독서모임 멤버 모집합니다
                            </a>
                            <span class="ml-2 text-gray-500 text-sm">[6]</span>
                        </div>
                    </td>
                    <td class="py-3 px-4 text-sm text-gray-600">박서현</td>
                    <td class="py-3 px-4 text-sm text-gray-600">2025-05-20</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">178</td>
                    <td class="py-3 px-4 text-sm text-gray-600 text-center">8</td>
                </tr>
                </tbody>
            </table>
        </div>
        <!-- 게시글 목록 (모바일) -->
        <div class="md:hidden space-y-4 mb-5">
            <!-- 공지 게시글 -->
            <div
                    class="bg-white rounded-lg shadow-sm p-4 border-l-4 border-primary"
            >
                <div class="flex justify-between items-start">
                    <div>
                <span
                        class="inline-block px-2 py-1 bg-blue-100 text-primary text-xs rounded-full mb-2"
                >공지</span
                >
                        <h3 class="font-medium text-gray-800">
                            커뮤니티 이용 규칙 안내 - 꼭 읽어주세요!
                        </h3>
                    </div>
                </div>
                <div class="flex items-center text-xs text-gray-500 mt-2">
                    <span>관리자</span>
                    <span class="mx-1">•</span>
                    <span>2025-05-20</span>
                    <span class="mx-1">•</span>
                    <span>조회 1,245</span>
                    <div class="flex items-center ml-2 text-gray-500">
                        <div class="w-3 h-3 flex items-center justify-center">
                            <i class="ri-thumb-up-line"></i>
                        </div>
                        <span class="ml-1">32</span>
                    </div>
                </div>
            </div>
            <!-- 새 게시글 (알림 효과) -->
            <div class="bg-white rounded-lg shadow-sm p-4">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="font-medium text-gray-800 mb-2">
                            오늘 처음으로 등산에 도전했는데 너무 힘들었어요 ㅠㅠ
                        </h3>
                        <div class="flex items-center text-xs text-gray-500">
                            <span>강지영</span>
                            <span class="mx-1">•</span>
                            <span>방금 전</span>
                            <span class="mx-1">•</span>
                            <span>조회 42</span>
                            <div class="flex items-center ml-2 text-gray-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-thumb-up-line"></i>
                                </div>
                                <span class="ml-1">5</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center text-gray-500 text-sm">
                        <div class="w-5 h-5 flex items-center justify-center">
                            <i class="ri-message-3-line"></i>
                        </div>
                        <span class="ml-1">12</span>
                    </div>
                </div>
            </div>
            <!-- 일반 게시글 -->
            <div class="bg-white rounded-lg shadow-sm p-4">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="font-medium text-gray-800 mb-2">
                            오늘 날씨가 정말 좋네요! 다들 어떻게 보내고 계신가요?
                        </h3>
                        <div class="flex items-center text-xs text-gray-500">
                            <span>김민준</span>
                            <span class="mx-1">•</span>
                            <span>3시간 전</span>
                            <span class="mx-1">•</span>
                            <span>조회 342</span>
                            <div class="flex items-center ml-2 text-gray-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-thumb-up-line"></i>
                                </div>
                                <span class="ml-1">28</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center text-gray-500 text-sm">
                        <div class="w-5 h-5 flex items-center justify-center">
                            <i class="ri-message-3-line"></i>
                        </div>
                        <span class="ml-1">28</span>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-lg shadow-sm p-4">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="font-medium text-gray-800 mb-2">
                            최근 출시된 신제품 리뷰 - 정말 기대 이상이네요!
                        </h3>
                        <div class="flex items-center text-xs text-gray-500">
                            <span>이서연</span>
                            <span class="mx-1">•</span>
                            <span>어제</span>
                            <span class="mx-1">•</span>
                            <span>조회 287</span>
                            <div class="flex items-center ml-2 text-gray-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-thumb-up-line"></i>
                                </div>
                                <span class="ml-1">24</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center text-gray-500 text-sm">
                        <div class="w-5 h-5 flex items-center justify-center">
                            <i class="ri-message-3-line"></i>
                        </div>
                        <span class="ml-1">15</span>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-lg shadow-sm p-4">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="font-medium text-gray-800 mb-2">
                            여름 휴가 계획 공유합니다 - 제주도 3박 4일 코스
                        </h3>
                        <div class="flex items-center text-xs text-gray-500">
                            <span>박지훈</span>
                            <span class="mx-1">•</span>
                            <span>2025-05-22</span>
                            <span class="mx-1">•</span>
                            <span>조회 256</span>
                            <div class="flex items-center ml-2 text-gray-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-thumb-up-line"></i>
                                </div>
                                <span class="ml-1">19</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center text-gray-500 text-sm">
                        <div class="w-5 h-5 flex items-center justify-center">
                            <i class="ri-message-3-line"></i>
                        </div>
                        <span class="ml-1">9</span>
                    </div>
                </div>
            </div>
            <div class="bg-white rounded-lg shadow-sm p-4">
                <div class="flex justify-between items-start">
                    <div>
                        <h3 class="font-medium text-gray-800 mb-2">
                            맛집 추천 부탁드립니다 - 강남역 주변
                        </h3>
                        <div class="flex items-center text-xs text-gray-500">
                            <span>최예은</span>
                            <span class="mx-1">•</span>
                            <span>2025-05-22</span>
                            <span class="mx-1">•</span>
                            <span>조회 312</span>
                            <div class="flex items-center ml-2 text-gray-500">
                                <div class="w-3 h-3 flex items-center justify-center">
                                    <i class="ri-thumb-up-line"></i>
                                </div>
                                <span class="ml-1">17</span>
                            </div>
                        </div>
                    </div>
                    <div class="flex items-center text-gray-500 text-sm">
                        <div class="w-5 h-5 flex items-center justify-center">
                            <i class="ri-message-3-line"></i>
                        </div>
                        <span class="ml-1">23</span>
                    </div>
                </div>
            </div>
        </div>
        <!-- 페이지네이션 -->
        <div class="flex justify-center items-center space-x-1 py-8 mt-8">
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full text-gray-500 hover:bg-gray-100"
            >
                <div class="w-5 h-5 flex items-center justify-center">
                    <i class="ri-arrow-left-s-line"></i>
                </div>
            </a>
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full bg-primary text-white"
            >1</a
            >
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full text-gray-700 hover:bg-gray-100"
            >2</a
            >
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full text-gray-700 hover:bg-gray-100"
            >3</a
            >
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full text-gray-700 hover:bg-gray-100"
            >4</a
            >
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full text-gray-700 hover:bg-gray-100"
            >5</a
            >
            <span class="w-9 h-9 flex items-center justify-center text-gray-500"
            >...</span
            >
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full text-gray-700 hover:bg-gray-100"
            >10</a
            >
            <a
                    href="#"
                    class="w-9 h-9 flex items-center justify-center rounded-full text-gray-500 hover:bg-gray-100"
            >
                <div class="w-5 h-5 flex items-center justify-center">
                    <i class="ri-arrow-right-s-line"></i>
                </div>
            </a>
        </div>
    </div>
</main>
<!-- 스크롤 상단 이동 버튼 -->
<button
        id="scrollToTop"
        class="scroll-to-top w-12 h-12 bg-primary text-white rounded-full shadow-lg flex items-center justify-center"
>
    <div class="w-6 h-6 flex items-center justify-center">
        <i class="ri-arrow-up-line"></i>
    </div>
</button>
<!-- 스크립트 -->
<script id="mobileMenuScript">
    document.addEventListener("DOMContentLoaded", function () {
        const mobileMenuBtn = document.getElementById("mobileMenuBtn");
        const mobileSidebar = document.getElementById("mobileSidebar");
        const closeMobileMenu = document.getElementById("closeMobileMenu");
        const sidebarOverlay = document.getElementById("sidebarOverlay");
        mobileMenuBtn.addEventListener("click", function () {
            mobileSidebar.classList.remove("hidden");
            setTimeout(() => {
                document.querySelector(".mobile-menu").classList.add("open");
            }, 10);
        });
        function closeSidebar() {
            document.querySelector(".mobile-menu").classList.remove("open");
            setTimeout(() => {
                mobileSidebar.classList.add("hidden");
            }, 300);
        }
        closeMobileMenu.addEventListener("click", closeSidebar);
        sidebarOverlay.addEventListener("click", closeSidebar);
    });
</script>
<script id="scrollToTopScript">
    document.addEventListener("DOMContentLoaded", function () {
        const scrollToTopBtn = document.getElementById("scrollToTop");
        window.addEventListener("scroll", function () {
            if (window.pageYOffset > 300) {
                scrollToTopBtn.classList.add("visible");
            } else {
                scrollToTopBtn.classList.remove("visible");
            }
        });
        scrollToTopBtn.addEventListener("click", function () {
            window.scrollTo({
                top: 0,
                behavior: "smooth",
            });
        });
    });
</script>
<script id="voteButtonsScript">
    document.addEventListener("DOMContentLoaded", function () {
        const voteButtons = document.querySelectorAll(".vote-button");
        voteButtons.forEach((button) => {
            button.addEventListener("click", function () {
                const currentCount = parseInt(this.querySelector("span").textContent);
                this.querySelector("span").textContent = currentCount + 1;
            });
        });
    });
</script>
</body>
</html>
