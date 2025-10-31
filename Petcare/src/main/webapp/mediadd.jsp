<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  mediadd.jsp
  - 목적: 반려동물의 투약기록을 신규로 등록하는 입력 폼
  - 포인트: input[type=datetime-local] 값은 서버에서 LocalDateTime.parse 로 처리
  - 사용법: index.jsp 또는 목록 화면에서 전달받은 petId를 그대로 사용합니다.
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>투약기록 등록</title>
  <style>
    body { font-family: system-ui, sans-serif; padding: 24px; }
    input, button, label { font-size:16px; }
    .card { padding:16px; border:1px solid #e5e7eb; border-radius:12px; max-width:520px; }
    .row { margin-bottom: 12px; display:flex; gap:8px; align-items:center; }
  </style>
</head>
<body>
  <h1>투약기록 등록</h1>
  <div class="card">
    <form action="mediaddprocess.jsp" method="post">
      <%-- 등록 대상 반려동물 식별자 입력. 실제 서비스에서는 숨김 필드/쿼리스트링으로 전달하는 방식 권장 --%>
      <div class="row">
        <label for="petId">Pet ID</label>
        <input type="number" id="petId" name="petId" value="<%= request.getParameter("petId") != null ? request.getParameter("petId") : "1" %>" required>
      </div>
      <div class="row">
        <%-- 어떤 약을 투약했는지 입력 --%>
        <label for="medicine">약품명</label>
        <input type="text" id="medicine" name="medicine" placeholder="예: 가상영양제 100mg" required maxlength="100">
      </div>
      <div class="row">
        <%-- 투약한 날짜/시간(로컬 시간). 서버에서는 문자열을 LocalDateTime으로 파싱합니다. --%>
        <label for="dosageTime">투약시각</label>
        <input type="datetime-local" id="dosageTime" name="dosageTime" required>
      </div>
      <button type="submit">등록</button>
      <a href="medilist.jsp?petId=<%= request.getParameter("petId") != null ? request.getParameter("petId") : "1" %>">목록으로</a>
    </form>
  </div>
</body>
</html>
