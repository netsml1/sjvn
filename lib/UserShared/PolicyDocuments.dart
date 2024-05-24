class PolicyDocumentsList {
  String? slno;
  String? subject;
  String? file;
  String? filename;

  PolicyDocumentsList(
      {this.slno,
        this.subject,
        this.file,
        this.filename});


  PolicyDocumentsList.fromJson(Map<String, dynamic> json) {
    slno = json['slno'];
    subject= json['subject'];
    file = json['file'];
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slno'] = this.slno;
    data['subject'] = this.subject;
    data['file'] = this.file;
    data['filename'] = this.filename;
    return data;
  }
}
