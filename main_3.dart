import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'toast.dart';
// import 'package:flutter_dev/mqtt.dart';

//MQTT
import 'dart:developer';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

//JSON
import 'json.dart';
import 'dart:convert'; //jsonDecode를 사용하기 위해
import 'package:json_annotation/json_annotation.dart';

import 'package:lite_rolling_switch/lite_rolling_switch.dart';

void main() => runApp(MyApp());

Color myColor = const Color(0x59CBE8);

class MyApp extends StatelessWidget {
  ////////////////////////////
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT서버실무 무드가습기',
      theme: ThemeData(primarySwatch: Colors.red),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

MqttServerClient client;

// broker.emqx.io
// 114.71.241.151
class _HomePageState extends State<HomePage> {
  mqttConnect() async {
    // init client
    // broker.emqx.io
    // 114.71.241.151
    client = new MqttServerClient.withPort('broker.emqx.io', 'client', 1883);
    client.keepAlivePeriod = 60;
    client.autoReconnect = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    // let's connect to mqtt broker
    try {
      await client.connect('inguk', 'ccit2');
    } on NoConnectionException catch (e) {
      log(e.toString());
    }
  }

  void mqttPublish(String topic, String addString) {
    final pubTopic = topic;
    final builder = MqttClientPayloadBuilder();
    builder.addString(addString);
    client.publishMessage(pubTopic, MqttQos.atLeastOnce, builder.payload);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> mqttSubscribe(String topic) {
    client.subscribe(topic, MqttQos.exactlyOnce);
    return client.updates;
  }

  void onDisconnected() {
    log('Disconnected');
  }

  void onConnected() {
    log('Connected');
  }

  @override
  void initState() {
    super.initState();
    mqttConnect();
    // mqttPublish(Flutter_to_Pi, "ledOff");
  }

  /////////////////////////////////////////////////////////////
  String ledCtrl = "off";
  double value = 50;

  String Pi_to_Flutter = 'jb/shilmu/csle/smenco/mdlp/dht';
  String Flutter_to_Pi = 'jb/shilmu/csle/smenco/mdlp/neo';
  /////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////////////////////
    //JSON Example
    // String json = '{"name": "Tom", "email": "Tong@example.com", "number":1189}';
    // Map<String, dynamic> userMap = jsonDecode(json);
    // print(userMap);
    // print(mqttSubscribe('ccit/1234'));
    // var user = User.fromJson(userMap);
    // var jsonData = user.toJson();
    /////////////////////////////////////////////////////////////

    return new Scaffold(
      // 앱 상단바
      appBar: AppBar(
        title: Text('IoT서버실무 무드가습기'),
        centerTitle: true,
        flexibleSpace: new Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.red,
                Colors.blue,
              ])),
        ),
        elevation: 0.0, //입체감을 주는 효과
        leading: IconButton(
          //leaging : 아이콘 버튼을 왼쪽에 배치
          icon: Icon(Icons.menu),
          onPressed: () {
            //함수 형태로 터치했을 때 일어나는 이벤트를 정의함
            debugPrint('menu button is clicked');
          },
        ),
        actions: <Widget>[
          //복수의 아이콘 버튼 등을 오른쪽에 배치
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              debugPrint('setting button is clicked');
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // 배경색
      body: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              //현재온도와 현재습도를 보여주는 ROW
              Row(
                //현재온도
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.orange[200],
                          border:
                              Border.all(width: 10, color: Colors.orangeAccent),
                          borderRadius: BorderRadius.circular(30)),
                      child: StreamBuilder(
                        stream: mqttSubscribe(Pi_to_Flutter),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<MqttReceivedMessage<MqttMessage>>
                                mqttRecieveMessage = snapshot.data;
                            MqttPublishMessage recieveMessage =
                                mqttRecieveMessage[0].payload;
                            String payload =
                                MqttPublishPayload.bytesToStringAsString(
                                    recieveMessage.payload.message);
                            print(payload);
                            Map<String, dynamic> payloadMap =
                                jsonDecode(payload);
                            print(payloadMap);
                            var user = Json.fromJson(payloadMap);
                            print(user.tmp);
                            return Center(
                              child: Text(
                                  "현재온도\n" + user.tmp.toString() + "\u{2103}"),
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        },
                      )),
                  Container(
                      margin: EdgeInsets.all(10),
                      height: 100,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.lightBlue[200],
                          border: Border.all(
                              width: 10, color: Colors.lightBlueAccent),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                          child: StreamBuilder(
                        stream: mqttSubscribe(Pi_to_Flutter),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<MqttReceivedMessage<MqttMessage>>
                                mqttRecieveMessage = snapshot.data;
                            MqttPublishMessage recieveMessage =
                                mqttRecieveMessage[0].payload;
                            String payload =
                                MqttPublishPayload.bytesToStringAsString(
                                    recieveMessage.payload.message);
                            Map<String, dynamic> payloadMap =
                                jsonDecode(payload);
                            var user = Json.fromJson(payloadMap);
                            return Center(
                              child: Text(
                                  "현재습도\n" + user.hum.toString() + "\u{0025}"),
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        },
                      ))),
                ],
              ),
              SizedBox(height: 10), // 위아래 간격
              //파란색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  Container(
                      height: 90,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: StreamBuilder(
                        stream: mqttSubscribe(Pi_to_Flutter),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<MqttReceivedMessage<MqttMessage>>
                                mqttRecieveMessage = snapshot.data;
                            MqttPublishMessage recieveMessage =
                                mqttRecieveMessage[0].payload;
                            String payload =
                                MqttPublishPayload.bytesToStringAsString(
                                    recieveMessage.payload.message);
                            Map<String, dynamic> payloadMap =
                                jsonDecode(payload);
                            var user = Json.fromJson(payloadMap);
                            return Center(
                              child: Text(
                                  "최고온도\n" + user.hum.toString() + "\u{0025}"),
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        },
                      ))),
                  Container(
                      height: 90,
                      width: 130,
                      decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: StreamBuilder(
                        stream: mqttSubscribe(Pi_to_Flutter),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            List<MqttReceivedMessage<MqttMessage>>
                                mqttRecieveMessage = snapshot.data;
                            MqttPublishMessage recieveMessage =
                                mqttRecieveMessage[0].payload;
                            String payload =
                                MqttPublishPayload.bytesToStringAsString(
                                    recieveMessage.payload.message);
                            Map<String, dynamic> payloadMap =
                                jsonDecode(payload);
                            var user = Json.fromJson(payloadMap);
                            return Center(
                              child: Text(
                                  "최고습도\n" + user.hum.toString() + "\u{0025}"),
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        },
                      ))),
                ],
              ),
              SizedBox(height: 20), // 위아래 간격
              //현재 실내 상태를 출력함
              Container(
                  height: 70,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: StreamBuilder(
                    stream: mqttSubscribe(Pi_to_Flutter),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<MqttReceivedMessage<MqttMessage>>
                            mqttRecieveMessage = snapshot.data;
                        MqttPublishMessage recieveMessage =
                            mqttRecieveMessage[0].payload;
                        String payload =
                            MqttPublishPayload.bytesToStringAsString(
                                recieveMessage.payload.message);
                        Map<String, dynamic> payloadMap = jsonDecode(payload);
                        var user = Json.fromJson(payloadMap);
                        return Center(
                          child: Text(user.alert),
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ))),
              SizedBox(height: 5), // 위아래 간격
              // LED 제어 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: <Widget>[
                  //슬라이드 스위치
                  Padding(
                      padding: EdgeInsets.all(20),
                      child: LiteRollingSwitch(
                        value: true,
                        textOn: "Led On",
                        textOff: "Led Off",
                        colorOn: Colors.greenAccent,
                        colorOff: Colors.redAccent,
                        iconOn: Icons.done,
                        iconOff: Icons.alarm_off,
                        textSize: 20.0,
                        onChanged: (bool position) {
                          print("The button is $position");
                          if (position) {
                            mqttPublish(Flutter_to_Pi, "ledOn");
                            ledOnToast();
                            ledCtrl = "on";
                          } else {
                            mqttPublish(Flutter_to_Pi, "ledOff");
                            ledOffToast();
                            ledCtrl = "off";
                          }
                        },
                      ))
                ],
              ),
              //빨간색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('YELLOW 1단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "ylw1");
                        print("ylw1 Published!");
                        y1toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('1'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(80, 255, 211, 26))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('YELLOW 2단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "ylw2");
                        print("ylw2 Published!");
                        y2toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('2'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(160, 255, 211, 26))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('YELLOW 3단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "ylw3");
                        print("ylw3 Published!");
                        y3toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('3'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(225, 255, 211, 26))),
                  ),
                ],
              ),
              // SizedBox(height: 5), // 위아래 간격
              // 초록색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('GREEN 1단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "grn1");
                        print("grn1 Published!");
                        g1toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('1'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green[200])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('GREEN 2단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "grn2");
                        print("grn2 Published!");
                        g2toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('2'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green[500])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('GREEN 3단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "grn3");
                        print("grn3 Published!");
                        g3toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('3'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green[800])),
                  ),
                ],
              ),
              // SizedBox(height: 5), // 위아래 간격
              //파란색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('BLUE 1단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "blu1");
                        print("blu1 Published!");
                        b1toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('1'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[200])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('BLUE 2단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "blu2");
                        print("blu2 Published!");
                        b2toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('2'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[500])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('BLUE 3단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "blu3");
                        print("blu3 Published!");
                        b3toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('3'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[800])),
                  ),
                ],
              ), // 간격 30
              // SizedBox(height: 5),
              // 보라색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('PURPLE 1단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "ppl1");
                        print("ppl1 Published!");
                        p1toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('1'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple[200])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('PURPLE 2단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "ppl2");
                        print("ppl2 Published!");
                        p2toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('2'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple[500])),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('PURPLE 3단계');
                      if (ledCtrl == "on") {
                        mqttPublish(Flutter_to_Pi, "ppl3");
                        print("ppl3 Published!");
                        p3toast();
                      } else {
                        print("Led is off and cannot operate.");
                        ledIsOff();
                      }
                    },
                    child: Text('3'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple[800])),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
