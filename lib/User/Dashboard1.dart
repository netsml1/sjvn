
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/User/EmpanelledHospital_List.dart';
import 'package:sjvn/User/Medical_Claim.dart';
import 'package:sjvn/User/PolicyDocuments_List.dart';
import 'package:sjvn/User/Request_Form.dart';
import 'package:sjvn/User/Request_Status_List.dart';
import 'package:sjvn/User/TransitCamp_List.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import '../UserShared/Profile.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import '../helper/MyProgress.dart';
import 'Dashboard2.dart';
import 'Feedback.dart';
import 'FeedbackDetail.dart';
import 'MedicalClaim_Form_1.dart';
import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import 'Profile.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'TransitCamp.dart';
import 'TransitCampBookingDetail.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

import 'TransitCampDetail.dart';
import 'Web.dart';

// void main()
// {
//   runApp(MaterialApp(
//     home: MyDashboardview(),
//   ));
// }
class MyDashboardsubview extends StatefulWidget
{
String? text;
String? index;
MyDashboardsubview({required this.text,required this.index});
  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State<MyDashboardsubview>
{
  List<MenuItem> firstItems = [];
  List<MenuItem> firstItems1 = [];
  EncryptData ed = new EncryptData();
  final _key = UniqueKey();
  //static const List<MenuItem> secondItems = [MenuItem(text: 'Suggestions & Feedback', icon: Icons.share)];

  int _selectedIndex = 0;


  Items item1 = new Items(
      title: "Medical Related",
      subtitle: "Medical Related",
      event: "1",
      img:Icon(Icons.medical_services,size: 45,color: Colors.white,)
  );
  Items item2 = new Items(
      title: "Financial Services",
      subtitle: "Finacial Services",
      event: "2",
      img:Icon(Icons.account_balance,size: 45,color: Colors.white,)
  );
  Items item3 = new Items(
      title: "Transit Camp",
      subtitle: "Transit Camp",
      event: "3",
      img:Icon(Icons.hotel,size: 45,color: Colors.white,)
  );
  Items item4 = new Items(
      title: "Terminal Benefits",
      subtitle: "Terminal Benefits",
      event: "4",
      img:Icon(Icons.ac_unit,size: 45,color: Colors.white,)
  );
  Items item5 = new Items(
      title: "Misc. Services",
      subtitle: "Misc. Services",
      event: "5",
      img:Icon(Icons.dashboard,size: 45,color: Colors.white,)
  );
  Items item6 = Items(
      title: "Medical Card",
      subtitle: "Medical Card",
      event: "6",
      img:Icon(Icons.settings,size: 45,color: Colors.white,)

  );
  Items item7 = Items(
      title: "Contact Details",
      subtitle: "Contact Details",
      event: "7",
      img:Icon(Icons.contact_phone,size: 45,color: Colors.white,)

  );
  Items item8 = Items(
      title: "Central Library",
      subtitle: "Central Library",
      event: "8",
      img:Icon(Icons.library_books,size: 45,color: Colors.white,)

  );
  Items item9 = Items(
      title: "Superannuation",
      subtitle: "Superannuation",
      event: "9",
      img:Icon(Icons.add_circle,size: 45,color: Colors.white,)

  );
  Items item10 = Items(
      title: "Social Media Link",
      subtitle: "Social Media Link",
      event: "10",
      img:Icon(Icons.list_alt,size: 45,color: Colors.white,)

  );

  @override
  void initState()
  {
    super.initState();
     FlutterDownloader.initialize();
    getRequest();
    getRequest1();
  }
  getRequest1() async
  {
    var phone="dd";
    String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
      <userid>'''+phone+'''</userid>
     
     
    </Query>

    '''.toString();
    // print("object#"+xmldata);
    var requestbody=    ed.encryptData(xmldata);
    //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
    var link = ed.geturl1()+"GetSocialMedia";

    var response = await http.post(Uri.parse(link),

       body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );
    //if (response.statusCode == 200) {
    if (response.statusCode == 200) {
      var xmldata = response.body;
     var msg1 = ed.decryptAES(xmldata.toString());
      var responseData = json.decode(msg1);
      for (var res in responseData) {
        setState(() {
               firstItems1.add(MenuItem(text: res["name"].toString(), icon: Icons.open_in_browser,pos: 1,value:res["link"].toString() ));

             });
      }
      // print("object_12_"+firstItems1[0].toString());
     // final List parsedList = responseData;
     //  var kk=parsedList.toList();
     //  print("object_12_"+kk.length.toString());
     //  for(int h=0;h<responseData.length;h++)
     //  {
     //
     //    setState(() {
     //      //firstItems1.add(MenuItem(text: kk[h]["NAME"].toString(), icon: Icons.download_for_offline_outlined,pos: int.parse(responseData["link"].toString())));
     //
     //    });
     //
     //
     //  }
      print("object_12_"+firstItems1.length.toString());

      //print("object_12_"+msg1["name"].toString());
     //final List parsedList1 = msg1;
    //print("object_"+responseData["self"]["CARD_NO"].toString());
    // for (var res in responseData['dependent']) {
    // final List parsedList = msg1;
    // var kk=parsedList.toList();
    //
    //
    //
    // for(int h=0;h<kk.length;h++) {
    //   setState(() {
    //     firstItems.add(MenuItem(
    //         text: kk[h]["NAME"].toString(),
    //         icon: Icons.download_for_offline_outlined,
    //         pos: h + 1));
    //   });
    // }
    }
    //print("paas_self_"+  kk[0]["NAME"].toString());


    // user = dependent(
    //     EMPRETID: res["EMPRETID"],
    //     NAME: res["NAME"],
    //     DTOBRTH: res["DTOBRTH"],
    //     CELL_NO: res["CELL_NO"],
    //     CARD_NO: res["CARD_NO"]
    // );
    // }
    // }
    // return msg;
  }
  getRequest() async
  {

//List<MenuItem>? firstItems;
    String msg;
    String year=EncryptData.fiscalyear(DateTime.now().year, DateTime.now().month).toString();

    EncryptData ed = new EncryptData();
    String st = '{"method" : "selfdependentdetails", "userid" : "Puserid","fiscalyear":"paas_year"}'
        .replaceAll("Puserid", UserSharedPreferences.getUsername().toString())
        .replaceAll("paas_year", year.toString());

    var kl = ed.encryptData(st);

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
    //if (response.statusCode == 200) {
    var xmldata = response.body;
    var contact = xml.XmlDocument.parse(xmldata);

    var result = contact
        .findAllElements('return')
        .first
        .text
        .toString();
    var data = ed.decryptAES(result);
    //  msg=data;
    var responseData = json.decode(data);
    // final List parsedList1 = responseData["self"];
    print("object_"+responseData["self"]["CARD_NO"].toString());
    // for (var res in responseData['dependent']) {
    final List parsedList = responseData["dependent"];
    var kk=parsedList.toList();

    setState(() {
      firstItems = [MenuItem(text: responseData["self"]["NAME"].toString(), icon: Icons.download_for_offline_outlined,pos: int.parse(responseData["self"]["CARD_NO"].toString()))];

    });
    int c=2;
    for(int h=0;h<kk.length;h++)
    {
      c=c+h;
      setState(() {
        firstItems.add(MenuItem(text: kk[h]["NAME"].toString(), icon: Icons.download_for_offline_outlined,pos: int.parse(kk[h]["CARD_NO"].toString())));

      });


    }
    // for(int j=c;j<8;j++)
    // {
    //   setState(() {
    //     firstItems.add(MenuItem(text: "", icon: Icons.download_for_offline_outlined,pos: j));
    //
    //   });
    // }
  }
  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);
    MyHeader header=new MyHeader(context);
    List<Items> myList = [item1, item2, item3, item4, item5, item6, item7, item8,item9,item10];
    //MyFooter footer=new MyFooter(context);
    // WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement build
    //logindata = SharedPreferences.getInstance();
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text("List Of "+widget!.text.toString(),style: TextStyle(fontSize: 20),),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Colors.lightBlue.shade900,
        child: Icon(Icons.camera),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyWebview()),
          );
        },
      ),
      bottomNavigationBar: footer.FooterShow(),

      //drawer:  MyNavigationBar.navi(context),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: callme1,
      //   label: const Text('Call Me'),
      //   icon: const Icon(Icons.phone),
      //   backgroundColor: Colors.pink,
      // )

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.lightBlue.shade900,
                  Colors.lightBlue.shade900,
                  Colors.lightBlue.shade400
                ]
            )
        ),
        child: Expanded(
          // child: Container(
          //   decoration: BoxDecoration(
          //
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
          //   ),
          //
          // ),
            child:
            Container(
              decoration: BoxDecoration(

                  color: Colors.white,
                  image: new DecorationImage(
                    image: AssetImage("assets/images/bg4.png"),
                    fit: BoxFit.fitHeight,
                  ),

                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
              ),
              child: GridView.count(
                childAspectRatio: 1.0,
                padding: EdgeInsets.only(left: 16, right: 16,top: 20,bottom: 20),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children:
                widget.index=="1"?
                MenuItems.firstItems.map((data) {
                  return
                    InkWell  (
                      onTap: () async{


                        switch (data.pos) {
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyMedicalClaimForm_1()),
                            );
                            break;
                          case 2:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyMedicalClaim()),
                            );
                            break;
                          case 3:
                            DialogBuilder(context).showLoadingIndicator('Calculating');
                            String msg = "";
                            //String fpath=ed.geturl2()+"Documents/MedicalRules/MedicalRules.pdf";
                            String link=ed.geturl1()+"DownloadFile";
                            String fpath="\\Documents\\MedicalRules\\";
                            String fn="MedicalRules.pdf";
                            String xmldata = '''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
       <path>''' + fpath + '''</path>
     <fn>''' + fn + '''</fn>
     
    </Query>

    '''.toString();

                            var requestbody = ed.encryptData(xmldata);
                            //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
                           // var link = "https://connect.sjvn.co.in/RetireeMobileApp.asmx/DownloadFile";
                            print("object#" + link);
                            print("object#" + fpath);

                            var response = await http.post(Uri.parse(link),

                                body: requestbody,
                                headers: {
                                  "Content-Type": "text/xml",

                                }

                            );
                           // print("object_paas_"+response.statusCode.toString());
                            if (response.statusCode == 200) {
                              var xmldata = response.body;
                              print("object_paas_"+xmldata);

                             var data = ed.decryptAES(xmldata.toString());
                             print("object_"+data);
                              var res = jsonDecode(data);
                            //  print("object_"+res);

                              msg = res["body"].toString();
                             // String bs4str = res["data"].toString();
                              if(res["body"]!=null)
                              await FileProcess.downloadFile(msg,"medicalrules.pdf");
                              else
                                {
                                  Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;



                                }
                              //print("object_"+msg);
                              DialogBuilder(context).hideOpenDialog();
                            }
                            break;
                          case 4:
                            DialogBuilder(context).showLoadingIndicator('Calculating');
                            String msg = "";
                            //String fpath=ed.geturl2()+"Documents/MedicalRules/MedicalRules.pdf";
                            String link=ed.geturl1()+"DownloadFile";
                            String fpath="\\Documents\\Hospital\\";
                            String fn="Hospital.pdf";
                            String xmldata = '''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
       <path>''' + fpath + '''</path>
     <fn>''' + fn + '''</fn>
     
    </Query>

    '''.toString();

                            var requestbody = ed.encryptData(xmldata);
                            //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
                            // var link = "https://connect.sjvn.co.in/RetireeMobileApp.asmx/DownloadFile";
                            print("object#" + link);
                            print("object#" + fpath);

                            var response = await http.post(Uri.parse(link),

                                body: requestbody,
                                headers: {
                                  "Content-Type": "text/xml",

                                }

                            );
                            // print("object_paas_"+response.statusCode.toString());
                            if (response.statusCode == 200) {
                              var xmldata = response.body;
                              print("object_paas_"+xmldata);

                              var data = ed.decryptAES(xmldata.toString());
                              print("object_"+data);
                              var res = jsonDecode(data);
                              //  print("object_"+res);

                              msg = res["body"].toString();
                              // String bs4str = res["data"].toString();
                              if(res["body"]!=null)
                                await FileProcess.downloadFile(msg,"Hospital.pdf");
                              else
                              {
                                Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;



                              }
                              //print("object_"+msg);
                              DialogBuilder(context).hideOpenDialog();
                            }
                            break;
                          case 5:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyDashboardsub1view(text: 'Medical Card Detail', index: '10',)),
                            );
                            break;
                        }

                      },

                        child:
                     data.text!=""?
                     Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                              //SizedBox(height: 10),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),


                            ],
                          ),

                        )
                         :
                         Container(


                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                  Colors.lightBlue.shade900,
                  Colors.lightBlue.shade900,
                  Colors.lightBlue.shade400
                  ]
                  ),
                    image: new DecorationImage(
                        image: AssetImage("assets/images/bg2.jpeg"),
                        fit: BoxFit.fill,
                      ),
                  borderRadius: BorderRadius.circular(10),
                  ),
                         )
                    );
                }).toList()
                :
                widget.index=="2"?
                MenuItems1.firstItems.map((data) {
                  return
                    InkWell  (
                      onTap: () async{

    switch (data.pos) {
      case 1:
                                  DialogBuilder(context).showLoadingIndicator('Calculating');
                            EncryptData ed=new EncryptData();
                            var kl=    ed.encryptData('{"method" : "lastPaySlip", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
                              //print("paas"+ contact.findAllElements('return').first.text.toString());
                              var result = contact
                                  .findAllElements('return')
                                  .first
                                  .text
                                  .toString();
                              // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
                              // EncryptData.encryptAES(xmldata);

                              var data = ed.decryptAES(result);

                              var res = jsonDecode(data);
                             // print("paas_" + data[0].toString());
                              String bs4str = res["payslip"].toString();
                              if(bs4str =="")
                              {
                                Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
                                DialogBuilder(context).hideOpenDialog();

                                return;
                              }

                              await FileProcess.downloadFile(bs4str,"lastPaySlip.pdf");
                             // _createFileFromString(res["payslip"].toString());

                             // print("paas" + res["payslip"].toString());

                            }
                            else
                              {

                              }
                            DialogBuilder(context).hideOpenDialog();
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyDashboardsub1view(text: 'Income Tax Detail', index: '6',)),
        );
    //     DialogBuilder(context).showLoadingIndicator('Calculating');
    //
    //    int fyear=EncryptData.fiscalyear1(DateTime.now().year,DateTime.now().month);
    //     String msg = "";
    //     //String fpath=ed.geturl2()+"Documents/MedicalRules/MedicalRules.pdf";
    //     String link=ed.geturl1()+"DownloadFile";
    //     String fpath="\\Documents\\IncomeTax\\"+fyear.toString()+"\\";
    //
    //     String fn=int.parse(UserSharedPreferences.getEmpID().toString()).toString()+ ".pdf";
    //     String xmldata = '''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    // <Query>
    //
    //    <path>''' + fpath + '''</path>
    //  <fn>''' + fn + '''</fn>
    //
    // </Query>
    //
    // '''.toString();
    //
    //     var requestbody = ed.encryptData(xmldata);
    //     //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
    //     // var link = "https://connect.sjvn.co.in/RetireeMobileApp.asmx/DownloadFile";
    //
    //
    //     var response = await http.post(Uri.parse(link),
    //
    //         body: requestbody,
    //         headers: {
    //           "Content-Type": "text/xml",
    //
    //         }
    //
    //     );
    //     // print("object_paas_"+response.statusCode.toString());
    //     if (response.statusCode == 200) {
    //       var xmldata = response.body;
    //       print("object_paas_"+xmldata);
    //
    //       var data = ed.decryptAES(xmldata.toString());
    //       print("object_"+data);
    //       var res = jsonDecode(data);
    //       //  print("object_"+res);
    //
    //       msg = res["body"].toString();
    //       // String bs4str = res["data"].toString();
    //       if(res["body"]!=null)
    //         await FileProcess.downloadFile(msg,"IncomeTax.pdf");
    //       else
    //       {
    //         Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
    //
    //
    //
    //       }
    //       //print("object_"+msg);
    //       DialogBuilder(context).hideOpenDialog();
    //     }
        break;
      case 3:
                            DialogBuilder(context).showLoadingIndicator('Calculating');
                            EncryptData ed=new EncryptData();
                            var kl=    ed.encryptData('{"method" : "epfslip", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
                              //print("paas"+ contact.findAllElements('return').first.text.toString());
                              var result = contact
                                  .findAllElements('return')
                                  .first
                                  .text
                                  .toString();
                              // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
                              // EncryptData.encryptAES(xmldata);

                              var data = ed.decryptAES(result);

                              var res = jsonDecode(data);

                              String bs4str = res["epfslip"].toString();
                              if(bs4str =="")
                              {
                                Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
                                DialogBuilder(context).hideOpenDialog();

                                return;
                              }
                              await FileProcess.downloadFile(bs4str,"epfslip.pdf");
                              // _createFileFromString(res["payslip"].toString());

                              // print("paas" + res["payslip"].toString());

                            }
                            else
                            {

                            }
                            DialogBuilder(context).hideOpenDialog();
        break;
      case 4:
        openBrowserTab("https://sjvn.factohr.com/esslogin");
        break;
      case 5:
        openBrowserTab("https://www.cra-nsdl.com/CRA/");
        break;
      default:
        break;
    }
                      },

