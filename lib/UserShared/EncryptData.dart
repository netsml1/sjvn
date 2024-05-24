
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import 'Profile.dart';
class EncryptData{
//for AES Algorithms

  static Encrypted? encrypted;
  static var decrypted;
  final aesKey = 'pkLB4ZB0OAClYuBq';
  final url="https://eprocureq.sjvn.co.in/RetireeMobileAppService/RetireeMoibleApp?wsdl";
  //final url1="https://roomagic.com/RetireeMobileApp.asmx";
final url1="https://connect.sjvn.co.in/RetireeMobileApp.asmx/";
final url2="https://connect.sjvn.co.in/";
  static int fiscalyear1(int y,int m)
  {
    // int month=DateTime.now().month;
    // int _year=DateTime.now().year;
    int cyear=m>=4?y:y-1;
    return cyear;
  }
static int fiscalyear(int y,int m)
{
  // int month=DateTime.now().month;
  // int _year=DateTime.now().year;
  int cyear=m>=4?y:y-1;
  return cyear;
}
  String geturl()
{
  return url;
}
  String geturl1()
  {
    return url1;
  }
  String geturl2()
  {
    return url2;
  }
  static const MaxNumericDigits = 17;
  static final _random = Random();


  int getInteger(int digitCount) {
    if (digitCount > MaxNumericDigits || digitCount < 1) throw new RangeError.range(0, 1, MaxNumericDigits, "Digit Count");
    var digit = _random.nextInt(9) + 1;  // first digit must not be a zero
    int n = digit;

    for (var i = 0; i < digitCount - 1; i++) {
      digit = _random.nextInt(10);
      n *= 10;
      n += digit;
    }
    return n;
  }
  Future<String?> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }
  Future<String> downloadfile(String path) async
  {
    print("object_path_"+path);
    String msg = "";

    String xmldata = '''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
       <path>''' + path + '''</path>
     
     
    </Query>

    '''.toString();

    var requestbody = encryptData(xmldata);
    //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
    var link = geturl1() + "DownloadFile";
     print("object#" + link);
    var response = await http.post(Uri.parse(link),

        body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );

    print("object#" + response.statusCode.toString());
    if (response.statusCode == 200) {
      var xmldata = response.body;
       //print("object_paas_"+xmldata);

      var data = decryptAES(xmldata.toString());
       print("object_"+data);
      var res = jsonDecode(data);
      //print("object_"+data);

      msg = res["body"].toString();

    }
    return msg;
  }
  Future<String> login(String username,String password,String phone,String Empid,String UserID) async
  {
    String msg1="";
    EncryptData ed=new EncryptData();



    String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
      <MobileNo>'''+phone+'''</MobileNo>
      <EmpID>'''+Empid+'''</EmpID>
      <UserID>'''+UserID+'''</UserID>
       <Username>'''+username+'''</Username>
      <Password>'''+password+'''</Password>
     
    </Query>

    '''.toString();
    // print("object#"+xmldata);
    var requestbody=    ed.encryptData(xmldata);
    //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
    var link = ed.geturl1()+"loginCheck";

    var response = await http.post(Uri.parse(link),

        body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );

    if (response.statusCode == 200) {
      var xmldata = response.body;
      msg1 = ed.decryptAES(xmldata.toString());
     print("object_12_"+msg1.toString());

      //var res = jsonDecode(data);

      //msg1 = res[0]["empid"];
    }

    return msg1;
  }
  Future<String> upddetail(String username,String password) async
  {
    String msg1="";
    EncryptData ed=new EncryptData();



    String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
       <Username>'''+username+'''</Username>
      <Password>'''+password+'''</Password>
     
    </Query>

    '''.toString();
    // print("object#"+xmldata);
    var requestbody=    ed.encryptData(xmldata);
    //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
    var link = ed.geturl1()+"UpdateDetail";

    var response = await http.post(Uri.parse(link),

        body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );

    if (response.statusCode == 200) {
      var xmldata = response.body;
      var data = ed.decryptAES(xmldata.toString());
      msg1=data;
     //print("object_12_"+data.toString());
      //var res = jsonDecode(data);

    // msg1 = res[0]["empid"];
    }

    return msg1;
  }
  Future<String> GetSomeData(String empid) async {

dynamic msg;
    EncryptData ed=new EncryptData();
    var fyear=  EncryptData.fiscalyear(DateTime.now().year,DateTime.now().month);
    var kl=    ed.encryptData('{"method" : "selfdependentdetails", "userid" : "","empid" : "$empid","fiscalyear":"$fyear"}');

    var link = ed.geturl();
    var requestbody ='''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
     <RetireeMobileApp xmlns="http://co.in/sjvn/RetireeMobileApp/">
            <data xmlns="">paasinfotech</data>
        </RetireeMobileApp>
    </Body>
</Envelope>

    '''.toString().replaceAll("paasinfotech", kl);
    var response = await http.post(Uri.parse(link),

        body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );
    List<dependent> users = [];

    if (response.statusCode == 200) {
      var xmldata = response.body;
      var contact = xml.XmlDocument.parse(xmldata);
      // print("paas"+  response.body.toString());
      var result = contact
          .findAllElements('return')
          .first
          .text
          .toString();
      // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
      // EncryptData.encryptAES(xmldata);

      var data = ed.decryptAES(result);
      msg=data;
//var data='{"self":{"CARD_NO":"100067","DEP_ID_STR":"Self","PERSA":"CC01","BLD_GRP_STR":"B-","VALID_TILL":"14.07.2027","DEP_ID":"99","EMP_POSTN":"test Desig","BANKL":"TEST IFSC","GENDER_STR":"Male","BANKN":"ABC7654321","DTOJOIN":"00.00.0000","GENDER":"1","SEP_TYP":"R","KOSTL":"1001000000","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp…..","REF_EMPID":"00010020","FILETYPE":"image/png","EMPRETID":"S100041","CELL_NO":"1234567890","NAME":"TEST RETIREE 1","BET01":"134000.00","PRCTR":"0000001001","DTOBRTH":"01.07.1950","BLD_GRP":"04","EMAIL_ID":"ASHI._SHR@GMAIL.COM"},"dependent":[{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"1","DEP_ID_STR":"Spouse","NAME":"NAME SPOUSE","GENDER":"2","GENDER_STR":"Female","BLD_GRP":"02","BLD_GRP_STR":"A-","DTOBRTH":"14.07.1960","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"MGH@YAHOO.COM","PERSA":"","CARD_NO":"100066","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"},{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"2","DEP_ID_STR":"Child","NAME":"DEP1","GENDER":"1","GENDER_STR":"Male","BLD_GRP":"03","BLD_GRP_STR":"B+","DTOBRTH":"01.07.2020","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"XYZ1@GMAIL.COM","PERSA":"","CARD_NO":"100065","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"}]}';

     // var responseData = json.decode(data);
     // msg=responseData.toString();
     // print("paas_self"+  responseData.toString());
    //msg=responseData.toString();

      // for (var res in responseData['dependent']) {
      //   dependent user = dependent(
      //       EMPRETID: res["EMPRETID"],
      //       NAME: res["NAME"],
      //       DTOBRTH: res["DTOBRTH"],
      //       CELL_NO: res["CELL_NO"]
      //   );
      //   // print("paaas "+res["EMPRETID"].toString());
      //   //Adding user to the list.
      //   users.add(user);
      // }
    }
    else
    {

    }

    return msg;

    //replace your restFull API here.
    // String url = "https://roomerang.net/webservice2.asmx/get_product_data";
    // final response = await http.get(Uri.parse(url));


  }
  Future<String> send_request(String msg,String tempid,String phone,String otp)
  async {
    String msg1="";
    var kl=    encryptData('{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
  //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
    var link = geturl1()+"SendSMS";
    var requestbody ='''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
     <RetireeMobileApp xmlns="http://co.in/sjvn/RetireeMobileApp/">
            <data xmlns="">paasinfotech</data>
        </RetireeMobileApp>
    </Body>
</Envelope>

    '''.toString().replaceAll("paasinfotech", kl);
    var response = await http.post(Uri.parse(link),

        body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );

    if (response.statusCode == 200) {
      var xmldata = response.body;
      var data=decryptAES(xmldata.toString());

      var res = jsonDecode(data);
      msg1=res["msg"];
    }
    //print("object_"+msg);
    return msg1;
  }

  String encryptData(final String data)
  {
    final key = Key.fromUtf8(aesKey);
    final iv = IV.fromUtf8(aesKey);

    final aesEncrypter = Encrypter(AES(key, mode: AESMode.ecb));

    final encrypted = aesEncrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }


  String decryptAES(final String encrypted){

    final key = Key.fromUtf8(aesKey);
    final iv = IV.fromUtf8(aesKey);
    final aesEncrypter = Encrypter(AES(key, mode: AESMode.ecb));

    final data = aesEncrypter.decrypt64(encrypted, iv: iv);
    return data;

  }
}