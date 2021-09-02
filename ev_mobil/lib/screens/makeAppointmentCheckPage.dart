import 'package:estetikvitrini/JsnClass/appointmentList.dart';
import 'package:estetikvitrini/model/appointmentModel.dart';
import 'package:estetikvitrini/settings/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import '../widgets/informationRowWidget.dart';
import 'package:estetikvitrini/settings/functions.dart';

class MakeAppointmentCheckPage extends StatefulWidget {
  final AppointmentObject appointment;
  final dynamic companyInfo;
  final int indexx;
  MakeAppointmentCheckPage({Key key, this.companyInfo, this.appointment, this.indexx}) : super(key: key);

  @override
  _MakeAppointmentCheckPageState createState() => _MakeAppointmentCheckPageState(companyInfo: companyInfo, appointment: appointment,indexx: indexx);
}

class _MakeAppointmentCheckPageState extends State<MakeAppointmentCheckPage> {
  TextEditingController teNote = TextEditingController();
  String teOperation;
  int indexx;

   AppointmentObject appointment;

   dynamic companyInfo;
   _MakeAppointmentCheckPageState({this.companyInfo, this.appointment, this.indexx});

  List appointmentList;

  Future appointmentListFunc() async{
    final AppointmentListJsn appointmentNewList = await appointmentListJsnFunc(1,"");
    setState(() {
      appointmentList = appointmentNewList.result;
    });
  }

  @override
  void initState() { 
    super.initState();
    appointmentListFunc();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: Builder(builder: (context)=>
              Container(
              color: secondaryColor,
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.all(defaultPadding),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(//iconun çevresini saran yapı tasarımı
                            maxRadius: 25,
                            backgroundColor: Colors.white,
                            child: IconButton(
                            iconSize: iconSize,
                            icon: Icon(Icons.arrow_back,color: secondaryColor),
                            onPressed: (){ Navigator.pop(context, false);}
                            ),
                          ),
                          SizedBox(width: maxSpace),
                          Text("Estetik Vitrini",
                          style     : TextStyle(
                          fontFamily: leadingFont, 
                          fontSize  : 20, 
                          color     : Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text( "Randevu Al",
                            style     : TextStyle(
                            fontFamily: leadingFont,
                            color     : Colors.white,
                            fontSize  : 45,
                            ),
                          ),
                        ),
                        Align(alignment: Alignment.topLeft,
                            child: Text(companyInfo[indexx-1].companyName, 
                            style: TextStyle(
                            color: Colors.white),
                          ),
                        ),
                        SizedBox(height: maxSpace)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(decoration: BoxDecoration(
                        color       : Colors.white,
                        borderRadius: BorderRadius.vertical(
                        top         : Radius.circular(cardCurved),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(children: [
                  InformationRowWidget(
                    containerColor: secondaryColor,
                    operationName: "Tarih",
                    width: deviceWidth(context)*0.6,
                    height: deviceWidth(context)*0.15,
                    child: Text(appointment.appointmentDate,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InformationRowWidget(
                    containerColor: secondaryColor,
                    width:  deviceWidth(context)*0.6,
                    height: deviceWidth(context)*0.15,
                    operationName: "Saat",
                    child: Text(
                      appointment.timeS,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InformationRowWidget(
                    containerColor: secondaryColor,
                    operationName: "İşlem",
                    width:  deviceWidth(context)*0.6,
                    height: deviceWidth(context)*0.15,
                    child: Text(appointment.operationS,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  InformationRowWidget(
                    containerColor: darkWhite,
                    width:  deviceWidth(context)*0.6,
                    height: deviceWidth(context)*0.3,
                    operationName: "Özel Not",
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: teNote,
                      cursorColor: primaryColor,
                      style: TextStyle(color: primaryColor, fontSize: 18),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(""),
                      Container(
                        width: deviceWidth(context)*0.6,
                        height: deviceWidth(context)*0.15,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: backGroundColor1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                        child: Center(
                          child: MaterialButton(
                            child: Text(
                              "Randevu Olustur",
                              style: TextStyle(
                                  fontFamily: leadingFont,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                            onPressed: () async{
                              final progressHUD = ProgressHUD.of(context);
                              progressHUD.show(); 
                                await appointmentAddJsnFunc(1, companyInfo[indexx-1].companyId,  companyInfo[indexx-1].campaingId ?? 0, appointment.appointmentDate, appointment.appointmentTimeId, appointment.operation, teNote.text);
                                await showToast(context, "Randevu başarıyla kaydedildi!");
                                await appointmentListFunc();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                progressHUD.dismiss();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    ));
  }
}


