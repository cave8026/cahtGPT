package com.pet.dao;

import common.DBConnPool;
import com.pet.dto.MediRecordDTO;
import java.sql.*;
import java.util.*;

/**
 * 투약기록(MEDI_RECORD) 테이블에 접근하는 DAO 클래스입니다.
 * - Connection, PreparedStatement, ResultSet은 상위 DBConnPool에서 제공
 * - 각 메서드는 작업 후 finally 블록에서 close()를 호출하여 리소스 정리
 */
public class MediRecordDAO extends DBConnPool {

    public MediRecordDAO() { super(); }

    /**
     * 특정 반려동물(petId)의 투약기록 목록을 최신 순으로 조회합니다.
     * @param petId 조회할 반려동물 ID
     * @return 투약기록 리스트 (없으면 빈 리스트)
     */
    public List<MediRecordDTO> list(int petId) {
        List<MediRecordDTO> list = new ArrayList<>();
        String sql = "SELECT record_id, medicine, dosage_time FROM MEDI_RECORD WHERE pet_id = ? ORDER BY record_id DESC";
        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, petId);
            rs = psmt.executeQuery();
            while(rs.next()) {
                MediRecordDTO dto = new MediRecordDTO();
                dto.setRecordId(rs.getInt("record_id"));
                dto.setMedicine(rs.getString("medicine"));
                dto.setDosageTime(rs.getTimestamp("dosage_time"));
                list.add(dto);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally { close(); }
        return list;
    }

    /**
     * 투약기록을 1건 등록합니다.
     * @param dto 등록할 데이터(약품명, 투약시각)
     * @param petId 대상 반려동물 ID
     * @return 영향 받은 행 수 (성공 시 1)
     */
    public int insert(MediRecordDTO dto, int petId) {
        int result = 0;
        String sql = "INSERT INTO MEDI_RECORD (pet_id, medicine, dosage_time) VALUES (?, ?, ?)";
        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, petId);
            psmt.setString(2, dto.getMedicine());
            psmt.setTimestamp(3, new Timestamp(dto.getDosageTime().getTime()));
            result = psmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally { close(); }
        return result;
    }

    /**
     * 투약기록을 1건 삭제합니다.
     * @param recordId 삭제 대상 기록 ID
     * @return 영향 받은 행 수 (성공 시 1)
     */
    public int delete(int recordId) {
        int result = 0;
        String sql = "DELETE FROM MEDI_RECORD WHERE record_id = ?";
        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, recordId);
            result = psmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally { close(); }
        return result;
    }

    /**
     * 투약기록을 수정합니다.
     * @param dto 수정할 데이터(레코드ID, 약품명, 투약시각)
     * @return 영향 받은 행 수 (성공 시 1)
     */
    public int update(MediRecordDTO dto) {
        int result = 0;
        String sql = "UPDATE MEDI_RECORD SET medicine = ?, dosage_time = ? WHERE record_id = ?";
        try {
            psmt = con.prepareStatement(sql);
            psmt.setString(1, dto.getMedicine());
            psmt.setTimestamp(2, new Timestamp(dto.getDosageTime().getTime()));
            psmt.setInt(3, dto.getRecordId());
            result = psmt.executeUpdate();
        } catch(Exception e) {
            e.printStackTrace();
        } finally { close(); }
        return result;
    }
}
