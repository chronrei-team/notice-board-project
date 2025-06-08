<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="notice.project.entity.UserStatus" %>

<%--
  [개발자 참고]
  이 페이지를 로드하는 서블릿에서는 아래와 같이 사용자 목록을 request에 담아 전달해야 합니다.
  List<UserDTO> userList = userService.findAllUsers();
  request.setAttribute("userList", userList);

  UserDTO는 아래와 같은 필드를 포함해야 합니다.
  - String userId (관리 버튼에서 내부적으로 사용)
  - String username
  - java.util.Date joinDate
  - String status ("ACTIVE", "SUSPENDED")
  - java.util.Date suspensionEndDate (정지된 경우, 정지 만료일. 영구 정지 시 null)
--%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 - 사용자 관리</title>
    <%@ include file="common/tailwind.jspf" %>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet"/>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
        }
        /* 기본 스크롤바 숨기기 */
        .no-scrollbar::-webkit-scrollbar {
            display: none;
        }
        .no-scrollbar {
            -ms-overflow-style: none;  /* IE and Edge */
            scrollbar-width: none;  /* Firefox */
        }
    </style>
</head>
<body class="bg-gray-50">
<%@ include file="common/header.jspf" %>

<main class="container mx-auto px-4 py-8">
    <div class="bg-white p-6 md:p-8 rounded shadow-sm">
        <div class="flex flex-col md:flex-row md:items-center md:justify-between mb-6 pb-4 border-b gap-4">
            <h1 class="text-2xl font-bold text-gray-800 whitespace-nowrap">
                사용자 관리
            </h1>
            
            <div class="w-full md:w-auto">
                <form method="get" action="${pageContext.request.contextPath}/admin/users" class="flex items-center gap-2">
                    <div class="relative flex-grow">
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="이름을 입력하세요"
                               class="custom-search w-48 py-2 px-1 border border-gray-300 rounded-button text-sm focus:border-primary transition-colors">
                    </div>
                    <button type="submit" class="flex-shrink-0 bg-primary text-white px-4 py-2 text-sm rounded hover:bg-primary/90">
                        <i class="ri-search-line md:hidden"></i>
                        <span class="hidden md:inline">검색</span>
                    </button>
                </form>
            </div>
        </div>

        <!-- 사용자 목록 테이블 -->
        <div class="overflow-x-auto no-scrollbar">
            <table class="min-w-full w-full text-sm text-left text-gray-600">
                <thead class="text-xs text-gray-700 uppercase bg-gray-100">
                <tr>
                    <th scope="col" class="px-6 py-3">이름</th>
                    <th scope="col" class="px-6 py-3 hidden md:table-cell">가입일</th>
                    <th scope="col" class="px-6 py-3 text-center">상태</th>
                    <th scope="col" class="px-6 py-3 text-center">정지 해제일</th>
                    <th scope="col" class="px-6 py-3 text-center">관리</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${not empty userList}">
                        <c:forEach var="user" items="${userList}">
                            <tr class="bg-white border-b hover:bg-gray-50">
                                <td class="px-6 py-4 font-medium text-gray-900 whitespace-nowrap">${user.username}</td>
                                <td class="px-6 py-4 hidden md:table-cell">
                                    <fmt:formatDate value="${user.joinDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <c:choose>
                                        <c:when test="${user.status == UserStatus.Suspended}">
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">정지</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">활성</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="px-6 py-4 text-center">
                                        <%-- 정지된 사용자에게만 정지 해제일 또는 영구 정지 표시 --%>
                                    <c:if test="${user.status == UserStatus.Suspended}">
                                        <c:choose>
                                            <c:when test="${not empty user.suspensionEndDate}">
                                                <span class="text-red-600 font-medium">
                                                    <fmt:formatDate value="${user.suspensionEndDate}" pattern="yyyy-MM-dd HH:mm:ss"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-red-700 font-bold">영구</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                    <c:if test="${user.status != UserStatus.Suspended}">
                                        -
                                    </c:if>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <c:if test="${user.status != UserStatus.Suspended}">
                                        <button type="button"
                                                class="suspend-btn font-medium text-white bg-yellow-500 hover:bg-yellow-600 focus:ring-4 focus:ring-yellow-300 rounded-lg text-xs px-3 py-1.5"
                                                data-userid="${user.userId}" data-username="${user.username}">
                                            계정 정지
                                        </button>
                                    </c:if>
                                    <c:if test="${user.status == UserStatus.Suspended}">
                                        <button type="button"
                                                class="release-btn font-medium text-white bg-blue-500 hover:bg-blue-600 focus:ring-4 focus:ring-blue-300 rounded-lg text-xs px-3 py-1.5"
                                                data-userid="${user.userId}">
                                            정지 해제
                                        </button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="text-center py-12 text-gray-500">
                                등록된 사용자가 없습니다.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</main>

