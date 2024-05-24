import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sjvn/User/MedicalClaim_Form.dart';

import '../UserShared/EncryptData.dart';
import '../UserShared/contact_modal.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

import '../helper/MyProgress.dart';
import '../helper/UserSharedPerfence.dart';

class ContactFormItemWidget extends StatefulWidget {
  ContactFormItemWidget(
      {Key? key, required this.contactModel, required this.onRemove, this.index,this.crt_visible})
      : super(key: key);

  final index;
  ContactModel contactModel;
  final Function onRemove;
  final state = _ContactFormItemWidgetState();
  bool? crt_visible;

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  // TextEditingController _nameController = TextEditingController();
  // TextEditingController _contactController = TextEditingController();
  // TextEditingController _emailController = TextEditingController();

  TextEditingController APPLYING_FORController = TextEditingController();
  TextEditingController PATIENT_NAMEController = TextEditingController();
  TextEditingController CARD_NOController = TextEditingController();
  TextEditingController HOSPITAL_TYPEController = TextEditingController();
  TextEditingController DOCTOR_NAMEController = TextEditingController();
  TextEditingController TREATMENT_STATUSController = TextEditingController();
  TextEditingController CONSULT_DATEController = TextEditingController();
  TextEditingController CASH_MEMO_NOController = TextEditingController();
  TextEditingController CASH_MEMO_DATEController = TextEditingController();
  TextEditingController CLAIMED_CONSULTATION_CHARGEController = TextEditingController();
  TextEditingController APPROVED_CONSULTATION_CHARGEController = TextEditingController();
  TextEditingController CLAIMED_INJECT_CHARGEController = TextEditingController();
  TextEditingController APPROVED_INJECT_CHARGEController = TextEditingController();
  TextEditingController CLAIMED_MEDI_COSTController = TextEditingController();
  TextEditingController APPROVED_MEDI_COSTController = TextEditingController();
  TextEditingController CLAIMED_PATH_CHARGEController = TextEditingController();
  TextEditingController APPROVED_PATH_CHARGEController = TextEditingController();
  TextEditingController GL_CHARGEController = TextEditingController();

  bool isValidated() => state.validate();
  bool isValidated1()=>state.validate1();

}

