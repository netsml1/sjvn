
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
import '../UserShared/EncryptData.dart';
import '../UserShared/Profile.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import '../helper/MyProgress.dart';
import 'Dashboard1.dart';
import 'MedicalClaim_Form_1.dart';
import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import 'Profile.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'TransitCamp.dart';
import 'TransitCampBookingDetail.dart';
import 'Web.dart';

// void main()
// {
//   runApp(MaterialApp(
//     home: MyDashboardview(),
//   ));
// }
class MyDashboardview extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{
  List<MenuItem> firstItems = [];
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
      subtitle: "Facilitator",
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
    getRequest();
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
      firstItems = [MenuItem(text: responseData["self"]["NAME"].toString()+"-"+responseData["self"]["CARD_NO"].toString(), icon: Icons.share)];

    });
    for(int h=0;h<kk.length;h++)
    {
      setState(() {
        firstItems.add(MenuItem(text: kk[h]["NAME"].toString()+"-"+kk[h]["CARD_NO"].toString(), icon: Icons.share));

      });

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
  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);
    MyHeader header=new MyHeader(context);
    List<Items> myList = [item1, item2, item3, item4, item5,  item7, item8,item9,item10];
    //MyFooter footer=new MyFooter(context);
    // WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement build
    //logindata = SharedPreferences.getInstance();
    return Scaffold(
      appBar: header.HeaderShow(),
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

      drawer:  MyNavigationBar.navi(context),

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
                children:myList.map((data) {
                  return
                    InkWell  (
                      onTap: () async{
                        if(data.event!="7"&& data.event!="8"&& data.event!="9")
                          {
                            Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => MyDashboardsubview(text: data.title,index: data.event,)),
                           );
                          }
                      },

//                         onTap:() async {
//
//                           if(data.event=="1")
//
//                           {
//                             DialogBuilder(context).showLoadingIndicator('Calculating');
//                             EncryptData ed=new EncryptData();
//                             var kl=    ed.encryptData('{"method" : "lastPaySlip", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));
//
//                             var link = ed.geturl();
//                             var requestbody ='''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
//     <Body>
//      <RetireeMobileApp xmlns="http://co.in/sjvn/RetireeMobileApp/">
//             <data xmlns="">paasinfotech</data>
//         </RetireeMobileApp>
//     </Body>
// </Envelope>
//
//     '''.toString().replaceAll("paasinfotech", kl);
//                             var response = await http.post(Uri.parse(link),
//
//                                 body: requestbody,
//                                 headers: {
//                                   "Content-Type": "text/xml",
//
//                                 }
//
//                             );
//                             if (response.statusCode == 200) {
//                               var xmldata = response.body;
//                               var contact = xml.XmlDocument.parse(xmldata);
//                               //print("paas"+ contact.findAllElements('return').first.text.toString());
//                               var result = contact
//                                   .findAllElements('return')
//                                   .first
//                                   .text
//                                   .toString();
//                               // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
//                               // EncryptData.encryptAES(xmldata);
//
//                               var data = ed.decryptAES(result);
//
//                               var res = jsonDecode(data);
//                               print("paas" + res["payslip"].toString());
//                               String bs4str = res["payslip"].toString();
//                               await FileProcess.downloadFile(bs4str,"lastPaySlip.pdf");
//                              // _createFileFromString(res["payslip"].toString());
//
//                              // print("paas" + res["payslip"].toString());
//
//                             }
//                             else
//                               {
//
//                               }
//                             DialogBuilder(context).hideOpenDialog();
//                           }
//                           else if(data.event=="2")
//                          {
//                            Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) => MyTransitCampListview()),
//                            );
//                          }
//
//
//                          else if(data.event=="3")
//                            {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (context) => MyEmpanelledHospitalListview()),
//                              );
//                            }
//
//
//                          else if(data.event=="4")
//                            {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (context) => MyPolicyDocumentsListview()),
//                              );
//                            }
//
//                          else if(data.event=="5")
//                           {
//                             DialogBuilder(context).showLoadingIndicator('Calculating');
//                             EncryptData ed=new EncryptData();
//                             var kl=    ed.encryptData('{"method" : "epfslip", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));
//
//                             var link = ed.geturl();
//                             var requestbody ='''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
//     <Body>
//      <RetireeMobileApp xmlns="http://co.in/sjvn/RetireeMobileApp/">
//             <data xmlns="">paasinfotech</data>
//         </RetireeMobileApp>
//     </Body>
// </Envelope>
//
//     '''.toString().replaceAll("paasinfotech", kl);
//                             var response = await http.post(Uri.parse(link),
//
//                                 body: requestbody,
//                                 headers: {
//                                   "Content-Type": "text/xml",
//
//                                 }
//
//                             );
//                             if (response.statusCode == 200) {
//                               var xmldata = response.body;
//                               var contact = xml.XmlDocument.parse(xmldata);
//                               //print("paas"+ contact.findAllElements('return').first.text.toString());
//                               var result = contact
//                                   .findAllElements('return')
//                                   .first
//                                   .text
//                                   .toString();
//                               // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
//                               // EncryptData.encryptAES(xmldata);
//
//                               var data = ed.decryptAES(result);
//
//                               var res = jsonDecode(data);
//
//                               String bs4str = res["epfslip"].toString();
//                               await FileProcess.downloadFile(bs4str,"epfslip.pdf");
//                               // _createFileFromString(res["payslip"].toString());
//
//                               // print("paas" + res["payslip"].toString());
//
//                             }
//                             else
//                             {
//
//                             }
//                             DialogBuilder(context).hideOpenDialog();
//                           }
//                          else if(data.event=="6")
//                           {
//                             DialogBuilder(context).showLoadingIndicator('Calculating');
//                             EncryptData ed=new EncryptData();
//                             var kl=    ed.encryptData('{"method" : "medicalcardfile", "userid" : "Puserid","cardno" : "Pcardno"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()).replaceAll("Pcardno", UserSharedPreferences.getCard().toString()));
//
//                             var link = ed.geturl();
//                             var requestbody ='''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
//     <Body>
//      <RetireeMobileApp xmlns="http://co.in/sjvn/RetireeMobileApp/">
//             <data xmlns="">paasinfotech</data>
//         </RetireeMobileApp>
//     </Body>
// </Envelope>
//
//     '''.toString().replaceAll("paasinfotech", kl);
//                             var response = await http.post(Uri.parse(link),
//
//                                 body: requestbody,
//                                 headers: {
//                                   "Content-Type": "text/xml",
//
//                                 }
//
//                             );
//                             if (response.statusCode == 200) {
//                               var xmldata = response.body;
//                               var contact = xml.XmlDocument.parse(xmldata);
//                               //print("paas"+ contact.findAllElements('return').first.text.toString());
//                               var result = contact
//                                   .findAllElements('return')
//                                   .first
//                                   .text
//                                   .toString();
//                               // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
//                               // EncryptData.encryptAES(xmldata);
//
//                               var data = ed.decryptAES(result);
//
//                               var res = jsonDecode(data);
//                               print("paaaas" + res["data"].toString());
//                               String bs4str = res["data"].toString();
//                               await FileProcess.downloadFile(bs4str,"medicalcardfile.pdf");
//                               // _createFileFromString(res["payslip"].toString());
//
//                               // print("paaaas" + res["data"].toString());
//
//                             }
//                             else
//                             {
//
//                             }
//                             DialogBuilder(context).hideOpenDialog();
//                           }
//                          else if(data.event=="7")
//                            {
//                              Navigator.push(
//                                context,
//                                MaterialPageRoute(builder: (context) => MyRequestForm()),
//                              );
//                            }
//                           else if(data.event=="8")
//                           {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => MyRequestStatusListview()),
//                             );
//                           }
//
//                           else if(data.event=="10")
//                           {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => MyMedicalClaim()),
//                             );
//                           }
//                           else if(data.event=="9")
//                           {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => MyMedicalClaimForm_1()),
//                             );
//                           }
//                         } ,
                        child:
                        // data.event=="1"?
                        // Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             SizedBox(height: 8),
                        //             Text(
                        //               data.subtitle!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 10,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //
                        // )
                        //     :
                        // data.event=="2"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="3"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...MenuItems2.firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems2.buildItem(item),
                        //                   ),
                        //                 ),
                        //                 const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
                        //                 ...MenuItems2.secondItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems2.buildItem(item),
                        //                   ),
                        //                 ),
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems2.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 250,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(MenuItems2.firstItems.length, 48),
                        //                   8,
                        //                   ...List<double>.filled(MenuItems2.secondItems.length, 48),
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="4"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...MenuItems3.firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems3.buildItem(item),
                        //                   ),
                        //                 ),
                        //                 const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
                        //                 ...MenuItems3.secondItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems3.buildItem(item),
                        //                   ),
                        //                 ),
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems3.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 350,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(MenuItems3.firstItems.length, 48),
                        //                   8,
                        //                   ...List<double>.filled(MenuItems3.secondItems.length, 48),
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="5"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...MenuItems4.firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems4.buildItem(item),
                        //                   ),
                        //                 ),
                        //                 const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
                        //                 ...MenuItems4.secondItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems4.buildItem(item),
                        //                   ),
                        //                 ),
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems4.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 250,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(MenuItems4.firstItems.length, 48),
                        //                   8,
                        //                   ...List<double>.filled(MenuItems4.secondItems.length, 48),
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="6"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems5.buildItem(item),
                        //                   ),
                        //                 ),
                        //
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems5.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 250,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(firstItems.length, 48),
                        //
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="7"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...MenuItems6.firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems6.buildItem(item),
                        //                   ),
                        //                 ),
                        //
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems6.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 250,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(MenuItems6.firstItems.length, 48),
                        //
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="8"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...MenuItems7.firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems5.buildItem(item),
                        //                   ),
                        //                 ),
                        //
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems7.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 250,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(MenuItems7.firstItems.length, 48),
                        //
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="9"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...MenuItems8.firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems8.buildItem(item),
                        //                   ),
                        //                 ),
                        //
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems8.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 250,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(MenuItems8.firstItems.length, 48),
                        //
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // data.event=="10"?  Container(
                        //
                        //     decoration: BoxDecoration(
                        //       gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           colors: [
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade900,
                        //             Colors.lightBlue.shade400
                        //           ]
                        //       ),
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     child:
                        //     DropdownButtonHideUnderline(
                        //         child:
                        //         Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           // children: [
                        //           children: <Widget>[
                        //
                        //             data.img!,
                        //             SizedBox(height: 14),
                        //             Text(
                        //               data.title!,
                        //               style: GoogleFonts.openSans(
                        //                 textStyle: TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.w600,
                        //                 ),
                        //               ),
                        //             ),
                        //             // SizedBox(height: 8),
                        //             // Text(
                        //             //   data.subtitle!,
                        //             //   style: GoogleFonts.openSans(
                        //             //     textStyle: TextStyle(
                        //             //       color: Colors.white,
                        //             //       fontSize: 10,
                        //             //       fontWeight: FontWeight.w600,
                        //             //     ),
                        //             //   ),
                        //             // ),
                        //             DropdownButton2(
                        //               customButton: const Icon(
                        //                 Icons.list,
                        //                 size: 35,
                        //                 color: Colors.white,
                        //               ),
                        //               items: [
                        //                 ...MenuItems8.firstItems.map(
                        //                       (item) => DropdownMenuItem<MenuItem>(
                        //                     value: item,
                        //                     child: MenuItems5.buildItem(item),
                        //                   ),
                        //                 ),
                        //
                        //               ],
                        //               onChanged: (value) {
                        //                 MenuItems8.onChanged(context, value! as MenuItem);
                        //               },
                        //               dropdownStyleData: DropdownStyleData(
                        //                 width: 250,
                        //                 padding: const EdgeInsets.symmetric(vertical: 6),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius: BorderRadius.circular(4),
                        //                   color: Colors.lightBlue.shade700,
                        //                 ),
                        //                 offset: const Offset(0, 8),
                        //               ),
                        //               menuItemStyleData: MenuItemStyleData(
                        //                 customHeights: [
                        //                   ...List<double>.filled(MenuItems8.firstItems.length, 48),
                        //
                        //                 ],
                        //                 padding: const EdgeInsets.only(left: 16, right: 16),
                        //               ),
                        //             ),
                        //
                        //           ],
                        //         )
                        //
                        //     )
                        //   // Column(
                        //   //
                        //   //   mainAxisAlignment: MainAxisAlignment.center,
                        //   //
                        //   //   children: <Widget>[
                        //   //
                        //   //     data.img!,
                        //   //     SizedBox(height: 14),
                        //   //     Text(
                        //   //       data.title!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 16,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //     SizedBox(height: 8),
                        //   //     Text(
                        //   //       data.subtitle!,
                        //   //       style: GoogleFonts.openSans(
                        //   //         textStyle: TextStyle(
                        //   //           color: Colors.white,
                        //   //           fontSize: 10,
                        //   //           fontWeight: FontWeight.w600,
                        //   //         ),
                        //   //       ),
                        //   //     ),
                        //   //
                        //   //     // SizedBox(height: 14),
                        //   //     // Text(
                        //   //     //   data.event!,
                        //   //     //   style: GoogleFonts.openSans(
                        //   //     //     textStyle: TextStyle(
                        //   //     //       color: Colors.white70,
                        //   //     //       fontSize: 11,
                        //   //     //       fontWeight: FontWeight.w600,
                        //   //     //     ),
                        //   //     //   ),
                        //   //     // ),
                        //   //   ],
                        //   // ),
                        // )
                        //     :
                        // Container()

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

                                data.img!,
                                SizedBox(height: 14),
                                Text(
                                  data.title!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  data.subtitle!,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
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
                }).toList(),

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
  });

  final String text;
  final IconData icon;
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
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'New Medical Claim', icon: Icons.add);
  static const share = MenuItem(text: 'View Medical Claim', icon: Icons.share);
  static const settings = MenuItem(text: 'Prevailing Medical Rules', icon: Icons.settings);
  static const logout = MenuItem(text: 'Empaneled Hospitals', icon: Icons.account_balance_sharp);

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
abstract class MenuItems1 {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout,last];

  static const home = MenuItem(text: 'LPC-Download Last Salary Slip', icon: Icons.add);
  static const share = MenuItem(text: 'Income Tax Detail', icon: Icons.share);
  static const settings = MenuItem(text: 'EPF Statement(Before 31.03.2023)', icon: Icons.settings);
  static const logout = MenuItem(text: 'EPF Statement(After 31.03.2023)', icon: Icons.account_balance_sharp);
  static const last = MenuItem(text: 'NPS Login Link', icon: Icons.link);

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
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Online Booking', icon: Icons.add);
  static const share = MenuItem(text: 'Requested Booking Detail', icon: Icons.share);
  static const settings = MenuItem(text: 'Approved Booking Detail', icon: Icons.settings);
  static const logout = MenuItem(text: 'Rejected Booking Detail', icon: Icons.account_balance_sharp);
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
  static const List<MenuItem> firstItems = [home];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Status Of Full & Final Payment', icon: Icons.add);
  static const logout = MenuItem(text: 'Status Of Terminal Benfits', icon: Icons.share);
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
abstract class MenuItems4 {
  static const List<MenuItem> firstItems = [home];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Birthday/Greeting Corner', icon: Icons.add);
  static const logout = MenuItem(text: 'Suggestions & Feedback', icon: Icons.share);
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

  static const home = MenuItem(text: 'View Detail', icon: Icons.add);
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

  static const home = MenuItem(text: 'View Detail', icon: Icons.add);
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

  static const home = MenuItem(text: 'View Detail', icon: Icons.add);
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

  static const home = MenuItem(text: 'View Detail', icon: Icons.add);
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