                        child:
data.text!=""?

                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            // gradient: LinearGradient(
                            //     begin: Alignment.topCenter,
                            //     colors: [
                            //       Colors.lightBlue.shade900,
                            //       Colors.lightBlue.shade900,
                            //       Colors.lightBlue.shade400
                            //     ]
                            // ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                             // SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                              child:
                              Text(
                                textAlign: TextAlign.center,

                                data.text!,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,

                                  ),
                                ),
                              ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
    :
Container(


  decoration: BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade400
        ]
    ),
    image: new DecorationImage(
      image: AssetImage("assets/images/bg2.jpeg"),
      fit: BoxFit.fill,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
)
                    );
                }).toList()
                    :
                widget.index=="3"?
                MenuItems2.firstItems.map((data) {
                  return
                    InkWell  (
                      onTap: () async{
                      switch (data.pos) {
                      case 1:
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => TransitCampForm()));
                        break;
                        case 2:
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => MyTransitCampDetail()));
                          break;
                        case 3:
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => MyTransitCampDetail1()));
                          break;
                      }
                      },

                        child:

data.text!=""?
                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                             // SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
    :

                        Container(


                        decoration: BoxDecoration(
                        gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                          Colors.lightBlue.shade900,
                          Colors.lightBlue.shade900,
                          Colors.lightBlue.shade400
                        ]
                    ),
                  image: new DecorationImage(
                  image: AssetImage("assets/images/bg2.jpeg"),
                  fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  ),
                  )
                    );
                }).toList()
                :
                widget.index=="4"?
                MenuItems3.firstItems.map((data) {
                  return
                    InkWell  (


                        child:

data.text!=""?
                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                              //SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
    :
Container(


  decoration: BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade400
        ]
    ),
    image: new DecorationImage(
      image: AssetImage("assets/images/bg2.jpeg"),
      fit: BoxFit.fill,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
)
                    );
                }).toList()
                    :
                widget.index=="5"?
                MenuItems4.firstItems.map((data) {
                  return
                    InkWell  (
                      onTap: () async{
                        switch (data.pos) {
                          case 3:
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => MyFeedbackForm()));
                            break;
                          case 4:
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => MyFeedbackDetail()));
                            break;
                          }
                      },

                        child:

