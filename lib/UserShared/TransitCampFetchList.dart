class TransitCampFetchList {
  String? requestID;
  String? status;
  String? location;
  String? checkin;
String? camp;
String? map;

  String? checkout;
  String? adult;
  String? child;
  String? room;

  String? checkin1;

  String? checkout1;
  String? adult1;
  String? child1;
  String? room1;

  String? guestname;
  String? guestaddress;
  String? mobilenumber;
  String? note;
  String? note1;
  String? id;
  TransitCampFetchList(
      {
        this.camp,
        this.map,

        this.requestID,
        this.status,
        this.location,
        this.checkin,
        this.checkout,
        this.adult,
        this.child,
        this.room,

        this.checkin1,
        this.checkout1,
        this.adult1,
        this.child1,
        this.room1,

        this.guestname,
        this.guestaddress,
        this.mobilenumber,
        this.note,
        this.note1,
        this.id,
      });


  TransitCampFetchList.fromJson(Map<String, dynamic> json) {
    map = json['map'];
    camp= json['camp'];
    requestID = json['requestID'];
    status= json['status'];
    location = json['location'];

    checkin = json['checkin'];

    checkout = json['checkout'];
    adult= json['adult'];
    child = json['child'];
    room = json['room'];

    checkin1 = json['checkin1'];

    checkout1 = json['checkout1'];
    adult1= json['adult1'];
    child1 = json['child1'];
    room1 = json['room1'];

    guestname = json['guestname'];
    guestaddress= json['guestaddress'];
    mobilenumber = json['mobilenumber'];
    note= json['note'];
    note1= json['note1'];
    id= json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['map'] = this.map;
    data['camp'] = this.camp;
    data['status'] = this.status;
    data['requestID'] = this.requestID;
    data['status'] = this.status;
    data['location'] = this.location;
    data['checkin'] = this.checkin;

    data['checkout'] = this.checkout;
    data['adult'] = this.adult;
    data['child'] = this.child;
    data['room'] = this.room;

    data['checkin1'] = this.checkin1;

    data['checkout1'] = this.checkout1;
    data['adult1'] = this.adult1;
    data['child1'] = this.child1;
    data['room1'] = this.room1;


    data['guestname'] = this.guestname;
    data['guestaddress'] = this.guestaddress;
    data['mobilenumber'] = this.mobilenumber;
    data['note'] = this.note;
    data['note1'] = this.note1;
    data['id'] = this.id;
    return data;
  }
}
