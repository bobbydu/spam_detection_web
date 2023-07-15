import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      // here
      builder: FlutterSmartDialog.init(),
      title: 'Hong Kong Short Message Spam Detection in a Machine Learning Approach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hong Kong Short Message Spam Detection in a Machine Learning Approach'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final tc_sms = TextEditingController();
  final tc_phone = TextEditingController();
  final tc_label = TextEditingController();
  final tc_datetime = TextEditingController();
  bool result_visible = false;
  String result = '';
  String sms = '';
  String phone = '12345678';
  String label = 'Not Sure';
  String datetime = '';
  String snn_score = '';
  String bert_score = '';
  String ChatGPT_result = '';
  String GoogleBard_result = '';
  final formKey = GlobalKey<FormState>();

  Future<void> submit() async{
    print('Submit');
    sms = tc_sms.text.toString();
    setState(() {
      SmartDialog.showLoading();
    });
    String _label='';
    if(label!='Not Sure'){
      _label = label;
    }
    final response = await http.post(
      Uri.parse("https://eiu051ow89.execute-api.ap-southeast-1.amazonaws.com/Test/main"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "sms": sms,
        "phone": phone,
        "label": _label,
        "source": "web",
        "datetime": datetime
      }),
    );
    print('Status code: '+response.statusCode.toString()+', Result: '+jsonDecode(response.body).toString());
    final data = json.decode(response.body);
    //print('Json decode: '+data.toString());
    final snn = data['snn_score'];
    snn_score = (double.parse(snn)*100).toStringAsFixed(2);
    final bert = data['bert_score'];
    bert_score = (double.parse(bert)*100).toStringAsFixed(2);
    setState(() {
      SmartDialog.dismiss();
      result_visible = true;
    });
  }

  Future<void> datePicker() async{
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000, 01), lastDate: DateTime(210, 01));
  }

  @override
  void initState() {
    super.initState();
  }

  final List<String> labelList = ['Not Sure','Spam', 'Ham'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: VStack(
                    [
                      Text(
                          'Hong Kong Short Message Spam Detection in a Machine Learning Approach',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Noto Sans HK',
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          )
                      ).centered().p(10),
                      Text(
                        'You can input message below to test whether it is spam or not:',
                      ).centered().p(10),
                      TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value){
                          setState(() {

                          });
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term){

                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Message can\'t be empty';
                          }
                          return null;
                        },
                        controller: tc_sms,
                        decoration: InputDecoration(
                          //errorText: errorText,
                          //hintText: 'e.g. ',
                          labelText: 'Message',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),),
                        style: const TextStyle(color: Colors.black),
                      ).p(10),
                      TextFormField(
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        onChanged: (value){
                          setState(() {

                          });
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (term){

                        },
                        controller: tc_phone,
                        decoration: const InputDecoration(
                          //errorText: _errorText,
                          //hintText: 'e.g. ',
                          labelText: 'Sender phone number (optional)',
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.black)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),),
                        style: const TextStyle(color: Colors.black),
                      ).p(10),
                      Container(child: Row(
                        children: [
                          Text('Spam/Ham label (optional):').centered().p(10),
                          DropdownButton(
                            value: label, //implement initial value or selected value
                            onChanged: (value){
                              setState(() { //set state will update UI and State of your App
                                label = value!.toString(); //change selectval to new value
                              });
                            },
                            items: labelList.map((itemone){
                              return DropdownMenuItem(
                                  value: itemone,
                                  child: Text(itemone)
                              );
                            }).toList(),
                          ).centered().p(10),
                        ],
                      ).centered(),),
                      Container(child: Row(
                        children: [
                          Text('Message received date (optional):').centered().p(10),
                          Text(datetime).centered().p(10),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                //width: MediaQuery.of(context).size.width * 0.20,
                                height: MediaQuery.of(context).size.height * 0.10),
                            child: ElevatedButton(
                                onPressed: (() async{
                                  final result = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000, 01),
                                      lastDate: DateTime(2100, 12));
                                  print(result.toString());
                                  final timeOfDay = await showTimePicker(
                                      context: context, initialTime: TimeOfDay.now());
                                  print(timeOfDay);
                                  DateFormat df = DateFormat('yyyy-MM-dd HH:mm:ss');
                                  setState(() {
                                    DateTime dt = DateTime(result!.year,result.month,result.day,timeOfDay!.hour,timeOfDay.minute);
                                    datetime = df.format(dt);
                                  });
                                }),
                                child: Text("Pick datetime",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Noto Sans HK',
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    )).centered(),
                                style: ButtonStyle(
                                  //backgroundColor: MaterialStateProperty.all<Color>( Color.fromARGB(0, 51, 78, 100)),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(30.0),
                                            side: BorderSide(color: Colors.black)
                                        )
                                    )
                                )
                            ).p(10),
                          ),
                        ],
                      ).centered(),),
                    ],
                  ).centered(),
                ).p(10).centered(),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.10),
                  child: ElevatedButton(
                      onPressed: (() {
                        if(formKey.currentState!.validate()){
                          submit();
                        }
                      }),
                      child: Text("Submit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Noto Sans HK',
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 255, 255, 255),
                          )).centered(),
                      style: ButtonStyle(
                        //backgroundColor: MaterialStateProperty.all<Color>( Color.fromARGB(0, 51, 78, 100)),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.black),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(35.0),
                                  side: BorderSide(color: Colors.black)
                              )
                          )
                      )
                  ).p(10),
                ),
                Visibility(
                  visible: result_visible,
                  child: VStack([
                    VStack([
                      Text(
                        'Spam Detection Result',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Noto Sans HK',
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ).centered(),
                      Text(
                        '(Higher score tends to be spam)',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Noto Sans HK',
                          //fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ).centered(),
                    ]).centered().p(10),
                    Text(
                        'Simple Neural Network Score:\n'+snn_score+'%',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Noto Sans HK',
                          //fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      textAlign: TextAlign.center,
                    ).centered().p(10),
                    Text(
                        'Bert Score:\n'+bert_score+'%',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Noto Sans HK',
                          //fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      textAlign: TextAlign.center,
                    ).centered().p(10),
                  ]),
                ),
              ],
            ).centered().px(30)
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
