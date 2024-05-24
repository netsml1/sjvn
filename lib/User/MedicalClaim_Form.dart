
import 'dart:convert';
import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:sjvn/UserShared/contact_modal1.dart';
import 'package:sjvn/helper/FileProcess.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';

import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import '../UserShared/contact_modal.dart';


import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import '../helper/MyProgress.dart';


import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import 'contact_form_item_widget_2.dart';
import 'contact_form_item_widget1.dart';


class MyMedicalClaimForm extends StatefulWidget
{

  final String? text;
  final String? text1;
  MyMedicalClaimForm({Key? key, this.text,this.text1}) : super(key: key);
  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State<MyMedicalClaimForm>
{
String? file_name="";
String? file_data="";
  bool rememberMe = false;
  bool rememberMe1 = false;
  bool showWidget = false;
  bool showWidget1 = false;
  bool showWidget2 = false;
  bool showWidget3 = false;
  bool showWidget4=false;
  bool showEdit=false;
  List<ContactFormItemWidget_2> contactForms = [];
  List<ContactFormItemWidget1> contactForms1 = [];
  TextEditingController txt_code=new TextEditingController();
  TextEditingController txt_date=new TextEditingController();
  TextEditingController txt_year=new TextEditingController();
  TextEditingController txt_ELIGIBLE_AMT=new TextEditingController();
  TextEditingController txt_CLAIMED_AMT=new TextEditingController();
  TextEditingController txt_entitled=new TextEditingController();
  TextEditingController txt_totalcgshclaim=new TextEditingController();
  TextEditingController txt_totalnonclaim=new TextEditingController();
  TextEditingController txt_totalclaim=new TextEditingController();
  TextEditingController txt_totalcgshapprove=new TextEditingController();
  TextEditingController txt_totalnonapprove=new TextEditingController();
  TextEditingController txt_totalapprove=new TextEditingController();
  TextEditingController txt_totaltax=new TextEditingController();
  TextEditingController txt_total=new TextEditingController();
  TextEditingController txt_from=new TextEditingController();
  TextEditingController txt_to=new TextEditingController();
  TextEditingController txt_to_id=new TextEditingController();
  TextEditingController txt_comment=new TextEditingController();
  TextEditingController txt_comment1=new TextEditingController();
  TextEditingController txt_comment2=new TextEditingController();
  TextEditingController txt_document=new TextEditingController();
  List<DropdownMenuItem<String>>? _menuItems;
  String? dropdownValue;
  File? _file;
  String? _image_file;
  bool isLoading = false;
  String? year;
  String? year1;
  String? _selectedLocation;
  String? _selectedLocation1;
  FilePickerResult? selectedfile;
  String? progress;
  String? baseimage;
  double? sizeInMb;
  final _formKey = GlobalKey<FormState>();
  getRequest1(String year) async{
    try
    {


  // DialogBuilder(context).showLoadingIndicator('Calculating');
    EncryptData ed=new EncryptData();
   // String st='';
    // if(widget.text!=null)
    // {
   //   st='{"method" : "medicalClaimFetchList","attachment":"", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString());

   // }
    var kl=    ed.encryptData('{"method":"medicalClaimFetchData","userid":"Puserid","attachment":"X","requestid":"REQ_Paas"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()).replaceAll("REQ_Paas", widget.text.toString()));

   // var kl=    ed.encryptData(st);

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
    if (response.statusCode == 200) {
      var xmldata = response.body;
      var contact = xml.XmlDocument.parse(xmldata);
     // print("paas"+  response.body.toString());
      var result = contact
          .findAllElements('return')
          .first
          .text
          .toString();
      var data = ed.decryptAES(result);
      var responseData = json.decode(data);
      final List parsedList;
      parsedList=responseData["hospital"];
      final List parsedList2;
      parsedList2=responseData["attachment"];
      if(parsedList2.length!=0)
        {
          setState(() {
            file_name=parsedList2[0]["FILE_NAME"].toString();
            file_data=parsedList2[0]["ATT_CONTENTS_BASE64"].toString();
          });

        }
    // print("object_json"+responseData["hospital"]);
      if(parsedList.length!=0)
        {
         // widget
          setState(() {
            _selectedLocation="Hospitalization Reimbursement";
            txt_date.text=widget.text1.toString();
            var inputformat = DateFormat('dd.MM.yyyy');
            var date1 = inputformat.parse(txt_date.text);

            var outputformat = DateFormat('yyyy-MM-dd');

           var date2 = outputformat.format(date1); // 2019-08-18
            DateTime dt=DateTime.parse(date2);
            //print("object_dt"+dt.toString());
            int cyear=EncryptData.fiscalyear(dt.year, dt.month);
           getRequest(cyear.toString());
          // txt_totalapprove.text=parsedList[0]["TOTAL_APPROVED_COST"].toString();

          });
         // onRemoveAll_Hospitalization();

          contactForms1.clear();
          double i_TOTAL_APPROVED_COST=0,i_TAX_AMOUNT=0,i_PAID_AMOUNT=0;
          double i_tot_cgsh=0,i_tot_non=0,i_tot_claim=0;
          double i_tot_cgsh_approv=0,i_tot_non_aaprov=0,i_tot_claim_approv=0;
         // DialogBuilder(context).showLoadingIndicator('Calculating');
          for(int k=0;k<parsedList.length;k++)
          {
            //onAdd1();
          // setState(() {
           // _contactModel.APPLYING_FOR="Self";
            txt_comment.text=parsedList[k]["COMMENT_RETIREE"].toString();
            txt_comment1.text=parsedList[k]["COMMENT_FINANCE1"].toString();
            txt_comment2.text=parsedList[k]["COMMENT_FINANCE2"].toString();
            i_TOTAL_APPROVED_COST=double.parse(parsedList[k]["TOTAL_APPROVED_COST"].toString());
            i_TAX_AMOUNT=double.parse(parsedList[k]["TAX_AMOUNT"].toString());
            i_PAID_AMOUNT=double.parse(parsedList[k]["PAID_AMOUNT"].toString());
if(parsedList[k]["HOSPITAL_TYPE"].toString()=="CGSH/Govt/Empanelled")
  {
    i_tot_cgsh=i_tot_cgsh+double.parse(parsedList[k]["CLAIMED_TOTAL_ROOM_CHARGE"].toString());
    i_tot_cgsh=i_tot_cgsh+double.parse(parsedList[k]["CLAIMED_OTHER_CHARGE"].toString());
    i_tot_cgsh=i_tot_cgsh+double.parse(parsedList[k]["CLAIMED_MEDI_COST"].toString());
    i_tot_cgsh=i_tot_cgsh+double.parse(parsedList[k]["CLAIMED_SURGICAL_COST"].toString());

    i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList[k]["APPROVED_TOTAL_ROOM_CHARGE"].toString());
    i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList[k]["APPROVED_OTHER_CHARGE"].toString());
    i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList[k]["APPROVED_MEDI_COST"].toString());
    i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList[k]["APPROVED_SURGICAL_COST"].toString());
  }
else
  {
    i_tot_non=i_tot_non+double.parse(parsedList[k]["CLAIMED_TOTAL_ROOM_CHARGE"].toString());
    i_tot_non=i_tot_non+double.parse(parsedList[k]["CLAIMED_OTHER_CHARGE"].toString());
    i_tot_non=i_tot_non+double.parse(parsedList[k]["CLAIMED_MEDI_COST"].toString());
    i_tot_non=i_tot_non+double.parse(parsedList[k]["CLAIMED_SURGICAL_COST"].toString());

    i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList[k]["APPROVED_TOTAL_ROOM_CHARGE"].toString());
    i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList[k]["APPROVED_OTHER_CHARGE"].toString());
    i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList[k]["APPROVED_MEDI_COST"].toString());
    i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList[k]["APPROVED_SURGICAL_COST"].toString());
  }

            ContactModel1 _contactModel = ContactModel1(id: contactForms1.length);
        contactForms1.add(ContactFormItemWidget1(
              index:txt_code.text ,
              contactModel: _contactModel,
              onRemove: () => onRemove1(_contactModel),

              crt_visible: false,
              applying: parsedList[k]["APPLYING_FOR"].toString(),
              TREATMENT: parsedList[k]["TREATMENT_STATUS"].toString(),
              CARD_N:parsedList[k]["CARD_NO"].toString() ,
              HOSPITAL: parsedList[k]["HOSPITAL_NAME"].toString(),
              HOSPITAL_TYP: parsedList[k]["HOSPITAL_TYPE"].toString(),
              DATE_FRO: parsedList[k]["DATE_FROM"].toString(),
              DATE_T: parsedList[k]["DATE_TO"].toString(),
              PATIENT_NAM: parsedList[k]["PATIENT_NAME"].toString(),
              //PATIENT_NAM: parsedList[k]["PATIENT_NAME"].toString()+"*"+parsedList[k]["CARD_NO"].toString(),

              APPROVED_COST_OF_MEDICIN: parsedList[k]["APPROVED_MEDI_COST"].toString(),
              APPROVED_ROO: parsedList[k]["APPROVED_TOTAL_ROOM_CHARGE"].toString(),
              CLAIMED_COST_OF_MEDICIN: parsedList[k]["CLAIMED_MEDI_COST"].toString(),
              APPROVED_OTHER_CHARGE: parsedList[k]["APPROVED_OTHER_CHARGE"].toString(),
              APPROVED_SURGICAL_CHARGE:parsedList[k]["APPROVED_SURGICAL_COST"].toString() ,
              CLAIMED_OTHER_CHARGE: parsedList[k]["CLAIMED_OTHER_CHARGE"].toString(),
              CLAIMED_ROOM_CHARGE: parsedList[k]["CLAIMED_TOTAL_ROOM_CHARGE"].toString(),
              CLAIMED_SURGICAL_CHARGE: parsedList[k]["CLAIMED_SURGICAL_COST"].toString(),

            )
            );
         //  onCaluclate_Hospitalization();
          // });
          }
          setState(() {
        txt_totalapprove.text=i_TOTAL_APPROVED_COST.toString();

          txt_totalclaim.text=i_TOTAL_APPROVED_COST.toString();
          txt_totaltax.text=i_TAX_AMOUNT.toString();
          txt_total.text=i_PAID_AMOUNT.toString();
          txt_totalcgshclaim.text=i_tot_cgsh.toString();
          txt_totalcgshapprove.text=i_tot_cgsh_approv.toString();
          txt_totalnonclaim.text=i_tot_non.toString();
         txt_totalnonapprove.text=i_tot_non_aaprov.toString();
          });
        //  DialogBuilder(context).hideOpenDialog();
        }
      else
      {
       print("object_chk"+responseData.toString());
        final List parsedList1;
        parsedList1=responseData["nonHospital"];
      //  print("object_chk"+parsedList1.length.toString());

        // widget
        setState(() {
          _selectedLocation="Non-Hospitalization Reimbursement";
          txt_date.text=widget.text1.toString();
          txt_code.text="Non-Hospitalization Reimbursement";
          txt_year.text=parsedList1[0]["FISCAL_YEAR"].toString();
          _selectedLocation1=parsedList1[0]["FISCAL_YEAR"].toString();
         getRequest(txt_year.text);


        });
        // onRemoveAll_Hospitalization();

        contactForms.clear();
        double i_TOTAL_APPROVED_COST=0,i_TAX_AMOUNT=0,i_PAID_AMOUNT=0;
        double i_tot_cgsh=0,i_tot_non=0,i_tot_claim=0;
        double i_tot_cgsh_approv=0,i_tot_non_aaprov=0,i_tot_claim_approv=0;
       // print("object_chk"+parsedList1.length.toString());
        // DialogBuilder(context).showLoadingIndicator('Calculating');
        for(int k=0;k<parsedList1.length;k++)
        {

          // setState(() {
          // _contactModel.APPLYING_FOR="Self";
          txt_comment.text=parsedList1[k]["COMMENT_RETIREE"].toString();
          txt_comment1.text=parsedList1[k]["COMMENT_FINANCE1"].toString();
          txt_comment2.text=parsedList1[k]["COMMENT_FINANCE2"].toString();
          i_TOTAL_APPROVED_COST=double.parse(parsedList1[k]["TOTAL_APPROVED_COST"].toString());
          i_TAX_AMOUNT=double.parse(parsedList1[k]["TAX_AMOUNT"].toString());
          i_PAID_AMOUNT=double.parse(parsedList1[k]["PAID_AMOUNT"].toString());
          if(parsedList1[k]["HOSPITAL_TYPE"].toString()=="CGSH/Govt/Empanelled")
          {
            i_tot_cgsh=i_tot_cgsh+double.parse(parsedList1[k]["CLAIMED_CONSULTATION_CHARGE"].toString());
            i_tot_cgsh=i_tot_cgsh+double.parse(parsedList1[k]["CLAIMED_INJECT_CHARGE"].toString());
            i_tot_cgsh=i_tot_cgsh+double.parse(parsedList1[k]["CLAIMED_MEDI_COST"].toString());
            i_tot_cgsh=i_tot_cgsh+double.parse(parsedList1[k]["CLAIMED_PATH_CHARGE"].toString());

            i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList1[k]["APPROVED_CONSULTATION_CHARGE"].toString());
            i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList1[k]["APPROVED_INJECT_CHARGE"].toString());
            i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList1[k]["APPROVED_MEDI_COST"].toString());
            i_tot_cgsh_approv=i_tot_cgsh_approv+double.parse(parsedList1[k]["APPROVED_PATH_CHARGE"].toString());
          }
          else
          {
            i_tot_non=i_tot_non+double.parse(parsedList1[k]["CLAIMED_CONSULTATION_CHARGE"].toString());
            i_tot_non=i_tot_non+double.parse(parsedList1[k]["CLAIMED_INJECT_CHARGE"].toString());
            i_tot_non=i_tot_non+double.parse(parsedList1[k]["CLAIMED_MEDI_COST"].toString());
            i_tot_non=i_tot_non+double.parse(parsedList1[k]["CLAIMED_PATH_CHARGE"].toString());

            i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList1[k]["APPROVED_CONSULTATION_CHARGE"].toString());
            i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList1[k]["APPROVED_INJECT_CHARGE"].toString());
            i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList1[k]["APPROVED_MEDI_COST"].toString());
            i_tot_non_aaprov=i_tot_non_aaprov+double.parse(parsedList1[k]["APPROVED_PATH_CHARGE"].toString());
          }



          ContactModel _contactModel = ContactModel(id: contactForms.length);
          contactForms.add(ContactFormItemWidget_2(
            index:txt_code.text ,
            contactModel: _contactModel,
            onRemove: () => onRemove(_contactModel),
            crt_visible: false,
           applying: parsedList1[k]["APPLYING_FOR"].toString(),
            TREATMENT: parsedList1[k]["TREATMENT_STATUS"].toString(),
            CARD_N:parsedList1[k]["CARD_NO"].toString() ,
            HOSPITAL: parsedList1[k]["DOCTOR_NAME"].toString(),
            HOSPITAL_TYP: parsedList1[k]["HOSPITAL_TYPE"].toString(),
            CONSULT_DATe: parsedList1[k]["CONSULT_DATE"].toString(),


            PATIENT_NAM: parsedList1[k]["PATIENT_NAME"].toString(),


            APPROVED_CONSULTATION_CHARGe: parsedList1[k]["APPROVED_CONSULTATION_CHARGE"].toString(),
            APPROVED_MEDI_COSt:parsedList1[k]["APPROVED_MEDI_COST"].toString() ,
            APPROVED_PATH_CHARGe:parsedList1[k]["APPROVED_PATH_CHARGE"].toString(),
            CASH_MEMO_DATe: parsedList1[k]["CASH_MEMO_DATE"].toString(),
            CASH_MEMO_no: parsedList1[k]["CASH_MEMO_NO"].toString(),
            CLAIMED_CONSULTATION_CHARGe: parsedList1[k]["CLAIMED_CONSULTATION_CHARGE"].toString(),
            CLAIMED_MEDI_COSt: parsedList1[k]["CLAIMED_MEDI_COST"].toString(),
            CLAIMED_PATH_CHARGe: parsedList1[k]["CLAIMED_PATH_CHARGE"].toString(),
            CLAIMED_INJECT_CHARGe:parsedList1[k]["CLAIMED_INJECT_CHARGE"].toString(),
            APPROVED_INJECT_CHARGe:parsedList1[k]["APPROVED_INJECT_CHARGE"].toString(),
          ));
          //  onCaluclate_Hospitalization();
          // });
        }
        setState(() {
          txt_totalapprove.text=i_TOTAL_APPROVED_COST.toString();

          txt_totalclaim.text=i_TOTAL_APPROVED_COST.toString();
          txt_totaltax.text=i_TAX_AMOUNT.toString();
          txt_total.text=i_PAID_AMOUNT.toString();
          txt_totalcgshclaim.text=i_tot_cgsh.toString();
          txt_totalcgshapprove.text=i_tot_cgsh_approv.toString();
          txt_totalnonclaim.text=i_tot_non.toString();
          txt_totalnonapprove.text=i_tot_non_aaprov.toString();
        });
        //  DialogBuilder(context).hideOpenDialog();
      }

    }
    }on Exception catch (_)
    {
 //DialogBuilder(context).hideOpenDialog();
    }
    //DialogBuilder(context).hideOpenDialog();
  }


   getRequest(String year) async
   {

     //DialogBuilder(context).showLoadingIndicator('Calculating');
    EncryptData ed=new EncryptData();
    String st='{"method" : "selfdependentdetails", "userid" : "Puserid","fiscalyear":"paas_year"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()).replaceAll("paas_year", year.toString());
   // if(widget.text!=null)
   //   {
   //    st='{"method" : "selfdependentdetails", "userid" : "Puserid","fiscalyear":"paas_year","requestid","'+widget.text!+'"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()).replaceAll("paas_year", year.toString());
   //
   //   }
  // print("object_request"+st);
    var kl=    ed.encryptData(st);

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
var data1='{"self":{"CARD_NO":"100067","DEP_ID_STR":"Self","PERSA":"CC01","BLD_GRP_STR":"B-","VALID_TILL":"14.07.2027","DEP_ID":"99","EMP_POSTN":"test Desig","BANKL":"TEST IFSC","GENDER_STR":"Male","BANKN":"ABC7654321","DTOJOIN":"00.00.0000","GENDER":"1","SEP_TYP":"R","KOSTL":"1001000000","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp…..","REF_EMPID":"00010020","FILETYPE":"image/png","EMPRETID":"S100041","CELL_NO":"1234567890","NAME":"TEST RETIREE 1","BET01":"134000.00","PRCTR":"0000001001","DTOBRTH":"01.07.1950","BLD_GRP":"04","EMAIL_ID":"ASHI._SHR@GMAIL.COM"},"dependent":[{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"1","DEP_ID_STR":"Spouse","NAME":"NAME SPOUSE","GENDER":"2","GENDER_STR":"Female","BLD_GRP":"02","BLD_GRP_STR":"A-","DTOBRTH":"14.07.1960","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"MGH@YAHOO.COM","PERSA":"","CARD_NO":"100066","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"},{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"2","DEP_ID_STR":"Child","NAME":"DEP1","GENDER":"1","GENDER_STR":"Male","BLD_GRP":"03","BLD_GRP_STR":"B+","DTOBRTH":"01.07.2020","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"XYZ1@GMAIL.COM","PERSA":"","CARD_NO":"100065","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"}]}';

      var responseData = json.decode(data);
      var responseData1 = json.decode(data1);
      final List parsedList = responseData["dependent"];
     var kk=parsedList.where((element) => element["DEP_ID_STR"]=="Child").toList();
      print("paas_self_"+  kk[0]["NAME"].toString());
     //print("paas_self"+  responseData1["dependent"].toString());
      setState(() {
        txt_to.text=responseData["WF_TO_NAME"].toString();
        txt_to_id.text=responseData["WF_TO"].toString();
        txt_from.text=UserSharedPreferences.getProfileName().toString();
       txt_CLAIMED_AMT.text="0".toString();
        txt_ELIGIBLE_AMT.text=responseData["ELIGIBLE_AMT"].toString();
        txt_CLAIMED_AMT.text=responseData["CLAIMED_AMT"].toString();
        txt_entitled.text=(double.parse(txt_ELIGIBLE_AMT.text.toString())-double.parse(txt_CLAIMED_AMT.text)).toString();
      });

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
  //  print("paaas "+users.length.toString());
  //  return users;

    //replace your restFull API here.
    // String url = "https://roomerang.net/webservice2.asmx/get_product_data";
    // final response = await http.get(Uri.parse(url));

    // DialogBuilder(context).hideOpenDialog();
  }

  @override
  void initState()
  {
    super.initState();



    DateFormat dateFormat = DateFormat("dd.MM.yyyy");

int cyear=EncryptData.fiscalyear(DateTime.now().year, DateTime.now().month);

    year=(cyear).toString();
    year1=(cyear-1).toString();


//txt_date.text=dateFormat.format(DateTime.now());
    txt_ELIGIBLE_AMT.text="0";
   txt_CLAIMED_AMT.text="0";
   txt_entitled.text="0";
    txt_totalcgshclaim.text="0";
    txt_totalnonclaim.text="0";
    txt_totalclaim.text="0";
    txt_totalcgshapprove.text="0";
    txt_totalnonapprove.text="0";
    txt_totalapprove.text="0";
   txt_totaltax.text="0";
 txt_total.text="0";
  }

  @override
  Widget build(BuildContext context)  {
    MyFooter footer=new MyFooter(context);
    MyHeader header=new MyHeader(context);

    if(widget.text!=null)
      {
        //DialogBuilder(context).hideOpenDialog();
        //DialogBuilder(context).showLoadingIndicator('Calculating');
        int cyear=EncryptData.fiscalyear(DateTime.now().year, DateTime.now().month);
        getRequest1(cyear.toString());
        showWidget=true;
     //  DialogBuilder(context).hideOpenDialog();

      }

    //MyFooter footer=new MyFooter(context);
    // WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement build
    //logindata = SharedPreferences.getInstance();
    return Scaffold(
     // resizeToAvoidBottomInset: false,
      appBar: AppBar(

        centerTitle: true,
        title: Text("Medical Claim Details"),
        actions: [
          IconButton(
            onPressed: () {
              UserSharedPreferences.remove();
              UserSharedPreferences.setAuth(false);
              Navigator.pushReplacement(context!, MaterialPageRoute(builder: (context)=>MyLoginScreen()));
            },

            icon: Icon(Icons.power_settings_new),
          )
        ],

        backgroundColor:Colors.lightBlue.shade900,
        bottomOpacity: 0.0,
        elevation: 0.0,


      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   elevation: 5,
      //   backgroundColor: Colors.lightBlue.shade900,
      //   child: Icon(Icons.camera),
      //   onPressed: () {},
      // ),
      bottomNavigationBar: footer.FooterShow(),
      body:
Form(
  key:_formKey,
  child: SingleChildScrollView(
    physics: ScrollPhysics(),
    child: Column(
      children: <Widget>[

        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(5),
          child:
          TextField(
            readOnly: true,
            controller: txt_date,
            decoration: InputDecoration(
                label: Text("Application Date"),
                hintText: "Application Date",
                prefixIcon: Icon(Icons.date_range),
                border: OutlineInputBorder()
            ),
          ),

        ),

        Container(
          padding: EdgeInsets.all(5),
          child: DropdownButtonFormField(

            hint: Text('Medical Claim Type'), // Not necessary for Option 1
            value: _selectedLocation,
            decoration: InputDecoration(
                label: Text("Medical Claim Type"),
                hintText: "Medical Claim Type",
                prefixIcon: Icon(Icons.account_circle_outlined),
                border: OutlineInputBorder()
            ),
            onChanged:showWidget==true?null: (value) {
              //DialogBuilder(context).showLoadingIndicator('Calculating');
              // setState(() {txt_code.text = value.toString()
              // )
              setState(() {
                if(UserSharedPreferences.getBasicPay().toString()=="")
                {
                  Fluttertoast.showToast(msg: "Basic Pay is empty error: Financial details are not maintained,kindly contact HR",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red);
                }
                else
                {
                  getRequest((EncryptData.fiscalyear(DateTime.now().year, DateTime.now().month)).toString());
                  txt_code.text = value.toString();
                  _selectedLocation = value.toString();
                  onRemoveAll_Hospitalization();
                  onRemoveAll_Non_Hospitalization();
                  showWidget2=false;
                  showWidget3 = false;
                  showWidget4=false;
                }
                //UserSharedPreferences.cleartotcgshclaim();
              });
              // DialogBuilder(context).hideOpenDialog();
            },
            items: <String>['Hospitalization Reimbursement', 'Non-Hospitalization Reimbursement']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // items: _myJson!.map((Map map) {
            //   return new DropdownMenuItem<String>(
            //     value: map["country"].toString(),
            //     child: new Text(
            //       map["country"],
            //     ),
            //   );
            // }).toList(),
          ),
        ),

        txt_code.text=="Non-Hospitalization Reimbursement"?

        Container(

          padding: EdgeInsets.all(5),
          child: DropdownButtonFormField(
            // validator: (value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please select the Fiscal Year';
            //   }
            //   return null;
            //
            // },
            hint: Text('Fiscal Year'), // Not necessary for Option 1
            value: _selectedLocation1,
            decoration: InputDecoration(
                label: Text("Fiscal Year"),
                hintText: "Fiscal Year",
                prefixIcon: Icon(Icons.account_circle_outlined),
                border: OutlineInputBorder()
            ),

            onChanged:showWidget==true?null: (value) {

              setState(() async {

                txt_year.text = value.toString();
                _selectedLocation1=value.toString();
                getRequest(txt_year.text);
                //  this.selectedCityId = states.singleWhere((x) => x.stateId == newStateId).cities[0].cityId; // set to first city for this state
                // this.selectedStateId = = newStateId;
              });

            }
            ,
            items: <String>[year.toString(), year1.toString()]
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            // items: _myJson!.map((Map map) {
            //   return new DropdownMenuItem<String>(
            //     value: map["country"].toString(),
            //     child: new Text(
            //       map["country"],
            //     ),
            //   );
            // }).toList(),
          ),
        ):
        Container(),


        // ListView.builder(
        //     physics: NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //           //shrinkWrap: true,
        //
        //           itemCount: contactForms.length,
        //           itemBuilder: (_, index) {
        //             return contactForms[index];
        //           }
        // ),
        txt_code.text=="Non-Hospitalization Reimbursement"?
        contactForms.isNotEmpty
            ?

        ListView.builder(
            shrinkWrap: true,
            // physics: ScrollPhysics(),
            physics: NeverScrollableScrollPhysics(),
            itemCount: contactForms.length,
            itemBuilder: (_, index) {
              return contactForms[index];
            }

        )
            : Container()
            :
        contactForms1.isNotEmpty
            ?
//Container(
  //child:
        ListView.builder(

      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: contactForms1.length,
      itemBuilder: (_, index) {
        return contactForms1[index];
      }

  )
//)

            : Container(),
        1==2 ?

        Container(

          child: Center(
              child:SizedBox.fromSize(
                size: Size(100, 56), // button width and height

                child: Material(
                  // color: Colors.orange, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      showWidget1 = true;

                      if(txt_code.text=="Non-Hospitalization Reimbursement")
                        onAdd();
                      else
                        onAdd1();
                    }, // button pressed
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add_circle_outline,color: Colors.lightBlue.shade900,), // icon
                        Text("Add Form",style: TextStyle(color: Colors.lightBlue.shade900),), // text
                      ],
                    ),
                  ),
                ),

              )

          ),
        )
               :

        Container()
        ,





        txt_code.text!="" && txt_code.text=="Non-Hospitalization Reimbursement"?
        Column(
          children: [

            Container(

              padding: EdgeInsets.all(5),
              child:
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Value is required';
                  }
                  return null;

                },

                readOnly: true,
                controller: txt_ELIGIBLE_AMT,
                decoration: InputDecoration(
                    label: Text("Max Eligible Amount",),
                    hintText: "Max Eligible Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder(

                    )
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Value is required';
                  }
                  return null;

                },
                readOnly: true,
                controller: txt_CLAIMED_AMT,
                decoration: InputDecoration(
                    label: Text("Total Claimed Amount"),
                    hintText: "Total Claimed Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Value is required';
                  }
                  return null;

                },
                readOnly: true,
                controller: txt_entitled,
                decoration: InputDecoration(
                    label: Text("Entitled Amount"),
                    hintText: "Entitled Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),





          ],
        )
            :
        Container(),
        showWidget?
        ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),

          children: [

            Container(
              padding: EdgeInsets.all(5),
              child:
              TextField(
                readOnly: true,
                // initialValue: UserSharedPreferences.gettotcgshclaim(),
                controller: txt_totalcgshclaim,
                decoration: InputDecoration(
                    label: Text("Total CGSH/Govt/Empanelled Claim Amount"),
                    hintText: "Total CGSH/Govt/Empanelled Claim Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),

              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextField(

                readOnly: true,
                controller: txt_totalnonclaim,
                decoration: InputDecoration(
                    label: Text("Total Non-Empanelled/Others Hospital Claim Amount"),
                    hintText: "Total Non-Empanelled/Others Hospital Claim Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextField(

                readOnly: true,
                controller: txt_totalclaim,
                decoration: InputDecoration(
                    label: Text("Total Amount Claim"),
                    hintText: "Total Amount Claim",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(

                readOnly: true,
                controller: txt_totalcgshapprove,
                decoration: InputDecoration(
                    label: Text("Approved CGSH/Govt/Empanelled Hospital Claim Amount"),
                    hintText: "Approved CGSH/Govt/Empanelled Hospital Claim Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(

                readOnly: true,
                controller: txt_totalnonapprove,
                decoration: InputDecoration(
                    label: Text("Approved Non-Empanelled/Others Hospital Claim Amount"),
                    hintText: "Approved Non-Empanelled/Others Hospital Claim Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(

                readOnly: true,
                controller: txt_totalapprove,
                decoration: InputDecoration(
                    label: Text("Total Sum of Approved Amount"),
                    hintText: "Total Sum of Approved Amount",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(

                readOnly: true,
                controller: txt_totaltax,
                decoration: InputDecoration(
                    label: Text("Total Tax to be paid"),
                    hintText: "Total Tax to be paid",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(

                readOnly: true,
                controller: txt_total,
                decoration: InputDecoration(
                    label: Text("Total Amount to be Reimbursed"),
                    hintText: "Total Amount to be Reimbursed",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
// Container(
//   padding: EdgeInsets.all(5),
//   child:
//   CheckboxListTile(
//     title: Text("Submitted for approval of time barred claim beyond 3 months but within 01 years from date of completion of the treatment as the delay in submission of the claim is beyond of the employee's control.",style:TextStyle(fontSize: 10) ,textAlign: TextAlign.justify),
//     value: rememberMe,
//     onChanged: (newValue) {
//       setState(() {
//         rememberMe = newValue!;
//       });
//     },
//     controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//   )
// ),
            Container(
                padding: EdgeInsets.all(5),
                child:
                CheckboxListTile(

                  title: Text("The bills/vouchers are being claimed by me in terms of SJVN Rules. All the information is true and all the bills uploaded are genuine. In case of false claim, I authorise SJVN to deduct/adjust the penalty amount (twice the amount paid against the false claim) from any dues payable to undersigned.",style:TextStyle(fontSize: 10) ,textAlign: TextAlign.justify),
                  value: true,
                  onChanged:showWidget==true?null: (newValue) {
                    setState(() {
                      rememberMe1 = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                )
            ),
            Container(
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
              ),

              child: Text("Comment Section",textAlign: TextAlign.center,  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Value is required';
                //   }
                //   return null;
                //
                // },
                readOnly: true,
                // initialValue: UserSharedPreferences.getProfileName().toString(),
                controller: txt_from,
                decoration: InputDecoration(
                    label: Text("From"),
                    hintText: "From",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return 'Value is required';
                //   }
                //   return null;
                //
                // },
                readOnly: true,
                controller: txt_to,
                decoration: InputDecoration(
                    label: Text("To"),
                    hintText: "To",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                    border: OutlineInputBorder()
                ),
              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Comment is mandatory';
                  }
                  return null;

                },
                readOnly: showWidget==true?true:false,
                controller: txt_comment,
                maxLength: 250,
                keyboardType: TextInputType.multiline,
                minLines: 5,//Normal textInputField will be displayed
                maxLines: 10,// when user presses enter it will adapt to it
                decoration:showWidget==false? InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),

                  border: OutlineInputBorder(),
                  hintText: "Comment of Retiree employee",
                  labelText: "Comment of Retiree employee",
                )
                    :
                InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                  border: OutlineInputBorder(),
                  hintText: "Comment of Retiree employee",
                  labelText: "Comment of Retiree employee",
                  filled: true,

                  fillColor: Colors.blue.shade50,
                )
                ,



              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(

                readOnly: true,
                controller: txt_comment1,
                maxLength: 250,
                keyboardType: TextInputType.multiline,
                minLines: 5,//Normal textInputField will be displayed
                maxLines: 10,// when user presses enter it will adapt to it
                decoration:InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),

                  border: OutlineInputBorder(),
                  hintText: "Comment of finance 1",
                  labelText: "Comment of finance 1",
                    filled: true,

                    fillColor: Colors.blue.shade50,

                )

                ,



              ),

            ),
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(

                readOnly: true,
                controller: txt_comment2,
               maxLength: 250,
                keyboardType: TextInputType.multiline,
                minLines: 5,//Normal textInputField will be displayed
                maxLines: 10,// when user presses enter it will adapt to it
                decoration:InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),

                  border: OutlineInputBorder(),
                  hintText: "Comment of finance 2",
                  labelText: "Comment of finance 2",
                  filled: true,

                  fillColor: Colors.blue.shade50,

                )

                ,



              ),

            ),
            showWidget==true?
            Container():
            Container(
              padding: EdgeInsets.all(5),
              child:
              TextFormField(
                  controller: txt_document,
                  readOnly: true,


                  decoration: InputDecoration(
                      label: Text("Uploaded Document : Max File Size(30MB)"),
                      hintText: "Uploaded Document : Max File Size(30MB)",
                      //prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kindly upload the attachments';
                    }
                    return null;

                  }
              ),

            ),
            showWidget==true?
                Container(
                  child: TextButton.icon(
                    onPressed:()async{
                      String fn=file_name.toString();
                      //print("object_file"+fn);
                      String bs4str = file_data.toString();
                      print("object_file"+bs4str);
                      await FileProcess.downloadFile(bs4str,fn);
                    },
                    icon:Icon(Icons.download_for_offline),
                    label: Text("Download File"),
                    //  color: Colors.deepOrangeAccent,
                    // colorBrightness: Brightness.dark,

                  ),
                ):
            Container(
              child: TextButton.icon(
                onPressed:loadImage,
                icon:Icon(Icons.folder_open),
                label: Text("Browse Document"),
                //  color: Colors.deepOrangeAccent,
                // colorBrightness: Brightness.dark,

              ),
            ),

          ],
        )

            :
        Container(),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showWidget==true && showEdit==true?
            Container(

              child:ElevatedButton.icon(onPressed: (){
                showAlertDialog("Confirmation","Do you want continue?");
              }, icon:Icon(Icons.save), label: Text("Submit  ")),
            )
            :
                Container(),
            Container(
              width: 10,
            ),
            showWidget1==true?
                showEdit==false?
            Container(

              child:ElevatedButton.icon(
                  onPressed: () async {
                    if(txt_code.text=="Non-Hospitalization Reimbursement")
                    {
                      // setState(() {
                      //   showWidget = true;
                      //
                      // });

                    await  onCaluclate_Non_Hospitalization();

                    }

                    else
                    {

                   await   onCaluclate_Hospitalization();
                  // await on_Hospitalization();

                    }
                  },
                  icon:Icon(Icons.calculate), label: Text("Calculate")),
            )
                :
                Container(

                  child:ElevatedButton.icon(
                      onPressed: () async {
                        if(txt_code.text=="Non-Hospitalization Reimbursement")
                        {
                          setState(() {
                            showEdit=false;
                          });
                          bool allValid=true;
                          contactForms.forEach((element) =>
                          allValid = (allValid && element.isValidated1()));

                        }

                        else
                        {
                          setState(() {
                            showEdit=false;
                          });
                          bool allValid=true;
                          contactForms1.forEach((element) =>
                          allValid = (allValid && element.isValidated1()));



                        }
                      },
                      icon:Icon(Icons.edit_rounded), label: Text("Edit Record")),
                )
                :
                Container()

          ],
        ),
        showWidget==true && showEdit==true?
        Container(

          child:ElevatedButton.icon(
              onPressed: (){
                if(txt_code.text=="Non-Hospitalization Reimbursement")
                  onSaveAs_Non_Hospitalization();
                else
                {
                  onSaveAs_Hospitalization();
                }
              },
              icon:Icon(Icons.save), label: Text("Save as Draft")),
        ):
            Container(),
        SizedBox(
          height: 25,
        )
      ],
    ),
  ),
)







    );
  }
  onCaluclate_Non_Hospitalization() async
  {
    // if(rememberMe1==false)
    //   {
    //     Fluttertoast.showToast(
    //
    //         msg: "Kindly accept the declaration", toastLength: Toast
    //         .LENGTH_LONG, backgroundColor: Colors.red);
    //     return;
    //   }
    if (_selectedLocation1 == "") {
      Fluttertoast.showToast(

          msg: "Fiscal Year is required", toastLength: Toast
          .LENGTH_LONG, backgroundColor: Colors.red);
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {

        // txt_totalclaim.text = "0".toString();
        // txt_totalcgshclaim.text = "0".toString();
        // txt_totalnonclaim.text =
        //     "0".toString();
        // txt_totalcgshapprove.text = "0".toString();
        // txt_totalnonapprove.text =
        //     "0".toString();
        // txt_totalapprove.text = "0".toString();
        // txt_totaltax.text = "0".toString();
        // txt_total.text = "0".toString();
        String? st = "";
        bool allValid = true;
        EncryptData ed = new EncryptData();
        contactForms.forEach((element) =>
        allValid = (allValid && element.isValidated()));
        if (contactForms.length == 0) {
          Fluttertoast.showToast(

              msg: "Claim details is mandatory", toastLength: Toast
              .LENGTH_LONG, backgroundColor: Colors.red);
          return;
        }
        if (allValid) {
          DialogBuilder(context).showLoadingIndicator('Calculating');
          for (int k = 0; k < contactForms.length; k++) {
            st = st! + '{' +
                '"APPLYING_FOR": "' +
                contactForms[k].APPLYING_FORController.text + '",' +
                '"PATIENT_NAME": "' +
                contactForms[k].PATIENT_NAMEController.text + '",' +
                '"CARD_NO": "' + contactForms[k].CARD_NOController.text + '",' +
                '"HOSPITAL_TYPE": "' +
                contactForms[k].HOSPITAL_TYPEController.text + '",' +
                '"DOCTOR_NAME": "' +
                contactForms[k].DOCTOR_NAMEController.text + '",' +
                '"TREATMENT_STATUS": "' +
                contactForms[k].TREATMENT_STATUSController.text + '",' +
                '"CONSULT_DATE": "' +
                contactForms[k].CONSULT_DATEController.text + '",' +
                '"CASH_MEMO_NO": "' +
                contactForms[k].CASH_MEMO_NOController.text + '",' +
                '"CASH_MEMO_DATE": "' + contactForms[k].CASH_MEMO_DATEController
                .text + '",' +
                '"CLAIMED_CONSULTATION_CHARGE": "' +
                contactForms[k].CLAIMED_CONSULTATION_CHARGEController.text +
                '",' +
                '"APPROVED_CONSULTATION_CHARGE": "' +
                contactForms[k].APPROVED_CONSULTATION_CHARGEController.text +
                '",' +
                '"CLAIMED_INJECT_CHARGE": "' +
                contactForms[k].CLAIMED_INJECT_CHARGEController.text + '",' +
                '"APPROVED_INJECT_CHARGE": "' +
                contactForms[k].APPROVED_INJECT_CHARGEController.text + '",' +
                '"CLAIMED_MEDI_COST": "' +
                contactForms[k].CLAIMED_MEDI_COSTController.text + '",' +
                '"APPROVED_MEDI_COST": "' +
                contactForms[k].APPROVED_MEDI_COSTController.text + '",' +
                '"CLAIMED_PATH_CHARGE": "' +
                contactForms[k].CLAIMED_PATH_CHARGEController.text + '",' +
                '"APPROVED_PATH_CHARGE": "' +
                contactForms[k].APPROVED_PATH_CHARGEController.text + '",' +
                '"GL": "' + contactForms[k].GL_CHARGEController.text + '"' +
                '},';
          }

          String? kl1 = '{"method" : "medicalClaimSaveData",' +
              '"data":{' +
              '"MED_CLAIM_TYPE": "Non-Hospitalization Reimbursement",' +
              '"USERID": "' + UserSharedPreferences.getUsername().toString() +
              '",' +
              '"BUTTON": "C",' +
              '"RECEIVER_ID": "' + txt_to_id.text + '",' +
              '"COMMENT_USER": "' + txt_comment.text + '",' +
              '"THREE_MONTHS": "",' +
              '"FISCAL_YEAR": "' + _selectedLocation1! + '",' +
              '"REQ_NO": "",' +
              '"ENTITLED_AMOUNT": "' + txt_entitled.text + '",' +
              '"TOTAL_CLAIMED_AMOUNT": "' + txt_CLAIMED_AMT.text + '",' +
              '"MAX_ELIGIBLE_AMOUNT": "' + txt_ELIGIBLE_AMT.text + '"' +

              '},"nonHospital":[' +
              st!.substring(0, st!.length - 1)! +

              '],' +
              '"attachment": [],' +
              '"hospital": []' +
              '}'
          ;

          String? kl = ed.encryptData(kl1);
          var link = ed.geturl();
          var requestbody = '''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
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

          //print("paas_"+response.statusCode.toString());
          if (response.statusCode == 200) {
            var xmldata = response.body;

            var contact = xml.XmlDocument.parse(xmldata);

            var result = contact
                .findAllElements('return')
                .first
                .text
                .toString();
            // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
            // EncryptData.encryptAES(xmldata);

            var data = ed.decryptAES(result);

            var res = jsonDecode(data);
            print("paas" + res.toString());

            if (res["STATUS"] == "S") {
              // txt_totalclaim.text = res["TOTAL_AMOUNT_CLAIM"].toString();
              // txt_totalcgshclaim.text = res["TOTAL_CGHS_CLAIM"].toString();
              // txt_totalnonclaim.text =
              //     res["TOTAL_NON_IMPANELED_CLAIM"].toString();
              // txt_totalcgshapprove.text = res["APPROVED_CGHS_CLAIM"].toString();
              // txt_totalnonapprove.text =
              //     res["APPROVED_NON_IMPANELED_CLAIM"].toString();
              // txt_totalapprove.text = res["APPROVED_AMOUNT_CLAIM"].toString();
              // txt_totaltax.text = res["TAX_AMOUNT"].toString();
              // txt_total.text = res["PAID_AMOUNT"].toString();
              txt_totalclaim.text = res["TOTAL_AMOUNT_CLAIM"].toString();
              txt_totalcgshclaim.text = res["TOTAL_IMPANELED_CLAIM"].toString();
              txt_totalnonclaim.text =
                  res["TOTAL_NON_IMPANELED_CLAIM"].toString();
              txt_totalcgshapprove.text = res["APPROVED_IMPANELED_CLAIM"].toString();
              txt_totalnonapprove.text =
                  res["APPROVED_NON_IMPANELED_CLAIM"].toString();
              //txt_totalapprove.text = res["APPROVED_AMOUNT_CLAIM"].toString();
              txt_totaltax.text = res["TAX_AMOUNT"].toString();
              txt_total.text = res["PAID_AMOUNT"].toString();
              setState(() {
                showWidget = true;
                showEdit=true;

              });

              DialogBuilder(context).hideOpenDialog();
            }
            else {
              Fluttertoast.showToast(

                  msg: "Error: " + res["ERROR"], toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              DialogBuilder(context).hideOpenDialog();
            }
          }
         // if(showWidget3==false)
          //  DialogBuilder(context).hideOpenDialog();
        }
      }
      on Exception catch (_) {
       // if(showWidget3==false)
          DialogBuilder(context).hideOpenDialog();
      }
    }
  }

  onCaluclate_Hospitalization() async
  {

    print("paas_cal");


   // _selectedLocation1=(DateTime.now().year-1).toString();

   // if (1==1) {

      try {


        String? st = "";
        bool allValid = true;
        EncryptData ed = new EncryptData();
        contactForms1.forEach((element) =>
        allValid = (allValid && element.isValidated()));
        if (contactForms1.length == 0) {
          Fluttertoast.showToast(

              msg: "Claim details is mandatory", toastLength: Toast
              .LENGTH_LONG, backgroundColor: Colors.red);
          return;
        }
        if (allValid) {
          DialogBuilder(context).showLoadingIndicator('Calculating');
          for (int k = 0; k < contactForms1.length; k++) {
           // setState(() {
            //  contactForms1[k].crt_visible=false;
            //});

            st = st! + '{' +
                '"APPLYING_FOR": "' +
                contactForms1[k].APPLYING_FORController.text + '",' +
                '"PATIENT_NAME": "' +
                contactForms1[k].PATIENT_NAMEController.text + '",' +
                '"CARD_NO": "' + contactForms1[k].CARD_NOController.text +
                '",' +
                '"HOSPITAL_TYPE": "' +
                contactForms1[k].HOSPITAL_TYPEController.text + '",' +
                '"HOSPITAL_NAME": "' +
                contactForms1[k].HOSPITAL_NAMEController.text + '",' +
                '"TREATMENT_STATUS": "' +
                contactForms1[k].TREATMENT_STATUSController.text + '",' +
                '"DATE_FROM": "' +
                contactForms1[k].DATE_FROMController.text + '",' +
                '"DATE_TO": "' +
                contactForms1[k].DATE_TOController.text + '",' +
                '"CLAIMED_ROOM_CHARGES": "' +
                contactForms1[k].CLAIMED_ROOM_CHARGESController.text + '",' +
                '"APPROVED_ROOM_CHARGES": "' +
                contactForms1[k].APPROVED_ROOM_CHARGESController.text + '",' +
                '"CLAIMED_OTHER_CHARGES": "' +
                contactForms1[k].CLAIMED_OTHER_CHARGESController.text + '",' +
                '"APPROVED_OTHER_CHARGES": "' +
                contactForms1[k].APPROVED_OTHER_CHARGESController.text + '",' +
                '"CLAIMED_COST_OF_MEDICINE": "' +
                contactForms1[k].CLAIMED_COST_OF_MEDICINEController.text +
                '",' +
                '"APPROVED_COST_OF_MEDICINE": "' +
                contactForms1[k].APPROVED_COST_OF_MEDICINEController.text +
                '",' +
                '"CLAIMED_SURGICAL_CHARGES": "' +
                contactForms1[k].CLAIMED_SURGICAL_CHARGESController.text +
                '",' +
                '"APPROVED_SURGICAL_CHARGES": "' +
                contactForms1[k].APPROVED_SURGICAL_CHARGESController.text +
                '",' +
                '},';
          }


          String? kl1 = '{"method" : "medicalClaimSaveData",' +
              '"data":{' +
              '"MED_CLAIM_TYPE": "Hospitalization Reimbursement",' +
              '"USERID": "' + UserSharedPreferences.getUsername().toString() +
              '",' +
              '"BUTTON": "C",' +
              '"RECEIVER_ID": "' + txt_to_id.text + '",' +
              '"COMMENT_USER": "' + txt_comment.text + '",' +
              '"THREE_MONTHS": "",' +
              '"FISCAL_YEAR": "' + _selectedLocation1! + '",' +
              '"REQ_NO": "",' +
              '"ENTITLED_AMOUNT": "",' +
              '"TOTAL_CLAIMED_AMOUNT": "",' +
              '"MAX_ELIGIBLE_AMOUNT": ""' +

              '},"hospital":[' +
              st!.substring(0, st!.length - 1)! +

              '],' +
              '"attachment": [],' +
              '"nonHospital": []' +
              '}'
          ;
          print("object_cal"+kl1.toString());
          // REQ1000000157
          String? kl = ed.encryptData(kl1);
          var link = ed.geturl();
          var requestbody = '''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
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

            var contact = xml.XmlDocument.parse(xmldata);

            var result = contact
                .findAllElements('return')
                .first
                .text
                .toString();
            // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
            // EncryptData.encryptAES(xmldata);

            var data = ed.decryptAES(result);

            var res = jsonDecode(data);
            print("paas" + res.toString());

            if (res["STATUS"] == "S") {
              setState(() {
                txt_totalclaim.text = res["TOTAL_AMOUNT_CLAIM"].toString();
                txt_totalcgshclaim.text = res["TOTAL_IMPANELED_CLAIM"].toString();
                txt_totalnonclaim.text =
                    res["TOTAL_NON_IMPANELED_CLAIM"].toString();
                txt_totalcgshapprove.text = res["APPROVED_IMPANELED_CLAIM"].toString();
                txt_totalnonapprove.text =
                    res["APPROVED_NON_IMPANELED_CLAIM"].toString();
                txt_totalapprove.text = res["APPROVED_AMOUNT_CLAIM"].toString();
                txt_totaltax.text = res["TAX_AMOUNT"].toString();
                txt_total.text = res["PAID_AMOUNT"].toString();
                setState(() {
                  showWidget = true;
                  showEdit=true;


                });
                DialogBuilder(context).hideOpenDialog();

              });


            }
            else {
              Fluttertoast.showToast(

                  msg: "Error: " + res["ERROR"], toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              DialogBuilder(context).hideOpenDialog();

              // return;
            }
          }
        // if(showWidget2==false)
        //   DialogBuilder(context).hideOpenDialog();
        }
      }
      on Exception catch (_) {
       // if(showWidget2==false)
          DialogBuilder(context).hideOpenDialog();
      }
   // }
  }

  onSave_Non_Hospitalization() async
  {
print("object_total_"+txt_totalclaim.text);
    if (_selectedLocation1 == "") {
      Fluttertoast.showToast(

          msg: "Fiscal Year is required", toastLength: Toast
          .LENGTH_LONG, backgroundColor: Colors.red);
      return;
    }
    if(txt_total.text=="0")
    {
      Fluttertoast.showToast(

          msg: "Total claim amount cannot be zero", toastLength: Toast
          .LENGTH_LONG, backgroundColor: Colors.red);
      return;
    }
    if(rememberMe1==false)
    {
      Fluttertoast.showToast(

          msg: "Kindly accept the declaration", toastLength: Toast
          .LENGTH_LONG, backgroundColor: Colors.red);
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
      //  DialogBuilder(context).showLoadingIndicator('Calculating');
        print("object_file_"+baseimage.toString());
        String? st = "";
        bool allValid = true;
        EncryptData ed = new EncryptData();
        contactForms.forEach((element) =>
        allValid = (allValid && element.isValidated()));
        if (allValid) {
          for (int k = 0; k < contactForms.length; k++) {
            st = st! + '{' +
                '"APPLYING_FOR": "' +
                contactForms[k].APPLYING_FORController.text + '",' +
                '"PATIENT_NAME": "' +
                contactForms[k].PATIENT_NAMEController.text + '",' +
                '"CARD_NO": "' + contactForms[k].CARD_NOController.text + '",' +
                '"HOSPITAL_TYPE": "' +
                contactForms[k].HOSPITAL_TYPEController.text + '",' +
                '"DOCTOR_NAME": "' +
                contactForms[k].DOCTOR_NAMEController.text + '",' +
                '"TREATMENT_STATUS": "' +
                contactForms[k].TREATMENT_STATUSController.text + '",' +
                '"CONSULT_DATE": "' +
                contactForms[k].CONSULT_DATEController.text + '",' +
                '"CASH_MEMO_NO": "' +
                contactForms[k].CASH_MEMO_NOController.text + '",' +
                '"CASH_MEMO_DATE": "' + contactForms[k].CASH_MEMO_DATEController
                .text + '",' +
                '"CLAIMED_CONSULTATION_CHARGE": "' +
                contactForms[k].CLAIMED_CONSULTATION_CHARGEController.text +
                '",' +
                '"APPROVED_CONSULTATION_CHARGE": "' +
                contactForms[k].APPROVED_CONSULTATION_CHARGEController.text +
                '",' +
                '"CLAIMED_INJECT_CHARGE": "' +
                contactForms[k].CLAIMED_INJECT_CHARGEController.text + '",' +
                '"APPROVED_INJECT_CHARGE": "' +
                contactForms[k].APPROVED_INJECT_CHARGEController.text + '",' +
                '"CLAIMED_MEDI_COST": "' +
                contactForms[k].CLAIMED_MEDI_COSTController.text + '",' +
                '"APPROVED_MEDI_COST": "' +
                contactForms[k].APPROVED_MEDI_COSTController.text + '",' +
                '"CLAIMED_PATH_CHARGE": "' +
                contactForms[k].CLAIMED_PATH_CHARGEController.text + '",' +
                '"APPROVED_PATH_CHARGE": "' +
                contactForms[k].APPROVED_PATH_CHARGEController.text + '",' +
                '"GL": "' + contactForms[k].GL_CHARGEController.text + '"' +
                '},';
          }

          String? kl1 = '{"method" : "medicalClaimSaveData",' +
              '"data":{' +
              '"MED_CLAIM_TYPE": "Non-Hospitalization Reimbursement",' +
              '"USERID": "' + UserSharedPreferences.getUsername().toString() +
              '",' +
              '"BUTTON": "I",' +
              '"RECEIVER_ID": "' + txt_to_id.text + '",' +
              '"COMMENT_USER": "' + txt_comment.text + '",' +
              '"THREE_MONTHS": "",' +
              '"FISCAL_YEAR": "' + _selectedLocation1! + '",' +
              '"REQ_NO": "",' +
              '"ENTITLED_AMOUNT": "' + txt_entitled.text + '",' +
              '"TOTAL_CLAIMED_AMOUNT": "' + txt_CLAIMED_AMT.text + '",' +
              '"MAX_ELIGIBLE_AMOUNT": "' + txt_ELIGIBLE_AMT.text + '"' +

              '},"nonHospital":[' +
              st!.substring(0, st!.length - 1)! +

              '],' +
              '"attachment": ['+
              '{'+
              '"DATA": "'+baseimage!+'",'+
              '"FILENAME": "'+progress.toString()+'"'+
              '}'+
              '],' +
              '"hospital": []' +
              '}'
          ;
          print("object_print_"+kl1);
          String? kl = ed.encryptData(kl1);
          var link = ed.geturl();
          var requestbody = '''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
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

          //print("paas_"+response.statusCode.toString());
          if (response.statusCode == 200) {
            var xmldata = response.body;

            var contact = xml.XmlDocument.parse(xmldata);

            var result = contact
                .findAllElements('return')
                .first
                .text
                .toString();
            // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
            // EncryptData.encryptAES(xmldata);

            var data = ed.decryptAES(result);

            var res = jsonDecode(data);
            print("paas" + res.toString());

            if (res["STATUS"] == "S") {
              // setState(() {
              //   showWidget4=true;
              // });

              Fluttertoast.showToast(

                  msg: "Your record saved successfully.Your REQUEST ID is "+res["REQUEST_ID"].toString(), toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              DialogBuilder(context).hideOpenDialog();
          reset_Non_Hospitalization();
            }
            else {
              Fluttertoast.showToast(

                  msg: "Error: " + res["ERROR"], toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
             // DialogBuilder(context).hideOpenDialog();
              // return;
            }
          }
          //DialogBuilder(context).hideOpenDialog();
        }
      }
      on Exception catch (_) {
        DialogBuilder(context).hideOpenDialog();
      }
    }
  }
  onSave_Hospitalization() async
  {
    print("object_total_"+txt_totalclaim.text);
    _selectedLocation1=(DateTime.now().year-1).toString();
    if (_selectedLocation1 == "") {
      Fluttertoast.showToast(

          msg: "Fiscal Year is required", toastLength: Toast
          .LENGTH_LONG, backgroundColor: Colors.red);
      return;
    }
    if(txt_total.text=="0")
    {
      Fluttertoast.showToast(

          msg: "Total claim amount cannot be zero", toastLength: Toast
          .LENGTH_LONG, backgroundColor: Colors.red);
      return;
    }
    if(rememberMe1==false)
    {
      Fluttertoast.showToast(

          msg: "Kindly accept the declaration", toastLength: Toast
          .LENGTH_LONG, backgroundColor: Colors.red);
      return;
    }
    if (_formKey.currentState!.validate()) {
      try {
       // DialogBuilder(context).showLoadingIndicator('Calculating');
        print("object_file_"+baseimage.toString());
        String? st = "";
        bool allValid = true;
        EncryptData ed = new EncryptData();
        contactForms1.forEach((element) =>
        allValid = (allValid && element.isValidated()));
        if (allValid) {
          DialogBuilder(context).showLoadingIndicator('Calculating');
          for (int k = 0; k < contactForms1.length; k++) {
            st = st! + '{' +
                '"APPLYING_FOR": "' +
                contactForms1[k].APPLYING_FORController.text + '",' +
                '"PATIENT_NAME": "' +
                contactForms1[k].PATIENT_NAMEController.text + '",' +
                '"CARD_NO": "' + contactForms1[k].CARD_NOController.text +
                '",' +
                '"HOSPITAL_TYPE": "' +
                contactForms1[k].HOSPITAL_TYPEController.text + '",' +
                '"HOSPITAL_NAME": "' +
                contactForms1[k].HOSPITAL_NAMEController.text + '",' +
                '"TREATMENT_STATUS": "' +
                contactForms1[k].TREATMENT_STATUSController.text + '",' +
                '"DATE_FROM": "' +
                contactForms1[k].DATE_FROMController.text + '",' +
                '"DATE_TO": "' +
                contactForms1[k].DATE_TOController.text + '",' +
                '"CLAIMED_ROOM_CHARGES": "' +
                contactForms1[k].CLAIMED_ROOM_CHARGESController.text + '",' +
                '"APPROVED_ROOM_CHARGES": "' +
                contactForms1[k].APPROVED_ROOM_CHARGESController.text + '",' +
                '"CLAIMED_OTHER_CHARGES": "' +
                contactForms1[k].CLAIMED_OTHER_CHARGESController.text + '",' +
                '"APPROVED_OTHER_CHARGES": "' +
                contactForms1[k].APPROVED_OTHER_CHARGESController.text + '",' +
                '"CLAIMED_COST_OF_MEDICINE": "' +
                contactForms1[k].CLAIMED_COST_OF_MEDICINEController.text +
                '",' +
                '"APPROVED_COST_OF_MEDICINE": "' +
                contactForms1[k].APPROVED_COST_OF_MEDICINEController.text +
                '",' +
                '"CLAIMED_SURGICAL_CHARGES": "' +
                contactForms1[k].CLAIMED_SURGICAL_CHARGESController.text +
                '",' +
                '"APPROVED_SURGICAL_CHARGES": "' +
                contactForms1[k].APPROVED_SURGICAL_CHARGESController.text +
                '"' +
                '},';
          }
          print("object_" + st.toString());

          String? kl1 = '{"method" : "medicalClaimSaveData",' +
              '"data":{' +
              '"MED_CLAIM_TYPE": "Hospitalization Reimbursement",' +
              '"USERID": "' + UserSharedPreferences.getUsername().toString() +
              '",' +
              '"BUTTON": "I",' +
              '"RECEIVER_ID": "' + txt_to_id.text + '",' +
              '"COMMENT_USER": "' + txt_comment.text + '",' +
              '"THREE_MONTHS": "",' +
              '"FISCAL_YEAR": "' + _selectedLocation1! + '",' +
              '"REQ_NO": "",' +
              '"ENTITLED_AMOUNT": "",' +
              '"TOTAL_CLAIMED_AMOUNT": "",' +
              '"MAX_ELIGIBLE_AMOUNT": ""' +

              '},"hospital":[' +
              st!.substring(0, st!.length - 1)! +

              '],' +
              '"attachment": ['+
              '{'+
              '"DATA": "'+baseimage!+'",'+
              '"FILENAME": "'+progress.toString()+'"'+
              '}'+
              '],' +
              '"nonHospital": []' +
              '}'
          ;
          print("object_print_"+kl1);
          String? kl = ed.encryptData(kl1);
          var link = ed.geturl();
          var requestbody = '''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
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

          print("paas_code_"+response.body.toString());
          if (response.statusCode == 200) {
            var xmldata = response.body;

            var contact = xml.XmlDocument.parse(xmldata);

            var result = contact
                .findAllElements('return')
                .first
                .text
                .toString();
            // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
            // EncryptData.encryptAES(xmldata);

            var data = ed.decryptAES(result);

            var res = jsonDecode(data);
            print("paas_test_" + res.toString());

            if (res["STATUS"] == "S") {
            // reset_Hospitalization();

              // showAlertDialog1("Confirmation", "Your record saved successfully.Your REQUEST ID is "+res["REQUEST_ID"].toString());
              Fluttertoast.showToast(

                  msg: "Your record saved successfully.Your REQUEST ID is "+res["REQUEST_ID"].toString(), toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              DialogBuilder(context).hideOpenDialog();

           //  Navigator.push(context!, MaterialPageRoute(builder: (context)=>MyMedicalClaim()));
            }
            else {
              Fluttertoast.showToast(

                  msg: "Error: " + res["ERROR"], toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              DialogBuilder(context).hideOpenDialog();
              // return;
            }
          }
         // DialogBuilder(context).hideOpenDialog();
        }
      }
      on Exception catch (_) {
        DialogBuilder(context).hideOpenDialog();
      }
    }
  }

  onSaveAs_Non_Hospitalization() async
  {


   // if (_formKey.currentState!.validate()) {
      try {
        DialogBuilder(context).showLoadingIndicator('Calculating');
print("object_file_"+baseimage.toString());
        String? st = "";
        bool allValid = true;
        EncryptData ed = new EncryptData();
        contactForms.forEach((element) =>
        allValid = (allValid && element.isValidated()));
        if (allValid) {
          for (int k = 0; k < contactForms.length; k++) {
            st = st! + '{' +
                '"APPLYING_FOR": "' +
                contactForms[k].APPLYING_FORController.text + '",' +
                '"PATIENT_NAME": "' +
                contactForms[k].PATIENT_NAMEController.text + '",' +
                '"CARD_NO": "' + contactForms[k].CARD_NOController.text + '",' +
                '"HOSPITAL_TYPE": "' +
                contactForms[k].HOSPITAL_TYPEController.text + '",' +
                '"DOCTOR_NAME": "' +
                contactForms[k].DOCTOR_NAMEController.text + '",' +
                '"TREATMENT_STATUS": "' +
                contactForms[k].TREATMENT_STATUSController.text + '",' +
                '"CONSULT_DATE": "' +
                contactForms[k].CONSULT_DATEController.text + '",' +
                '"CASH_MEMO_NO": "' +
                contactForms[k].CASH_MEMO_NOController.text + '",' +
                '"CASH_MEMO_DATE": "' + contactForms[k].CASH_MEMO_DATEController
                .text + '",' +
                '"CLAIMED_CONSULTATION_CHARGE": "' +
                contactForms[k].CLAIMED_CONSULTATION_CHARGEController.text +
                '",' +
                '"APPROVED_CONSULTATION_CHARGE": "' +
                contactForms[k].APPROVED_CONSULTATION_CHARGEController.text +
                '",' +
                '"CLAIMED_INJECT_CHARGE": "' +
                contactForms[k].CLAIMED_INJECT_CHARGEController.text + '",' +
                '"APPROVED_INJECT_CHARGE": "' +
                contactForms[k].APPROVED_INJECT_CHARGEController.text + '",' +
                '"CLAIMED_MEDI_COST": "' +
                contactForms[k].CLAIMED_MEDI_COSTController.text + '",' +
                '"APPROVED_MEDI_COST": "' +
                contactForms[k].APPROVED_MEDI_COSTController.text + '",' +
                '"CLAIMED_PATH_CHARGE": "' +
                contactForms[k].CLAIMED_PATH_CHARGEController.text + '",' +
                '"APPROVED_PATH_CHARGE": "' +
                contactForms[k].APPROVED_PATH_CHARGEController.text + '",' +
                '"GL": "' + contactForms[k].GL_CHARGEController.text + '"' +
                '},';
          }

          String? kl1 = '{"method" : "medicalClaimSaveData",' +
              '"data":{' +
              '"MED_CLAIM_TYPE": "Non-Hospitalization Reimbursement",' +
              '"USERID": "' + UserSharedPreferences.getUsername().toString() +
              '",' +
              '"BUTTON": "S",' +
              '"RECEIVER_ID": "' + txt_to_id.text + '",' +
              '"COMMENT_USER": "' + txt_comment.text + '",' +
              '"THREE_MONTHS": "",' +
              '"FISCAL_YEAR": "' + _selectedLocation1! + '",' +
              '"REQ_NO": "",' +
              '"ENTITLED_AMOUNT": "' + txt_entitled.text + '",' +
              '"TOTAL_CLAIMED_AMOUNT": "' + txt_CLAIMED_AMT.text + '",' +
              '"MAX_ELIGIBLE_AMOUNT": "' + txt_ELIGIBLE_AMT.text + '"' +

              '},"nonHospital":[' +
              st!.substring(0, st!.length - 1)! +

              '],' +
              '"attachment": [],' +
              '"hospital": []' +
              '}'
          ;
print("object_print_"+kl1);
          String? kl = ed.encryptData(kl1);
          var link = ed.geturl();
          var requestbody = '''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
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

          //print("paas_"+response.statusCode.toString());
          if (response.statusCode == 200) {
            var xmldata = response.body;

            var contact = xml.XmlDocument.parse(xmldata);

            var result = contact
                .findAllElements('return')
                .first
                .text
                .toString();
            // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
            // EncryptData.encryptAES(xmldata);

            var data = ed.decryptAES(result);

            var res = jsonDecode(data);
            print("paas" + res.toString());

            if (res["STATUS"] == "S") {
              //DialogBuilder(context).hideOpenDialog();
//showAlertDialog1("Confirmation", "Your "+res["REQUEST_ID"].toString()+" has been saved");
              Fluttertoast.showToast(

                  msg: "Your REQUEST ID is "+res["REQUEST_ID"].toString(), toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              // txt_totalclaim.text = res["TOTAL_AMOUNT_CLAIM"].toString();
              // txt_totalcgshclaim.text = res["TOTAL_CGHS_CLAIM"].toString();
              // txt_totalnonclaim.text =
              //     res["TOTAL_NON_IMPANELED_CLAIM"].toString();
              // txt_totalcgshapprove.text = res["APPROVED_CGHS_CLAIM"].toString();
              // txt_totalnonapprove.text =
              //     res["APPROVED_NON_IMPANELED_CLAIM"].toString();
              // txt_totalapprove.text = res["APPROVED_AMOUNT_CLAIM"].toString();
              // txt_totaltax.text = res["TAX_AMOUNT"].toString();
              // txt_total.text = res["PAID_AMOUNT"].toString();
            }
            else {
              Fluttertoast.showToast(

                  msg: "Error: " + res["ERROR"], toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              DialogBuilder(context).hideOpenDialog();
             // return;
            }
          }
          DialogBuilder(context).hideOpenDialog();
        }
      }
      on Exception catch (_) {
        DialogBuilder(context).hideOpenDialog();
      }
    //}
  }
  onSaveAs_Hospitalization() async
  {
_selectedLocation1=(DateTime.now().year-1).toString();

  //  if (_formKey.currentState!.validate()) {
      try {
        DialogBuilder(context).showLoadingIndicator('Calculating');
        print("object_file_"+baseimage.toString());
        String? st = "";
        bool allValid = true;
        EncryptData ed = new EncryptData();
        contactForms1.forEach((element) =>
        allValid = (allValid && element.isValidated()));
        if (allValid) {
          DialogBuilder(context).showLoadingIndicator('Calculating');
          for (int k = 0; k < contactForms1.length; k++) {
            st = st! + '{' +
                '"APPLYING_FOR": "' +
                contactForms1[k].APPLYING_FORController.text + '",' +
                '"PATIENT_NAME": "' +
                contactForms1[k].PATIENT_NAMEController.text + '",' +
                '"CARD_NO": "' + contactForms1[k].CARD_NOController.text +
                '",' +
                '"HOSPITAL_TYPE": "' +
                contactForms1[k].HOSPITAL_TYPEController.text + '",' +
                '"HOSPITAL_NAME": "' +
                contactForms1[k].HOSPITAL_NAMEController.text + '",' +
                '"TREATMENT_STATUS": "' +
                contactForms1[k].TREATMENT_STATUSController.text + '",' +
                '"DATE_FROM": "' +
                contactForms1[k].DATE_FROMController.text + '",' +
                '"DATE_TO": "' +
                contactForms1[k].DATE_TOController.text + '",' +
                '"CLAIMED_ROOM_CHARGES": "' +
                contactForms1[k].CLAIMED_ROOM_CHARGESController.text + '",' +
                '"APPROVED_ROOM_CHARGES": "' +
                contactForms1[k].APPROVED_ROOM_CHARGESController.text + '",' +
                '"CLAIMED_OTHER_CHARGES": "' +
                contactForms1[k].CLAIMED_OTHER_CHARGESController.text + '",' +
                '"APPROVED_OTHER_CHARGES": "' +
                contactForms1[k].APPROVED_OTHER_CHARGESController.text + '",' +
                '"CLAIMED_COST_OF_MEDICINE": "' +
                contactForms1[k].CLAIMED_COST_OF_MEDICINEController.text +
                '",' +
                '"APPROVED_COST_OF_MEDICINE": "' +
                contactForms1[k].APPROVED_COST_OF_MEDICINEController.text +
                '",' +
                '"CLAIMED_SURGICAL_CHARGES": "' +
                contactForms1[k].CLAIMED_SURGICAL_CHARGESController.text +
                '",' +
                '"APPROVED_SURGICAL_CHARGES": "' +
                contactForms1[k].APPROVED_SURGICAL_CHARGESController.text +
                '",' +
                '},';
          }
          print("object_" + st.toString());

          String? kl1 = '{"method" : "medicalClaimSaveData",' +
              '"data":{' +
              '"MED_CLAIM_TYPE": "Hospitalization Reimbursement",' +
              '"USERID": "' + UserSharedPreferences.getUsername().toString() +
              '",' +
              '"BUTTON": "S",' +
              '"RECEIVER_ID": "' + txt_to_id.text + '",' +
              '"COMMENT_USER": "' + txt_comment.text + '",' +
              '"THREE_MONTHS": "",' +
              '"FISCAL_YEAR": "' + _selectedLocation1! + '",' +
              '"REQ_NO": "REQ1000000157",' +
              '"ENTITLED_AMOUNT": "",' +
              '"TOTAL_CLAIMED_AMOUNT": "",' +
              '"MAX_ELIGIBLE_AMOUNT": ""' +

              '},"hospital":[' +
              st!.substring(0, st!.length - 1)! +

              '],' +
              '"attachment": ['+
              '{'+
              '"DATA": "'+baseimage!+'",'+
              '"FILENAME": "'+progress.toString()+'"'+
              '}'+
              '],' +
              '"nonHospital": []' +
              '}'
          ;
         // print("object_print_"+kl1);
          String? kl = ed.encryptData(kl1);
          var link = ed.geturl();
          var requestbody = '''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
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

          //print("paas_"+response.statusCode.toString());
          if (response.statusCode == 200) {
            var xmldata = response.body;

            var contact = xml.XmlDocument.parse(xmldata);

            var result = contact
                .findAllElements('return')
                .first
                .text
                .toString();
            // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
            // EncryptData.encryptAES(xmldata);

            var data = ed.decryptAES(result);

            var res = jsonDecode(data);
            print("paas" + res.toString());

            if (res["STATUS"] == "S") {
              DialogBuilder(context).hideOpenDialog();
              //showAlertDialog1("Confirmation", "Your "+res["REQUEST_ID"].toString()+" has been saved");
              //showAlertDialog1("Confirmation", "Your record saved successfully.Your REQUEST ID is "+res["REQUEST_ID"].toString());
              Fluttertoast.showToast(

                  msg: "Your REQUEST ID is "+res["REQUEST_ID"].toString(), toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              // txt_totalclaim.text = res["TOTAL_AMOUNT_CLAIM"].toString();
              // txt_totalcgshclaim.text = res["TOTAL_CGHS_CLAIM"].toString();
              // txt_totalnonclaim.text =
              //     res["TOTAL_NON_IMPANELED_CLAIM"].toString();
              // txt_totalcgshapprove.text = res["APPROVED_CGHS_CLAIM"].toString();
              // txt_totalnonapprove.text =
              //     res["APPROVED_NON_IMPANELED_CLAIM"].toString();
              // txt_totalapprove.text = res["APPROVED_AMOUNT_CLAIM"].toString();
              // txt_totaltax.text = res["TAX_AMOUNT"].toString();
              // txt_total.text = res["PAID_AMOUNT"].toString();
            }
            else {
              Fluttertoast.showToast(

                  msg: "Error: " + res["ERROR"], toastLength: Toast
                  .LENGTH_LONG, backgroundColor: Colors.red);
              DialogBuilder(context).hideOpenDialog();
              // return;
            }
          }
          DialogBuilder(context).hideOpenDialog();
        }
      }
      on Exception catch (_) {
        DialogBuilder(context).hideOpenDialog();
      }
    //}
  }
  //Delete All
  onRemoveAll_Non_Hospitalization() async
  {
    setState(() {
      for(int n=0;n<contactForms.length;n++)
        {
          contactForms.removeAt(n);
        }
    });
  }
  onRemoveAll_Hospitalization() async
  {
    setState(() {
      for(int n=0;n<contactForms1.length;n++)
      {
        contactForms1.removeAt(n);

      }
    });
  }
  on_Hospitalization() async
  {
    setState(() {
      ContactModel1 _contactModel = ContactModel1(id: contactForms1.length);
      // int index =contactForms1
      //     .indexWhere((element) => element.contactModel.id == contact.id);
      // if (contactForms1 != null) contactForms1[0].crt_visible=false;
      ContactFormItemWidget1(
        index:txt_code.text ,
        contactModel: _contactModel,
        onRemove: () => onRemove1(_contactModel),
        crt_visible: false,

      ).crt_visible=false;
     // if (contactForms1 != null) contactForms1.removeAt(index);
    });
  }
  //Delete specific form
  onRemove(ContactModel contact) async {

    setState(() {
      int index =contactForms
          .indexWhere((element) => element.contactModel.id == contact.id);

      if (contactForms != null) contactForms.removeAt(index);
    });
  }
  onRemove1(ContactModel1 contact) async {
    setState(() {
      int index =contactForms1
          .indexWhere((element) => element.contactModel.id == contact.id);
     // if (contactForms1 != null) contactForms1[0].crt_visible=false;
     if (contactForms1 != null) contactForms1.removeAt(index);
    });
  }
  onAdd() async {
    DialogBuilder(context).showLoadingIndicator('Calculating');
    setState(() {
      try
      {



        ContactModel _contactModel = ContactModel(id: contactForms.length);
        contactForms.add(ContactFormItemWidget_2(
          index:txt_code.text ,
          contactModel: _contactModel,
          onRemove: () => onRemove(_contactModel),
          crt_visible: true,
        ));
      }
      on Exception catch (_) {
        // make it explicit that this function can throw exceptions
        rethrow;
      }
    });
    DialogBuilder(context).hideOpenDialog();
  }
  onAdd1() async {
    DialogBuilder(context).showLoadingIndicator('Calculating');
    setState(() {
      try
      {



        ContactModel1 _contactModel = ContactModel1(id: contactForms1.length);
        contactForms1.add(ContactFormItemWidget1(
          index:txt_code.text ,
          contactModel: _contactModel,
          onRemove: () => onRemove1(_contactModel),

          crt_visible: true,
        ));
      }
      on Exception catch (_) {
        // make it explicit that this function can throw exceptions
        rethrow;
      }
    });
    DialogBuilder(context).hideOpenDialog();
  }
  void loadImage() async{
    var   image= await FilePicker.platform.pickFiles(
      allowCompression: true,
//allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf','PDF','jpg','JPG'],
       withData: true,


      //allowed extension to choose
    );
    // var image= await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedfile=image;
      //progress = selectedfile!.files.first.extension;
      progress = new DateTime.now().millisecondsSinceEpoch.toString()+"."+selectedfile!.files.first.extension.toString();
      File file = File(selectedfile!.files.single.path!);
      baseimage =base64Encode(file.readAsBytesSync());
      int sizeInBytes = file.lengthSync();
      sizeInMb = sizeInBytes / (1024 * 1024);
      if(sizeInMb!<=30)
      {
        txt_document.text=progress.toString();
      }
      else
      {
        txt_document.text="";
        Fluttertoast.showToast(
            backgroundColor: Colors.red,
            msg: "File size is :"+sizeInMb.toString(), toastLength: Toast
            .LENGTH_SHORT);
      }
    });
  }
  void showAlertDialog(String? st,String st1) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(st!),
            content: Text(st1!),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () async {
                   // Navigator.pop(context);
                    if(txt_code.text=="Non-Hospitalization Reimbursement") {
                      showWidget3=true;
                   //  await onCaluclate_Non_Hospitalization();
                   //  await onSave_Non_Hospitalization();
                     // Navigator.of(context, rootNavigator: true).pop('dialog');
                      // Navigator.pop(context);
// if(showWidget4==true) {
//
//   reset();
// }
                    }
                    else
                    {
                    showWidget2=true;

                   //  await onCaluclate_Hospitalization();
                   //  await onSave_Hospitalization();
                    //Navigator.of(context, rootNavigator: true).pop('dialog');

                    // if(showWidget4==true) {
                    //   reset1();
                    // }

                    }

                  },
                  child: const Text(
                    'Yes',
                  )),
            ],
          );
        });
  }
  void showAlertDialog1(String? st,String st1) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(st!),
            content: Text(st1!),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),

            ],
          );
        });
  }
  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
      // TODO: Here goes your functionality that remembers the user.
    } else {
      // TODO: Forget the user
    }
  });
   void reset_Hospitalization()
   {

     setState(() {
       DateFormat dateFormat = DateFormat("dd.MM.yyyy");

showWidget4=false;


       txt_date.text=dateFormat.format(DateTime.now());

       txt_ELIGIBLE_AMT.text="0";
       txt_CLAIMED_AMT.text="0";
       txt_entitled.text="0";
       txt_totalcgshclaim.text="0";
       txt_totalnonclaim.text="0";
       txt_totalclaim.text="0";
       txt_totalcgshapprove.text="0";
       txt_totalnonapprove.text="0";
       txt_totalapprove.text="0";
       txt_totaltax.text="0";
       txt_total.text="0";
      // onRemoveAll();
       onRemoveAll_Hospitalization();
      rememberMe = false;
      rememberMe1 = false;
     showWidget = false;
       showWidget1 = false;
     //  showWidget2 = false;
       txt_comment.text="";
       txt_to_id.text="";
       txt_to.text="";
       txt_code.text="";
       progress="";

     });
   }
  void reset_Non_Hospitalization()
  {

    setState(() {
      DateFormat dateFormat = DateFormat("dd.MM.yyyy");

showWidget4=false;


      txt_date.text=dateFormat.format(DateTime.now());

      txt_ELIGIBLE_AMT.text="0";
      txt_CLAIMED_AMT.text="0";
      txt_entitled.text="0";
      txt_totalcgshclaim.text="0";
      txt_totalnonclaim.text="0";
      txt_totalclaim.text="0";
      txt_totalcgshapprove.text="0";
      txt_totalnonapprove.text="0";
      txt_totalapprove.text="0";
      txt_totaltax.text="0";
      txt_total.text="0";
       onRemoveAll_Non_Hospitalization();
     // onRemoveAll1();
      rememberMe = false;
      rememberMe1 = false;
      showWidget = false;
      showWidget1 = false;
    //  showWidget3 = false;
      txt_comment.text="";
      txt_to_id.text="";
      txt_to.text="";
      txt_code.text="";
      progress="";

    });
  }

}