class _ContactFormItemWidgetState extends State<ContactFormItemWidget> {
  final formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> productlistddlKey =GlobalKey<FormFieldState>();
  List<DropdownMenuItem<String>>? _menuItems;
  List<dynamic>? kk;
  getRequest(String year) async {

    DialogBuilder(context).showLoadingIndicator('Calculating');
    EncryptData ed=new EncryptData();
    var kl=    ed.encryptData('{"method" : "selfdependentdetails", "userid" : "Puserid","fiscalyear":"paas_year"}'.replaceAll("Puserid", UserSharedPreferences.getUsername().toString()).replaceAll("paas_year", year.toString()));

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
      var data1='{"self":{"CARD_NO":"100067","DEP_ID_STR":"Self","PERSA":"CC01","BLD_GRP_STR":"B-","VALID_TILL":"14.07.2027","DEP_ID":"99","EMP_POSTN":"test Desig","BANKL":"TEST IFSC","GENDER_STR":"Male","BANKN":"ABC7654321","DTOJOIN":"00.00.0000","GENDER":"1","SEP_TYP":"R","KOSTL":"1001000000","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp…..","REF_EMPID":"00010020","FILETYPE":"image/png","EMPRETID":"S100041","CELL_NO":"1234567890","NAME":"TEST RETIREE 1","BET01":"134000.00","PRCTR":"0000001001","DTOBRTH":"01.07.1950","BLD_GRP":"04","EMAIL_ID":"ASHI._SHR@GMAIL.COM"},"dependent":[{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"1","DEP_ID_STR":"Spouse","NAME":"NAME SPOUSE","GENDER":"2","GENDER_STR":"Female","BLD_GRP":"02","BLD_GRP_STR":"A-","DTOBRTH":"14.07.1960","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"MGH@YAHOO.COM","PERSA":"","CARD_NO":"100066","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"},{"EMPRETID":"S100041","REF_EMPID":"00000000","DEP_ID":"2","DEP_ID_STR":"Child","NAME":"DEP1","GENDER":"1","GENDER_STR":"Male","BLD_GRP":"03","BLD_GRP_STR":"B+","DTOBRTH":"01.07.2020","DTOJOIN":"00.00.0000","FILETYPE":"image/png","FILECONTENT":"E7jsPDw2w54zL7ajR0AAAAAAMBp….","CELL_NO":"1234567890","EMAIL_ID":"XYZ1@GMAIL.COM","PERSA":"","CARD_NO":"100065","VALID_TILL":"14.07.2027","SEP_TYP":"","EMP_POSTN":"","BANKL":"","BANKN":"","KOSTL":"","PRCTR":"","BET01":"0"}]}';

      var responseData = json.decode(data);
      var responseData1 = json.decode(data);
      if(widget.contactModel.APPLYING_FOR!="Self")
        {

          final List parsedList = responseData1["dependent"];

          kk=   parsedList.where((element) => element["DEP_ID_STR"]==widget.contactModel.APPLYING_FOR).toList();

          // print("paas_self_"+  kk[0]["NAME"].toString());
          // print("paas_self"+  responseData1["dependent"].toString());
          // List dataList=responseJson["countries"];


          setState(() {
            _menuItems = List.generate(
              kk!.length,
                  (i) => DropdownMenuItem(
                value: kk![i]["NAME"]+"*"+kk![i]["CARD_NO"],
               // key:kk[i]["CARD_NO"],
                child: Text("${kk![i]["NAME"]}"),
              ),
            );
          });
        }
      else
        {
          print("object_paas"+responseData["self"]["NAME"].toString());
         // final List parsedList = responseData["self"];

         // var kk=   parsedList.toList();
          setState(() {
            _menuItems = List.generate(
              1,
                  (i) => DropdownMenuItem(
                value: responseData["self"]["NAME"]+"*"+responseData["self"]["CARD_NO"],
                child: Text("${responseData["self"]["NAME"]}"),
              ),
            );
          });
        }


      // for (var res in responseData['dependent']) {
      //   dependent user = dependent(
      //       EMPRETID: res["EMPRETID"],
      //       NAME: res["NAME"],
      //       DTOBRTH: res["DTOBRTH"],
      //       CELL_NO: res["CELL_NO"]
      //   );
      //   // print("paaas "+res["EMPRETID"].toString());
      //   //Adding user to the list.
      //   users.add(user);
      // }
    }
    else
    {

    }
    //  print("paaas "+users.length.toString());
    //  return users;

    //replace your restFull API here.
    // String url = "https://roomerang.net/webservice2.asmx/get_product_data";
    // final response = await http.get(Uri.parse(url));

