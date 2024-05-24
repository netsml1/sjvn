import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sjvn/helper/UserSharedPerfence.dart';

import '../LoginScreen.dart';
import '../UserShared/EncryptData.dart';
import '../UserShared/PolicyDocuments.dart';
import '../UserShared/Profile.dart';
import '../helper/MyFooter.dart';
import '../helper/MyHeader.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
class MyProfileview extends StatefulWidget {
  MyProfileview({Key? key}) : super(key: key);

  @override
  State<MyProfileview> createState() => _TabbarExampleState();
}

class _TabbarExampleState extends State<MyProfileview> {
  Future<List<dependent>> getRequest() async {


    EncryptData ed=new EncryptData();
  var fyear=  EncryptData.fiscalyear(DateTime.now().year,DateTime.now().month);
    var kl=    ed.encryptData('{"method" : "selfdependentdetails", "userid" : "Puserid","fiscalyear":"fisca_paas"}'.replaceAll("fisca_paas",fyear.toString() ) .replaceAll("Puserid", UserSharedPreferences.getUsername().toString()));

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
    List<dependent> users = [];

    if (response.statusCode == 200) {
      var xmldata = response.body;
      var contact = xml.XmlDocument.parse(xmldata);
      // print("paas"+  response.body.toString());
      var result = contact
          .findAllElements('return')
          .first
          .text
          .toString();
      // result="kzAL/Ei0L404GBErfTPzpBHRtrJJTqqCNkN11Yy8o7HbpKy8HD+A8LDHoruLyAMB";
      // EncryptData.encryptAES(xmldata);

      var data = ed.decryptAES(result);
//var data='{"self":{"CARD_NO":"100067","DEP_ID_STR":"Self","PERSA":"CC01","BLD_GRP_STR":"B-","VALID_TILL":"14.07.2027","DEP_ID":"99","EMP_POSTN":"test Desig","BANKL":"TEST IFSC","GENDER_STR":"Male","BANKN":"ABC7654321","DTOJOIN":"00.00.0000","GENDER":"1","SEP_TYP":"R","KOSTL":"1001000000","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp…..","REF_EMPID":"00010020","FILETYPE":"image/png","EMPRETID":"S100041","CELL_NO":"1234567890","NAME":"TEST RETIREE 1","BET01":"134000.00","PRCTR":"0000001001","DTOBRTH":"01.07.1950","BLD_GRP":"04","EMAIL_ID":"ASHI._SHR@GMAIL.COM"},"dependent":[{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"1","DEP_ID_STR":"Spouse","NAME":"NAME SPOUSE","GENDER":"2","GENDER_STR":"Female","BLD_GRP":"02","BLD_GRP_STR":"A-","DTOBRTH":"14.07.1960","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"MGH@YAHOO.COM","PERSA":"","CARD_NO":"100066","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"},{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"2","DEP_ID_STR":"Child","NAME":"DEP1","GENDER":"1","GENDER_STR":"Male","BLD_GRP":"03","BLD_GRP_STR":"B+","DTOBRTH":"01.07.2020","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"XYZ1@GMAIL.COM","PERSA":"","CARD_NO":"100065","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"}]}';

     var responseData = json.decode(data);
     print("paas_self"+  responseData.toString());


      for (var res in responseData['dependent']) {
        dependent user = dependent(
            EMPRETID: res["EMPRETID"],
            NAME: res["NAME"],
            DTOBRTH: res["DTOBRTH"],
           CELL_NO: res["CELL_NO"]
        );
        // print("paaas "+res["EMPRETID"].toString());
        //Adding user to the list.
        users.add(user);
      }
    }
    else
    {

    }
    print("paaas "+users.length.toString());
    return users;

    //replace your restFull API here.
    // String url = "https://roomerang.net/webservice2.asmx/get_product_data";
    // final response = await http.get(Uri.parse(url));


  }
  @override
  Widget build(BuildContext context) {
    MyFooter footer=new MyFooter(context);
    MyHeader header=new MyHeader(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:  Text("Profile Details"),
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
          backgroundColor: Colors.lightBlue.shade900,
          bottom:  TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(Icons.account_box_outlined),
                text: "Employee Details",
              ),
              Tab(
                icon: Icon(Icons.list_alt),
                text: "Dependent's Details",
              ),
              // Tab(
              //   icon: Icon(Icons.ac_unit),
              //   text: "Bank Detail",
              // ),
              Tab(
                icon: Icon(Icons.ac_unit),
                text: "Card Detail",
              )

            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          elevation: 6,
          backgroundColor: Colors.lightBlue.shade900,
          child: Icon(Icons.camera),
          onPressed: () {},
        ),
        bottomNavigationBar: footer.FooterShow(),
        body:  TabBarView(
          children: [

              Card(
                child:      ListTile(
                  shape: RoundedRectangleBorder( //<-- SEE HERE
                    side: BorderSide(width: 1),

                  ),
                  title: DataTable(
                      columns: [
                        DataColumn(

                          label: Text('Title'),
                        ),
                        DataColumn(
                          label: Text('Detail'),

                        ),

                      ],
                      rows: [

                        DataRow(cells: [

                          DataCell(Text('Employee ID')),
                          DataCell(Text(UserSharedPreferences.getUsername().toString())),

                        ]),
                        DataRow(cells: [
                          DataCell(Text('Name')),
                          DataCell(Text(UserSharedPreferences.getProfileName().toString())),

                        ]),
                        DataRow(cells: [
                          DataCell(Text('Designation')),
                          DataCell(Text(UserSharedPreferences.getDesignation().toString())),

                        ]),
                        DataRow(cells: [
                          DataCell(Text('Date Of Birth')),
                          DataCell(Text(UserSharedPreferences.getDOB().toString())),

                        ]),
                        DataRow(cells: [
                          DataCell(Text('Basic Pay')),
                          DataCell(Text(UserSharedPreferences.getBasicPay().toString())),

                        ]),
                        DataRow(cells: [
                          DataCell(Text('Email ID')),
                          DataCell(Text(UserSharedPreferences.getEmail().toString())),

                        ]),
                        DataRow(cells: [
                          DataCell(Text('Date Of Joining')),
                          DataCell(Text(UserSharedPreferences.getDOJ().toString())),

                        ])
                      ]

                  )
                  //subtitle: Text("Date: "),



                ),
              ),


            Card(
              child: Container(

                padding: EdgeInsets.all(5.0),
                child: FutureBuilder(
                  future: getRequest(),
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return

                        ListView.builder(

                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, index) =>


                                Card(
                                  child:      ListTile(
                                    shape: RoundedRectangleBorder( //<-- SEE HERE
                                      side: BorderSide(width: 1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    title: Text("UserID: "+snapshot.data[index].EMPRETID),
                                    subtitle: Text("Name: "+snapshot.data[index].NAME.toString()+"\n"+
                                        "DOB: "+snapshot.data[index].DTOBRTH.toString()+"\n"+
                                        "Phone No: "+snapshot.data[index].CELL_NO.toString()+"\n"
                                        // "Date Of Joining: "+snapshot.data[index].DTOJOIN.toString()+"\n"
                                       // "Date Of Retirement: "+snapshot.data[index].CELL_NO.toString()+"\n"
                                    ),
                                    // leading:CircleAvatar(
                                    //   backgroundImage: NetworkImage("https://i.stack.imgur.com/Dw6f7.png",),
                                    // ),
                                  ),
                                )

                        );
                    }
                  },
                ),
              ),
            ),
            // Card(
            //   child:      ListTile(
            //       shape: RoundedRectangleBorder( //<-- SEE HERE
            //         side: BorderSide(width: 1),
            //
            //       ),
            //       title: DataTable(
            //           columns: [
            //             DataColumn(
            //               label: Text('Title'),
            //             ),
            //             DataColumn(
            //               label: Text('Detail'),
            //             ),
            //
            //           ],
            //           rows: [
            //
            //             DataRow(cells: [
            //               DataCell(Text('Account No')),
            //               DataCell(Text(UserSharedPreferences.getAccountNo().toString())),
            //
            //             ]),
            //             DataRow(cells: [
            //               DataCell(Text('IFSC Code')),
            //               DataCell(Text(UserSharedPreferences.getIFSC().toString())),
            //
            //             ]),
            //
            //           ]
            //
            //       )
            //     //subtitle: Text("Date: "),
            //
            //
            //
            //   ),
            // ),
            Card(
              child:      ListTile(
                  shape: RoundedRectangleBorder( //<-- SEE HERE
                    side: BorderSide(width: 1),

                  ),
                  title: DataTable(
                      columns: [
                        DataColumn(
                          label: Text('Title'),
                        ),
                        DataColumn(
                          label: Text('Detail'),
                        ),

                      ],
                      rows: [

                        DataRow(cells: [
                          DataCell(Text('Card No')),
                          DataCell(Text(UserSharedPreferences.getAccountNo().toString())),

                        ]),
                        DataRow(cells: [
                          DataCell(Text('Validity')),
                          DataCell(Text(UserSharedPreferences.getVALID().toString())),

                        ]),

                      ]

                  )
                //subtitle: Text("Date: "),



              ),
            ),


          ],
        ),

      ),

    );
  }
}