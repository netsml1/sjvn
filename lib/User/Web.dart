
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
import 'package:webview_flutter/webview_flutter.dart';

// void main()
// {
//   runApp(MaterialApp(
//     home: MyDashboardview(),
//   ));
// }
class MyWebview extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{
  late final WebViewController controller;
  final options1 = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(

      javaScriptEnabled: true,

    ),
  );
  @override
  void initState()
  {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          // onNavigationRequest: (NavigationRequest request) {
          //   if (request.url.startsWith('https://www.youtube.com/')) {
          //     return NavigationDecision.prevent;
          //   }
          //   return NavigationDecision.navigate;
          // },
        ),
      )
      ..loadRequest(Uri.parse('https://sjvn.nic.in/'));
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
      appBar: header.HeaderShow(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Colors.lightBlue.shade900,
        child: Icon(Icons.camera),
        onPressed: () {},
      ),
      bottomNavigationBar: footer.FooterShow(),

      drawer:  MyNavigationBar.navi(context),

      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: callme1,
      //   label: const Text('Call Me'),
      //   icon: const Icon(Icons.phone),
      //   backgroundColor: Colors.pink,
      // )
body:
      InAppWebView(
     // key: _key,


      initialUrlRequest:URLRequest(url:Uri.parse("https://connect.sjvn.co.in/#services")) ,


    initialOptions: options1,
    // onWebViewCreated: (InAppWebViewController controller)  {
    //
    // webView = controller;
    //
    //
    // },
      )
      ,
    );
  }


}



