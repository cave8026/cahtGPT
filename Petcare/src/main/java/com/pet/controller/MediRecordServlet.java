package com.pet.controller;

/**
 * 반려동물 투약기록 관련 요청을 처리하는 서블릿입니다.
 * - URL 패턴 예: /medi/* (프로젝트의 매핑 설정에 따라 달라질 수 있음)
 * - 주요 기능: 목록 조회, 등록 화면, 수정 화면, 등록/수정/삭제 처리
 *
 * 수업/학습 포인트
 * 1) doGet/doPost 내에서 path 혹은 파라미터로 분기 처리
 * 2) DAO를 통해 DB에 접근하고 DTO로 데이터 전달
 * 3) forward(화면 이동)와 redirect(요청 재전송)의 차이
 */

import com.pet.dao.MediRecordDAO;
import com.pet.dao.PetDAO;
import com.pet.dto.MediRecordDTO;
import com.pet.dto.PetDTO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.util.*;

public class MediRecordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // /medi 뒤에 오는 추가 경로 (예: /list, /add, /edit)
        String path = req.getPathInfo(); // /list, /add, /edit
        if (path == null || "/".equals(path) || path.startsWith("/list")) {
            // 기본은 목록 화면
            list(req, resp);
        } else if (path.startsWith("/add")) {
            // 등록 화면
            showAdd(req, resp);
        } else if (path.startsWith("/edit")) {
            // 수정 화면 (간단한 폼 데이터만 세팅)
            showEdit(req, resp);
        } else {
            // 정의되지 않은 경로
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // HTML 폼에서 _method=PUT/DELETE를 사용하면 REST 흉내내기 가능
        String method = req.getParameter("_method");
        if ("PUT".equalsIgnoreCase(method)) {
            update(req, resp);
            return;
        } else if ("DELETE".equalsIgnoreCase(method)) {
            delete(req, resp);
            return;
        }
        // default: create
        create(req, resp);
    }

    private void list(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 특정 반려동물의 투약기록 목록을 보여줍니다.
        // petId가 없으면(=0) 먼저 반려동물을 선택하는 화면으로 이동합니다.
        int petId = parseInt(req.getParameter("petId"), 0);
        if (petId == 0) {
            // 선택 드롭다운을 위해 소유자별 반려동물 목록 제공
            // NOTE: ownerId는 실제 서비스에서는 로그인 세션에서 가져오도록 리팩터링 필요
            int ownerId = parseInt(req.getParameter("ownerId"), 1);
            PetDAO pdao = new PetDAO();
            List<PetDTO> pets = pdao.getPetsByOwner(ownerId);
            req.setAttribute("pets", pets);
            RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/views/medi/select_pet.jsp");
            rd.forward(req, resp);
            return;
        }

        MediRecordDAO dao = new MediRecordDAO();
        List<MediRecordDTO> list = dao.list(petId);
        req.setAttribute("petId", petId);
        req.setAttribute("list", list);
        RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/views/medi/list.jsp");
        rd.forward(req, resp);
    }

    private void showAdd(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 등록 화면으로 이동. 화면에서 petId를 hidden 또는 queryString으로 유지합니다.
        int petId = parseInt(req.getParameter("petId"), 0);
        req.setAttribute("petId", petId);
        RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/views/medi/add.jsp");
        rd.forward(req, resp);
    }

    private void showEdit(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 간단한 수정 화면. 실제로는 DB에서 상세를 조회하여 채우는 것이 일반적입니다.
        int recordId = parseInt(req.getParameter("recordId"), 0);
        int petId = parseInt(req.getParameter("petId"), 0);
        String medicine = nvl(req.getParameter("medicine"));
        String dosage = nvl(req.getParameter("dosage")); // "yyyy-MM-dd HH:mm:ss"
        if (!dosage.isEmpty()) dosage = dosage.replace(' ', 'T'); // for datetime-local
        req.setAttribute("recordId", recordId);
        req.setAttribute("petId", petId);
        req.setAttribute("medicine", medicine);
        req.setAttribute("dosage", dosage);
        RequestDispatcher rd = req.getRequestDispatcher("/WEB-INF/views/medi/edit.jsp");
        rd.forward(req, resp);
    }

    private void create(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        // 투약기록 등록 처리
        int petId = parseInt(req.getParameter("petId"), 0);
        String medicine = nvl(req.getParameter("medicine"));
        String dosageTime = nvl(req.getParameter("dosageTime"));
        String msg;
        try {
            // input[type=datetime-local] 값(예: 2025-10-31T09:30)을 LocalDateTime으로 파싱
            LocalDateTime ldt = LocalDateTime.parse(dosageTime);
            Date utilDate = new Date(Timestamp.valueOf(ldt).getTime());
            MediRecordDTO dto = new MediRecordDTO();
            dto.setMedicine(medicine);
            dto.setDosageTime(utilDate);
            MediRecordDAO dao = new MediRecordDAO();
            int r = dao.insert(dto, petId);
            msg = (r>0) ? "등록되었습니다." : "등록 실패(변경 없음).";
        } catch (Exception e) {
            msg = "등록 오류: " + e.getMessage();
        }
        req.getSession().setAttribute("flash", msg);
        resp.sendRedirect(req.getContextPath() + "/medi/list?petId=" + petId);
    }

    private void update(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 투약기록 수정 처리
        int petId = parseInt(req.getParameter("petId"), 0);
        int recordId = parseInt(req.getParameter("recordId"), 0);
        String medicine = nvl(req.getParameter("medicine"));
        String dosageTime = nvl(req.getParameter("dosageTime"));
        String msg;
        try {
            LocalDateTime ldt = LocalDateTime.parse(dosageTime);
            Date utilDate = new Date(Timestamp.valueOf(ldt).getTime());
            MediRecordDTO dto = new MediRecordDTO();
            dto.setRecordId(recordId);
            dto.setMedicine(medicine);
            dto.setDosageTime(utilDate);
            MediRecordDAO dao = new MediRecordDAO();
            int r = dao.update(dto);
            msg = (r>0) ? "수정되었습니다." : "수정 실패(변경 없음).";
        } catch (Exception e) {
            msg = "수정 오류: " + e.getMessage();
        }
        req.getSession().setAttribute("flash", msg);
        resp.sendRedirect(req.getContextPath() + "/medi/list?petId=" + petId);
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 투약기록 삭제 처리
        int petId = parseInt(req.getParameter("petId"), 0);
        int recordId = parseInt(req.getParameter("recordId"), 0);
        String msg;
        try {
            MediRecordDAO dao = new MediRecordDAO();
            int r = dao.delete(recordId);
            msg = (r>0) ? "삭제되었습니다." : "삭제 실패(대상 없음).";
        } catch (Exception e) {
            msg = "삭제 오류: " + e.getMessage();
        }
        req.getSession().setAttribute("flash", msg);
        resp.sendRedirect(req.getContextPath() + "/medi/list?petId=" + petId);
    }

    private int parseInt(String s, int def) {
        // 숫자가 아니면 기본값 반환
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
    private String nvl(String s) { return s==null? "": s.trim(); }
}
