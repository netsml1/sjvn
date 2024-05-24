class RequestStatusList {
  String? INCIDENT_NO;
  String? EMP_NO;
  String? CARD_NO;
  String? HEADING;
  String? DESCRIPTION;
  String? HR_RMRK;
  String? STATUS;
  String? ATTACHMENT_BASE6;
  String? CREATED_ON;
  String? CREATED_AT;
  String? HR_DTL;
  String? CHNG_ON_HRDTL;
  String? FILE_TYPE;
  String? FILE_NM;
  RequestStatusList(
      {

        this.INCIDENT_NO,
        this. EMP_NO,
        this. CARD_NO,
        this. HEADING,
        this. DESCRIPTION,
        this. HR_RMRK,
        this. STATUS,
        this. ATTACHMENT_BASE6,
        this. CREATED_ON,
        this. CREATED_AT,
        this. HR_DTL,
        this. CHNG_ON_HRDTL,
        this. FILE_TYPE,
        this. FILE_NM,
      });


  RequestStatusList.fromJson(Map<String, dynamic> json) {
    INCIDENT_NO = json['INCIDENT_NO'];
    EMP_NO= json['EMP_NO'];
    CARD_NO = json['CARD_NO'];
    HEADING = json['HEADING'];
    DESCRIPTION = json['DESCRIPTION'];
    HR_RMRK= json['HR_RMRK'];
    STATUS = json['STATUS'];
    ATTACHMENT_BASE6 = json['ATTACHMENT_BASE6'];

    CREATED_ON = json['CREATED_ON'];
    CREATED_AT= json['CREATED_AT'];
    HR_DTL = json['HR_DTL'];
    CHNG_ON_HRDTL= json['CHNG_ON_HRDTL'];
    FILE_TYPE = json['FILE_TYPE'];
    FILE_NM= json['FILE_NM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['INCIDENT_NO'] = this.INCIDENT_NO;
    data['EMP_NO'] = this.EMP_NO;
    data['CARD_NO'] = this.CARD_NO;
    data['HEADING'] = this.HEADING;
    data['DESCRIPTION'] = this.DESCRIPTION;
    data['HR_RMRK'] = this.HR_RMRK;
    data['STATUS'] = this.STATUS;
    data['ATTACHMENT_BASE6'] = this.ATTACHMENT_BASE6;

    data['CREATED_ON'] = this.CREATED_ON;
    data['CREATED_AT'] = this.CREATED_AT;
    data['HR_DTL'] = this.HR_DTL;
    data['CHNG_ON_HRDTL'] = this.CHNG_ON_HRDTL;
    data['FILE_TYPE'] = this.FILE_TYPE;
    data['FILE_NM'] = this.FILE_NM;
    return data;
  }
}
