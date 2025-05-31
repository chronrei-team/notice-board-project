<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Toast UI Editor CDN -->
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
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

        // 첨부파일 삭제 버튼 클릭 시 해당 파일 input 초기화
        function removeFile(index) {
            const fileInput = document.getElementById(`file${index}`);
            fileInput.value = "";
            document.getElementById(`fileName${index}`).textContent = "선택된 파일 없음";
            document.getElementById(`removeBtn${index}`).style.display = "none";
        }

        // 파일 선택 시 파일명 표시 및 삭제 버튼 표시
        function handleFileChange(index) {
            const fileInput = document.getElementById(`file${index}`);
            const fileNameDisplay = document.getElementById(`fileName${index}`);
            const removeBtn = document.getElementById(`removeBtn${index}`);

            if (fileInput.files.length > 0) {
                fileNameDisplay.textContent = fileInput.files[0].name;
                removeBtn.style.display = "inline-block";
            } else {
                fileNameDisplay.textContent = "선택된 파일 없음";
                removeBtn.style.display = "none";
            }
        }

        window.onload = () => {
            // 검색 타입 드롭다운
            const searchTypeButton = document.getElementById("searchTypeButton");
            const searchTypeDropdown = document.getElementById("searchTypeDropdown");
            const selectedSearchType = document.getElementById("selectedSearchType");

            if (searchTypeButton) {
                searchTypeButton.addEventListener("click", () => {
                    searchTypeDropdown.classList.toggle("hidden");
                });

                document.querySelectorAll(".search-type-option").forEach((btn) => {
                    btn.addEventListener("click", () => {
                        selectedSearchType.textContent = btn.textContent;
                        searchTypeDropdown.classList.add("hidden");
                    });
                });
            }

            // 로그인 모달
            const loginButton = document.getElementById("loginButton");
            const loginModal = document.getElementById("loginModal");
            const closeLoginModal = document.getElementById("closeLoginModal");

            if (loginButton && loginModal && closeLoginModal) {
                loginButton.onclick = () => loginModal.classList.remove("hidden");
                closeLoginModal.onclick = () => loginModal.classList.add("hidden");
                window.onclick = (e) => {
                    if (e.target === loginModal) loginModal.classList.add("hidden");
                };
            }
        };

        let editor;

        window.addEventListener('DOMContentLoaded', () => {
            editor = new toastui.Editor({
                el: document.querySelector('#editor'),
                height: '800px',
                initialEditType: 'wysiwyg',
                previewStyle: 'vertical',
                hooks: {
                    async addImageBlobHook(blob, callback) {
                        const formData = new FormData();
                        formData.append('image', blob);

                        try {
                            const response = await fetch('<%= request.getContextPath() %>/uploadImage', {
                                method: 'POST',
                                body: formData
                            });
                            const result = await response.json();
                            callback(result.url, blob.name);
                        } catch (error) {
                            console.error('이미지 업로드 실패:', error);
                        }
                    }
                }
            });

            // 폼 제출 시 에디터 내용을 textarea로 복사
            document.querySelector('form').addEventListener('submit', function () {
                document.getElementById('content').value = editor.getHTML();
            });
        });
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
        .container {
            max-width: 1000px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            font-weight: bold;
            display: block;
            margin-bottom: 8px;
        }
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        .form-group textarea {
            height: 250px;
            resize: vertical;
        }
        .button-group {
            text-align: right;
        }
        .button-group button {
            padding: 10px 20px;
            margin-left: 10px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
        }
        .btn-submit {
            background-color: #4a60ff;
            color: white;
        }
        .btn-cancel {
            background-color: #ccc;
            color: black;
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">

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
                            class="ml-2 bg-primary text-white px-4 py-2 !rounded-button text-sm hover:bg-primary/90 whitespace-nowrap"
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
                        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50"
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
                                        for="email"
                                        class="block text-sm font-medium text-gray-700 mb-1"
                                >이메일</label
                                >
                                <input
                                        type="email"
                                        id="email"
                                        name="email"
                                        required
                                        class="w-full px-3 py-2 border border-gray-300 rounded-button focus:border-primary focus:ring-1 focus:ring-primary text-sm"
                                        placeholder="이메일 주소를 입력하세요"
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
                            <div class="flex items-center justify-between text-sm">
                                <div class="flex items-center">
                                    <input
                                            type="checkbox"
                                            id="remember"
                                            name="remember"
                                            class="custom-checkbox"
                                    />
                                    <label for="remember" class="ml-2 text-gray-600"
                                    >자동 로그인</label
                                    >
                                </div>
                                <a href="#" class="text-gray-600 hover:text-primary"
                                >아이디/비밀번호 찾기</a
                                >
                            </div>
                            <button
                                    type="submit"
                                    class="w-full bg-primary text-white py-2 !rounded-button hover:bg-primary/90"
                            >
                                로그인
                            </button>
                        </form>
                        <div class="relative my-6">
                            <div class="absolute inset-0 flex items-center">
                                <div class="w-full border-t border-gray-200"></div>
                            </div>
                            <div class="relative flex justify-center text-sm">
                                <span class="px-2 bg-white text-gray-500">간편 로그인</span>
                            </div>
                        </div>
                        <div class="grid grid-cols-3 gap-3 mb-6">
                            <button
                                    class="flex items-center justify-center py-2 px-4 border border-gray-300 rounded-button hover:bg-gray-50"
                            >
                                <div class="w-6 h-6 flex items-center justify-center">
                                    <i class="ri-kakao-talk-fill text-[#FAE100]"></i>
                                </div>
                            </button>
                            <button
                                    class="flex items-center justify-center py-2 px-4 border border-gray-300 rounded-button hover:bg-gray-50"
                            >
                                <div class="w-6 h-6 flex items-center justify-center">
                                    <i class="ri-naver-fill text-[#03C75A]"></i>
                                </div>
                            </button>
                            <button
                                    class="flex items-center justify-center py-2 px-4 border border-gray-300 rounded-button hover:bg-gray-50"
                            >
                                <div class="w-6 h-6 flex items-center justify-center">
                                    <i class="ri-google-fill text-[#4285F4]"></i>
                                </div>
                            </button>
                        </div>
                        <div class="text-center text-sm text-gray-600">
                            아직 회원이 아니신가요?
                            <a
                                    href="#"
                                    class="text-primary hover:text-primary/90 font-medium"
                            >회원가입</a
                            >
                        </div>
                    </div>
                </div>
                <a
                        href="https://readdy.ai/home/794bfdf2-75c4-4d76-8583-1799c03dda83/254d9dbf-0809-4d6e-b18d-dda8ec89cc9b"
                        data-readdy="true"
                        class="bg-primary text-white px-4 py-2 !rounded-button text-sm hover:bg-primary/90 whitespace-nowrap inline-block"
                >회원가입</a
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

<main class="container">
    <h2 class="text-2xl font-bold mb-6">게시글 작성</h2>
    <!-- enctype="multipart/form-data" 필수 -->
    <form action="write.jsp" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="title">제목 <span style="color:red;">*</span></label>
            <input type="text" id="title" name="title" required />
        </div>

        <div class="form-group">
            <label for="category">카테고리 <span style="color:red;">*</span></label>
            <select id="category" name="category" required>
                <option value="" disabled selected>카테고리를 선택하세요</option>
                <option value="공지사항">공지사항</option>
                <option value="자유게시판">자유게시판</option>
                <option value="Q&A">Q&A</option>
                <option value="정보공유">정보공유</option>
                <!-- 필요에 따라 옵션 추가 -->
            </select>
        </div>

        <div class="form-group">
            <label for="content">내용 <span style="color:red;">*</span></label>
            <textarea id="content" name="content" required style="display: none;"></textarea>
            <div id="editor"></div>
        </div>

        <div class="form-group">
            <label>첨부파일 (최대 3개)</label>

            <div class="file-input-wrapper">
                <input
                        type="file"
                        id="file1"
                        name="file1"
                        accept="image/*,application/pdf,application/octet-stream"
                        onchange="handleFileChange(1)"
                />
                <span class="file-name" id="fileName1">선택된 파일 없음</span>
                <button type="button" class="remove-file-btn" id="removeBtn1" onclick="removeFile(1)">삭제</button>
            </div>

            <div class="file-input-wrapper">
                <input
                        type="file"
                        id="file2"
                        name="file2"
                        accept="image/*,application/pdf,application/octet-stream"
                        onchange="handleFileChange(2)"
                />
                <span class="file-name" id="fileName2">선택된 파일 없음</span>
                <button type="button" class="remove-file-btn" id="removeBtn2" onclick="removeFile(2)">삭제</button>
            </div>

            <div class="file-input-wrapper">
                <input
                        type="file"
                        id="file3"
                        name="file3"
                        accept="image/*,application/pdf,application/octet-stream"
                        onchange="handleFileChange(3)"
                />
                <span class="file-name" id="fileName3">선택된 파일 없음</span>
                <button type="button" class="remove-file-btn" id="removeBtn3" onclick="removeFile(3)">삭제</button>
            </div>
        </div>

        <div class="button-group">
            <button type="submit" class="btn-submit">등록</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        </div>
    </form>
</main>

</body>
</html>