data.text!=""?
                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                              // SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
    :
Container(


  decoration: BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade400
        ]
    ),
    image: new DecorationImage(
      image: AssetImage("assets/images/bg2.jpeg"),
      fit: BoxFit.fill,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
)
                    );
                }).toList()
                    :
                widget.index=="6"?
                firstItems.map((data) {
                  return
                    InkWell  (
                      onTap: () async{
                                                    DialogBuilder(context).showLoadingIndicator('Calculating');
                            EncryptData ed=new EncryptData();
                            var kl=    ed.encryptData('{"method" : "medicalcardfile", "userid" : "Puserid","cardno" : "Pcardno"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()).replaceAll("Pcardno", data.pos.toString()));

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
                              //print("paas"+ contact.findAllElements('return').first.text.toString());
                              var result = contact
                                  .findAllElements('return')
                                  .first
                                  .text
                                  .toString();
                              // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
                              // EncryptData.encryptAES(xmldata);

                              var data = ed.decryptAES(result);

                              var res = jsonDecode(data);
                              print("paaaas" + res["data"].toString());
                              String bs4str = res["data"].toString();
                              if(bs4str =="")
                              {
                                Fluttertoast.showToast(msg: "Record not found",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
                                DialogBuilder(context).hideOpenDialog();

                                return;
                              }

                              await FileProcess.downloadFile(bs4str,"medicalcardfile.pdf");
                              // _createFileFromString(res["payslip"].toString());

                              //print("paaaas" + res["data"].toString());

                            }
                            else
                            {

                            }
                            DialogBuilder(context).hideOpenDialog();
                      },

                        child:

data.text!=""?
                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                             // SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
    :
Container(


  decoration: BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        colors: [
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade900,
          Colors.lightBlue.shade400
        ]
    ),
    image: new DecorationImage(
      image: AssetImage("assets/images/bg2.jpeg"),
      fit: BoxFit.fill,
    ),
    borderRadius: BorderRadius.circular(10),
  ),
)
                    );
                }).toList()
                    :
                widget.index=="7"?
                MenuItems6.firstItems.map((data) {
                  return
                    InkWell  (
                      // onTap: () async{
                      //   if(data.event=="1")
                      //     {
                      //       print("pass");
                      //     }
                      // },

                        child:


                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                              SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
                    );
                }).toList()
                    :
                widget.index=="8"?
                MenuItems7.firstItems.map((data) {
                  return
                    InkWell  (
                      // onTap: () async{
                      //   if(data.event=="1")
                      //     {
                      //       print("pass");
                      //     }
                      // },

                        child:


                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                              SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
                    );
                }).toList()
                    :
                widget.index=="9"?
                MenuItems8.firstItems.map((data) {
                  return
                    InkWell  (
                      // onTap: () async{
                      //   if(data.event=="1")
                      //     {
                      //       print("pass");
                      //     }
                      // },

                        child:


                        Container(

                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              image: AssetImage("assets/images/background4.avif"),
                              fit: BoxFit.fitHeight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                              SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
                    );
                }).toList()
                    :
                firstItems1.map((data) {
                  return
                    InkWell  (
                      onTap: () async{
                        openBrowserTab(data.value.toString());
                      },

                        child:


                        Container(

                          decoration: BoxDecoration(
                              image: new DecorationImage(
                                image: AssetImage("assets/images/background4.avif"),
                                fit: BoxFit.fitHeight,
                              ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                          Column(

                            mainAxisAlignment: MainAxisAlignment.center,

                            children: <Widget>[
                              Icon(data.icon,size: 40,color: Colors.white),

                              //data.icon,
                              SizedBox(height: 14),

                              Container(
                                padding:EdgeInsets.all(10),

                                child:
                                Text(
                                  textAlign: TextAlign.center,

                                  data.text!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,

                                    ),
                                  ),
                                ),
                              ),

                              // SizedBox(height: 14),
                              // Text(
                              //   data.event!,
                              //   style: GoogleFonts.openSans(
                              //     textStyle: TextStyle(
                              //       color: Colors.white70,
                              //       fontSize: 11,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),

                        )
                    );
                }).toList()
              ),

            )



        ),
      ),

    );
  }


}
class MenuItem {
  const MenuItem({
    required this.text,
    required this.icon,
    required this.pos,
    this.value,

  });

