
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sjvn/User/Dashboard.dart';


import 'OTP1.dart';
import 'SignUpScreen.dart';
import 'UserShared/EncryptData.dart';
import 'package:sjvn/helper/UserSharedPerfence.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'helper/MyFooter1.dart';
import 'helper/MyProgress.dart';

// void main()
// {
//   runApp(MaterialApp(
//     home: MaterialApp(
//       home: MyLoginScreen(),
//     ),
//   ));
// }
class MyLoginScreen extends StatefulWidget
{
  createState()=>MyLoginScreen1();
}
class MyLoginScreen1 extends State<MyLoginScreen>
{


  var passKey = GlobalKey<FormFieldState>();
   bool? status;


   @override
   void initState()
   {
     super.initState();
    // UserSharedPreferences.init();
     UserSharedPreferences.init();
     // Future.delayed(Duration(seconds: 1), () async {
     //  // DialogBuilder(context).showLoadingIndicator('Calculating');
     //   bool? login= (UserSharedPreferences.getLogin() ?? false);
     //  // UserSharedPreferences.getImage();
     //   //print("login");
     //   if(login==true)
     //   {
     //   await Navigator.push(context, MaterialPageRoute(builder: (context)=>MyDashboardview()));
     //
     //   }
     //  // DialogBuilder(context).hideOpenDialog();
     //   // if(login==false)
     //   // {
     //   //   //print(login.toString());
     //   //
     //   //   Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLoginScreen()));
     //   //
     //   // }
     //
     //
     //
     // });
   }

  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);

    TextEditingController user_name=new TextEditingController();
    TextEditingController user_pass=new TextEditingController();
    final _formKey = GlobalKey<FormState>();

    // status = (UserSharedPreferences.getLogin() ?? false);
    //
    //
    // if (status == true) {
    // //   //print(newuser);
    //    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyListView()));
    //  }

    bool _validate = false;
    LocalAuthentication auth = LocalAuthentication();
    Future authenticate() async {
      final bool isBiometricsAvailable = await auth.isDeviceSupported();

      if (!isBiometricsAvailable) return false;

      try {
        return await auth.authenticate(
          localizedReason: 'Scan Fingerprint To Enter Retiree Portal',
          options: const AuthenticationOptions(
              useErrorDialogs: true,
              stickyAuth: true,
              biometricOnly: true
          ),
        );
      } on PlatformException catch (e){

        return;
      }
    }

    // TODO: implement build
    return Scaffold(

       appBar: AppBar(
         centerTitle: true,
         title: Text("Login Screen"),
         backgroundColor: Colors.lightBlue.shade900,
         //leading: Image.asset('assets/images/retiree_logo.jpeg',height: 10,),
       automaticallyImplyLeading: false,

       ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   elevation: 5,
        //   backgroundColor: Colors.lightBlue.shade900,
        //   child: Icon(Icons.camera),
        //   onPressed: () {
        //     // Navigator.push(
        //     //   context,
        //     //   MaterialPageRoute(builder: (context) => MyMedicalClaimForm()),
        //     // );
        //   },
        // ),
        bottomNavigationBar: footer.FooterShow(),

backgroundColor: Colors.white,
     // SingleChildScrollView
      body: SingleChildScrollView(
        child:Form(
          key: _formKey,
          child: Column(

//mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                height: 200.0,
                //width: 190.0,
                //padding: EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(120),
                    border: Border.all(width: 1,color: const Color(0xff7c94b6) )

                ),
                child: Center(
                  child: Image.asset('assets/images/retiree_logo.jpeg',opacity: const AlwaysStoppedAnimation(.9),height: 150),
                ),
              ),

              Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.sentences,
                    controller: user_name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;

                    }

                    ,

                    decoration: InputDecoration(
                      label:Text("Username"),
                      prefixIcon: Icon(Icons.account_box_outlined),
                      border: OutlineInputBorder(),
                      // errorText: _validateName(user_name.text),
                    ),


                  )

              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: user_pass,
                    obscureText: true,
                    decoration: InputDecoration(

                        label:Text("Password"),
                        prefixIcon: Icon(Icons.account_box_outlined),
                        border: OutlineInputBorder()

                    ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;

                      }
                  )

              ),
              Container(
                width: 150,
                // margin: EdgeInsets.fromLTRB(200, 0, 0, 0),
                child: ElevatedButton( child: Text("Login"),onPressed:  () async {

                  if (_formKey.currentState!.validate()) {
                    DialogBuilder(context).showLoadingIndicator('Calculating');

                    String emp_id="";
                    EncryptData ed=new EncryptData();
                   var data=await ed.upddetail(user_name.text,user_pass.text);
                    var res3 = jsonDecode(data);
                    if(res3[0]["msg"]!="S")
                      {
                        Fluttertoast.showToast(msg: res3[0]["msg"],toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

                        Fluttertoast.showToast(
                            msg: res3[0]["msg"], toastLength: Toast
                            .LENGTH_SHORT);
                        DialogBuilder(context).hideOpenDialog();
                        return;
                      }

                    emp_id= res3[0]["empid"];

                    var detail= await ed.GetSomeData(emp_id);

                    var responseData = json.decode(detail);
                    var res = json.decode(detail);

                    String? phone="";
                    String? userid="";
                    phone=responseData['self']["CELL_NO"].toString();
                    userid=responseData['self']["EMPRETID"].toString();

                    var detail1= await ed.login(user_name.text, user_pass.text, phone, emp_id, userid);

                    var responseData1 = json.decode(detail1);

                   String? msg1=responseData1[0]["msg"];
                     if(msg1=="S")
                     {
                       String otp=ed.getInteger(4).toString();


                       //print("object_13_"+phone.toString());
                       var msg=  await ed.send_request("OTP for Ex-employee Portal is $otp-SJVN Limited", "1007901543481898216", "$phone", "$otp");
                       if(msg=="S")
                        {
                          DialogBuilder(context).hideOpenDialog();
                          final result=   Navigator.push(
                                          context, MaterialPageRoute(
                                           builder: (context) => OTP(text: otp.toString(),txt_phone:phone!)));//set output date to TextField value.
                          if(result!="")
                          {
                            result.then((val){
                              setState(() {
                                if(val==false)
                                  {
                                    UserSharedPreferences.setProfileName(res['self']['NAME'].toString());
UserSharedPreferences.setProfileEmail(res['self']['EMAIL_ID'].toString().toLowerCase());
UserSharedPreferences.setProfileMobile(res['self']['CELL_NO'].toString());
UserSharedPreferences.setProfileImage(res['self']['FILECONTENT'].toString());
UserSharedPreferences.setProfileCard(res['self']['CARD_NO'].toString());
                          UserSharedPreferences.setProfile(
                              res['self']['EMPRETID'].toString(), res['self']['REF_EMPID'].toString(), res['self']['DEP_ID'].toString(),
                              res['self']['DEP_ID_STR'].toString(), res['self']['NAME'].toString(), res['self']['DTOBRTH'].toString(), res['self']['FILETYPE'].toString(),
                              res['self']['FILECONTENT'].toString(), res['self']['CELL_NO'].toString(), res['self']['EMAIL_ID'].toString(),
                              res['self']['PERSA'].toString(), res['self']['CARD_NO'].toString(), res['self']['VALID_TILL'].toString(), res['self']['SEP_TYP'].toString(),
                              res['self']['BANKL'].toString(), res['self']['BANKN'].toString(), res['self']['KOSTL'].toString(),
                              res['self']['PRCTR'].toString(), res['self']['BET01'].toString(), res['self']['BLD_GRP'].toString(), res['self']['BLD_GRP_STR'].toString(), res['self']['GENDER'].toString(),
                              res['self']['GENDER_STR'].toString(),res['self']['EMP_POSTN'].toString(),res['self']['DTOJOIN'].toString());
                                    //                         UserSharedPreferences.setUsername(user_name.text);
                        UserSharedPreferences.setLogin(true);
                                    UserSharedPreferences.setUsername(res['self']['EMPRETID'].toString());
//



                        // DialogBuilder(context).hideOpenDialog();

                        Fluttertoast.showToast(
                            msg: "Welcome....", toastLength: Toast
                            .LENGTH_SHORT);
                        Navigator.push(
                            context, MaterialPageRoute(
                            builder: (context) => MyDashboardview()));
                       // DialogBuilder(context).hideOpenDialog();
                                  }
                              });
                              // widget.text = val;
                              // print("object_"+val.toString());

                            });
                          }
                        }
                       else
                         {
                           Fluttertoast.showToast(msg: msg.toString(),toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

                         }


                     }
                     else
                       {
                         Fluttertoast.showToast(msg: "Invalid username/password".toString(),toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;
                         DialogBuilder(context).hideOpenDialog();
                         return;


                       }

                  }



//                   if (_formKey.currentState!.validate()) {
//
//                     var params = {
//                       "method": "loginCheck",
//                       "userid": user_name.text,
//                       "password": user_pass.text,
//
//                     };
//                     EncryptData ed=new EncryptData();
//                 var kl=    ed.encryptData('{"method" : "loginCheck", "userid" : "Puserid", "password" : "Ppassword"}'.replaceAll("Puserid", user_name.text).replaceAll("Ppassword", user_pass.text));
//
//                     var link = ed.geturl();
//                     var requestbody ='''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
//     <Body>
//      <RetireeMobileApp xmlns="http://co.in/sjvn/RetireeMobileApp/">
//             <data xmlns="">paasinfotech</data>
//         </RetireeMobileApp>
//     </Body>
// </Envelope>
//
//     '''.toString().replaceAll("paasinfotech", kl);
//                     var response = await http.post(Uri.parse(link),
//
//                         body: requestbody,
//                         headers: {
//                          "Content-Type": "text/xml",
//
//                         }
//
//                     );
// print("paas_login"+kl.toString());
//                     if (response.statusCode == 200) {
//                 var xmldata=response.body;
//                       var contact = xml.XmlDocument.parse(xmldata);
//                       //print("paas"+ contact.findAllElements('return').first.text.toString());
//                     var result=contact.findAllElements('return').first.text.toString();
//                    // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
//                // EncryptData.encryptAES(xmldata);
//
//               var data=  ed.decryptAES(result);
//               print("paas"+data.toString());
//                       var res = jsonDecode(data);
//
//
//                       if (res["status"] == "S") {
//
//
//                         var kl=    ed.encryptData('{"method" : "selfdependentdetails", "userid" : "Puserid", "password" : "Ppassword"}'.replaceAll("Puserid", user_name.text).replaceAll("Ppassword", user_pass.text));
//
//                         var link = ed.geturl();
//                         var requestbody ='''<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
//     <Body>
//      <RetireeMobileApp xmlns="http://co.in/sjvn/RetireeMobileApp/">
//             <data xmlns="">paasinfotech</data>
//         </RetireeMobileApp>
//     </Body>
// </Envelope>
//
//     '''.toString().replaceAll("paasinfotech", kl);
//                         var response = await http.post(Uri.parse(link),
//
//                             body: requestbody,
//                             headers: {
//                               "Content-Type": "text/xml",
//
//                             }
//
//                         );
//                         if (response.statusCode == 200) {
//
//                           var xmldata=response.body;
//                           var contact = xml.XmlDocument.parse(xmldata);
//                           //print("paas"+ contact.findAllElements('return').first.text.toString());
//                           var result=contact.findAllElements('return').first.text.toString();
//                           // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
//                           // EncryptData.encryptAES(xmldata);
//
//                           var data=  ed.decryptAES(result);
//                           print("paaas"+data.toString());
//                           var res = jsonDecode(data);
// UserSharedPreferences.setProfileName(res['self']['NAME'].toString());
// UserSharedPreferences.setProfileEmail(res['self']['EMAIL_ID'].toString().toLowerCase());
// UserSharedPreferences.setProfileMobile(res['self']['CELL_NO'].toString());
// UserSharedPreferences.setProfileImage(res['self']['FILECONTENT'].toString());
// UserSharedPreferences.setProfileCard(res['self']['CARD_NO'].toString());
//                           UserSharedPreferences.setProfile(
//                               res['self']['EMPRETID'].toString(), res['self']['REF_EMPID'].toString(), res['self']['DEP_ID'].toString(),
//                               res['self']['DEP_ID_STR'].toString(), res['self']['NAME'].toString(), res['self']['DTOBRTH'].toString(), res['self']['FILETYPE'].toString(),
//                               res['self']['FILECONTENT'].toString(), res['self']['CELL_NO'].toString(), res['self']['EMAIL_ID'].toString(),
//                               res['self']['PERSA'].toString(), res['self']['CARD_NO'].toString(), res['self']['VALID_TILL'].toString(), res['self']['SEP_TYP'].toString(),
//                               res['self']['BANKL'].toString(), res['self']['BANKN'].toString(), res['self']['KOSTL'].toString(),
//                               res['self']['PRCTR'].toString(), res['self']['BET01'].toString(), res['self']['BLD_GRP'].toString(), res['self']['BLD_GRP_STR'].toString(), res['self']['GENDER'].toString(),
//                               res['self']['GENDER_STR'].toString(),res['self']['EMP_POSTN'].toString(),res['self']['DTOJOIN'].toString());
//                         // print("paaas"+res['self']['FILECONTENT'].toString());
//
//                         }
//     // Future.delayed(Duration(seconds: 7), () async {
//     //  await UserSharedPreferences.getImage();
//     // });
//
//
//                         UserSharedPreferences.setUsername(user_name.text);
//                         UserSharedPreferences.setLogin(true);
//
//
//
//                         // DialogBuilder(context).hideOpenDialog();
//
//                         Fluttertoast.showToast(
//                             msg: "Welcome....", toastLength: Toast
//                             .LENGTH_SHORT);
//                         Navigator.push(
//                             context, MaterialPageRoute(
//                             builder: (context) => MyDashboardview()));
//                        // DialogBuilder(context).hideOpenDialog();
//                       }
//                       else {
//                         Fluttertoast.showToast(
//                             msg: "Invalid username/password", toastLength: Toast
//                             .LENGTH_SHORT);
//                       }
//                     }
//                     else {
//
//                       Fluttertoast.showToast(msg: "Invalid username/password",
//                           toastLength: Toast.LENGTH_SHORT);
//                     }
//                    // DialogBuilder(context).hideOpenDialog();
//                   }
                }
                ),
              ),
              UserSharedPreferences.getUsername()!=null? InkWell(
                child: Container(
                  height:50 ,
                  child: Image.asset("assets/images/fingerprint.png"),
                ),
                onTap: () async {
                  DialogBuilder(context).showLoadingIndicator('Calculating');
                  bool isAuthenticated = await authenticate();
                  // print("object_auth_"+isAuthenticated.toString());
                  //
                  DialogBuilder(context).hideOpenDialog();
                  if (isAuthenticated) {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => MyDashboardview()));
                  } else {
                    showAlertDialog1("Information","You are not authenticated");
                  }

                }
                ,
              ):
              Container()
              ,
              SizedBox(height: 20,),
              Text("Does not have account?",
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
              //const Text('Does not have account?'),
              TextButton(
                child: const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {

                  //signup screen
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRegApp(text: true,)));
                },
              ),
              MaterialButton(
                onPressed: (){
                  //showLoaderDialog(context);
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),

              // Row(
              //   children: [
              //     const Text('Does not have account?'),
              //     TextButton(
              //       child: const Text(
              //         'Sign up',
              //         style: TextStyle(fontSize: 20),
              //       ),
              //       onPressed: () {
              //
              //         //signup screen
              //        // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRegistration()));
              //       },
              //     )
              //   ],
              //   mainAxisAlignment: MainAxisAlignment.center,
              // ),
            ],
          ),
        )


      )
    );

  }
  void showAlertDialog1(String? st,String st1) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(st!),
            content: Text(st1!),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),

            ],
          );
        });
  }
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );

  }
  void callme() async
  {
   // await FlutterPhoneDirectCaller.callNumber("9857051176");
  }

}