


import 'package:flutter/material.dart';

import '../LoginScreen.dart';
import 'UserSharedPerfence.dart';




class MyHeader
{
  int _selectedIndex = 0;
//static BuildContext? context;
  BuildContext? context;
  MyHeader(BuildContext context)
  {
    this.context=context;
  }
    HeaderShow()
  {

    return
      AppBar(


        centerTitle: true,
        title: Text("EX-SJVNites",style: TextStyle(fontSize: 20),),
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


      );
  }

}
