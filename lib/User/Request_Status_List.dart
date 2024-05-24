
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/UserShared/PolicyDocuments.dart';
import 'package:sjvn/UserShared/TransitCampList.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
import '../UserShared/EncryptData.dart';
import '../UserShared/RequestStatus.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;


class MyRequestStatusListview extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{

  Future<List<RequestStatusList>> getRequest() async {


                                EncryptData ed=new EncryptData();
                            var kl=    ed.encryptData('{"method" : "changerequeststatus", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
                                List<RequestStatusList> users = [];

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
//print("paas_data"+responseData);
                              //Creating a list to store input data;

                             for (var res in json.decode(responseData)) {
                               RequestStatusList user = RequestStatusList(
                                    ATTACHMENT_BASE6: res["ATTACHMENT_BASE64"],
                                    CARD_NO: res["CARD_NO"],
                                    CHNG_ON_HRDTL: res["CHNG_ON_HRDTL"],
                                    CREATED_AT: res["CREATED_AT"],
                                 CREATED_ON: res["CREATED_ON"],

                                 DESCRIPTION: res["DESCRIPTION"],
                                 EMP_NO: res["EMP_NO"],
                                 FILE_NM: res["FILE_NM"],
                                 FILE_TYPE: res["FILE_TYPE"],
                                 HEADING: res["HEADING"],

                                 HR_DTL: res["HR_DTL"],
                                 HR_RMRK: res["HR_RMRK"],
                                 INCIDENT_NO: res["INCIDENT_NO"],
                                STATUS: res["STATUS"]
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
        title: Text("Request Status"),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MyApp2(text: "https://ecc.sjvn.co.in:44300/sap/bc/ui2/flp")),
              // );
            },

            icon: Image.asset('assets/images/sjvn_logo.png'),
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
        onPressed: () {},
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
                    child:      ListTile(
                      shape: RoundedRectangleBorder( //<-- SEE HERE
                        side: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: Text(snapshot.data[index].INCIDENT_NO.toString()),
                      subtitle: Text(
                          "Employee No: "+snapshot.data[index].EMP_NO.toString()+
                              "\nCard No: "+snapshot.data[index].CARD_NO.toString()+
                              "\nIssue Heading: "+snapshot.data[index].HEADING.toString()+
                              "\nDescription: "+snapshot.data[index].DESCRIPTION.toString()+
                              "\nStatus: "+snapshot.data[index].STATUS.toString()+
                              "\nCreated At: "+snapshot.data[index].CREATED_AT.toString()+
                              "\nCreated On: "+snapshot.data[index].CREATED_ON.toString()+
                              "\nChange on HR Detail: "+snapshot.data[index].CHNG_ON_HRDTL.toString()+
                              "\nHR Detail: "+snapshot.data[index].CREATED_ON.toString()+
                              "\nChange on HR Detail: "+snapshot.data[index].HR_DTL.toString()+
                              "\nHR Remarks: "+snapshot.data[index].HR_RMRK.toString()
                      ),
                      trailing: ElevatedButton.icon(
                        onPressed: () async{
                          String fn=snapshot.data[index].FILE_NM;
                          //print("object_file"+fn);
                          String bs4str = snapshot.data[index].ATTACHMENT_BASE6.toString();
                          print("object_file"+bs4str);
                          await FileProcess.downloadFile(bs4str,fn);
                        },
                        icon: Icon( // <-- Icon
                          Icons.download,
                          size: 24.0,
                        ),
                        label: Text('Download'), // <-- Text
                      ),
                    ),
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