<!-- 계정 정지 모달 -->
<div id="suspend-modal" class="hidden fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-lg shadow-xl w-full max-w-md">
        <div class="p-6 border-b">
            <h3 class="text-lg font-medium text-gray-900">
                계정 정지
                <span id="modal-username" class="text-primary font-bold"></span>
            </h3>
        </div>
        <form action="${pageContext.request.contextPath}/admin/suspendUser" method="post">
            <div class="p-6 space-y-4">
                <input type="hidden" name="userId" id="modal-user-id">

                <div>
                    <label for="suspensionPeriod" class="block mb-2 text-sm font-medium text-gray-900">정지 기간</label>
                    <select id="suspensionPeriod" name="suspensionPeriod" class="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary focus:border-primary block w-full p-2.5" required>
                        <option value="1">1일</option>
                        <option value="7" selected>7일</option>
                        <option value="30">30일</option>
                        <option value="-1">영구 정지</option>
                    </select>
                </div>
                <div>
                    <label for="suspensionReason" class="block mb-2 text-sm font-medium text-gray-900">정지 사유</label>
                    <textarea id="suspensionReason" name="suspensionReason" rows="4" class="block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary focus:border-primary" placeholder="정지 사유를 입력하세요..." required></textarea>
                </div>
            </div>
            <div class="flex items-center justify-end p-4 bg-gray-50 border-t rounded-b-lg space-x-2">
                <button type="button" id="modal-cancel-btn" class="text-gray-500 bg-white hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-gray-200 rounded-lg border border-gray-200 text-sm font-medium px-5 py-2.5 hover:text-gray-900 focus:z-10">
                    취소
                </button>
                <button type="submit" class="text-white bg-primary hover:bg-primary/90 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center">
                    계정 정지
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    // 스크립트는 이전과 동일하게 사용하면 됩니다.
    document.addEventListener('DOMContentLoaded', () => {
        const suspendModal = document.getElementById('suspend-modal');
        const modalUserIdInput = document.getElementById('modal-user-id');
        const modalUsernameSpan = document.getElementById('modal-username');
        const modalCancelBtn = document.getElementById('modal-cancel-btn');

        document.querySelectorAll('.suspend-btn').forEach(button => {
            button.addEventListener('click', () => {
                const userId = button.dataset.userid;
                const username = button.dataset.username;

                modalUserIdInput.value = userId;
                modalUsernameSpan.textContent = `(` + username +`)`;
                suspendModal.classList.remove('hidden');
            });
        });

        document.querySelectorAll('.release-btn').forEach(button => {
            button.addEventListener('click', () => {
                if (confirm('정말로 이 사용자의 정지를 해제하시겠습니까?')) {
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = '${pageContext.request.contextPath}/admin/releaseUser';

                    const userIdInput = document.createElement('input');
                    userIdInput.type = 'hidden';
                    userIdInput.name = 'userId';
                    userIdInput.value = button.dataset.userid;

                    form.appendChild(userIdInput);
                    document.body.appendChild(form);
                    form.submit();
                }
            });
        });

        modalCancelBtn.addEventListener('click', () => {
            suspendModal.classList.add('hidden');
        });

        suspendModal.addEventListener('click', (event) => {
            if (event.target === suspendModal) {
                suspendModal.classList.add('hidden');
            }
        });
    });
</script>
<script src="https://cdn.tailwindcss.com?plugins=forms"></script>
</body>
</html>