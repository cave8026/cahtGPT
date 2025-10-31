package com.pet.dto;

import java.util.Date;

/**
 * 투약기록 데이터 전송 객체(VO/DTO).
 * - 컨트롤러 <-> DAO 사이에서 데이터를 옮길 때 사용합니다.
 */
public class MediRecordDTO {
    /** DB PK */
    private int recordId;
    /** 약품명 */
    private String medicine;
    /** 투약 시각 (java.util.Date 사용) */
    private Date dosageTime;

    public int getRecordId() { return recordId; }
    public void setRecordId(int recordId) { this.recordId = recordId; }

    public String getMedicine() { return medicine; }
    public void setMedicine(String medicine) { this.medicine = medicine; }

    public Date getDosageTime() { return dosageTime; }
    public void setDosageTime(Date dosageTime) { this.dosageTime = dosageTime; }
}
