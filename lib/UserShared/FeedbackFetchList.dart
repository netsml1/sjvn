class FeedbackFetchList {
  String? Name;
  String? Save_Date;

  String? id;
  FeedbackFetchList(
      {
        this.Name,
        this.Save_Date,

        this.id,
      });


  FeedbackFetchList.fromJson(Map<String, dynamic> json) {
   Name = json['Name'];
    Save_Date= json['Save_Date'];
    id= json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.Name;
    data['Save_Date'] = this.Save_Date;

    data['id'] = this.id;
    return data;
  }
}
