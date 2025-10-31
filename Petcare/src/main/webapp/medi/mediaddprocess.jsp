<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.pet.dao.MediRecordDAO,com.pet.dto.MediRecordDTO" %>
<%@ page import="java.time.LocalDateTime,java.time.format.DateTimeParseException,java.sql.Timestamp,java.util.Date" %>
<%--
    mediaddprocess.jsp
    - 목적: 투약기록 등록 폼(mediadd.jsp)의 제출을 처리하는 서버측 로직
    - 흐름: 파라미터 읽기 -> 유효성 검사 -> DTO 생성 -> DAO 호출 -> 메시지/리다이렉션 결정
    - 예외: NumberFormatException, DateTimeParseException 등 상황별로 사용자 메시지 분기
--%>
<%
    request.setCharacterEncoding("UTF-8");
    String petIdStr = request.getParameter("petId");
    String medicine = request.getParameter("medicine");
    String dosageTimeStr = request.getParameter("dosageTime"); // 'yyyy-MM-dd\'T\'HH:mm' 형식

    String msg;
    String redirect;

    try {
        // 1) 필수값 검증 및 형 변환
        int petId = Integer.parseInt(petIdStr);
        if (medicine == null || medicine.trim().isEmpty()) throw new IllegalArgumentException("약품명을 입력하세요.");
        // 2) datetime-local(예: 2025-10-31T09:30) 문자열을 LocalDateTime으로 파싱
        LocalDateTime ldt = LocalDateTime.parse(dosageTimeStr);
        Date utilDate = new Date(Timestamp.valueOf(ldt).getTime());

        // 3) DTO에 데이터 담기
        MediRecordDTO dto = new MediRecordDTO();
        dto.setMedicine(medicine.trim());
        dto.setDosageTime(utilDate);

        // 4) DAO 호출로 DB에 등록
        MediRecordDAO dao = new MediRecordDAO();
        int r = dao.insert(dto, petId);
        if (r > 0) {
            msg = "등록되었습니다.";
            redirect = "medilist.jsp?petId=" + petId;
        } else {
            msg = "등록 실패(변경 없음).";
            redirect = "mediadd.jsp?petId=" + petId;
        }
    } catch (NumberFormatException e) {
        msg = "Pet ID 형식이 올바르지 않습니다.";
        redirect = "index.jsp";
    } catch (DateTimeParseException e) {
        msg = "투약시각 형식이 올바르지 않습니다.";
        redirect = "mediadd.jsp?petId=" + (petIdStr != null ? petIdStr : "1");
    } catch (Exception e) {
        msg = "처리 중 오류: " + e.getMessage();
        redirect = "mediadd.jsp?petId=" + (petIdStr != null ? petIdStr : "1");
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>등록 결과</title>
  <meta http-equiv="refresh" content="1; url=<%=redirect%>">
</head>
<body>
  <p><%= msg %></p>
  <p><a href="<%= redirect %>">이동</a></p>
</body>
</html>
