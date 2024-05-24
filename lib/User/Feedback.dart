
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


class MyFeedbackForm extends StatefulWidget
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
        title: Text("Suggestions & Feedback"),
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
              TextFormField(
                  controller: txt_description,
                  maxLength: 1000,
                  keyboardType: TextInputType.multiline,
                  minLines: 10,//Normal textInputField will be displayed
                  maxLines: 20,// when user presses enter it will adapt to it
                  decoration: InputDecoration(
                     // label: Text("Request Description"),
                      hintText: "Feedback & Suggestions Description",
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

                child: ElevatedButton(

                    child: Text("Submit Record"),
                    onPressed:() async{


    if (_formKey.currentState!.validate()) {

      DialogBuilder(context).showLoadingIndicator('Calculating');
try
{
  String msg1="";
  EncryptData ed=new EncryptData();



  String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     
      <name>'''+txt_description.text+'''</name>
       <userid>'''+UserSharedPreferences.getUsername().toString()+'''</userid>
    
     
    </Query>

    '''.toString();
  // print("object#"+xmldata);
  var requestbody=    ed.encryptData(xmldata);
  //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
  var link = ed.geturl1()+"SaveFeedback";

  var response = await http.post(Uri.parse(link),

      body: requestbody,
      headers: {
        "Content-Type": "text/xml",

      }

  );

  if (response.statusCode == 200) {
    var xmldata = response.body;
    msg1 = ed.decryptAES(xmldata.toString());


    var res = jsonDecode(msg1);

    var msg2 = res["msg"];
    if(msg2=="S")
      {
        Fluttertoast.showToast(msg: "Record Saved Successfully".toString(),toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.green,textColor: Colors.white) ;
        txt_description.text="";
      }
    else
      {
        Fluttertoast.showToast(msg:msg2.toString(),toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

      }
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