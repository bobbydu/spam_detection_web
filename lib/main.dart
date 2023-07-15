import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';

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
  bool result_visible = false;
  String result = '';
  String sms = '';
  String phone = '12345678';
  String label = '';
  String datetime = '';
  String snn_score = '';
  String bert_score = '';
  String ChatGPT_result = '';
  String GoogleBard_result = '';
  final formKey = GlobalKey<FormState>();

  Future<void> submit() async{
    print('Submit');
    datetime = DateTime.now().toString();
    sms = tc_sms.text.toString();
    setState(() {
      SmartDialog.showLoading();
    });
    final response = await http.post(
      Uri.parse("https://eiu051ow89.execute-api.ap-southeast-1.amazonaws.com/Test/main"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "sms": sms,
        "phone": phone,
        "label": label,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
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
                      'Simple Neural Network Score: '+snn_score+'%',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans HK',
                        //fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )
                  ).centered().p(10),
                  Text(
                      'Bert Score: '+bert_score+'%',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Noto Sans HK',
                        //fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )
                  ).centered().p(10),
                ]),
            ),
          ],
        ).centered().px(30)
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
