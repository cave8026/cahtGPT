package com.pet.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.pet.dto.PetDTO;
import common.DBConnPool;

/**
 * 반려동물(PET) 테이블을 조회하는 DAO입니다.
 * - 현재 예제에서는 소유자(owner_id) 기준으로 목록을 가져옵니다.
 */
public class PetDAO extends DBConnPool {
    public PetDAO() { super(); }

    /**
     * 소유자(ownerId)가 등록한 반려동물 목록을 조회합니다.
     * @param ownerId 소유자 ID
     * @return 등록된 반려동물 목록 (없으면 빈 리스트)
     */
    public List<PetDTO> getPetsByOwner(int ownerId) {
        List<PetDTO> list = new ArrayList<>();
        String sql = "SELECT pet_id, owner_id, pet_name, breed_code, sex, birth_date, weight_kg FROM PET WHERE owner_id=? ORDER BY pet_id";
        try {
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, ownerId);
            rs = psmt.executeQuery();
            while(rs.next()) {
                PetDTO pet = new PetDTO();
                pet.setPetId(rs.getInt("pet_id"));
                pet.setOwnerId(rs.getInt("owner_id"));
                pet.setPetName(rs.getString("pet_name"));
                pet.setBreedCode(rs.getString("breed_code"));
                pet.setSex(rs.getString("sex"));
                try { pet.setBirthDate(rs.getString("birth_date")); } catch(Exception ignore){}
                pet.setWeightKg(rs.getDouble("weight_kg"));
                list.add(pet);
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally { close(); }
        return list;
    }
}