    DialogBuilder(context).hideOpenDialog();
  }
  @override
  Widget build(BuildContext context) {

   // widget.CLAIMED_CONSULTATION_CHARGEController.text="0";
   // widget.APPROVED_CONSULTATION_CHARGEController.text="0";
   // widget.CLAIMED_INJECT_CHARGEController.text="0";
   // widget.APPROVED_INJECT_CHARGEController.text="0";
   // widget.CLAIMED_MEDI_COSTController.text="0";
   // widget.APPROVED_MEDI_COSTController.text="0";
   // widget.CLAIMED_PATH_CHARGEController.text="0";
   // widget.APPROVED_PATH_CHARGEController.text="0";

    return
      Material(
      child:
      Padding(
        padding: const EdgeInsets.all(12.0),
        child:
        Form(
          key: formKey,
          child:
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.crt_visible==true?
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.index}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Colors.orange),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        TextButton(
                            onPressed: () async {
                              setState(() {
                                //Clear All forms Data
                                // widget.contactModel.name = "";
                                // widget.contactModel.number = "";
                                // widget.contactModel.email = "";


                                widget.contactModel.APPLYING_FOR= "";
                                widget.contactModel.PATIENT_NAME= "";
                                widget.PATIENT_NAMEController.clear();
                                widget.contactModel.CARD_NO= "";
                                widget.contactModel.HOSPITAL_TYPE= "";
                                widget.contactModel.DOCTOR_NAME= "";
                                widget.contactModel.TREATMENT_STATUS= "";
                                widget.contactModel.CONSULT_DATE= "";
                                widget.contactModel.CASH_MEMO_NO= "";
                                widget.contactModel.CASH_MEMO_DATE= "";
                                widget.contactModel.CLAIMED_CONSULTATION_CHARGE= "";
                                widget.contactModel.APPROVED_CONSULTATION_CHARGE= "";
                                widget.contactModel.CLAIMED_INJECT_CHARGE= "";
                                widget.contactModel.APPROVED_INJECT_CHARGE= "";
                                widget.contactModel.CLAIMED_MEDI_COST= "";
                                widget.contactModel.APPROVED_MEDI_COST= "";
                                widget.contactModel.CLAIMED_PATH_CHARGE= "";
                                widget.contactModel.APPROVED_PATH_CHARGE= "";
                                widget.contactModel.GL="";

                                widget.APPLYING_FORController.clear();

                                widget.CARD_NOController.clear();
                                widget.HOSPITAL_TYPEController.clear();
                                widget.DOCTOR_NAMEController.clear();
                                widget.TREATMENT_STATUSController.clear();
                                widget.CONSULT_DATEController.clear();
                                widget.CASH_MEMO_NOController.clear();
                                widget.CASH_MEMO_DATEController.clear();
                                widget.CLAIMED_CONSULTATION_CHARGEController.clear();
                                widget.APPROVED_CONSULTATION_CHARGEController.clear();
                                widget.CLAIMED_INJECT_CHARGEController.clear();
                                widget.APPROVED_INJECT_CHARGEController.clear();
                                widget.CLAIMED_MEDI_COSTController.clear();
                                widget.APPROVED_MEDI_COSTController.clear();
                                widget.CLAIMED_PATH_CHARGEController.clear();
                                widget.APPROVED_PATH_CHARGEController.clear();
                                widget.GL_CHARGEController.clear();
                                // widget._nameController.clear();
                                // widget._contactController.clear();
                                // widget._emailController.clear();
                              });
                            },
                            child: Icon(
                             Icons.cleaning_services,
                            )),
                        TextButton(
                            onPressed: () => widget.onRemove(),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ],
                )
                    :
                    Container()
                ,
            DropdownButtonFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '“Please select the Applying For in row-';
                }
                return null;

              },

              hint: Text('Applying For'), // Not necessary for Option 1
              //value: _selectedLocation,
              decoration: InputDecoration(
                  label: Text("Applying For"),
                  hintText: "Applying For",
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  border: OutlineInputBorder()
              ),
              isExpanded: true,
              onChanged: widget.crt_visible==false?null:(value){
                // setState(() => widget.contactModel.APPLYING_FOR = value.toString()
                //
                // );
                setState(() {
                  widget.contactModel.APPLYING_FOR = value.toString();
                  widget.APPLYING_FORController.text=value.toString();
                });

                productlistddlKey.currentState?.reset();
                widget.CARD_NOController.text="";
                widget.CARD_NOController.clear();

              var kk=  getRequest(DateTime.now().year.toString());

              },
              items: <String>['Child', 'Father','Father-in-law','Minor Brother','Mother','Mother-in-law','Self','Spouse','Unmarried sister']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              // items: _myJson!.map((Map map) {
              //   return new DropdownMenuItem<String>(
              //     value: map["country"].toString(),
              //     child: new Text(
              //       map["country"],
              //     ),
              //   );
              // }).toList(),
            ),
                SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the patient name in row-';
                    }
                    return null;

                  },

                  key: productlistddlKey,
                  hint: Text('Patient Name'), // Not necessary for Option 1
                  //value: _selectedLocation,
                  decoration: InputDecoration(
                      label: Text("Patient Name"),
                      hintText: "Patient Name",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder(),
                    filled: true,

                    fillColor: Colors.blue.shade50,
                  ),
                  onChanged:widget.crt_visible==false?null: (value){
  setState(() {
     print("paas_self_23"+value.toString());
    var arr=value!.toString().split('*');
    widget.contactModel.PATIENT_NAME = arr[0];
    widget.PATIENT_NAMEController.text=arr[0];
    widget.CARD_NOController.text=arr[1].toString();
    widget.GL_CHARGEController.text="280410";
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
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  readOnly: true,
                  controller: widget.CARD_NOController,
                  onChanged: (value) => widget.contactModel.CARD_NO = value,
                  onSaved: (value) => widget.contactModel.CARD_NO = value,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Card No",
                    labelText: "Card No",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the patient name in row-';
                    }
                    return null;

                  },
                  hint: Text('Hospital Type'), // Not necessary for Option 1
                  //value: _selectedLocation,
                  decoration: InputDecoration(
                      label: Text("Hospital Type"),
                      hintText: "Hospital Type",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder()
                  ),
                  onChanged:widget.crt_visible==false?null: (value) {
                    //DialogBuilder(context).showLoadingIndicator('Calculating');
                    // setState(() {txt_code.text = value.toString()
                    // )
                    setState(() {
                      widget.contactModel.HOSPITAL_TYPE= value.toString();
                      widget.HOSPITAL_TYPEController.text=value.toString();

                    });
                    // DialogBuilder(context).hideOpenDialog();
                  },

                  items: <String>['CGSH/Govt/Empanelled','Non-Empanelled/Others']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  // items: _myJson!.map((Map map) {
                  //   return new DropdownMenuItem<String>(
                  //     value: map["country"].toString(),
                  //     child: new Text(
                  //       map["country"],
                  //     ),
                  //   );
                  // }).toList(),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '“Doctor/ Clinic Name” cannot be empty';
                    }
                    return null;

                  },
                  controller: widget.DOCTOR_NAMEController,
                  onChanged: (value) => widget.contactModel.DOCTOR_NAME = value,
                  onSaved: (value) => widget.contactModel.DOCTOR_NAME = value,
                  readOnly: widget.crt_visible==true?false:true ,
                  decoration: widget.crt_visible==true?
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Doctor/Clinic Name",
                    labelText: "Doctor/Clinic Name",
                  )
                      :
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Doctor/Clinic Name",
                    labelText: "Doctor/Clinic Name",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                  )
                  ,
                ),
                SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the treatment status in row-';
                    }
                    return null;

                  },
                  hint: Text('Treatment Status'), // Not necessary for Option 1
                  //value: _selectedLocation,
                  decoration: InputDecoration(
                      label: Text("Treatment Status"),
                      hintText: "Treatment Status",
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      border: OutlineInputBorder()
                  ),
                  // onChanged: (value) =>
                  //     setState(() => widget.contactModel.TREATMENT_STATUS= value.toString()
                  //     ),
                  onChanged:widget.crt_visible==false?null: (value)
                  {
                    setState(() {
                      widget.contactModel.TREATMENT_STATUS= value.toString();
                      widget.TREATMENT_STATUSController.text=value.toString();
                    });
                  }
                  ,
                  items: <String>['Treatment Completed','Treatment Ongoing']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  // items: _myJson!.map((Map map) {
                  //   return new DropdownMenuItem<String>(
                  //     value: map["country"].toString(),
                  //     child: new Text(
                  //       map["country"],
                  //     ),
                  //   );
                  // }).toList(),
                ),
                SizedBox(
                  height: 8,
                ),
                widget.crt_visible==true?
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Consultation date cannot be empty';
                      }
                      return null;

                    },
                  controller: widget.CONSULT_DATEController,
                  onChanged: (value) => widget.contactModel.CONSULT_DATE= value,
                  onSaved: (value) => widget.contactModel.CONSULT_DATE = value,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Consultation Date",
                    labelText: "Consultation Date",
                    prefixIcon: Icon(Icons.date_range),
                  ),
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      if(pickedDate != null ){
                        // print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                         // widget.CARD_NOController.text=value.toString();
                          widget.CONSULT_DATEController.text=formattedDate; //set output date to TextField value.
                        });
                      }else{
                        Fluttertoast.showToast(msg: "Date is not selected",toastLength: Toast.LENGTH_SHORT) ;
                      }
                    }
                )
                :
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Consultation date cannot be empty';
                      }
                      return null;

                    },
                    controller: widget.CONSULT_DATEController,
                    onChanged: (value) => widget.contactModel.CONSULT_DATE= value,
                    onSaved: (value) => widget.contactModel.CONSULT_DATE = value,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Consultation Date",
                      labelText: "Consultation Date",
                      prefixIcon: Icon(Icons.date_range),
                      filled: true,

                      fillColor: Colors.blue.shade50,
                    ),
                    readOnly: true,

                )
                ,
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Cash Memo Number cannot be empty';
                    }
                    return null;

                  },
                  controller: widget.CASH_MEMO_NOController,
                  onChanged: (value) => widget.contactModel.CASH_MEMO_NO = value,
                  onSaved: (value) => widget.contactModel.CASH_MEMO_NO = value,
                  readOnly:widget.crt_visible==true? false:true,
                  decoration: widget.crt_visible==true?
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Cash Memo No",
                    labelText: "Cash Memo No",
                  )
                      :
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Cash Memo No",
                    labelText: "Cash Memo No",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                  )
                  ,
                )

                ,
                SizedBox(
                  height: 8,
                ),
                widget.crt_visible==true?
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cash Memo Date cannot be empty';
                      }
                      return null;

                    },
                    controller: widget.CASH_MEMO_DATEController,
                    onChanged: (value) => widget.contactModel.CASH_MEMO_DATE= value,
                    onSaved: (value) => widget.contactModel.CASH_MEMO_DATE = value,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Cash Memo Date",
                      labelText: "Cash Memo Date",
                      prefixIcon: Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    onTap: () async{
                      DateTime? pickedDate = await showDatePicker(context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now());
                      if(pickedDate != null ){
                        // print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          widget.CASH_MEMO_DATEController.text=formattedDate; //set output date to TextField value.
                        });
                      }else{
                        Fluttertoast.showToast(msg: "Date is not selected",toastLength: Toast.LENGTH_SHORT) ;
                      }
                    }
                )
                :
                TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cash Memo Date cannot be empty';
                      }
                      return null;

                    },
                    controller: widget.CASH_MEMO_DATEController,
                    onChanged: (value) => widget.contactModel.CASH_MEMO_DATE= value,
                    onSaved: (value) => widget.contactModel.CASH_MEMO_DATE = value,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Cash Memo Date",
                      labelText: "Cash Memo Date",
                      prefixIcon: Icon(Icons.date_range),
                      filled: true,

                      fillColor: Colors.blue.shade50,
                    ),
                    readOnly: true,

                )
                ,
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'This field cannot be empty';
                  //   }
                  //   return null;
                  //
                  // },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: widget.CLAIMED_CONSULTATION_CHARGEController,
                  onChanged: (value)
                  {
                  // if(widget.contactModel.HOSPITAL_TYPE=="CGSH/Govt/Empanelled")
                  //   {
                  //     UserSharedPreferences.settotcgshclaim(double.parse(value));
                  //    // MyMedicalClaimForm md=new MyMedicalClaimForm();
                  //
                  //   }


                   // UserSharedPreferences.settotcgshclaim(double.parse(value));
                    widget.contactModel.CLAIMED_CONSULTATION_CHARGE = value;
                   widget.contactModel.APPROVED_CONSULTATION_CHARGE=value;
                   widget.APPROVED_CONSULTATION_CHARGEController.text=value;
                  },

                  onSaved: (value){
                    widget.contactModel.CLAIMED_CONSULTATION_CHARGE = value;
                    widget.contactModel.APPROVED_CONSULTATION_CHARGE=value;
                  },
                  readOnly:widget.crt_visible==true? false:true,

                  decoration:widget.crt_visible==true?
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Claimed Consultation Charges",
                    labelText: "Claimed Consultation Charges",
                  )
                      :
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Claimed Consultation Charges",
                    labelText: "Claimed Consultation Charges",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                  )
                  ,
                ),
                SizedBox(
                  height: 8,
                ),
                // TextFormField(
                //   readOnly: true,
                //
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                //   controller: widget.APPROVED_CONSULTATION_CHARGEController,
                //   onChanged: (value) => widget.contactModel.APPROVED_CONSULTATION_CHARGE= value,
                //   onSaved: (value) => widget.contactModel.APPROVED_CONSULTATION_CHARGE = value,
                //   decoration: InputDecoration(
                //
                //     contentPadding: EdgeInsets.symmetric(horizontal: 12),
                //     border: OutlineInputBorder(),
                //     hintText: "Approved Consultation Charges",
                //     labelText: "Approved Consultation Charges",
                //     filled: true,
                //
                //     fillColor: Colors.blue.shade50,
                //   ),
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'This field cannot be empty';
                  //   }
                  //   return null;
                  //
                  // },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: widget.CLAIMED_INJECT_CHARGEController,
                  onChanged: (value){
                    widget.contactModel.CLAIMED_INJECT_CHARGE= value;
                    widget.contactModel.APPROVED_INJECT_CHARGE=value;
                    widget.APPROVED_INJECT_CHARGEController.text=value;
                  },
                  onSaved: (value) => widget.contactModel.CLAIMED_INJECT_CHARGE = value,
                  readOnly:widget.crt_visible==true? false:true,

                  decoration:widget.crt_visible==true?
                  // filled: true,
                  //
                  //   fillColor: Colors.blue.shade50,
               InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Claimed Inject Charges",
                    labelText: "Claimed Inject Charges",
                  )
                  :
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Claimed Inject Charges",
                    labelText: "Claimed Inject Charges",
                    filled: true,

                    fillColor: Colors.blue.shade50,
                  )
                  ,
                ),
                SizedBox(
                  height: 8,
                ),
                // TextFormField(
                //
                //   readOnly: true,
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                //   controller: widget.APPROVED_INJECT_CHARGEController,
                //   onChanged: (value) => widget.contactModel.APPROVED_INJECT_CHARGE= value,
                //   onSaved: (value) => widget.contactModel.APPROVED_INJECT_CHARGE = value,
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(horizontal: 12),
                //     border: OutlineInputBorder(),
                //     hintText: "Approved Inject Charges",
                //     labelText: "Approved Inject Charges",
                //     filled: true,
                //
                //     fillColor: Colors.blue.shade50,
                //   ),
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'This field cannot be empty';
                  //   }
                  //   return null;
                  //
                  // },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: widget.CLAIMED_MEDI_COSTController,
                  onChanged: (value){
                    widget.contactModel.CLAIMED_MEDI_COST= value;
                    widget.contactModel.APPROVED_MEDI_COST=value;
                    widget.APPROVED_MEDI_COSTController.text=value;
                  },
                  onSaved: (value) => widget.contactModel.CLAIMED_MEDI_COST = value,
                  readOnly:widget.crt_visible==true? false:true,

                  decoration:widget.crt_visible==true?
                  // filled: true,
                  //
                  //   fillColor: Colors.blue.shade50,
              InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Claimed Medicine Charges",
                    labelText: "Claimed Medicine Charges",
                  )
                      :
                  InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Claimed Medicine Charges",
                    labelText: "Claimed Medicine Charges",
                    filled: true,

                      fillColor: Colors.blue.shade50,
                  )
                  ,
                ),
                SizedBox(
                  height: 8,
                ),
                // TextFormField(
                //   readOnly: true,
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                //   controller: widget.APPROVED_MEDI_COSTController,
                //   onChanged: (value){
                //     widget.contactModel.APPROVED_MEDI_COST= value;
                //
                //   },
                //
                //   onSaved: (value) => widget.contactModel.APPROVED_MEDI_COST = value,
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(horizontal: 12),
                //     border: OutlineInputBorder(),
                //     hintText: "Approved Medicine Charges",
                //     labelText: "Approved Medicine Charges",
                //     filled: true,
                //
                //     fillColor: Colors.blue.shade50,
                //   ),
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'This field cannot be empty';
                  //   }
                  //   return null;
                  //
                  // },
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: widget.CLAIMED_PATH_CHARGEController,
                  onChanged: (value) { widget.contactModel.CLAIMED_PATH_CHARGE= value;
                    widget.contactModel.APPROVED_PATH_CHARGE=value;
                    widget.APPROVED_PATH_CHARGEController.text=value;
                  },
                  onSaved: (value) => widget.contactModel.CLAIMED_PATH_CHARGE = value,
                    readOnly:widget.crt_visible==true? false:true,

                    decoration:widget.crt_visible==true?
                    // filled: true,
                    //
                    //   fillColor: Colors.blue.shade50,
                    InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Claimed pathology charges",
                      labelText: "Claimed pathology charges",
                    )
                        :
                    InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(),
                      hintText: "Claimed pathology charges",
                      labelText: "Claimed pathology charges",
                      filled: true,

                      fillColor: Colors.blue.shade50,
                    )

                ),
                SizedBox(
                  height: 8,
                ),
                // TextFormField(
                //   readOnly: true,
                //   keyboardType: TextInputType.numberWithOptions(decimal: true),
                //   controller: widget.APPROVED_PATH_CHARGEController,
                //   onChanged: (value) => widget.contactModel.APPROVED_PATH_CHARGE= value,
                //   onSaved: (value) => widget.contactModel.APPROVED_PATH_CHARGE = value,
                //
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(horizontal: 12),
                //     border: OutlineInputBorder(),
                //     hintText: "Approved pathology charges",
                //     labelText: "Approved pathology charges",
                //     filled: true,
                //
                //     fillColor: Colors.blue.shade50,
                //
                //   ),
                //
                // ),
                // SizedBox(
                //   height: 8,
                // ),
                // TextFormField(
                //   readOnly: true,
                //  // keyboardType: TextInputType.numberWithOptions(decimal: true),
                //   controller: widget.GL_CHARGEController,
                //   onChanged: (value) => widget.contactModel.GL= value,
                //   onSaved: (value) => widget.contactModel.GL= value,
                //
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(horizontal: 12),
                //     border: OutlineInputBorder(),
                //     hintText: "GL account",
                //     labelText: "GL account",
                //     filled: true,
                //
                //     fillColor: Colors.blue.shade50,
                //
                //   ),
                //
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// String? cgshclaim()
// {
//
// }
  bool validate1()
  {
    setState(() {
      widget.crt_visible=true;

    });
    return true;
  }
  bool validate() {
    //Validate Form Fields
    bool validate = formKey.currentState!.validate();
    if (validate) formKey.currentState!.save();
    if(validate==true)
    {
      setState(() {
        widget.crt_visible=false;

      });
    }
    return validate;
  }
}
