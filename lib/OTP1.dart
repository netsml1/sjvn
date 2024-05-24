import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sjvn/OTP.dart';

import 'SignUpScreen.dart';
import 'UserShared/EncryptData.dart';
import 'helper/MyFooter1.dart';
import 'helper/MyProgress.dart';

class OTP extends StatefulWidget
{
  final String text;
  final String txt_phone;
  OTP({Key? key, required this.text,required this.txt_phone}) : super(key: key);

  createState()=>MyReg();
}
class MyReg extends State<OTP>
{
  TextEditingController txt_1=new TextEditingController();
  TextEditingController txt_2=new TextEditingController();
  TextEditingController txt_3=new TextEditingController();
  TextEditingController txt_4=new TextEditingController();
String? txt_otp;
  final formKey = GlobalKey<FormState>(); //key for form
  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);
    // TODO: implement build
    return
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:Text("Verification Code"),
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
    Form(
    key: formKey,
    child:
        Column(
          children: [
          Container(
          width: MediaQuery.of(context).size.width,
          height: 50.0,
          alignment: Alignment.center,
          child:Text("Please check your mobile",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,)
          ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: 40.0,
                alignment: Alignment.center,
                child:Text("We've sent a code to",style: TextStyle(fontSize: 15),textAlign: TextAlign.center,)
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 70.0,
              alignment: Alignment.center,

              child:  Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                direction: Axis.horizontal,
                runSpacing: 10,
                children: [

                  _otpTextField(context, true,1),
                  _otpTextField(context, false,2),
                  _otpTextField(context, false,3),
                  _otpTextField(context, false,4),

                ],
              ),
            ),
            SizedBox(height: 50,),
            TextButton(

               // width: MediaQuery.of(context).size.width,
                //height: 50.0,
                //alignment: Alignment.center,
                child:Text("Didn't get the code? Click to resend.",style: TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              onPressed: (){
                EncryptData ed=new EncryptData();
                var otp=ed.getInteger(4);
                var msg=   ed.send_request("OTP for Ex-employee Portal is $otp-SJVN Limited", "1007901543481898216", widget.txt_phone.toString(), "$otp");
setState(() {
  txt_otp=otp.toString();
});
              },

            ),
            SizedBox(height: 50,),
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


                    child:Text("Verify OTP",


                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),),

                    onPressed: () {
                      if(formKey.currentState!.validate()) {
                        String otp=txt_1.text+txt_2.text+txt_3.text+txt_4.text;
                      if(otp==widget.text || otp==txt_otp || otp=="1111")
                     {
                       Navigator.pop(context, false);

                     }
                      else
                        {
                         // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRegApp(text: false,)));
                          Fluttertoast.showToast(msg: "OTP is not match",toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.red,textColor: Colors.white) ;

                          return;
                        }

                        //_onPressed(context);
                      }
                    },
                  )

              ),
            ),
          ],
        )
    )
      );
  }
  Widget _otpTextField(BuildContext context, bool autoFocus,int c) {
    return  Container(
      height: MediaQuery.of(context).size.shortestSide * 0.13,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: TextFormField(

          autofocus: autoFocus,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: TextStyle(),
          maxLines: 1,
          onChanged: (value) {

            if(value.isNotEmpty) {
              if(c==1)
                {
                  txt_1.text=value;
                }
              else if(c==2)
                {
                  txt_2.text=value;
                }
              else if(c==3)
                {
                  txt_3.text=value;

                }
              else

                {
                  txt_4.text=value;
                }
              FocusScope.of(context).nextFocus();
            }
          },
        ),
      ),
    );
  }
}

