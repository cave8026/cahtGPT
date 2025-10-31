<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  petobesitycheck.jsp
  - 목적: 간단한 설문 5문항으로 강아지 비만도 점수를 계산해 안내합니다.
  - 점수 규칙: 불리한 답변마다 2점씩 가산하여 총 0~10점, 점수 구간별 BCS 라벨 매핑
  - 수업 포인트: DOM 조작, 기본 이벤트 처리, 간단한 조건 분기
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>강아지 비만도 간단 체크표</title>
<style>
  body { font-family: Arial, Helvetica, sans-serif; max-width: 720px; margin: 20px; }
  .q { margin: 12px 0; }
  button { margin-top: 12px; padding: 8px 12px; cursor: pointer; }
  .result { margin-top: 16px; padding: 12px; border-radius: 6px; background: #f7f7f7; border: 1px solid #ddd; }
  
</style>
</head>
<body>
  <h2>강아지 비만도 간단 체크 (Yes / No)</h2>
  <div>
    <div class="q">
      <label>1) 갈비뼈가 쉽게 만져지나요?</label>
      <select id="q1">
        <option value="yes">Yes</option>
        <option value="no">No</option>
      </select>
    </div>
    <div class="q">
      <label>2) 위에서 봤을 때 허리 라인이 분명하게 있나요?</label>
      <select id="q2">
        <option value="yes">Yes</option>
        <option value="no">No</option>
      </select>
    </div>
    <div class="q">
      <label>3) 옆에서 봤을 때 복부가 안으로 들어가 있나요?</label>
      <select id="q3">
        <option value="yes">Yes</option>
        <option value="no">No</option>
      </select>
    </div>
    <div class="q">
      <label>4) 꼬리 밑(엉치)이나 허리 주변에 지방이 두껍게 잡히나요?</label>
      <select id="q4">
        <option value="no">No</option>
        <option value="yes">Yes</option>
      </select>
    </div>
    <div class="q">
      <label>5) 걸을 때 배가 늘어지거나 흔들리나요?</label>
      <select id="q5">
        <option value="no">No</option>
        <option value="yes">Yes</option>
      </select>
    </div>

    <button id="btn">결과 보기</button>

    <div id="out" class="result" style="display:none;"></div>
  </div>

<script>
document.getElementById('btn').addEventListener('click', calcBCS);

function calcBCS() {
  const q1 = document.getElementById('q1').value;
  const q2 = document.getElementById('q2').value;
  const q3 = document.getElementById('q3').value;
  const q4 = document.getElementById('q4').value;
  const q5 = document.getElementById('q5').value;

  let pts = 0;
  if (q1 === 'no') pts += 2;  // 갈비뼈 안 만져짐 -> 비만 신호
  if (q2 === 'no') pts += 2;  // 허리 라인 없음 -> 비만 신호
  if (q3 === 'no') pts += 2;  // 복부가 들어가 있지 않음 -> 비만 신호
  if (q4 === 'yes') pts += 2; // 지방이 두껍다 -> 비만 신호
  if (q5 === 'yes') pts += 2; // 배가 늘어짐 -> 비만 신호

  let bcsLabel = '';
  if (pts === 0) bcsLabel = 'BCS 2–3 (매우 마름 ~ 약간 마름)';
  else if (pts === 2) bcsLabel = 'BCS 3–4 (약간 마름 ~ 정상 근처)';
  else if (pts === 4) bcsLabel = 'BCS 4–5 (정상 ~ 약간 여유 지방)';
  else if (pts === 6) bcsLabel = 'BCS 6 (약간 과체중)';
  else if (pts === 8) bcsLabel = 'BCS 7 (과체중 / 비만 가능성)';
  else if (pts === 10) bcsLabel = 'BCS 8–9 (고도 비만 ~ 극심 비만 — 수의사 상담 권장)';
  else bcsLabel = '결과 해석 불가 (예상치 못한 점수)';

  const out = document.getElementById('out');
  out.style.display = 'block';
  out.innerHTML = '<strong>총 비만점수: ' + pts + ' / 10</strong><br>' +
                  '<strong>추정 BCS:</strong> ' + bcsLabel +
                  '<p style="margin-top:8px;color:#555">※ 이 결과는 간단 선별용입니다. 정확한 평가는 수의사 진찰이 필요합니다.</p>';
}
</script>
</body>
</html>
