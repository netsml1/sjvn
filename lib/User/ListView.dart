
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
import '../UserShared/EncryptData.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

void main()
{
  runApp(MaterialApp(
    home: MyListview(),
  ));
}
class MyListview extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{


  @override
  void initState()
  {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);

    //MyFooter footer=new MyFooter(context);
    // WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement build
    //logindata = SharedPreferences.getInstance();
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        title: Text("SJVN Retiree Employee"),
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
drawer: MyNavigationBar.navi(context),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: callme1,
      //   label: const Text('Call Me'),
      //   icon: const Icon(Icons.phone),
      //   backgroundColor: Colors.pink,
      // )



    );
  }


}