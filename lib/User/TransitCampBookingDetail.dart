
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/User/Dashboard2.dart';
import 'package:sjvn/User/MedicalClaim_Form.dart';
import 'package:sjvn/User/MedicalClaim_Form_2.dart';
import 'package:sjvn/UserShared/PolicyDocuments.dart';
import 'package:sjvn/UserShared/TransitCampList.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import '../UserShared/MedicalClaimFetchList.dart';
import '../UserShared/TransitCampFetchList.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import '../helper/MyProgress.dart';


import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;




class MyTransitCampDetail extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{

  EncryptData ed=new EncryptData();
  var inputFormat = DateFormat('MM/dd/yyyy');


  var outputFormat = DateFormat('dd.MM.yyyy');
  Future<List<TransitCampFetchList>> getRequest() async {


    String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
      <userid>'''+UserSharedPreferences.getUsername().toString()+'''</userid>
       <status>'''+"Under Progress"+'''</status>
     
    </Query>

    '''.toString();

    var requestbody=    ed.encryptData(xmldata);
    var link = ed.geturl1()+"GetRecord";

    var response = await http.post(Uri.parse(link),

        body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );
    List<TransitCampFetchList> users = [];

    if (response.statusCode == 200) {
      var xmldata = response.body;

      var  data = ed.decryptAES(xmldata.toString());
     print("object_"+data);
      var responseData = json.decode(data);


      final List parsedList = responseData;

  var    kk=   parsedList.toList();
  for(int j=0;j<kk.length;j++)
    {
      TransitCampFetchList user = TransitCampFetchList(
          camp : kk[j]['Camp'],
          map: kk[j]['GoogleLocation'],
          requestID : kk[j]['RequestID'],
          status: kk[j]['Status'],
          location : kk[j]['Location'],
          checkin : kk[j]['CheckIn'],

          checkout : kk[j]['CheckOut'],
          adult:kk[j]['Adult'],
          child : kk[j]['Child'],
          room : kk[j]['Room'],

          checkin1 : kk[j]['CheckIn1'],

          checkout1 : kk[j]['CheckOut1'],
          adult1:kk[j]['Adult1'],
          child1 : kk[j]['Child1'],
          room1 : kk[j]['Room1'],

          guestname : kk[j]['GuestName'],
          guestaddress:kk[j]['Address'],
          mobilenumber : kk[j]['MobileNumber'],
          note: kk[j]['Note'],
          note1: kk[j]['Note1'],
          id: kk[j]['TCID']
      );
      users.add(user);
    }
  //print("object_"+users.length.toString());


    }
    else
    {

    }

    return users;

    //replace your restFull API here.
    // String url = "https://roomerang.net/webservice2.asmx/get_product_data";
    // final response = await http.get(Uri.parse(url));


  }
  @override
  void initState()
  {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);
    MyHeader header=new MyHeader(context);
    //MyFooter footer=new MyFooter(context);
    // WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement build
    //logindata = SharedPreferences.getInstance();
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text("Booking Detail"),
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

        // leading: IconButton(
        //   onPressed: () {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(builder: (context) => MyApp2(text: "https://ecc.sjvn.co.in:44300/sap/bc/ui2/flp")),
        //     // );
        //   },
        //
        //   icon: Image.asset('assets/images/sjvn_logo.png'),
        // ),
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
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyMedicalClaimForm()),
          // );
        },
      ),
      bottomNavigationBar: footer.FooterShow(),
      //drawer: MyNavigationBar.navi(context),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: callme1,
      //   label: const Text('Call Me'),
      //   icon: const Icon(Icons.phone),
      //   backgroundColor: Colors.pink,
      // )

      body:



      Card(
        child: Container(

          padding: EdgeInsets.all(5.0),
          child: FutureBuilder(
            future: getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return

                  ListView.builder(


                      itemCount: snapshot.data.length,
                      itemBuilder: (ctx, index) =>


                          Card(
                            child:  InkWell(
                                // onTap: ()
                                // {
                                //   if(snapshot.data[index].status.toString().toLowerCase()!="saved")
                                //  // DialogBuilder(context).showLoadingIndicator('Calculating');
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(builder: (context) => MyMedicalClaimForm(text: snapshot.data[index].requestID,text1:snapshot.data[index].pendingFrom ,))
                                //   );
                                //   else
                                //     {
                                //
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(builder: (context) => MyMedicalClaimForm_2(text: snapshot.data[index].requestID,text1:snapshot.data[index].pendingFrom ,))
                                //       );
                                //     }
                                //
                                //   //DialogBuilder(context).hideOpenDialog();
                                // },
                                child:ListTile(
                                  shape: RoundedRectangleBorder( //<-- SEE HERE
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                 // title: Text("Request ID: "+snapshot.data[index].requestID),
                                  title:
                                  snapshot.data[index].status.toString()=="Approve"?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 200,
                                        // You can set width of container here
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: Radius.circular(15),
                                          //   bottomLeft: Radius.circular(15),
                                          // ),
                                        ),
                                        child: Padding(
                                          // Following padding to give space around the icon and text
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/approve.jpeg',
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                snapshot.data[index].status.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  )
                                  :
                                  snapshot.data[index].status.toString()=="Reject"?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 200,
                                        // You can set width of container here
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: Radius.circular(15),
                                          //   bottomLeft: Radius.circular(15),
                                          // ),
                                        ),
                                        child: Padding(
                                          // Following padding to give space around the icon and text
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/images/Reject.png',
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                snapshot.data[index].status.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  )
                                      :
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 200,
                                        // You can set width of container here
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: Radius.circular(15),
                                          //   bottomLeft: Radius.circular(15),
                                          // ),
                                        ),
                                        child: Padding(
                                          // Following padding to give space around the icon and text
                                          padding: const EdgeInsets.all(0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              // Image.asset(
                                              //   'assets/images/progress.jpeg',
                                              // ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text(
                                                snapshot.data[index].status.toString(),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  )
                                  ,
                                  subtitle:
                                  snapshot.data[index].status.toString()=="Approve"?
                                  InkWell  (
                                    onTap: ()
                                    {
                                      String url=ed.geturl2()+"Map.aspx?id="+snapshot.data[index].id;
                                      openBrowserTab(url);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => MyTransitCampMap()),
                                      // );
                                    }
                                    ,

                                    child: Text(
                                      // "Status: "+snapshot.data[index].status.toString()+
                                        "\nLocation: "+snapshot.data[index].location.toString()+
                                            "\nCheckIn: "+ outputFormat.format(inputFormat.parse(snapshot.data[index].checkin1)).toString()+
                                            "\nCheckOut: "+outputFormat.format(inputFormat.parse(snapshot.data[index].checkout1)).toString()+
                                            "\nAdult: "+snapshot.data[index].adult1.toString()+
                                            ": Child: "+snapshot.data[index].child1.toString()+
                                            ": Room: "+snapshot.data[index].room1.toString()+
                                            "\nGuest Name: "+snapshot.data[index].guestname.toString()+
                                            "\nMobile Number: "+snapshot.data[index].mobilenumber.toString()+
                                            "\nNote: "+snapshot.data[index].note.toString()+
                                            "\nTransit Camp: "+snapshot.data[index].camp.toString()+
                                            "\nAddress: "+snapshot.data[index].guestaddress.toString()+
                                            "\nAdmin Note: "+snapshot.data[index].note1.toString()+
                                            "\nView Location On Google Map"
                                      // "\nGoogle Location: "+snapshot.data[index].map.toString()

                                    ),
                                  )

                                  :
                                  Text(
                                    // "Status: "+snapshot.data[index].status.toString()+
                                      "\nLocation: "+snapshot.data[index].location.toString()+
                                          "\nCheckIn: "+ outputFormat.format(inputFormat.parse(snapshot.data[index].checkin)).toString()+
                                          "\nCheckOut: "+outputFormat.format(inputFormat.parse(snapshot.data[index].checkout)).toString()+
                                          "\nAdult: "+snapshot.data[index].adult.toString()+
                                          ": Child: "+snapshot.data[index].child.toString()+
                                          ": Room: "+snapshot.data[index].room.toString()+
                                          "\nGuest Name: "+snapshot.data[index].guestname.toString()+

                                          "\nMobile Number: "+snapshot.data[index].mobilenumber.toString()+
                                          "\nNote: "+snapshot.data[index].note.toString()


                                  )
                                  ,

                                  // trailing: ElevatedButton.icon(
                                  //   onPressed: () async{
                                  //     // String fn=snapshot.data[index].filename;
                                  //     // String bs4str = snapshot.data[index].file.toString();
                                  //     // await FileProcess.downloadFile(bs4str,fn+".pdf");
                                  //   },
                                  //   icon: Icon( // <-- Icon
                                  //     Icons.edit_rounded,
                                  //     size: 24.0,
                                  //   ),
                                  //   label: Text('Edit Record'), // <-- Text
                                  // ),
                                )
                              )



                          )

                  );
              }
            },
          ),
        ),
      )
      ,

    );
  }


}