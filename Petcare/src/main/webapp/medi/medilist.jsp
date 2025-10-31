<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.pet.dao.MediRecordDAO,com.pet.dto.MediRecordDTO,com.pet.dao.PetDAO,com.pet.dto.PetDTO" %>
<%--
  medilist.jsp
  - 목적: 특정 반려동물(petId)의 투약기록을 테이블로 보여줍니다.
  - 흐름: petId 파라미터 읽기 -> DAO.list 호출 -> 목록 출력
  - 추가: 각 행에서 삭제 링크를 제공(간단한 예제)
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>투약기록 목록</title>
  <style>
    body { font-family: system-ui, sans-serif; padding: 24px; }
    table { border-collapse: collapse; min-width: 640px; }
    th, td { border: 1px solid #e5e7eb; padding: 8px 10px; text-align: left; }
    th { background:#f8fafc; }
    .actions a { margin-right:8px; }
  </style>
</head>
<body>
  <h1>투약기록 목록</h1>
<%
  // 파라미터에서 petId를 읽고, 숫자 변환 실패 시 기본값 1을 사용
    String petIdStr = request.getParameter("petId");
    int petId = 1; // 기본값
    try { petId = Integer.parseInt(petIdStr); } catch(Exception ignore) {}
  // DB에서 목록 조회
    MediRecordDAO dao = new MediRecordDAO();
    List<MediRecordDTO> list = dao.list(petId);
  // 반려동물 이름 조회 (petId에 해당하는 반려동물 정보)
    PetDAO petDao = new PetDAO();
    PetDTO pet = petDao.getPetById(petId);
    String petName = (pet != null && pet.getPetName() != null) ? pet.getPetName() : "알 수 없음";
%>
  <p>강아지 이름: <strong><%= petName %></strong> | <a href="mediadd.jsp?petId=<%=petId%>">새 기록 추가</a> | <a href="index.jsp">홈</a></p>
  <table>
    <thead>
      <tr><th>Record ID</th><th>약품명</th><th>투약시각</th><th>작업</th></tr>
    </thead>
    <tbody>
      <%
        if (list == null || list.isEmpty()) {
      %>
        <tr><td colspan="4">등록된 투약기록이 없습니다.</td></tr>
      <%
        } else {
          for (MediRecordDTO m : list) {
      %>
        <tr>
          <td><%= m.getRecordId() %></td>
          <td><%= m.getMedicine() %></td>
          <td><%= m.getDosageTime() %></td>
          <td class="actions">
            <%-- 간단히 삭제만 제공. 실전에서는 수정/상세 등 버튼을 추가하고 CSRF 대비가 필요합니다. --%>
            <a href="medidelete.jsp?recordId=<%=m.getRecordId()%>&petId=<%=petId%>" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
          </td>
        </tr>
      <%
          }
        }
      %>
    </tbody>
  </table>
</body>
</html>