package com.pet.dto;

/**
 * 반려동물 정보 DTO.
 * - 화면/컨트롤러/DAO 사이에서 데이터를 담아 전달할 때 사용합니다.
 */
public class PetDTO {
    /** 반려동물 ID (PK) */
    private int petId;
    /** 소유자 ID (FK) */
    private int ownerId;
    /** 품종 코드 (예: DOG_MALTese 등) */
    private String breedCode;
    /** 반려동물 이름 */
    private String petName;
    /** 성별 (예: M/F) */
    private String sex;
    /** 생일 (간단히 문자열로 보관하는 예제) */
    private String birthDate;
    /** 몸무게(kg) */
    private double weightKg;

    public int getPetId() { return petId; }
    public void setPetId(int petId) { this.petId = petId; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public String getBreedCode() { return breedCode; }
    public void setBreedCode(String breedCode) { this.breedCode = breedCode; }

    public String getPetName() { return petName; }
    public void setPetName(String petName) { this.petName = petName; }

    public String getSex() { return sex; }
    public void setSex(String sex) { this.sex = sex; }

    public String getBirthDate() { return birthDate; }
    public void setBirthDate(String birthDate) { this.birthDate = birthDate; }

    public double getWeightKg() { return weightKg; }
    public void setWeightKg(double weightKg) { this.weightKg = weightKg; }
}
