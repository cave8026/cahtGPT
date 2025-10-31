<%@ page import="com.pet.dao.PetDAO, com.pet.dto.PetDTO, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
  index.jsp
  - 목적: 반려동물 선택 후 투약기록 보기/추가, 비만도 간단 체크 제공
  - 포인트: JSP에서 DAO를 직접 사용하는 예제(실전에서는 MVC로 분리 권장)
  - 주의: 학습용 예제이며, 로그인/권한/예외 처리 등은 최소화되어 있습니다.
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>반려동물 투약정보 & 비만도 체크</title>
  <style>
    body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; padding: 24px; line-height:1.5; }
    h1 { margin-bottom: 14px; }
    h2 { margin: 0 0 12px; font-size: 18px; }
    label, button, a { font-size: 16px; }
    .row { margin-bottom: 12px; }
    .card { padding:16px; border:1px solid #e5e7eb; border-radius:12px; max-width:720px; margin-bottom: 24px; }
    .result { margin-top: 16px; padding: 12px; border-radius: 6px; background: #f7f7f7; border: 1px solid #ddd; }
    .radios { display: inline-flex; gap: 14px; margin-left: 6px; vertical-align: middle; }
    .radios label { display: inline-flex; align-items: center; gap: 6px; cursor: pointer; }
    button { padding: 8px 12px; cursor: pointer; }
  </style>
</head>
<body>
  <h1>🐾 반려동물 투약정보 & 비만도 간단 체크</h1>

  <!-- 💊 투약정보 섹션 -->
  <div class="card">
    <h2>💊 투약기록 관리</h2>
    <%
        PetDAO dao = new PetDAO();
        List<PetDTO> pets = dao.getPetsByOwner(1); // 테스트용 owner_id = 1 (통합 시 세션에서 가져오세요)
    %>
    <form action="medilist.jsp" method="get">
      <div class="row">
        <label for="petId">반려동물 선택: </label>
        <select id="petId" name="petId" required>
          <%
            if (pets != null && !pets.isEmpty()) {
              for (PetDTO pet : pets) {
          %>
                <option value="<%=pet.getPetId()%>"><%=pet.getPetName()%></option>
          <%
              }
            } else {
          %>
              <option disabled>등록된 반려동물이 없습니다.</option>
          <%
            }
          %>
        </select>
      </div>
      <div class="row">
        <button type="submit" <%= (pets==null || pets.isEmpty()) ? "disabled" : "" %>>투약기록 보기</button>
      </div>
    </form>
    <hr>
    <p>새 기록 추가:
      <a id="addLink" href="mediadd.jsp?petId=<%= (pets != null && !pets.isEmpty()) ? pets.get(0).getPetId() : 1 %>">
        mediadd.jsp
      </a>
    </p>
  </div>

  <!-- ⚖️ 비만도 체크 섹션 (라디오 전면 전환) -->
  <div class="card">
    <h2>⚖️ 강아지 비만도 간단 체크</h2>

    <div class="row">
      <label>1) 갈비뼈가 쉽게 만져지나요?</label>
      <span class="radios">
        <label><input type="radio" name="q1" value="yes" checked>Yes</label>
        <label><input type="radio" name="q1" value="no">No</label>
      </span>
    </div>

    <div class="row">
      <label>2) 위에서 봤을 때 허리 라인이 분명하게 있나요?</label>
      <span class="radios">
        <label><input type="radio" name="q2" value="yes" checked>Yes</label>
        <label><input type="radio" name="q2" value="no">No</label>
      </span>
    </div>

    <div class="row">
      <label>3) 옆에서 봤을 때 복부가 안으로 들어가 있나요?</label>
      <span class="radios">
        <label><input type="radio" name="q3" value="yes" checked>Yes</label>
        <label><input type="radio" name="q3" value="no">No</label>
      </span>
    </div>

    <div class="row">
      <label>4) 꼬리 밑(엉치)이나 허리 주변에 지방이 두껍게 잡히나요?</label>
      <span class="radios">
        <label><input type="radio" name="q4" value="no" checked>No</label>
        <label><input type="radio" name="q4" value="yes">Yes</label>
      </span>
    </div>

    <div class="row">
      <label>5) 걸을 때 배가 늘어지거나 흔들리나요?</label>
      <span class="radios">
        <label><input type="radio" name="q5" value="no" checked>No</label>
        <label><input type="radio" name="q5" value="yes">Yes</label>
      </span>
    </div>

    <button id="btn">결과 보기</button>
    <div id="out" class="result" style="display:none;"></div>
  </div>

  <script>
    // 새 기록 추가 링크를 드롭다운 선택에 맞춰 동기화
    const select = document.getElementById('petId');
    const link = document.getElementById('addLink');
    if (select && link) {
      select.addEventListener('change', () => {
        link.href = 'mediadd.jsp?petId=' + select.value;
      });
    }

    // 라디오 값 읽기 헬퍼
    function val(name){
    const el = document.querySelector('input[name="'+name+'"]:checked');
    return el ? el.value : '';
  }

  document.getElementById('btn').addEventListener('click', function(){
    const q1 = val('q1'), q2 = val('q2'), q3 = val('q3'), q4 = val('q4'), q5 = val('q5');

    let pts = 0;
    if (q1 === 'no') pts += 2;
    if (q2 === 'no') pts += 2;
    if (q3 === 'no') pts += 2;
    if (q4 === 'yes') pts += 2;
    if (q5 === 'yes') pts += 2;

    let bcsLabel = '';
    if (pts === 0) bcsLabel = 'BCS 2–3 (매우 마름 ~ 약간 마름)';
    else if (pts === 2) bcsLabel = 'BCS 3–4 (약간 마름 ~ 정상 근처)';
    else if (pts === 4) bcsLabel = 'BCS 4–5 (정상 ~ 약간 여유 지방)';
    else if (pts === 6) bcsLabel = 'BCS 6 (약간 과체중)';
    else if (pts === 8) bcsLabel = 'BCS 7 (과체중 / 비만 가능성)';
    else if (pts === 10) bcsLabel = 'BCS 8–9 (고도 비만 ~ 극심 비만 — 수의사 상담 권장)';
    else bcsLabel = '결과 해석 불가';

    const out = document.getElementById('out');
    out.style.display = 'block';
    // ▼ JSP EL 충돌 피하려고 문자열 연결 방식으로 출력
    out.innerHTML =
      '<strong>총 점수: ' + pts + ' / 10</strong><br>' +
      '<strong>판정:</strong> ' + bcsLabel +
      '<p style="margin-top:8px;color:#555;">※ 이 결과는 간단 선별용입니다. 정확한 평가는 수의사 상담이 필요합니다.</p>';
  });
  </script>
</body>
</html>
