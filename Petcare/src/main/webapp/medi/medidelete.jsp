<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pet.dao.MediRecordDAO" %>
<%--
  medidelete.jsp
  - 목적: 투약기록 1건을 삭제하고 결과 메시지와 함께 목록으로 돌아갑니다.
  - 흐름: recordId/petId 파라미터 읽기 -> DAO.delete 호출 -> 결과 메시지 구성 -> 리다이렉트
--%>
<%
    String recordIdStr = request.getParameter("recordId");
    String petIdStr = request.getParameter("petId");
    String redirect = "../index.jsp";
    String msg;
    try {
    // 파라미터 형 변환
        int recordId = Integer.parseInt(recordIdStr);
        int petId = Integer.parseInt(petIdStr);
        MediRecordDAO dao = new MediRecordDAO();
        int r = dao.delete(recordId);
        msg = (r > 0) ? "삭제되었습니다." : "삭제 실패(대상 없음).";
        redirect = "medilist.jsp?petId=" + petId;
    } catch (Exception e) {
        msg = "삭제 중 오류: " + e.getMessage();
        if (petIdStr != null) redirect = "medilist.jsp?petId=" + petIdStr;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>삭제 결과</title>
  <meta http-equiv="refresh" content="1; url=<%=redirect%>">
</head>
<body>
  <p><%= msg %></p>
  <p><a href="<%= redirect %>">이동</a></p>
</body>
</html>