  final String text;
  final IconData icon;
  final int pos;
  final String? value;
}
Future<void> openBrowserTab(String url) async {
  await    FlutterWebBrowser.openWebPage(

    url: url,

    customTabsOptions: CustomTabsOptions(

      //colorScheme: CustomTabsColorScheme.dark,

      darkColorSchemeParams: CustomTabsColorSchemeParams(
        toolbarColor: Colors.deepPurple,
        secondaryToolbarColor: Colors.green,
        navigationBarColor: Colors.amber,
        navigationBarDividerColor: Colors.cyan,



      ),
      //shareState: CustomTabsShareState.,

      instantAppsEnabled: true,
      showTitle: true,
      urlBarHidingEnabled: true,




    ),
  );
}
abstract class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings,logout,logout1];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'New Medical Claim', icon: Icons.open_in_new,pos: 1);
  static const share = MenuItem(text: 'View Medical Claim', icon: Icons.open_in_new,pos:2);
  static const settings = MenuItem(text: 'Prevailing Medical Rules', icon: Icons.download_for_offline_outlined,pos:3);
  static const logout = MenuItem(text: 'Empanelled Hospitals', icon: Icons.open_in_new,pos:4);
  static const logout1 = MenuItem(text: 'Medical Card', icon: Icons.open_in_new,pos:5);
  static const logout2 = MenuItem(text: '', icon: Icons.open_in_new,pos:6);
  static const logout3 = MenuItem(text: '', icon: Icons.open_in_new,pos:7);
  static const logout4 = MenuItem(text: '', icon: Icons.open_in_new,pos:8);
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 25),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyMedicalClaimForm_1()),
        );
        break;
      case MenuItems.settings:

        break;
      case MenuItems.share:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyMedicalClaim()),
        );
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}
Widget _buildPopupDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text('Select Year'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello"),
      ],
    ),
    actions: <Widget>[
      new TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },

        child: const Text('Close'),
      ),
    ],
  );
}
abstract class MenuItems1 {
  static const List<MenuItem> firstItems = [home, share, settings,logout,last];
  static const List<MenuItem> secondItems = [logout,last];

