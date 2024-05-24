class dependent {
  //String? self;
  String? EMPRETID;
  String? REF_EMPID;
  String? DEP_ID;
  String? DEP_ID_STR; //String //Yes Relationship with employee
  String? NAME; //String //Yes Name of the user
  String? DTOBRTH; //String //Yes Date of Birth
  String? FILETYPE; //String //Yes Image format for the profile
  String? FILECONTENT; //String //Yes Base64 image for the profile pic
  String? CELL_NO; //String //Yes Mobile Number
  String? EMAIL_ID; //String //Yes Email ID
  String? PERSA; //String //Yes
  String? CARD_NO; //String //Yes Card No
  String? VALID_TILL; //String //Yes Card No Validity Date
  String? SEP_TYP; //String //Yes Separation Type
  String? BANKL; //String //Yes Bank Account No
  String? BANKN; //String Yes Bank Account No
  String? KOSTL; //String Yes Cost Centre
  String? PRCTR; //String Yes Profit Centre
  String? BET01; //String Yes Basic Pay
  String? BLD_GRP; //String Yes Blood Group Key
  String? BLD_GRP_STR; //String Yes Blood Group Value in text
  String? GENDER; //String Yes Gender Key
  String? GENDER_STR; //String Yes Gender Key in text

  dependent(
      {
        //this.self,
        this.CARD_NO,
        this.EMPRETID,
        this.REF_EMPID,
        this.DEP_ID,
        this.DEP_ID_STR,
        this.NAME,
        this.DTOBRTH,
        this.FILETYPE,
        this.FILECONTENT,
        this.CELL_NO,
        this.VALID_TILL,
        this.SEP_TYP,
        this.BANKL,
        this.BANKN,
        this.KOSTL,
        this.PRCTR,
        this.BET01,
        this.BLD_GRP,
        this.BLD_GRP_STR,
        this.GENDER,
        this.GENDER_STR,


      });


  dependent.fromJson(Map<String, dynamic> json) {
   // self = json['self'];
    EMPRETID= json['EMPRETID'];
    REF_EMPID = json['REF_EMPID'];
    DEP_ID = json['DEP_ID'];
DEP_ID_STR=json['DEP_ID_STR'];
NAME=json['NAME'];
DTOBRTH=json['DTOBRTH'];
FILETYPE=json['FILETYPE'];
FILECONTENT=json['FILECONTENT'];
CELL_NO=json['CELL_NO'];
VALID_TILL=json['VALID_TILL'];
SEP_TYP=json['SEP_TYP'];
BANKL=json['BANKL'];
BANKN=json['BANKN'];
KOSTL=json['KOSTL'];
PRCTR=json['PRCTR'];
BET01=json['BET01'];
BLD_GRP=json['BLD_GRP'];
BLD_GRP_STR=json['BLD_GRP_STR'];
GENDER=json['GENDER'];
GENDER_STR=json['GENDER_STR'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['self'] = this.self;
    data['EMPRETID'] = this.EMPRETID;
    data['REF_EMPID'] = this.REF_EMPID;
    data['DEP_ID'] = this.DEP_ID;
    data['DEP_ID_STR']=this.DEP_ID_STR;
    data['NAME']=this.NAME;
    data['DTOBRTH']=this.DTOBRTH;
    data['FILETYPE']=this.FILETYPE;
    data['FILECONTENT']=this.FILECONTENT;
    data['CELL_NO']=this.CELL_NO;
    data['VALID_TILL']=this.VALID_TILL;
    data['SEP_TYP']=this.SEP_TYP;
    data['BANKL']=this.BANKL;
    data['BANKN']=this.BANKN;
    data['KOSTL']=this.KOSTL;
    data['PRCTR']=this.PRCTR;
    data['BLD_GRP']=this.BLD_GRP;
    data['BLD_GRP_STR']=this.BLD_GRP_STR;
    data['GENDER']=this.GENDER;
    data['GENDER_STR']=this.GENDER_STR;
    return data;
  }
}
