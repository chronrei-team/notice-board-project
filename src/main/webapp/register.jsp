<%@ page import="notice.project.auth.DTO.RegisterResponse" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  RegisterResponse registerDO = (RegisterResponse)request.getAttribute("RegisterResponse");
%>
<!DOCTYPE html>
<html>
<head>
  <title>회원가입</title>
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
            button: "8px", // Consistent button radius
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
    :where([class^="ri-"])::before { content: "\f3c2"; } /* Note: This makes all Remix Icons the same. You might want to remove or fix this line if icons aren't displaying correctly. */
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
      flex-shrink: 0; /* Prevent shrinking in flex layouts */
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
    .custom-search:focus,
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
    <form id="registrationForm" action="<%=request.getContextPath()%>/auth/register" method="post" class="space-y-6">

      <div>
        <label for="regNickname" class="block text-sm font-medium text-gray-700 mb-1">닉네임</label>
        <input type="text" id="regNickname" name="userName" required
               class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm"
               placeholder="닉네임을 입력하세요 (2~10자)">
      </div>
      
      <div class="input-group">
        <label for="regPassword" class="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
        <input type="password" id="regPassword" name="password" required
               class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm pr-10"
               placeholder="비밀번호를 입력하세요 (영문, 숫자, 특수문자 조합 8~16자)">
        <span class="password-toggle" onclick="togglePasswordVisibility('regPassword', this)">
                    <i class="ri-eye-off-line"></i>
                </span>
        <!-- <p class="text-xs text-red-500 mt-1">비밀번호는 8~16자의 영문 대소문자, 숫자, 특수문자를 사용해야 합니다.</p> -->
      </div>

      <div class="input-group">
        <label for="regPasswordConfirm" class="block text-sm font-medium text-gray-700 mb-1">비밀번호 확인</label>
        <input type="password" id="regPasswordConfirm" name="passwordConfirm" required
               class="form-input w-full px-4 py-2.5 border border-gray-300 rounded-button text-sm pr-10"
               placeholder="비밀번호를 다시 입력하세요">
        <span class="password-toggle" onclick="togglePasswordVisibility('regPasswordConfirm', this)">
                     <i class="ri-eye-off-line"></i>
                </span>
        <!-- <p class="text-xs text-red-500 mt-1">비밀번호가 일치하지 않습니다.</p> -->
      </div>
      
      <%
        if (registerDO != null) {
          if (registerDO.getFailMessage() != null) {
      %>
            <p class="text-red-500"><%=registerDO.getFailMessage()%></p>
      <%
          }
      %>
      <%
          if (registerDO.getSuccessMessage() != null) {
      %>
            <p class="text-green-500"><%=registerDO.getSuccessMessage()%></p>
      <%
          }
        }
      %>

      <div>
        <button type="submit"
                class="w-full bg-primary bg-blue-700 text-white py-3 px-4 rounded-lg hover:bg-primary/90 font-semibold text-sm transition-colors">
          가입하기
        </button>
      </div>
    </form>

    <div class="text-center mt-8 text-sm text-gray-600">
      이미 계정이 있으신가요?
      <a href="#" id="openLoginModalFromRegister" class="text-primary hover:text-primary/90 font-medium">로그인</a>
    </div>
  </div>
</main>

<!-- 푸터 영역 (주석 해제하여 사용 가능) -->
<%--<footer class="bg-gray-800 text-white py-6 mt-auto">--%>
<%--    <div class="container mx-auto px-4">--%>
<%--        <div class="text-center text-gray-400 text-sm">--%>
<%--            © 2025 커뮤니티 주식회사. All rights reserved.--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</footer>--%>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    // Header scripts (Login Modal, Search Dropdown, Mobile Menu)
    const loginButton = document.getElementById("loginButton");
    const loginModal = document.getElementById("loginModal");
    const closeLoginModal = document.getElementById("closeLoginModal");

    function openModal() {
      loginModal.classList.remove("hidden");
      document.body.style.overflow = "hidden";
    }
    function closeModal() {
      loginModal.classList.add("hidden");
      document.body.style.overflow = "";
    }

    if (loginButton) loginButton.addEventListener("click", openModal);
    if (closeLoginModal) closeLoginModal.addEventListener("click", closeModal);

    if (loginModal) {
      loginModal.addEventListener("click", (e) => {
        if (e.target === loginModal) {
          closeModal();
        }
      });
    }

    const openLoginModalFromRegister = document.getElementById("openLoginModalFromRegister");
    if(openLoginModalFromRegister) {
      openLoginModalFromRegister.addEventListener("click", (e) => {
        e.preventDefault();
        openModal();
      });
    }


    const searchTypeButton = document.getElementById("searchTypeButton");
    const searchTypeDropdown = document.getElementById("searchTypeDropdown");
    const selectedSearchType = document.getElementById("selectedSearchType");
    const searchTypeOptions = document.querySelectorAll(".search-type-option");

    if (searchTypeButton) {
      searchTypeButton.addEventListener("click", function (e) {
        e.stopPropagation();
        if (searchTypeDropdown) searchTypeDropdown.classList.toggle("hidden");
      });
    }

    if (searchTypeOptions) {
      searchTypeOptions.forEach((option) => {
        option.addEventListener("click", function () {
          if (selectedSearchType) selectedSearchType.textContent = this.textContent;
          if (searchTypeDropdown) searchTypeDropdown.classList.add("hidden");
        });
      });
    }

    document.addEventListener("click", function (e) {
      if (searchTypeButton && !searchTypeButton.contains(e.target) && searchTypeDropdown) {
        searchTypeDropdown.classList.add("hidden");
      }
    });

    const menuButton = document.querySelector(".ri-menu-line")?.parentElement;
    const mobileNav = document.querySelector("header nav"); // More specific selector

    if (menuButton && mobileNav) {
      menuButton.addEventListener("click", function () {
        mobileNav.classList.toggle("hidden"); // Base toggle
        // For mobile-specific layout classes
        mobileNav.classList.toggle("md:flex"); // Ensure it's hidden on md, then re-shown by JS if needed
        mobileNav.classList.toggle("flex-col");
        mobileNav.classList.toggle("absolute");
        mobileNav.classList.toggle("top-16"); // Adjust based on header height
        mobileNav.classList.toggle("right-4");
        mobileNav.classList.toggle("bg-white");
        mobileNav.classList.toggle("shadow-lg");
        mobileNav.classList.toggle("p-4");
        mobileNav.classList.toggle("rounded");
        mobileNav.classList.toggle("z-50");

        const ul = mobileNav.querySelector("ul");
        if (ul) {
          if (mobileNav.classList.contains("flex-col")) { // When mobile menu is open
            ul.classList.remove("flex", "space-x-8");
            ul.classList.add("flex-col", "space-y-4");
          } else { // When mobile menu is closed or on desktop
            ul.classList.add("flex", "space-x-8");
            ul.classList.remove("flex-col", "space-y-4");
          }
        }
      });
    }

    // Custom checkbox styling (already in main page, but good to ensure it's here)
    const checkboxes = document.querySelectorAll(".custom-checkbox");
    checkboxes.forEach(checkbox => {
      checkbox.addEventListener("change", function () {
        // Tailwind's :checked pseudo-class handles this if set up in <style>
        // This JS part is actually redundant if custom-checkbox:checked styles are defined
      });
    });

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