  static const home = MenuItem(text: 'LPC-Download Last Salary Slip', icon: Icons.download_for_offline_outlined,pos: 1);
  static const share = MenuItem(text: 'Income Tax Detail', icon: Icons.download_for_offline_outlined,pos: 2);
  static const settings = MenuItem(text: 'EPF Statement(Before 31.03.2023)', icon: Icons.download_for_offline_outlined,pos: 3);
  static const logout = MenuItem(text: 'EPF Statement(After 31.03.2023)', icon: Icons.open_in_browser,pos: 4);
  static const last = MenuItem(text: 'NPS Login Link', icon: Icons.open_in_browser,pos: 5);
  static const logout1 = MenuItem(text: '', icon: Icons.open_in_new,pos:5);
  static const logout2 = MenuItem(text: '', icon: Icons.open_in_new,pos:6);
  static const logout3 = MenuItem(text: '', icon: Icons.open_in_new,pos:7);
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> onChanged(BuildContext context, MenuItem item) async {

    switch (item)  {
      case MenuItems1.home:

        DialogBuilder(context).showLoadingIndicator('Calculating');
        EncryptData ed=new EncryptData();
        var kl=    ed.encryptData('{"method" : "lastPaySlip", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
          //print("paas"+ contact.findAllElements('return').first.text.toString());
          var result = contact
              .findAllElements('return')
              .first
              .text
              .toString();
          // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
          // EncryptData.encryptAES(xmldata);

          var data = ed.decryptAES(result);

          var res = jsonDecode(data);
          print("paas" + res["payslip"].toString());
          String bs4str = res["payslip"].toString();
          if(res["payslip"]!="")
            await FileProcess.downloadFile(bs4str,"lastPaySlip.pdf");
          else
          {
            Fluttertoast.showToast(msg: "Record Not Found23".toString(),toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
            DialogBuilder(context).hideOpenDialog();
            return;
          }
          // _createFileFromString(res["payslip"].toString());

          // print("paas" + res["payslip"].toString());

        }
        else
        {

        }
        DialogBuilder(context).hideOpenDialog();
        break;
      case MenuItems1.share:
      //do something
        break;
      case MenuItems1.settings:
        DialogBuilder(context).showLoadingIndicator('Calculating');
        EncryptData ed=new EncryptData();
        var kl=    ed.encryptData('{"method" : "epfslip", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
          //print("paas"+ contact.findAllElements('return').first.text.toString());
          var result = contact
              .findAllElements('return')
              .first
              .text
              .toString();
          // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
          // EncryptData.encryptAES(xmldata);

          var data = ed.decryptAES(result);

          var res = jsonDecode(data);

          String bs4str = res["epfslip"].toString();
          if(bs4str!="")
            await FileProcess.downloadFile(bs4str,"epfslip.pdf");
          else
          {
            Fluttertoast.showToast(msg: "Record Not Found".toString(),toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
            DialogBuilder(context).hideOpenDialog();
            return;
          }
          // _createFileFromString(res["payslip"].toString());

          // print("paas" + res["payslip"].toString());

        }
        else
        {

        }
        DialogBuilder(context).hideOpenDialog();
        break;

      case MenuItems1.logout:
        openBrowserTab("https://sjvn.factohr.com/esslogin");
        break;
      case MenuItems1.last:
        openBrowserTab("https://www.cra-nsdl.com/CRA/");
        break;
    }
  }
}
abstract class MenuItems2 {
  static const List<MenuItem> firstItems = [home, share,settings ];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Online Booking', icon: Icons.open_in_new,pos: 1);
  static const share = MenuItem(text: 'Booking Detail', icon: Icons.open_in_new,pos: 2);
  static const settings = MenuItem(text: 'Transit Camp Detail', icon: Icons.open_in_new,pos: 3);
  static const logout = MenuItem(text: '', icon: Icons.open_in_new,pos: 4);
  static const logout1 = MenuItem(text: '', icon: Icons.open_in_new,pos: 5);
  static const logout2 = MenuItem(text: '', icon: Icons.open_in_new,pos: 6);
  static const logout3 = MenuItem(text: '', icon: Icons.open_in_new,pos: 7);
  static const logout4 = MenuItem(text: '', icon: Icons.open_in_new,pos: 8);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems2.home:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TransitCampForm()),
        );
        break;
      case MenuItems.settings:
      //Do something
        break;
      case MenuItems2.share:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyTransitCampDetail()),
        );
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}
abstract class MenuItems3 {
  static const List<MenuItem> firstItems = [home,logout];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Status Of Full & Final Payment', icon: Icons.open_in_new,pos: 1);
  static const logout = MenuItem(text: 'Status Of Terminal Benfits', icon: Icons.open_in_new,pos: 2);
  static const logout1 = MenuItem(text: '', icon: Icons.open_in_new,pos: 5);
  static const logout2 = MenuItem(text: '', icon: Icons.open_in_new,pos: 6);
  static const logout3 = MenuItem(text: '', icon: Icons.open_in_new,pos: 7);
  static const logout4 = MenuItem(text: '', icon: Icons.open_in_new,pos: 8);
  static const logout5 = MenuItem(text: '', icon: Icons.open_in_new,pos: 7);
  static const logout6 = MenuItem(text: '', icon: Icons.open_in_new,pos: 8);
  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.settings:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}
