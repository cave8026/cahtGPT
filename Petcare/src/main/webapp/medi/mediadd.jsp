<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pet.dao.PetDAO, com.pet.dto.PetDTO" %>
<%
  // petId 파라미터 안전 파싱
  String petIdParam = request.getParameter("petId");
  int petId = 1;
  try {
    if (petIdParam != null) petId = Integer.parseInt(petIdParam);
  } catch (NumberFormatException ignore) {
    petId = 1;
  }

  // DB 조회
  PetDAO dao = new PetDAO();
  PetDTO pet = dao.getPetById(petId);
  String petName = (pet != null && pet.getPetName() != null && !pet.getPetName().isEmpty())
      ? pet.getPetName()
      : "알 수 없음";
%>
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
    .muted { color:#6b7280; }
  </style>
</head>
<body>
  <h1>투약기록 등록</h1>
  <div class="card">
    <form action="mediaddprocess.jsp" method="post">
      <!-- 실제로 전송될 petId는 숨김 처리 -->
      <input type="hidden" id="petId" name="petId" value="<%= petId %>">

      <div class="row">
        <label>반려동물</label>
        <span><strong><%= petName %></strong></span>
        <% if (pet == null) { %>
          <span class="muted">(petId=<%= petId %> 조회 실패)</span>
        <% } %>
      </div>

      <div class="row">
        <!-- 어떤 약을 투약했는지 입력 -->
        <label for="medicine">약품명</label>
        <input type="text" id="medicine" name="medicine" placeholder="예: 가상영양제 100mg" required maxlength="100">
      </div>

      <div class="row">
        <!-- 투약한 날짜/시간(로컬 시간). 서버에서는 문자열을 LocalDateTime으로 파싱합니다. -->
        <label for="dosageTime">투약시각</label>
        <input type="datetime-local" id="dosageTime" name="dosageTime" required>
      </div>

      <button type="submit">등록</button>
      <a href="medilist.jsp?petId=<%= petId %>">목록으로</a>
    </form>
  </div>
</body>
</html>
