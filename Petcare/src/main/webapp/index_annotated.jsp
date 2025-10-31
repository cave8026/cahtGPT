<%@ page import="com.pet.dao.PetDAO, com.pet.dto.PetDTO, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>반려동물 투약정보 & 비만도 체크 (주석 추가 버전)</title>
  <style>
    /* 기본 레이아웃과 간단한 스타일: 수업용으로 보기 쉬운 최소 스타일만 적용 */
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

  <!-- 투약정보 섹션: DB에서 반려동물 목록을 불러와 투약 기록을 조회하거나 새 기록을 추가할 수 있도록 구성 -->
  <div class="card">
    <h2>💊 투약기록 관리</h2>
    <%--
      아래 부분은 서버에서 실행되는 JSP 스크립틀릿입니다.
      PetDAO 객체를 생성하고 테스트용으로 owner_id = 1인 반려동물 목록을 가져옵니다.
      실제 시스템에서는 로그인한 사용자의 세션에서 owner_id를 가져와 사용해야 합니다.
    --%>
    <%
        PetDAO dao = new PetDAO();
        List<PetDTO> pets = dao.getPetsByOwner(1); // 테스트용 owner_id = 1 (통합 시 세션에서 가져오세요)
    %>

    <!-- 반려동물을 선택하면 medilist.jsp로 GET 요청을 보내 해당 반려동물의 투약기록을 보여줌 -->
    <form action="medilist.jsp" method="get">
      <div class="row">
        <label for="petId">반려동물 선택: </label>
        <select id="petId" name="petId" required>
          <%-- 서버에서 가져온 pets 리스트로 옵션을 동적으로 생성합니다. 등록된 동물이 없으면 안내문을 보여줍니다. --%>
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
        <!-- 등록된 반려동물이 없으면 버튼을 비활성화하여 클릭을 막습니다 -->
        <button type="submit" <%= (pets==null || pets.isEmpty()) ? "disabled" : "" %>>투약기록 보기</button>
      </div>
    </form>

    <hr>
    <p>새 기록 추가:
      <!--
        새 기록 추가 링크. 드롭다운에서 선택한 반려동물에 맞춰 링크의 쿼리 스트링(petId)이 변경됩니다.
        초기값은 pets 리스트의 첫 번째 항목을 사용하거나 기본값 1을 사용합니다. (테스트용)
      -->
      <a id="addLink" href="mediadd.jsp?petId=<%= (pets != null && !pets.isEmpty()) ? pets.get(0).getPetId() : 1 %>">
        mediadd.jsp
      </a>
    </p>
  </div>

  <!-- 비만도 체크 섹션: 사용자가 라디오 버튼으로 간단 질문에 답하면 점수 계산 후 판정 표시 -->
  <div class="card">
    <h2>⚖️ 강아지 비만도 간단 체크</h2>

    <!-- 각 질문은 Yes/No 라디오로 되어 있으며, 스크립트에서 값을 읽어 점수로 환산합니다. -->
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
    // 드롭다운에서 선택한 반려동물에 따라 '새 기록 추가' 링크의 쿼리스트링(petId)을 실시간으로 변경해 주는 코드
    const select = document.getElementById('petId');
    const link = document.getElementById('addLink');
    if (select && link) {
      select.addEventListener('change', () => {
        // 선택이 바뀌면 링크의 href를 mediadd.jsp?petId=선택값 으로 변경
        link.href = 'mediadd.jsp?petId=' + select.value;
      });
    }

    // 라디오 버튼에서 선택된 값을 쉽게 가져오는 헬퍼 함수
    // name: 라디오 그룹 이름
    // 반환값: 선택된 라디오의 value 또는 선택 안 된 경우 빈 문자열
    function val(name){
      const el = document.querySelector('input[name="'+name+'"]:checked');
      return el ? el.value : '';
    }

    // 결과 버튼 클릭 시 점수를 계산하고 결과를 화면에 표시
    document.getElementById('btn').addEventListener('click', function(){
      // 각 질문의 값(yes/no)을 읽음
      const q1 = val('q1'), q2 = val('q2'), q3 = val('q3'), q4 = val('q4'), q5 = val('q5');

      // 점수 계산 규칙 (수업용 간단 규칙): 특정 답변에 2점씩 부여하여 총 0~10 점으로 환산
      // q1,q2,q3 는 'no' 이면 (갈비가 만져지지 않음 등) 과체중 가능성을 의미하므로 2점 추가
      // q4,q5 는 'yes' 이면 지방이 많거나 걸음걸이가 늘어지는 등 과체중 가능성을 의미하므로 2점 추가
      let pts = 0;
      if (q1 === 'no') pts += 2;
      if (q2 === 'no') pts += 2;
      if (q3 === 'no') pts += 2;
      if (q4 === 'yes') pts += 2;
      if (q5 === 'yes') pts += 2;

      // 점수 범위에 따라 간단한 BCS(체형 점수) 라벨을 결정
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
      // JSP EL 충돌을 피하기 위해 문자열 연결 방식으로 결과 HTML을 만듭니다.
      out.innerHTML =
        '<strong>총 점수: ' + pts + ' / 10</strong><br>' +
        '<strong>판정:</strong> ' + bcsLabel +
        '<p style="margin-top:8px;color:#555;">※ 이 결과는 간단 선별용입니다. 정확한 평가는 수의사 상담이 필요합니다.</p>';
    });
  </script>
</body>
</html>