abstract class MenuItems4 {
  static const List<MenuItem> firstItems = [logout1,logout2];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Birthday/Greeting Corner', icon: Icons.open_in_new,pos: 1);
  static const logout = MenuItem(text: 'Birthday/Greeting Corner Detail', icon: Icons.open_in_new,pos: 2);
  static const logout1 = MenuItem(text: 'Suggestions & Feedback', icon: Icons.open_in_new,pos: 3);
  static const logout2 = MenuItem(text: 'Suggestions & Feedback Detail', icon: Icons.open_in_new,pos: 4);

  static const logout3 = MenuItem(text: '', icon: Icons.open_in_new,pos: 7);
  static const logout4 = MenuItem(text: '', icon: Icons.open_in_new,pos: 8);
  static const logout5 = MenuItem(text: '', icon: Icons.open_in_new,pos: 7);
  static const logout6 = MenuItem(text: '', icon: Icons.open_in_new,pos: 8);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.settings:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}
abstract class MenuItems5{

  static  List<MenuItem> firstItems = [];
  //static const List<MenuItem> secondItems = [MenuItem(text: 'Suggestions & Feedback', icon: Icons.share)];







  // static const home = MenuItem(text: 'Birthday/Greeting Corner', icon: Icons.add);
  //static const logout = MenuItem(text: 'Suggestions & Feedback', icon: Icons.share);
  // static const settings = MenuItem(text: 'Approved Booking Detail', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Rejected Booking Detail', icon: Icons.account_balance_sharp);
  //static const last = MenuItem(text: 'NPS Login Link', icon: Icons.account_balance_sharp);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> onChanged(BuildContext context, MenuItem item) async {

