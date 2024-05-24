
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
import '../UserShared/TransitCampDetialList.dart';
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




class MyTransitCampDetail1 extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{

  EncryptData ed=new EncryptData();
  var inputFormat = DateFormat('MM/dd/yyyy');


  var outputFormat = DateFormat('dd.MM.yyyy');
  Future<List<TransitCampDetailList>> getRequest() async {


    String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
      <userid>'''+UserSharedPreferences.getUsername().toString()+'''</userid>
     
     
    </Query>

    '''.toString();

    var requestbody=    ed.encryptData(xmldata);
    var link = ed.geturl1()+"GetTransitRecord";

    var response = await http.post(Uri.parse(link),

        body: requestbody,
        headers: {
          "Content-Type": "text/xml",

        }

    );
    List<TransitCampDetailList> users = [];

    if (response.statusCode == 200) {
      var xmldata = response.body;

      var  data = ed.decryptAES(xmldata.toString());
     print("object_"+data);
      var responseData = json.decode(data);


      final List parsedList = responseData;

  var    kk=   parsedList.toList();
  for(int j=0;j<kk.length;j++)
    {
      TransitCampDetailList user = TransitCampDetailList(
        Address: kk[j]['Address'],
        GoogleLocation : kk[j]['GoogleLocation'],
        Location : kk[j]['Location'],
        PersonName: kk[j]['PersonName'],
        msg: kk[j]['msg'],
         Name: kk[j]['Name'],

          PersonMobile : kk[j]['PersonMobile'],
          Room:kk[j]['Room'],
          id: kk[j]['id']
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
        title: Text("Transit Camp Detail"),
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

                                  Text(snapshot.data[index].Name.toString())

                                  ,
                                  subtitle:

                                  InkWell  (
                                    onTap: ()
                                    {
                                     // print("object_url");
                                      String url=ed.geturl2()+"Map.aspx?id="+snapshot.data[index].id;
                                      print("object_url"+url);

                                      openBrowserTab(url);
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => MyTransitCampMap()),
                                      // );
                                    }
                                    ,

                                    child: Text(
                                      "Location: "+snapshot.data[index].Location.toString()+

                                            "\nAddress: "+snapshot.data[index].Address.toString()+
                                            "\nContact Person Name: "+snapshot.data[index].PersonName.toString()+
                                            "\nContact Person Mobile No.: "+snapshot.data[index].PersonMobile.toString()+
                                            "\nRoom: "+snapshot.data[index].Room.toString()+
                                            "\nView Location On Google Map"
                                      // "\nGoogle Location: "+snapshot.data[index].map.toString()

                                    ),
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