class TransitCampList {
  String? docno;
  String? filename;
  String? date;
  String? data;

  TransitCampList(
      {this.docno,
        this.filename,
        this.date,
        this.data});


  TransitCampList.fromJson(Map<String, dynamic> json) {
    docno = json['docno'];
    filename= json['filename'];
    date = json['date'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['docno'] = this.docno;
    data['filename'] = this.filename;
    data['date'] = this.date;
    data['data'] = this.data;
    return data;
  }
}
