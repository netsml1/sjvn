

// import 'package:firebase/Secure/MyProfile.dart';
 import 'dart:convert';
import 'dart:typed_data';

import 'package:sjvn/User/Profile.dart';
import 'package:sjvn/User/Request_Status_List.dart';
import 'package:sjvn/helper/UserSharedPerfence.dart';
// import 'package:firebase/screen/login_screen.dart';
import 'package:flutter/material.dart';

import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../helper/FileProcess.dart';
import '../helper/MyProgress.dart';
import 'Dashboard1.dart';
import 'DirectoryDocuments_List.dart';
import 'EmpanelledHospital_List.dart';

import 'Medical_Claim.dart';
import 'PolicyDocuments_List.dart';
import 'Request_Form.dart';
import 'TransitCamp_List.dart';


class  MyNavigationBar
{
  //late  Map<String, dynamic> data;

  // BuildContext? context;
  // MyNavigationBar(BuildContext context)
  // {
  //   this.context=context;
  // }
  // Future<void> foo() async {
  //   String? imagenJson =  UserSharedPreferences.getProfileImage();
  //   Uint8List? _image = await base64Decode(imagenJson!);
  // }



  static  Widget? navi(BuildContext context)
  {
    final formKey = GlobalKey<FormState>();
    // UserSharedPreferences.init();
    //
    // Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String? imagenJson =  UserSharedPreferences.getProfileImage();
    // Uint8List? _image = base64Decode(imagenJson!);
   // image = Image.memory(_image); // assign it value here
    return

      Drawer(
        child: new Column(
          children: <Widget>[
            new
                         UserAccountsDrawerHeader(
              accountName: new Text("Name: "+UserSharedPreferences.getProfileName().toString(),style: TextStyle(color: Colors.blue,backgroundColor: Colors.white),),
              accountEmail: new Text("Email: "+UserSharedPreferences.getEmail().toString()+"\nMobile: "+UserSharedPreferences.getProfileMobile().toString(),style: TextStyle(color: Colors.blue,backgroundColor: Colors.white)),
              decoration: new BoxDecoration(
                image: new DecorationImage(

                  image: new ExactAssetImage('assets/images/sjvn_bg.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
               // currentAccountPicture: CircleAvatar(
               //     backgroundImage: NetworkImage(
               //       //data=(await UserSharedPreferences.userdetail())!;
               //         UserSharedPreferences.getUrl().toString())),
              currentAccountPicture:

              CircleAvatar(


                backgroundImage:

                MemoryImage(

                   // UserSharedPreferences.getProfileImage() as Uint8List
                 // Future.delayed(Duration(seconds: 7), () async {
  base64Decode(UserSharedPreferences.getProfileImage().toString())
                  //});
                )




              )
            ),
            new Expanded(
              child: new ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[

                  new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                                  new ListTile(
                leading: Icon(Icons.medical_services),
                title: new Text("Medical Related"),
                subtitle: new Text("New Medical Claim,View Medical Claim",style:TextStyle(fontSize: 10) ,),
                onTap: () async
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Medical Related",index: "1",)),
                  );
                }
                ),
            new ListTile(
                leading: Icon(Icons.account_balance),
                title: new Text("Financial Services"),
                subtitle:new Text("LPC,Income Tax Detail,EPF and NPS",style:TextStyle(fontSize: 10) ,),
                onTap: () async
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Financial Services",index: "2",)),
                  );
                }
                ),
            new ListTile(
                leading: Icon(Icons.hotel),
                title: new Text("Transit Camp"),
                subtitle: new Text("Online Booking,Booking Detail",style:TextStyle(fontSize: 10) ,),
                onTap: () async
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Transit Camp",index: "3",)),
                  );
                }
                ),
            new ListTile(
                leading: Icon(Icons.ac_unit),
                title: new Text("Terminal Benefits"),
                subtitle: new Text("Status Of Full & Final Payment , Status Of Terminal Benfits",style:TextStyle(fontSize: 10) ,),
                onTap: () async
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Terminal Benefits",index: "4",)),
                  );
                }),
            new ListTile(
                leading: Icon(Icons.dashboard),
                title: new Text("Misc. Services"),
                subtitle: new Text("Birthday/Greeting Corner , Suggestions & Feedback ",style:TextStyle(fontSize: 10) ,),
                onTap: () async
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Misc. Services",index: "5",)),
                  );
                }),
            new ListTile(
                leading: Icon(Icons.settings),
                title: new Text("Medical Card"),
                subtitle: new Text("Download Card Detail",style:TextStyle(fontSize: 10) ,),
                onTap: () async
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Medical Card",index: "6",)),
                  );
                }

                ),
                      new ListTile(
                          leading: Icon(Icons.contact_phone),
                          title: new Text("Contact Details"),
                          subtitle: new Text("Contact Details",style:TextStyle(fontSize: 10) ,),
                          onTap: () async
                          {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Contact Details",index: "7",)),
                            // );
                          }),
                      new ListTile(
                          leading: Icon(Icons.library_books),
                          title: new Text("Central Library"),
                          subtitle: new Text("Central Library",style:TextStyle(fontSize: 10) ,),
                          onTap: () async
                          {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Central Library",index: "8",)),
                            // );
                          }),
                      new ListTile(
                          leading: Icon(Icons.add_circle),
                          title: new Text("Superannuation"),
                          subtitle: new Text("Facilitator",style:TextStyle(fontSize: 10) ,),
                          onTap: () async
                          {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Superannuation",index: "9",)),
                            // );
                          }),

                      new ListTile(
                          leading: Icon(Icons.list_alt),
                          title: new Text("Social Media Link"),
                          subtitle: new Text("Social Media Link",style:TextStyle(fontSize: 10) ,),
                          onTap: () async
                          {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => MyDashboardsubview(text: "Social Media Link",index: "10",)),
                            // );
                          }),
            new Divider(),
            new ListTile(
                leading: Icon(Icons.account_box_outlined),
                title: new Text("Profile"),
                subtitle: new Text("User Detail"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfileview()),
                  );
                }),
            new ListTile(
                leading: Icon(Icons.power_settings_new),
                title: new Text("Logout"),
                onTap: () {
                UserSharedPreferences.remove();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLoginScreen()));
                }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }
}