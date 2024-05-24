import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sjvn/OTP.dart';

import 'LoginScreen.dart';
import 'UserShared/EncryptData.dart';
import 'UserShared/Profile.dart';
import 'helper/MyFooter1.dart';
import 'helper/MyProgress.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
class MyRegApp extends StatefulWidget
{
  bool text;
  MyRegApp({Key? key, required this.text}) : super(key: key);
  createState()=>MyReg();
}
class MyReg extends State<MyRegApp>
{
  TextEditingController txt_dob=new TextEditingController();
  TextEditingController txt_empid=new TextEditingController();
  TextEditingController txt_dor=new TextEditingController();
  TextEditingController txt_pwd=new TextEditingController();
  TextEditingController txt_pwd1=new TextEditingController();
  TextEditingController txt_username=new TextEditingController();
  String? txt_phone;
  String? dob;
  String? dor;
  String? userid;
  String? empname;
  final formKey = GlobalKey<FormState>(); //key for form
  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text("New Registration"),
        //backgroundColor:Colors. orange.shade900,
        bottomOpacity: 0.0,
        elevation: 0.0,

      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   elevation: 6,
      //   backgroundColor: Colors.lightBlue.shade900,
      //   child: Icon(Icons.camera),
      //   onPressed: () {},
      // ),
      bottomNavigationBar: footer.FooterShow(),
      body:
      Container(
          width: double.infinity,

          child: Form(
              key: formKey,
              child:
              Expanded(
                child: Container(
                  decoration: BoxDecoration(

                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[

                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(
                                  color: Color.fromRGBO(225, 95, 27, .3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)
                              )]
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                  readOnly: widget.text==false?true:false,
                                 controller: txt_empid,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[

                                    FilteringTextInputFormatter.digitsOnly

                                  ],
                                  validator: (value){
                                    if (value!.isEmpty == false) {
                                      return null;
                                    }
                                    return 'Employee ID is required';
                                  },
                                  decoration: InputDecoration(
                                    label: Text("Employee ID"),
                                    hintText: "Employee ID",
                                    prefixIcon: Icon(Icons.account_circle_outlined),
                                    border: OutlineInputBorder(),

                                  ),

                                ),
                              ),



                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(

                                  controller: txt_dob,
                                  validator: (value){
                                    if(value!.isEmpty==true)
                                    {
                                      return "Date Of Birth is required";
                                    }
                                    else
                                    {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      label: Text("Date Of Birth"),
                                      hintText: "Date Of Birth",
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder()
                                  ),
                                  readOnly: true,
                                  onTap: ()  async{
                                    if(widget.text==false)
                                      {
                                        return;
                                      }
                                    DateTime? pickedDate = await showDatePicker(context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2101));
                                    if(pickedDate != null ){
                                      // print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
                                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement

                                      setState(() {
                                        txt_dob.text = formattedDate;
                                        txt_dor.text="";//set output date to TextField value.
                                      });
                                    }else{
                                      // Fluttertoast.showToast(msg: "Date is not selected",toastLength: Toast.) ;
                                    }
                                  },
                                ),

                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextFormField(
                                   controller: txt_dor,
                                  validator: (value){
                                    if(value!.isEmpty==true)
                                    {
                                      return "Date Of Retirement is required";
                                    }
                                    else
                                    {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      label: Text("Date Of Retirement"),
                                      hintText: "Date Of Retirement",
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder()
                                  ),
                                  readOnly: true,
                                  onTap: () async{
                                    if(widget.text==false)
                                    {
                                      return;
                                    }
                                    DateTime? pickedDate = await showDatePicker(context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2101));
                                    if(pickedDate != null ){
                                      DialogBuilder(context).showLoadingIndicator('Calculating');

                                      // print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
                                      print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                      //you can implement different kind of Date Format here according to your requirement
                                    //  Fluttertoast.showToast(msg: "Date is not selected",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
                                      EncryptData ed=new EncryptData();
                                      var detail= await ed.GetSomeData(txt_empid.text);
                                      var responseData = json.decode(detail);
                                      //print("object_"+detail);
                                      // for (var res in responseData['dependent']) {
                                      //   dependent user = dependent(
                                      //       EMPRETID: res["EMPRETID"],
                                      //       NAME: res["NAME"],
                                      //       DTOBRTH: res["DTOBRTH"],
                                      //       CELL_NO: res["CELL_NO"]
                                      //   );
                                     // responseData.then((value) {


                                         setState(() {
                                        dor=    responseData['self']["DRSD_DATE"].toString();
                                        dob=responseData['self']["DTOBRTH"].toString();
                                        txt_phone=responseData['self']["CELL_NO"].toString();
                                        userid=responseData['self']["EMPRETID"].toString();
                                        empname=responseData['self']["NAME"].toString();

                                         });



                                     // });
                                      setState(()  {


                                        txt_dor.text = formattedDate;
                                        if(txt_empid.text.isEmpty==true)
                                        {
                                          Fluttertoast.showToast(msg: "Employee ID is required",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

                                          return;
                                        }
                                        else if(txt_dob.text.isEmpty==true)
                                          {
                                             Fluttertoast.showToast(msg: "Date of birth is required",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

                                            return;
                                          }
                                        String? st;

                                        var otp=ed.getInteger(4);

                                       print("object_");

                                        if(txt_dor.text!=dor && txt_dob.text!=dob)
                                          {
                                            Fluttertoast.showToast(msg: "Details are not match",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
                                            DialogBuilder(context).hideOpenDialog();

                                            return;
                                          }

                                      var msg=   ed.send_request("OTP for Ex-employee Portal is $otp-SJVN Limited", "1007901543481898216", "$txt_phone", "$otp");
                                        msg.then((value) {
                                          if(value=="S")
                                            {
                                              DialogBuilder(context).hideOpenDialog();
                                           final result=   Navigator.push(
                                                  context, MaterialPageRoute(
                                                  builder: (context) => OTP(text: otp.toString(),txt_phone:txt_phone! ,)));//set output date to TextField value.

                                           if(result!="")
                                             {
                                               result.then((val){
                                                 setState(() {
                                                  widget.text = val;
                                                 });
                                                 // widget.text = val;
                                                // print("object_"+val.toString());

                                               });
                                             }
                                            //print("object_"+result.toString());
                                              // setState(() {
                                              //  widget. text = result as bool;
                                              // });
                                            }
                                          else
                                            {
                                              Fluttertoast.showToast(msg: value,toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
                                              DialogBuilder(context).hideOpenDialog();

                                            }
                                        });


                                      });
                                    }else{
                                      // Fluttertoast.showToast(msg: "Date is not selected",toastLength: Toast.) ;
                                    }
                                  },
                                ),

                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors. grey.shade100))
                                ),
                                child: TextFormField(
                                  readOnly: widget.text,
                                 controller: txt_username,
                                  validator: (value){
                                    if(value!.isEmpty || !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&_])[A-Za-z\d@$!%*#?&_]{8,}$').hasMatch(value)){
                                      return "Minimum eight characters,at least one letter,\n one number and one special character";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(

                                    hintText: "Username",
                                    label:Text("Enter Username"),
                                    prefixIcon: Icon(Icons.account_box_outlined),
                                    border: OutlineInputBorder(),
                                    hintStyle: TextStyle(color: Colors.grey),

                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),

                                child: TextFormField(
                                  readOnly: widget.text,
                                  obscureText: true,
                                  controller: txt_pwd,
                                  validator: (value) {
                                    if(value!.isEmpty || !RegExp(r'^[a-z0-9]{6,15}$').hasMatch(value)){
                                      return ". Match characters and symbols in the list, a-z, 0-9\n2. Length at least 6 characters and maximum length of 15";
                                    }else{
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      label:Text("Enter Password"),
                                      prefixIcon: Icon(Icons.password),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder()
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),

                                child: TextFormField(
                                  readOnly: widget.text,
                                  obscureText: true,
                                   controller: txt_pwd1,
                                  validator: (value) {
                                    //print("validate_"+txt_pwd.text);
                                   // if (value!.length < 8) {
                                     // return 'Password must be 8 digits';
                                      if(value!.toString()!=txt_pwd.text)
                                        {
                                          return 'Password not match';
                                        }

                                   // }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Retype Password",
                                      label:Text("Retype Password"),
                                      prefixIcon: Icon(Icons.password),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder()
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 10,),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue[900]
                          ),
                          child: Center(
                              child:
                              TextButton(


                                child:Text("Sign Up",


                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                                onPressed: () {
                                  if(formKey.currentState!.validate()) {
                                    _onPressed(context);
                                  }
                                },
                              )

                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),

                  ),
                ),
              )
          )




      ),

    );
  }
  void _onPressed(BuildContext context) async {
    if(formKey.currentState!.validate()) {
      EncryptData ed=new EncryptData();
      DialogBuilder(context).showLoadingIndicator('Calculating');

      String msg1="";
      String xmldata='''<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <Query>
     <MobileNo>'''+txt_phone!+'''</MobileNo>
       <Username>'''+txt_username.text+'''</Username>
      <Password>'''+ed.encryptData(txt_pwd.text)+'''</Password>
        <EmpID>'''+txt_empid.text+'''</EmpID>
        <UserID>'''+userid!+'''</UserID>
    </Query>

    '''.toString();
     // print("object#"+xmldata);
      var requestbody=    ed.encryptData(xmldata);
      //print("object*"+'{"MobileNo" : "MobileNo_1", "dlttempid" : "dlttempid_1", "msg" : "msg_1", "Code" : "Code_1"}'.replaceAll("MobileNo_1", phone).replaceAll("dlttempid_1", tempid).replaceAll("msg_1", msg).replaceAll("Code_1", otp));
      var link = ed.geturl1()+"SaveUser";

      var response = await http.post(Uri.parse(link),

          body: requestbody,
          headers: {
            "Content-Type": "text/xml",

          }

      );
print("object_"+response.statusCode.toString());
      if (response.statusCode == 200) {
        var xmldata = response.body;
        var data=ed.decryptAES(xmldata.toString());

        var res = jsonDecode(data);
        msg1=res["msg"];
        if (msg1 == "S")
        {
          String otp1 = ed.getInteger(4).toString();
          String msg = "Your Ex-employee Portal user account with Username " + txt_username.text + " is successfully generated-SJVN Limited";

          String tempid = "1007655549613578270";
          var msg_1=   ed.send_request("$msg", "$tempid", "$txt_phone", "$otp1");
          Fluttertoast.showToast(msg: "Dear " + empname! + " Your Ex - Employee Portal Username: " + txt_username.text + " is successfully created.",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => MyLoginScreen()));


        }
        else
          {
            Fluttertoast.showToast(msg: msg1,toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
            DialogBuilder(context).hideOpenDialog();
          }
      }
      else
        {
          Fluttertoast.showToast(msg: response.statusCode.toString(),toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

          DialogBuilder(context).hideOpenDialog();
        }
     // Navigator.pop(context);

     }
  }


}

