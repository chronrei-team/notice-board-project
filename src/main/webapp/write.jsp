<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>게시글 작성</title>
    <%@ include file="common/tailwind.jspf" %>
    <!-- Toast UI Editor CDN -->
    <link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
    <script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
    <script>
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
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.6.0/remixicon.min.css"
    />
    <style>
        :where([class^="ri-"])::before { content: "\f3c2"; }
        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
        }
        .container2 {
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
<!-- 헤더 영역 (동일하게 유지) -->
<%@ include file="common/header.jspf" %>

<main class="container2">
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