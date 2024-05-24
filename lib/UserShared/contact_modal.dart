
class ContactModel {
  int? id;
  String? APPLYING_FOR;
  String? PATIENT_NAME;
  String? CARD_NO;
  String? HOSPITAL_TYPE;
  String? DOCTOR_NAME;
  String? TREATMENT_STATUS;
  String? CONSULT_DATE;
  String? CASH_MEMO_NO;
  String? CASH_MEMO_DATE;
  String? CLAIMED_CONSULTATION_CHARGE;
  String? APPROVED_CONSULTATION_CHARGE;
  String? CLAIMED_INJECT_CHARGE;
  String? APPROVED_INJECT_CHARGE;
  String? CLAIMED_MEDI_COST;
  String? APPROVED_MEDI_COST;
  String? CLAIMED_PATH_CHARGE;
  String? APPROVED_PATH_CHARGE;
  String? GL;
  ContactModel(
      {
        this.id,
        this.APPLYING_FOR,
        this.PATIENT_NAME,
        this.CARD_NO,
        this.HOSPITAL_TYPE,
        this.DOCTOR_NAME,
        this.TREATMENT_STATUS,
        this.CONSULT_DATE,
        this.CASH_MEMO_NO,
        this.CASH_MEMO_DATE,
        this.CLAIMED_CONSULTATION_CHARGE,
        this.APPROVED_CONSULTATION_CHARGE,
        this.CLAIMED_INJECT_CHARGE,
        this.APPROVED_INJECT_CHARGE,
        this.CLAIMED_MEDI_COST,
        this.APPROVED_MEDI_COST,
        this.CLAIMED_PATH_CHARGE,
        this.APPROVED_PATH_CHARGE,
        this.GL
      }
      );
}