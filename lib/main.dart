
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sjvn/User/Dashboard.dart';

import 'LoginScreen.dart';

import 'package:sjvn/helper/UserSharedPerfence.dart';
void main() {
runApp(
MaterialApp(
  debugShowCheckedModeBanner: false,
home: MyScreen(),
)
);
}


class MyScreen extends StatefulWidget
{

 createState()=>MyScreen1();
}
class MyScreen1 extends State
{

@override
void initState() {
  super.initState();
  UserSharedPreferences.init();
  // Future.delayed(Duration(seconds: 4), () async {
  //   // DialogBuilder(context).showLoadingIndicator('Calculating');
  //   bool? login = (UserSharedPreferences.getLogin() ?? false);
  // //  status = (UserSharedPreferences.getLogin() ?? false);
  //   // UserSharedPreferences.getImage();
  //   //print("login");
  //   if (login == true) {
  //     await Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => MyDashboardview()));
  //   }
  // });
}

  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body:Stack(

        children: [
          Container(
            child:
      AnimatedSplashScreen(
              //backgroundColor: Colors.blueAccent,
             // duration: 3000,
              animationDuration: Duration(seconds: 5),
              splashIconSize: 300,
              splash:Image.asset("assets/images/retiree_logo.jpeg",),
              curve: Curves.easeInCirc,

              nextScreen: MyLoginScreen(),
              splashTransition: SplashTransition.scaleTransition,
              pageTransitionType: PageTransitionType.rightToLeft,
            )
    ),



        ],
      )





    );
  }
}