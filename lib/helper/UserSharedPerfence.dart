
import 'dart:convert';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
class UserSharedPreferences
{

  static SharedPreferences? preferences;
  static Uint8List? _image;

  static Future init() async
  {
    preferences= await SharedPreferences.getInstance();
    //return preferences;
  }
  static Future setAuth(bool status) async
  {
    await preferences!.setBool("auth", status);
  }
  static bool? getAuth()
  {
    return preferences!.getBool("auth");
  }
  static Future setLogin(bool status) async
  {
    await preferences!.setBool("login", status);
  }
  static bool? getLogin()
  {
    return preferences!.getBool("login");
  }
  static Future setUsername(String username) async
  {
    await preferences!.setString("username", username);
  }
  static String? getUsername()
  {
    return preferences!.getString("username");
  }
  static Future settotcgshclaim(double prc) async
  {
    double tot=0;

    if(preferences!.getString("prc")!=null)
      {
        tot=double.parse(preferences!.getString("prc").toString());
      }
    prc=tot+prc;
    await preferences!.setString("prc", prc.toString());
  }
  static String? gettotcgshclaim()
  {
    return preferences!.getString("prc");
  }
  static cleartotcgshclaim()
  {
    preferences!.setString("prc", "0");
  }

  // static Future setname(String username) async
  // {
  //   await preferences!.setString("name", username);
  // }
  // static String? getname()
  // {
  //   return preferences!.getString("name");
  // }
  static remove()
  {
    preferences!.clear();
  }
  static Future setImageUrl(String url) async
  {
    await preferences!.setString("url",url);
  }
  static String? getUrl()
  {
    return preferences!.getString("url");
  }

  static Future setProfile(

  String EMPRETID,
  String REF_EMPID,
  String DEP_ID,
  String DEP_ID_STR, //String //Yes Relationship with employee
  String NAME, //String //Yes Name of the user
  String DTOBRTH, //String //Yes Date of Birth
  String FILETYPE, //String //Yes Image format for the profile
  String FILECONTENT, //String //Yes Base64 image for the profile pic
  String CELL_NO, //String //Yes Mobile Number
  String EMAIL_ID, //String //Yes Email ID
  String PERSA, //String //Yes
  String CARD_NO, //String //Yes Card No
  String VALID_TILL, //String //Yes Card No Validity Date
  String SEP_TYP, //String //Yes Separation Type
  String BANKL, //String //Yes Bank Account No
  String BANKN, //String Yes Bank Account No
  String KOSTL, //String Yes Cost Centre
  String PRCTR, //String Yes Profit Centre
  String BET01, //String Yes Basic Pay
  String BLD_GRP, //String Yes Blood Group Key
  String BLD_GRP_STR, //String Yes Blood Group Value in text
  String GENDER, //String Yes Gender Key
  String GENDER_STR, //String Yes Gender Key
      String EMP_POSTN,
      String DTOJOIN

      ) async
  {
  await preferences!.setString("EMPRETID",EMPRETID);
  await preferences!.setString("REF_EMPID",REF_EMPID);
  await preferences!.setString("DEP_ID",DEP_ID);
  await preferences!.setString("DEP_ID_STR",DEP_ID_STR);
  //await preferences!.setString("NAME",NAME);
  await preferences!.setString("DTOBRTH",DTOBRTH);
  await preferences!.setString("FILETYPE",FILETYPE);
  //await preferences!.setString("FILECONTENT",FILECONTENT);
 // await preferences!.setString("CELL_NO",CELL_NO);
 // await preferences!.setString("EMAIL_ID",EMAIL_ID);
  await preferences!.setString("PERSA",PERSA);
  await preferences!.setString("CARD_NO",CARD_NO);
  await preferences!.setString("VALID_TILL",VALID_TILL);
  await preferences!.setString("PERSA",PERSA);

  await preferences!.setString("VALID_TILL",VALID_TILL);
  await preferences!.setString("SEP_TYP",SEP_TYP);
  await preferences!.setString("BANKL",BANKL);
  await preferences!.setString("BANKN",BANKN);
  await preferences!.setString("KOSTL",KOSTL);
  await preferences!.setString("PRCTR",PRCTR);
  await preferences!.setString("BET01",BET01);
  await preferences!.setString("BLD_GRP",BLD_GRP);
  await preferences!.setString("BLD_GRP_STR",BLD_GRP_STR);
  await preferences!.setString("GENDER",GENDER);
  await preferences!.setString("GENDER_STR",GENDER_STR);
  await preferences!.setString("EMP_POSTN",EMP_POSTN);
  await preferences!.setString("DTOJOIN",DTOJOIN);

  }
  static Future setProfileCard(String CARD_NO) async
  {
    await preferences!.setString("CARD_NO",CARD_NO);
  }
  static String? getCard()
  {
    return preferences!.getString("CARD_NO");
  }
  static Future setProfileName(String Name) async
  {
    await preferences!.setString("NAME",Name);
  }
  static Future setProfileEmail(String EMAIL_ID) async
  {
    await preferences!.setString("EMAIL_ID",EMAIL_ID);
  }
  static Future setProfileMobile(String CELL_NO) async
  {
    await preferences!.setString("CELL_NO",CELL_NO);
  }
  static Future setProfileImage(String FILECONTENT) async
  {
    await preferences!.setString("FILECONTENT",FILECONTENT);
  }
  static String? getEmail()
  {
    return preferences!.getString("EMAIL_ID");
  }
  static String? getProfileName()
  {
    return preferences!.getString("NAME");
  }
  static String? getProfileMobile()
  {
    return preferences!.getString("CELL_NO");
  }
  static String? getProfileImage()
  {
    //Uint8List _bytesImage;
//_bytesImage=preferences!.getString("FILECONTENT") as Uint8List;

    return preferences!.getString("FILECONTENT");
  }
  static String? getProfileImageType()
  {
    return preferences!.getString("FILETYPE");
  }
  static Uint8List getImage()
  {

    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String? imagenJson =  UserSharedPreferences.getProfileImage();
    Uint8List? _image = base64Decode(imagenJson!);

    return _image;
  }
  static String? getDesignation()
  {
return preferences!.getString("EMP_POSTN");
  }
  static String? getDOB()
  {
    return preferences!.getString("DTOBRTH");
  }
  static String? getBasicPay()
  {
    return preferences!.getString("BET01");
  }
  static String? getAccountNo()
  {
    return preferences!.getString("BANKN");
  }
  static String? getIFSC()
  {
    return preferences!.getString("BANKL");
  }
  static String? getDOJ()
  {
    return preferences!.getString("DTOJOIN");
  }
  static String? getVALID()
  {
    return preferences!.getString("VALID_TILL");
  }
  static String? getEmpID()
  {
    return preferences!.getString("REF_EMPID");
  }
 //  static Future<Map<String, dynamic>?>   userdetail() async
 //  {
 // Map<String, dynamic> detail;
 //    var collection = FirebaseFirestore.instance.collection('netsml1');
 //    var docSnapshot = await collection.doc(
 //        '${UserSharedPreferences.getUsername()}').get();
 //   // if (docSnapshot.exists) {
 //      detail = docSnapshot.data()! as Map<String, dynamic> ;
 //      setImageUrl(detail["ImageUrl"]);
 //   // }
 //    //print(detail);
 //    return detail;
 //  }
}