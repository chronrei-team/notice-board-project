<%@ page import="notice.project.auth.DTO.RegisterResponse" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>회원가입</title>
  <%@ include file="common/tailwind.jspf" %>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
          rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/remixicon/4.6.0/remixicon.min.css"
  />
  <style>
    :where([class^="ri-"])::before { content: "\f3c2"; } /* Note: This makes all Remix Icons the same. You might want to remove or fix this line if icons aren't displaying correctly. */
    body {
      font-family: 'Noto Sans KR', sans-serif;
      color: #333;
    }
    .form-input:focus { /* Unified focus style for inputs */
      outline: none;
      border-color: #4F46E5;
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
  </style>
</head>
<body class="bg-gray-50 min-h-screen flex flex-col">
<!-- 헤더 영역 (동일하게 유지) -->
<%@ include file="common/header.jspf" %>

<!-- 회원가입 컨텐츠 영역 -->
<main class="flex-1 container mx-auto px-4 py-8 flex items-center justify-center">
  <div class="bg-white rounded-lg shadow-md p-8 w-full max-w-lg">
    <h1 class="text-3xl font-bold text-gray-800 mb-8 text-center">회원가입</h1>
    <form id="registrationForm" action="${pageContext.request.contextPath}/auth/register" method="post" class="space-y-6">
      <input type="hidden" name="redirectUrl" value="${param.redirectUrl}">
      <div>
        <label for="regNickname" class="block text-sm font-medium text-gray-700 mb-1">닉네임</label>
        <input type="text" id="regNickname" name="userName" required
               class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm"
               placeholder="닉네임을 입력하세요"
               value="${param.userName}">
      </div>
      
      <div class="input-group">
        <label for="regPassword" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
        <input type="password" id="regPassword" name="password" required
               class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm pr-10"
               placeholder="비밀번호를 입력하세요"
               value="${param.password}">
        <span class="password-toggle" onclick="togglePasswordVisibility('regPassword', this)">
                    <i class="ri-eye-off-line"></i>
                </span>
      </div>

      <div class="input-group">
        <label for="regPasswordConfirm" class="block text-sm font-medium text-gray-700 mb-1">비밀번호 확인</label>
        <input type="password" id="regPasswordConfirm" name="passwordConfirm" required
               class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm pr-10"
               placeholder="비밀번호를 다시 입력하세요"
               value="${param.password}">
        <span class="password-toggle" onclick="togglePasswordVisibility('regPasswordConfirm', this)">
                     <i class="ri-eye-off-line"></i>
                </span>
      </div>

      <c:if test="${!empty RegisterResponse and !empty RegisterResponse.failMessage}">
            <p class="mb-4 p-3 rounded-md bg-red-100 text-red-700">${RegisterResponse.failMessage}</p>
      </c:if>
      <c:if test="${!empty RegisterResponse and !empty RegisterResponse.successMessage}">
        <p class="mb-4 p-3 rounded-md bg-green-100 text-green-700">${RegisterResponse.successMessage}</p>
      </c:if>

      <div>
        <button type="submit"
                class="w-full bg-primary bg-blue-700 text-white py-3 px-4 rounded-lg hover:bg-primary/90 font-semibold text-sm transition-colors">
          가입하기
        </button>
      </div>
    </form>

    <div class="text-center mt-8 text-sm text-gray-600">
      이미 계정이 있으신가요?
      <a href="${pageContext.request.contextPath}/auth/login?redirectUrl=${URLEncoder.encode(param.redirectUrl, StandardCharsets.UTF_8)}"
         class="text-primary hover:text-primary/90 font-medium">로그인</a>
    </div>
  </div>
</main>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    // Registration form specific script
    const registrationForm = document.getElementById("registrationForm");
    if (registrationForm) {
      registrationForm.addEventListener("submit", function(event) {
        // Basic password confirmation example
        const password = document.getElementById("regPassword").value;
        const passwordConfirm = document.getElementById("regPasswordConfirm").value;
        if (password !== passwordConfirm) {
          alert("비밀번호가 일치하지 않습니다.");
          event.preventDefault(); // Prevent form submission
          document.getElementById("regPasswordConfirm").focus();
          return;
        }
        // Add more validation logic here if needed
        // e.g., AJAX checks for username/email availability
      });
    }
  });

  // Password visibility toggle function
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
</script>
</body>
</html>