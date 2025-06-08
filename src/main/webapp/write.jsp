<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
    <form id="postUploadForm" action="${empty EditResponse ? 'write' : 'edit'}" method="post" enctype="multipart/form-data">
        <input type="hidden" name="redirectUrl" value="${param.redirectUrl}">
        <input type="hidden" name="postId" value="${EditResponse.postId}">
        <div class="form-group">
            <label for="title">제목 <span style="color:red;">*</span></label>
            <input type="text" id="title" name="title" value="${fn:escapeXml(EditResponse.title)}" required />
        </div>

        <div class="form-group">
            <label for="category">카테고리 <span style="color:red;">*</span></label>
            <select id="category" name="category" required>
                <option value="" disabled ${empty EditResponse.category ? 'selected' : ''}>카테고리를 선택하세요</option>
                <c:if test="${admin}">
                    <option value="Notice" ${EditResponse.category == 'Notice' ? 'selected' : ''}>공지사항</option>
                </c:if>
                <option value="Normal" ${EditResponse.category == 'Normal' ? 'selected' : ''}>자유게시판</option>
                <option value="Qna" ${EditResponse.category == 'Qna' ? 'selected' : ''}>Q&A</option>
                <option value="Information" ${EditResponse.category == 'Information' ? 'selected' : ''}>정보공유</option>
            </select>
        </div>

        <div class="form-group">
            <label for="content">내용 <span style="color:red;">*</span></label>
            <textarea id="content" name="content" style="display: none;">${fn:escapeXml(EditResponse.content)}</textarea>
            <div id="editor"></div>
        </div>

        <div>
            <label class="font-bold">첨부파일 (최대 3개)</label>

            <div class="space-y-6 py-4"> <!-- 전체 컨테이너 및 각 파일 입력 그룹 간 간격 -->

                <!-- 파일 입력 그룹 1 -->
                <div class="file-input-group flex items-center space-x-3 p-4 border border-gray-300 rounded-lg bg-gray-50 shadow-sm">
                    <!-- 실제 파일 입력 (시각적으로 숨김, 접근성을 위해 sr-only 사용) -->
                    <input
                            type="file"
                            id="file1"
                            name="file1"
                            class="sr-only"
                            accept="image/*,application/pdf,application/octet-stream"
                            onchange="handleFileChange(1)"
                    />
                    <input type="hidden" id="file1_before_id" name="file1_before_id" value="${EditResponse.fileIdList[0]}">
                    <!-- 커스텀 파일 선택 버튼 (label 활용) -->
                    <label
                            for="file1"
                            class="cursor-pointer bg-primary hover:bg-primary/90 text-white font-medium py-2 px-4 rounded-md transition-colors duration-150 ease-in-out whitespace-nowrap"
                    >
                        파일 선택
                    </label>
                    <!-- 선택된 파일 이름 표시 영역 -->
                    <span id="fileName1" class="flex-grow text-sm text-gray-700 truncate" title="선택된 파일 없음">
            선택된 파일 없음
        </span>
                    <!-- 삭제 버튼 -->
                    <button
                            type="button"
                            id="removeBtn1"
                            onclick="removeFile(1)"
                            class="hidden bg-red-500 hover:bg-red-600 text-white font-medium py-1.5 px-3 rounded-md transition-colors duration-150 ease-in-out text-sm"
                    >
                        삭제
                    </button>
                </div>

                <!-- 파일 입력 그룹 2 -->
                <div class="file-input-group flex items-center space-x-3 p-4 border border-gray-300 rounded-lg bg-gray-50 shadow-sm">
                    <input type="file" id="file2" name="file2" class="sr-only" accept="image/*,application/pdf,application/octet-stream" onchange="handleFileChange(2)"/>
                    <input type="hidden" id="file2_before_id" name="file2_before_id" value="${EditResponse.fileIdList[1]}">
                    <label for="file2" class="cursor-pointer bg-primary hover:bg-primary/90 text-white font-medium py-2 px-4 rounded-md transition-colors duration-150 ease-in-out whitespace-nowrap">
                        파일 선택
                    </label>
                    <span id="fileName2" class="flex-grow text-sm text-gray-700 truncate" title="선택된 파일 없음">
            선택된 파일 없음
        </span>
                    <button type="button" id="removeBtn2" onclick="removeFile(2)" class="hidden bg-red-500 hover:bg-red-600 text-white font-medium py-1.5 px-3 rounded-md transition-colors duration-150 ease-in-out text-sm">
                        삭제
                    </button>
                </div>

                <!-- 파일 입력 그룹 3 -->
                <div class="file-input-group flex items-center space-x-3 p-4 border border-gray-300 rounded-lg bg-gray-50 shadow-sm">
                    <input type="file" id="file3" name="file3" class="sr-only" accept="image/*,application/pdf,application/octet-stream" onchange="handleFileChange(3)"/>
                    <input type="hidden" id="file3_before_id" name="file3_before_id" value="${EditResponse.fileIdList[2]}">
                    <label for="file3" class="cursor-pointer bg-primary hover:bg-primary/90 text-white font-medium py-2 px-4 rounded-md transition-colors duration-150 ease-in-out whitespace-nowrap">
                        파일 선택
                    </label>
                    <span id="fileName3" class="flex-grow text-sm text-gray-700 truncate" title="선택된 파일 없음">
            선택된 파일 없음
        </span>
                    <button type="button" id="removeBtn3" onclick="removeFile(3)" class="hidden bg-red-500 hover:bg-red-600 text-white font-medium py-1.5 px-3 rounded-md transition-colors duration-150 ease-in-out text-sm">
                        삭제
                    </button>
                </div>

            </div>
        </div>

        <div class="button-group">
            <button type="submit" class="bg-primary text-white">등록</button>
            <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
        </div>
    </form>
