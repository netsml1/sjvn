
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/User/Dashboard.dart';
import 'package:sjvn/UserShared/TransitCampList.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import '../helper/FileProcess.dart';
import '../helper/Items.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import '../helper/MyProgress.dart';
import 'MyNavigationBar.dart';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;


class TransitCampForm extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{
  FilePickerResult? selectedfile;
  DateTime? dt;
  DateTime? dt1;
  String? progress;
  String? baseimage;
  String? txt_location;
  TextEditingController txt_checkin=new TextEditingController();
  TextEditingController txt_checkout=new TextEditingController();
  TextEditingController txt_adult=new TextEditingController();
  TextEditingController txt_child=new TextEditingController();
  String? txt_room;
  TextEditingController txt_name=new TextEditingController();
  TextEditingController txt_address=new TextEditingController();
  TextEditingController txt_mobile=new TextEditingController();
  TextEditingController txt_note=new TextEditingController();
  String? txt_type;
  List<DropdownMenuItem<String>>? _menuItems;
  XFile? _file1;
  File? _file;
  String? _image_file;
  double? sizeInMb;
  bool isLoading = false;

  @override
  void initState()
  {
    super.initState();
getlocation();
  }
getlocation() async
{
  EncryptData ed=new EncryptData();
  List<dynamic>? kk;


  String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
      <UserID>'''+UserSharedPreferences.getUsername().toString()+'''</UserID>
      
     
    </Query>

    '''.toString();

  var requestbody=    ed.encryptData(xmldata);
  var link = ed.geturl1()+"GetLocation";

  var response = await http.post(Uri.parse(link),

      body: requestbody,
      headers: {
        "Content-Type": "text/xml",

      }

  );
  if (response.statusCode == 200) {
    var xmldata = response.body;
  var  data = ed.decryptAES(xmldata.toString());
    var responseData = json.decode(data);


    final List parsedList = responseData;

    kk=   parsedList.toList();

    setState(() {
      _menuItems = List.generate(
        kk!.length,
            (i) => DropdownMenuItem(
          value: kk![i]["id"].toString(),
          // key:kk[i]["CARD_NO"],
          child: Text("${kk![i]["name"]}"),
        ),
      );
    });
    //print("object"+_menuItems!.length.toString());
  }
}
  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);
    MyHeader header=new MyHeader(context);
    final _formKey = GlobalKey<FormState>();

    //MyFooter footer=new MyFooter(context);
    // WidgetsFlutterBinding.ensureInitialized();
    // TODO: implement build
    //logindata = SharedPreferences.getInstance();
    return Scaffold(
      //  resizeToAvoidBottomInset: false,
      appBar: AppBar(

        centerTitle: true,
        title: Text("Transit Camp Booking"),
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   elevation: 5,
      //   backgroundColor: Colors.lightBlue.shade900,
      //   child: Icon(Icons.camera),
      //   onPressed: () {},
      // ),
      bottomNavigationBar: footer.FooterShow(),
      body:
      Form(
        key: _formKey,
        child:  ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              DropdownButtonFormField(

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the location';
                  }
                  return null;

                },

                //key: productlistddlKey,
                hint: Text('Location'), // Not necessary for Option 1
               value: txt_location,
                decoration: InputDecoration(
                  label: Text("Location"),
                  hintText: "Location",
                  prefixIcon: Icon(Icons.location_history),
                  border: OutlineInputBorder(),
                  filled: true,

                  fillColor: Colors.blue.shade50,
                ),
               onChanged: (value){

                  setState(() {
                    txt_location=value!.toString();
                  });
               },

                // items: <String>['']
                //     .map<DropdownMenuItem<String>>((String value) {
                //   return DropdownMenuItem<String>(
                //     value: value,
                //     child: Text(value),
                //   );
                // }).toList(),
                items: _menuItems,
                // items: _myJson!.map((Map map) {
                //   return new DropdownMenuItem<String>(
                //     value: map["country"].toString(),
                //     child: new Text(
                //       map["country"],
                //     ),
                //   );
                // }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              DropdownButtonFormField(

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select the type';
                  }
                  return null;

                },

                //key: productlistddlKey,
                hint: Text('Type'), // Not necessary for Option 1
                value: txt_type,
                decoration: InputDecoration(
                  label: Text("Type"),
                  hintText: "Type",
                  prefixIcon: Icon(Icons.location_history),
                  border: OutlineInputBorder(),
                  filled: true,

                  fillColor: Colors.blue.shade50,
                ),
                onChanged: (value){

                  setState(() {
                    txt_type=value!.toString();
                  });
                },

                items: <String>['Transit Camp','Guest']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_checkin,
                validator: (value){
                  print("object_"+value.toString());
                  if(value!.isEmpty)
                  {
                    return "CheckIn date is required";
                  }
                  else
                  {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: Text("CheckIn date"),
                    hintText: "CheckIn date",
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder()
                ),
                readOnly: true,
                onTap: () async{
                  // if(widget.text==false)
                  // {
                  //   return;
                  // }

                  DateTime? pickedDate = await showDatePicker(context: context,
                      initialDate:  DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101));
                  if(pickedDate != null ){
                    //DialogBuilder(context).showLoadingIndicator('Calculating');

                    // print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
                    print(formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dt=pickedDate;
                      txt_checkin.text=formattedDate;
    if(dt1!.compareTo(dt!) < 0) {
      txt_checkout.text = "";
    }

                    });
                  }else{
                    //Fluttertoast.showToast(msg: "Date is not selected",toastLength: Toast.) ;
                  }
                },
              ),

            ),

            Container(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: txt_checkout,
                validator: (value){
                  if(value!.isEmpty)
                  {
                    return "Checkout date is required";
                  }
                  else
                  {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    label: Text("CheckOut date"),
                    hintText: "CheckOut date",
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder()
                ),
                readOnly: true,
                onTap: () async{
                  if(txt_checkin.text.isEmpty)
                  {
                    Fluttertoast.showToast(msg: "CheckIn date is required",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

                    return;
                  }


                // print("object"+DateTime.now().toString());
                  print("object"+dt.toString());

                  DateTime? pickedDate = await showDatePicker(context: context,
                      initialDate: DateTime.parse(dt.toString()),
                      firstDate:DateTime.parse(dt.toString()),
                      lastDate: DateTime(2101));
                  if(pickedDate != null ){
                    //DialogBuilder(context).showLoadingIndicator('Calculating');

                    // print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
                    print(formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dt1=pickedDate;
                      txt_checkout.text=formattedDate;
                    });
                  }else{
                    //Fluttertoast.showToast(msg: "Date is not selected",toastLength: Toast.) ;
                  }
                },
              ),

            ),
        Container(
          padding: EdgeInsets.all(10),
          child:
          TextFormField(

              keyboardType: TextInputType.number,
              controller: txt_adult,
              decoration: InputDecoration(
                  label: Text("Number of Adult"),
                  hintText: "Number of Adult",
                  prefixIcon: Icon(Icons.account_box_outlined),
                  border: OutlineInputBorder()
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number adult';
                }
                return null;

              }
          ),
        ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              TextFormField(
                controller: txt_child,

                  keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                      label: Text("Number of Child"),
                      hintText: "Number of Child",
                      prefixIcon: Icon(Icons.account_box_outlined),
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter child';
                    }
                    return null;

                  }
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              DropdownButtonFormField(

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select number of rooms';
                  }
                  return null;

                },

                //key: productlistddlKey,
                hint: Text('Number of rooms'), // Not necessary for Option 1
                value: txt_room,
                decoration: InputDecoration(
                  label: Text("Number of rooms"),
                  hintText: "Number of rooms",
                  prefixIcon: Icon(Icons.room),
                  border: OutlineInputBorder(),
                  filled: true,

                  fillColor: Colors.blue.shade50,
                ),
                onChanged: (value){

                  setState(() {
                    txt_room=value!.toString();
                  });
                },

                items: <String>['1','2','3','4','5','6','7','8','9','10']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              TextFormField(
controller: txt_name,
                 // keyboardType: TextInputType.number,

                  decoration: InputDecoration(
                      label: Text("Guest Name"),
                      hintText: "Guest Name",
                      prefixIcon: Icon(Icons.account_box_outlined),
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter guest name';
                    }
                    return null;

                  }
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              TextFormField(
                  controller: txt_address,
                  maxLength: 250,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,//Normal textInputField will be displayed
                  maxLines: 10,// when user presses enter it will adapt to it
                  decoration: InputDecoration(
                      label: Text("Guest Address"),
                      hintText: "Guest Address",
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter guest address';
                    }
                    return null;

                  }
              ),

            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              TextFormField(
controller: txt_mobile,
                keyboardType: TextInputType.number,

                  maxLength: 10,
                  decoration: InputDecoration(
                      label: Text("Guest Mobile"),
                      hintText: "Guest Mobile",
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter guest mobile';
                    }
                    return null;

                  }
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              TextFormField(
                  controller: txt_note,
                  maxLength: 350,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,//Normal textInputField will be displayed
                  maxLines: 10,// when user presses enter it will adapt to it
                  decoration: InputDecoration(
                      label: Text("Note"),
                      hintText: "Note",
                      prefixIcon: Icon(Icons.note),
                      border: OutlineInputBorder()
                  ),

              ),

            ),
            Container(

                child: ElevatedButton(

                    child: Text("Submit Record"),
                    onPressed:() async{


                if (_formKey.currentState!.validate())
                  {
                    if(txt_location!.isEmpty==true)
                      {

                      }
                    EncryptData ed=new EncryptData();
                    DialogBuilder(context).showLoadingIndicator('Calculating');

                    String msg1="";
                    String cdate=dt.toString()+" to "+dt1.toString();
                    String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     <rangedatepicker>'''+cdate!+'''</rangedatepicker>
       <location>'''+txt_location!+'''</location>
       
      <adult>'''+txt_adult.text+'''</adult>
        <child>'''+txt_child.text+'''</child>
        <name>'''+txt_name.text+'''</name>
         <address>'''+txt_address.text+'''</address>
          <mobile>'''+txt_mobile.text+'''</mobile>
         <note>'''+txt_note.text+'''</note>
         <userid>'''+UserSharedPreferences.getUsername().toString()+'''</userid>
          <room>'''+txt_room!+'''</room>
    </Query>

    '''.toString();
                    print("object#"+xmldata);
                    var requestbody=    ed.encryptData(xmldata);
                    //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
                    var link = ed.geturl1()+"SaveTransitCamp";

                    var response = await http.post(Uri.parse(link),

                        body: requestbody,
                        headers: {
                          "Content-Type": "text/xml",

                        }

                    );
                    if (response.statusCode == 200) {
                      var xmldata = response.body;
                      var data = ed.decryptAES(xmldata.toString());

                      var res = jsonDecode(data);
if(res["msg"]=="F")
  {
    Fluttertoast.showToast(msg:res["error"],toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

  }
else
  {
    _formKey.currentState!.reset();
    Fluttertoast.showToast(msg: "Your Transit Camp Booking RequestID is "+res["msg"],toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

  }

                    }
                    DialogBuilder(context).hideOpenDialog();
                   }



                    }
                )
            ),
            SizedBox(
              height: 10,
            ),



          ],

        ),
      )





    );
  }


}