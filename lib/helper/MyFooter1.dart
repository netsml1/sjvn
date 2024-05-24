


import 'package:flutter/material.dart';
import 'package:sjvn/User/Dashboard.dart';

import '../User/MedicalClaim_Form_1.dart';
import '../User/Profile.dart';
import '../User/Request_Form.dart';




class MyFooter
{
  int _selectedIndex = 0;
//static BuildContext? context;
  BuildContext? context;
  MyFooter(BuildContext context)
  {
    this.context=context;
  }
  Widget?  FooterShow()
  {

    return
      BottomAppBar(
        color: Colors.lightBlue.shade900,
        shape: CircularNotchedRectangle(),
        notchMargin: 7.0,
        child: Row(

          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
               // Navigator.push(context!, MaterialPageRoute(builder: (context)=>MyDashboardview()));


              },
            ),
            IconButton(
              icon: Icon(Icons.message, color: Colors.white),
              onPressed: () {
                // Navigator.push(
                //   context!,
                //   MaterialPageRoute(builder: (context) => MyRequestForm()),
                // );
              },
            ),

            //SizedBox(width: 25),
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.white),
              onPressed: () {
                // Navigator.push(
                //   context!,
                //   MaterialPageRoute(builder: (context) => MyMedicalClaimForm_1()),
                // );
              },
            ),
            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                // Navigator.push(
                //   context!,
                //   MaterialPageRoute(builder: (context) => MyProfileview()),
                // );
              },
            ),
          ],
        ),
      );
//       BottomNavigationBar(
//       items: [
//
//         BottomNavigationBarItem(label: "Back", icon: Icon(Icons.arrow_back,color: Colors.white,),
//
//         ),
//         BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home,color: Colors.white,)),
//         BottomNavigationBarItem(label: "Forward", icon: Icon(Icons.arrow_forward,color: Colors.white,)),
//
//
//       ],
//       currentIndex: _selectedIndex, //New
//       backgroundColor: Colors.lightBlue.shade900,
// unselectedItemColor: Colors.white,
//       selectedItemColor: Colors.yellow,
//       onTap: _onItemTapped,
//     );
  }
  _onItemTapped(int index) {

    print(index);
    if(index==0)
    {
     // Navigator.push(context!, MaterialPageRoute(builder: (context)=>MyAppDashboard()));
    }
    else if(index==1)
    {
      callme();
     // Navigator.push(context!, MaterialPageRoute(builder: (context)=>PhoneCall()));

    }
    else if(index==2)
    {
     //Navigator.push(context!, MaterialPageRoute(builder: (context)=>MyChatRoom()));

    }

    //setState(() {
    _selectedIndex = index;

    //});

  }
  void callme() async
  {
   // await FlutterPhoneDirectCaller.callNumber("9857051176");
  }
}
