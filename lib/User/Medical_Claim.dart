
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/User/MedicalClaim_Form.dart';
import 'package:sjvn/User/MedicalClaim_Form_2.dart';
import 'package:sjvn/UserShared/PolicyDocuments.dart';
import 'package:sjvn/UserShared/TransitCampList.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import '../UserShared/MedicalClaimFetchList.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import '../helper/MyProgress.dart';


import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;


class MyMedicalClaim extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{

  Future<List<MedicalClaimFetchList>> getRequest() async {


    EncryptData ed=new EncryptData();
    var kl=    ed.encryptData('{"method" : "medicalClaimFetchList", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
    List<MedicalClaimFetchList> users = [];

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

      // var res = jsonDecode(data);
      // var responseData = json.decode(data);

      String responseData = data.toString();

      //Creating a list to store input data;

      for (var json in json.decode(responseData)) {
        MedicalClaimFetchList user = MedicalClaimFetchList(
            requestID : json['requestID'],
            status: json['status'],
            type : json['type'],
        appliedAmount : json['appliedAmount'],

        approvedAmount : json['approvedAmount'],
        reimburseAmount: json['reimburseAmount'],
        pendingWith : json['pendingWithName'],
        pendingFrom :json['pendingFrom']

            // slno: res["slno"],
            // subject: res["subject"],
            // file: res["file"],
            // filename: res["filename"]
        );
        // print("paaas "+singleUser["docno"].toString());
        //Adding user to the list.
        users.add(user);
      }
      //  print("paaas "+responseData.toString());

      // String bs4str = res["data"].toString();
      // String fn=res["filename"];
      // await FileProcess.downloadFile(bs4str,fn+".pdf");
      // _createFileFromString(res["payslip"].toString());

      // print("paas" + res["payslip"].toString());

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
        title: Text("Medical Claim Detail"),
        actions: [
          IconButton(
            onPressed: () {
              UserSharedPreferences.remove();
              Navigator.push(context!, MaterialPageRoute(builder: (context)=>MyLoginScreen()));
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
                                onTap: (){
                                  if(snapshot.data[index].status.toString().toLowerCase()!="saved")
                                 // DialogBuilder(context).showLoadingIndicator('Calculating');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyMedicalClaimForm(text: snapshot.data[index].requestID,text1:snapshot.data[index].pendingFrom ,))
                                  );
                                  else
                                    {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MyMedicalClaimForm_2(text: snapshot.data[index].requestID,text1:snapshot.data[index].pendingFrom ,))
                                      );
                                    }

                                  //DialogBuilder(context).hideOpenDialog();
                                },
                                child:ListTile(
                                  shape: RoundedRectangleBorder( //<-- SEE HERE
                                    side: BorderSide(width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  title: Text("Request ID: "+snapshot.data[index].requestID),
                                  subtitle: Text(
                                      "Status: "+snapshot.data[index].status.toString()+
                                          "\nType: "+snapshot.data[index].type.toString()+
                                          "\nApplied Amount: "+snapshot.data[index].appliedAmount.toString()+
                                          "\nApproved Amount: "+snapshot.data[index].approvedAmount.toString()+
                                          "\nReimburse Amount: "+snapshot.data[index].reimburseAmount.toString()+
                                          "\nPending With: "+snapshot.data[index].pendingWith.toString()+
                                          "\nPending From: "+snapshot.data[index].pendingFrom.toString()
                                  ),
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