    var card=item.text.split('-');
    DialogBuilder(context).showLoadingIndicator('Calculating');
    EncryptData ed=new EncryptData();
    var kl=    ed.encryptData('{"method" : "medicalcardfile", "userid" : "Puserid","cardno" : "Pcardno"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()).replaceAll("Pcardno", card[1].toString()));

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
      //print("paas"+ contact.findAllElements('return').first.text.toString());
      var result = contact
          .findAllElements('return')
          .first
          .text
          .toString();
      // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
      // EncryptData.encryptAES(xmldata);

      var data = ed.decryptAES(result);

      var res = jsonDecode(data);
      print("paaaas" + res["data"].toString());
      String bs4str = res["data"].toString();
      await FileProcess.downloadFile(bs4str,"medicalcardfile.pdf");
      // _createFileFromString(res["payslip"].toString());

      // print("paaaas" + res["data"].toString());

    }
    else
    {

    }
    DialogBuilder(context).hideOpenDialog();

  }
}
abstract class MenuItems6 {
  static const List<MenuItem> firstItems = [home];
  //static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'View Detail', icon: Icons.add,pos: 1);
  //static const logout = MenuItem(text: 'Suggestions & Feedback', icon: Icons.share);
  // static const settings = MenuItem(text: 'Approved Booking Detail', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Rejected Booking Detail', icon: Icons.account_balance_sharp);
  //static const last = MenuItem(text: 'NPS Login Link', icon: Icons.account_balance_sharp);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.settings:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}
abstract class MenuItems7 {
  static const List<MenuItem> firstItems = [home];
  //static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'View Detail', icon: Icons.add,pos: 1);
  //static const logout = MenuItem(text: 'Suggestions & Feedback', icon: Icons.share);
  // static const settings = MenuItem(text: 'Approved Booking Detail', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Rejected Booking Detail', icon: Icons.account_balance_sharp);
  //static const last = MenuItem(text: 'NPS Login Link', icon: Icons.account_balance_sharp);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.settings:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}
abstract class MenuItems8 {
  static const List<MenuItem> firstItems = [home];
  //static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'View Detail', icon: Icons.add,pos: 1);
  //static const logout = MenuItem(text: 'Suggestions & Feedback', icon: Icons.share);
  // static const settings = MenuItem(text: 'Approved Booking Detail', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Rejected Booking Detail', icon: Icons.account_balance_sharp);
  //static const last = MenuItem(text: 'NPS Login Link', icon: Icons.account_balance_sharp);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.settings:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}
abstract class MenuItems9 {
  static const List<MenuItem> firstItems = [home];
  //static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'View Detail', icon: Icons.add,pos: 1);
  //static const logout = MenuItem(text: 'Suggestions & Feedback', icon: Icons.share);
  // static const settings = MenuItem(text: 'Approved Booking Detail', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Rejected Booking Detail', icon: Icons.account_balance_sharp);
  //static const last = MenuItem(text: 'NPS Login Link', icon: Icons.account_balance_sharp);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.home:
      //Do something
        break;
      case MenuItems.settings:
      //Do something
        break;
      case MenuItems.share:
      //Do something
        break;
      case MenuItems.logout:
      //Do something
        break;
    }
  }
}


