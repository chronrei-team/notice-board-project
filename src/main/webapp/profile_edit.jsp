<%@ page import="notice.project.my.DO.UserResponse" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>정보 수정</title>
    <%-- Tailwind CSS 및 기타 필요한 CSS/JS 링크 --%>
    <%@ include file="common/tailwind.jspf" %>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.6.0/remixicon.min.css"
    />
    <style>
        /* :where([class^="ri-"])::before { content: "\f3c2"; } /* This line from original might cause all icons to be the same, consider removing if icons are wrong */
        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
        }
        .form-input:focus { /* Unified focus style for inputs */
            outline: none;
            border-color: #4F46E5; /* primary-600 */
            box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.2);
        }
        .input-group {
            position: relative;
        }
        .password-toggle {
            position: absolute;
            right: 0.75rem; /* 12px */
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6b7280; /* gray-500 */
        }
        .password-toggle:hover {
            color: #4F46E5; /* primary */
        }
        .form-section-divider {
            border-top: 1px solid #e5e7eb; /* gray-200 */
            margin-top: 1.5rem; /* 24px */
            margin-bottom: 1.5rem; /* 24px */
            padding-top: 1.5rem; /* 24px */
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">
<%-- 헤더 영역 --%>
<%@ include file="common/header.jspf" %>

<!-- 정보 수정 컨텐츠 영역 -->
<main class="flex-1 container mx-auto px-4 py-8 flex items-center justify-center">
    <div class="bg-white rounded-lg shadow-md p-8 w-full max-w-lg">
        <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">정보 수정</h1>

        <form id="userEditForm" action="${pageContext.request.contextPath}/my/update" method="post" class="space-y-6">
            <div>
                <label for="userName" class="block text-sm font-medium text-gray-700 mb-1">닉네임</label>
                <input type="text" id="userName" name="userName" required
                       class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm"
                       placeholder="새 닉네임을 입력하세요 현재: ${token.userName}"
                       value="${param.userName}">
            </div>

            <div class="form-section-divider">
                <h2 class="text-xl font-semibold text-gray-700 mb-4">비밀번호 변경</h2>
                <p class="text-xs text-gray-500 mb-4">비밀번호를 변경하시려면 아래 필드를 모두 입력해주세요. 변경하지 않으려면 비워두세요.</p>
            </div>

            <div class="input-group">
                <label for="currentPassword" class="block text-sm font-medium text-gray-700 mb-1">현재 비밀번호</label>
                <input type="password" id="currentPassword" name="currentPassword" required
                       class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm pr-10"
                       placeholder="현재 비밀번호 (닉네임 변경 시 또는 비밀번호 변경 시 필수)"
                       value="${param.currentPassword}">
                <span class="password-toggle" onclick="togglePasswordVisibility('currentPassword', this)">
                    <i class="ri-eye-off-line"></i>
                </span>
            </div>

            <div class="input-group">
                <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-1">새 비밀번호</label>
                <input type="password" id="newPassword" name="newPassword"
                       class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm pr-10"
                       placeholder="새 비밀번호 입력"
                       value="${param.newPassword}">
                <span class="password-toggle" onclick="togglePasswordVisibility('newPassword', this)">
                    <i class="ri-eye-off-line"></i>
                </span>
            </div>

            <div class="input-group">
                <label for="confirmNewPassword" class="block text-sm font-medium text-gray-700 mb-1">새 비밀번호 확인</label>
                <input type="password" id="confirmNewPassword" name="confirmNewPassword"
                       class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm pr-10"
                       placeholder="새 비밀번호 다시 입력"
                       value="${param.confirmNewPassword}">
                <span class="password-toggle" onclick="togglePasswordVisibility('confirmNewPassword', this)">
                    <i class="ri-eye-off-line"></i>
                </span>
                <p id="passwordMatchError" class="text-xs text-red-500 mt-1" style="display: none;">새 비밀번호가 일치하지 않습니다.</p>
            </div>

            <c:if test="${!empty UserResponse and !empty UserResponse.failMessage}">
                <div class="mb-4 p-3 rounded-md bg-red-100 text-red-700">
                        ${UserResponse.failMessage}
                </div>
            </c:if>
            <c:if test="${!empty UserResponse and !empty UserResponse.successMessage}">
                <div class="mb-4 p-3 rounded-md bg-green-100 text-green-700">
                        ${UserResponse.successMessage}
                </div>
            </c:if>

            <div>
                <button type="submit"
                        class="w-full bg-primary text-white py-3 px-4 rounded-lg hover:bg-primary/90 font-semibold text-sm transition-colors">
                    정보 수정
                </button>
            </div>
        </form>

        <div class="form-section-divider">
            <h2 class="text-xl font-semibold text-gray-700 mb-4">회원 탈퇴</h2>
        </div>
        <div>
            <button type="button" onclick="confirmWithdrawal()"
                    class="w-full bg-red-600 text-white py-3 px-4 rounded-lg hover:bg-red-700 font-semibold text-sm transition-colors">
                회원 탈퇴
            </button>
            <p class="text-xs text-gray-500 mt-2 text-center">회원 탈퇴 시 모든 정보가 삭제되며 복구할 수 없습니다.</p>
            <form id="withdrawForm" action="<%=request.getContextPath()%>/my/withdraw" method="post" style="display: none;">
                <input type="hidden" id="confirmWithdrawPasswordInput" name="password">
            </form>
        </div>
    </div>
</main>

<script>
    function togglePasswordVisibility(inputId, toggleElement) {
        const passwordInput = document.getElementById(inputId);
        const icon = toggleElement.querySelector("i");
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            icon.classList.remove("ri-eye-off-line");
            icon.classList.add("ri-eye-line");
        } else {
            passwordInput.type = "password";
            icon.classList.remove("ri-eye-line");
            icon.classList.add("ri-eye-off-line");
        }
    }

    const userEditForm = document.getElementById('userEditForm');
    const newPasswordInput = document.getElementById('newPassword');
    const confirmNewPasswordInput = document.getElementById('confirmNewPassword');
    const passwordMatchError = document.getElementById('passwordMatchError');
    const currentPasswordInput = document.getElementById('currentPassword');

    userEditForm.addEventListener('submit', function(event) {
        // Clear previous error
        passwordMatchError.style.display = 'none';
        let hasError = false;

        // If new password is provided, then confirmPassword must match
        if (newPasswordInput.value !== "") {
            if (newPasswordInput.value !== confirmNewPasswordInput.value) {
                passwordMatchError.textContent = '새 비밀번호가 일치하지 않습니다.';
                passwordMatchError.style.display = 'block';
                confirmNewPasswordInput.focus();
                hasError = true;
            }
        } else if (confirmNewPasswordInput.value !== "") {
            // If only confirm new password is set, but new password is not
            alert('새 비밀번호를 입력해주세요.');
            newPasswordInput.focus();
            hasError = true;
        }

        if (hasError) {
            event.preventDefault(); // Prevent form submission
        }
    });

    function confirmWithdrawal() {
        const confirmation = confirm("정말로 회원 탈퇴를 진행하시겠습니까? 이 작업은 되돌릴 수 없습니다.");
        if (confirmation) {
            const password = prompt("회원 탈퇴를 위해 현재 비밀번호를 입력해주세요:");
            if (password !== null && password !== "") {
                document.getElementById('confirmWithdrawPasswordInput').value = password;
                document.getElementById('withdrawForm').submit();
            } else if (password !== null) { // User pressed OK but entered nothing
                alert("비밀번호를 입력해야 합니다.");
            }
        }
    }

</script>
</body>
</html>
