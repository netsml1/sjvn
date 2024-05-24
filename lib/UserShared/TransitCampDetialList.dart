class TransitCampDetailList {
  String? Name;
  String? Room;
  String? Location;
  String? Address;
String? GoogleLocation;
String? PersonName;

  String? PersonMobile;
  String? id;
  String? msg;

  TransitCampDetailList(
      {
        this.Name,
        this.Room,
        this.Location,
        this.Address,
        this.GoogleLocation,
        this.PersonName,

        this.PersonMobile,
        this.id,
        this.msg
      });


  TransitCampDetailList.fromJson(Map<String, dynamic> json) {
    Name = json['Name'];
    Room= json['Room'];
    Location = json['Location'];
    Address= json['Address'];
    GoogleLocation = json['GoogleLocation'];

   PersonName = json['PersonName'];

    PersonMobile = json['PersonMobile'];
   id= json['id'];
    msg= json['msg'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.Name;
    data['Room'] = this.Room;
    data['Location'] = this.Location;
    data['Address'] = this.Address;
    data['GoogleLocation'] = this.GoogleLocation;
    data['PersonName'] = this.PersonName;
    data['PersonMobile'] = this.PersonMobile;

    data['id'] = this.id;
    data['msg'] = this.msg;

    return data;
  }
}