</main>
<script>
    // 첨부파일 삭제 버튼 클릭 시 해당 파일 input 초기화
    function removeFile(index) {
        const fileInput = document.querySelector(`#file` + index);
        const fileNameDisplay = document.getElementById(`fileName` + index);
        const removeBtn = document.getElementById(`removeBtn` + index);
        const fileBeforeId = document.querySelector(`#file` + index + `_before_id`);

        if (fileInput) {
            fileInput.value = ""; // 파일 입력 값 초기화
        }
        if (fileNameDisplay) {
            fileNameDisplay.textContent = "선택된 파일 없음";
            fileNameDisplay.setAttribute('title', "선택된 파일 없음");
        }
        if (removeBtn) {
            removeBtn.classList.add('hidden'); // Tailwind: hidden 클래스 추가로 버튼 숨기기
        }

        fileBeforeId.value = '';
    }

    // 파일 선택 시 파일명 표시 및 삭제 버튼 표시
    function handleFileChange(index) {
        const fileInput = document.getElementById(`file` + index);
        const removeBtn = document.getElementById(`removeBtn` + index);
        const fileNameDisplay = document.getElementById(`fileName` + index);
        const fileBeforeId = document.querySelector(`#file` + index + `_before_id`);

        if (fileInput.files && fileInput.files.length > 0) {
            const fileName = fileInput.files[0].name;
            fileNameDisplay.textContent = fileName;
            fileNameDisplay.setAttribute('title', fileName); // 긴 파일 이름을 위해 title 속성 추가
            removeBtn.classList.remove('hidden'); // Tailwind: hidden 클래스 제거로 버튼 보이기
        } else {
            // 파일 선택 취소 시 (일부 브라우저) 또는 파일이 없는 초기 상태
            fileNameDisplay.textContent = "선택된 파일 없음";
            fileNameDisplay.setAttribute('title', "선택된 파일 없음");
            removeBtn.classList.add('hidden'); // Tailwind: hidden 클래스 추가로 버튼 숨기기
        }

        fileBeforeId.value = '';
    }

    const form = document.querySelector('#postUploadForm');

    // 폼 제출 시 에디터 내용을 textarea로 복사
    form.addEventListener('submit', function (event) {
        const contentTextarea = document.getElementById('content');
        const editorContent = editor.getMarkdown(); // 또는 getHTML()
        contentTextarea.value = editorContent;

        // 에디터 내용에 대한 자체 유효성 검사
        if (editorContent.trim() === '') {
            alert('내용을 입력해주세요.'); // 사용자에게 알림
            event.preventDefault(); // 폼 제출 막기
            return;
        }
    });

    let editor;

    window.addEventListener('DOMContentLoaded', () => {
        let fileNameDisplay;
        let removeBtn;
        <c:forEach items="${EditResponse.fileNames}" var="fileName" varStatus="loop">
            fileNameDisplay = document.getElementById(`fileName` + ${loop.index + 1});

            fileNameDisplay.textContent = '${fileName}';
            fileNameDisplay.setAttribute('title', '${fileName}'); // 긴 파일 이름을 위해 title 속성 추가

            removeBtn = document.getElementById(`removeBtn` + ${loop.index + 1});
            removeBtn.classList.remove('hidden'); // Tailwind: hidden 클래스 제거로 버튼 보이기
        </c:forEach>

        const contentText = document.querySelector('#content').value;

        editor = new toastui.Editor({
            el: document.querySelector('#editor'),
            initialValue: contentText,
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
    });
</script>
</body>
</html>