
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/User/Dashboard.dart';
import 'package:sjvn/UserShared/TransitCampList.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
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


class MyRequestForm extends StatefulWidget
{


  @override
  createState()=>MyDashboardview1();
}
class MyDashboardview1 extends State
{
  FilePickerResult? selectedfile;
  String? progress;
  String? baseimage;
  TextEditingController txt_code=new TextEditingController();
  TextEditingController txt_subject=new TextEditingController();
  TextEditingController txt_description=new TextEditingController();
  TextEditingController txt_productimage=new TextEditingController();
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
        resizeToAvoidBottomInset: false,
      appBar: AppBar(

        centerTitle: true,
        title: Text("Change Request Form"),
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
      Form(
        key: _formKey,
        child:  ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: DropdownButtonFormField(

                hint: Text('Please choose a card No'), // Not necessary for Option 1
                value: UserSharedPreferences.getCard().toString(),
                decoration: InputDecoration(
                    label: Text("Card No"),
                    hintText: "Card Number",
                    prefixIcon: Icon(Icons.account_circle_outlined),
                    border: OutlineInputBorder()
                ),
                onChanged: (value) =>
                    setState(() => txt_code.text = value.toString()
                    ),
                items: <String>[UserSharedPreferences.getCard().toString()]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                  validator: (value) {
                    if (value == null ) {
                      return 'Please select card number';
                    }
                    return null;

                  }
                // items: _menuItems,
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
              TextFormField(
                  controller: txt_subject,
                  maxLength: 100,
                  decoration: InputDecoration(
                      label: Text("Subject"),
                      hintText: "Subject",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder()
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide the Subject of the request';
                    }
                    return null;

                  }
              ),

            ),
            Container(
              padding: EdgeInsets.all(10),
              child:
              TextFormField(
                  controller: txt_description,
                  maxLength: 250,
                  keyboardType: TextInputType.multiline,
                  minLines: 5,//Normal textInputField will be displayed
                  maxLines: 10,// when user presses enter it will adapt to it
                  decoration: InputDecoration(
                      label: Text("Request Description"),
                      hintText: "Request Description",
                      //prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder()
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide the Description of the request';
                    }
                    return null;

                  }
              ),

            ),
          Container(
            padding: EdgeInsets.all(10),
            child:
            TextFormField(
                controller: txt_productimage,
                readOnly: true,


                decoration: InputDecoration(
                    label: Text("Uploaded Document : Max File Size(10MB)"),
                    hintText: "Uploaded Document : Max File Size(10MB)",
                    //prefixIcon: Icon(Icons.account_circle_outlined),
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please upload the supporting document';
                  }
                  return null;

                }
            ),

          ),
            Container(
              child: TextButton.icon(
                onPressed: loadImage,
                icon:Icon(Icons.folder_open),
                label: Text("Upload Documents"),
                //  color: Colors.deepOrangeAccent,
                // colorBrightness: Brightness.dark,

              ),
            ),
            Container(

                child: ElevatedButton(

                    child: Text("Submit Record"),
                    onPressed:() async{


    if (_formKey.currentState!.validate()) {

      DialogBuilder(context).showLoadingIndicator('Calculating');
try
{



      EncryptData ed=new EncryptData();
      String? kl=   ed.encryptData( '{"method" : "changerequestform", "userid" : "'+UserSharedPreferences.getUsername().toString()+
          '", "cardno" : "'+UserSharedPreferences.getCard().toString()+
          '", "subject" : "'+txt_subject.text.toString()+
          '", "description" : "'+txt_description.text.toString()+
          '", "data" : "'+baseimage.toString()+
          '", "filename" : "'+progress.toString()+
          '"}');
     print("object_"+sizeInMb.toString());


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
print("paas_"+response.statusCode.toString());
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
     print("paas" + data.toString());
     var res = jsonDecode(data);
      if (res["status"] == "S") {
        DialogBuilder(context).hideOpenDialog();
        Fluttertoast.showToast(

            msg: "Record Saved Successfully.Your Incident Number Is "+res['incidentno'], toastLength: Toast
            .LENGTH_LONG);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyDashboardview()),
        );
      }
      DialogBuilder(context).hideOpenDialog();
   }
      DialogBuilder(context).hideOpenDialog();
    }
    on Exception catch (_) {
      DialogBuilder(context).hideOpenDialog();
    }
    }
                    }
                )
            ),


          ],

        ),
      )





    );
  }

  void loadImage() async{
 var   image= await FilePicker.platform.pickFiles(
   allowCompression: true,
//allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf','xls','xlsx','jpg','jpeg','png','zip'],
     // withData: true,


      //allowed extension to choose
    );
    // var image= await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      selectedfile=image;
      //progress = selectedfile!.files.first.extension;
      progress = new DateTime.now().millisecondsSinceEpoch.toString()+"."+selectedfile!.files.first.extension.toString();
      File file = File(selectedfile!.files.single.path!);
      baseimage =base64Encode(file.readAsBytesSync());
      int sizeInBytes = file.lengthSync();
       sizeInMb = sizeInBytes / (1024 * 1024);
       if(sizeInMb!<=10)
         {
           txt_productimage.text=progress.toString();
         }
       else
         {
           txt_productimage.text="";
           Fluttertoast.showToast(
             backgroundColor: Colors.red,
               msg: "File size is :"+sizeInMb.toString(), toastLength: Toast
               .LENGTH_SHORT);
         }
    });
  }
}