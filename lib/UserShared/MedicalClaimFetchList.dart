class MedicalClaimFetchList {
  String? requestID;
  String? status;
  String? type;
  String? appliedAmount;

  String? approvedAmount;
  String? reimburseAmount;
  String? pendingWith;
  String? pendingFrom;

  MedicalClaimFetchList(
      {
        this.requestID,
        this.status,
        this.type,
        this.appliedAmount,

        this.approvedAmount,
        this.reimburseAmount,
        this.pendingWith,
        this.pendingFrom
      });


  MedicalClaimFetchList.fromJson(Map<String, dynamic> json) {
    requestID = json['requestID'];
    status= json['status'];
    type = json['type'];
    appliedAmount = json['appliedAmount'];

    approvedAmount = json['approvedAmount'];
    reimburseAmount= json['reimburseAmount'];
    pendingWith = json['pendingWith'];
    pendingFrom = json['pendingFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestID'] = this.requestID;
    data['status'] = this.status;
    data['type'] = this.type;
    data['appliedAmount'] = this.appliedAmount;

    data['approvedAmount'] = this.approvedAmount;
    data['reimburseAmount'] = this.reimburseAmount;
    data['pendingWith'] = this.pendingWith;
    data['pendingFrom'] = this.pendingFrom;
    return data;
  }
}
