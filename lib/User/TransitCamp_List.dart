
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/UserShared/TransitCampList.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

void main()
{
  runApp(MaterialApp(
    home: MyTransitCampListview(),
  ));
}
class MyTransitCampListview extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{

  Future<List<TransitCampList>> getRequest() async {


                                EncryptData ed=new EncryptData();
                            var kl=    ed.encryptData('{"method" : "transitcamp", "userid" : "Puserid"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
                                List<TransitCampList> users = [];

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

                             String responseData = "["+data.toString()+"]";

                              //Creating a list to store input data;

                             for (var res in json.decode(responseData)) {
                                TransitCampList user = TransitCampList(
                                    docno: res["docno"],
                                    filename: res["filename"],
                                    date: res["date"],
                                    data: res["data"]
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
        title: Text("Transit Camp Details"),
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
        onPressed: () {},
      ),
      bottomNavigationBar: footer.FooterShow(),


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
                      title: Text("Document Number: "+snapshot.data[index].docno),
                      subtitle: Text("Date: "+snapshot.data[index].date.toString()),


                      trailing: ElevatedButton.icon(
                        onPressed: () async{
                          String fn=snapshot.data[index].filename;
                          String bs4str = snapshot.data[index].data.toString();
                          await FileProcess.downloadFile(bs4str,fn+".pdf");
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