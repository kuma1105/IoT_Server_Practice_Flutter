import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'toast.dart';
// import 'package:flutter_dev/mqtt.dart';

//MQTT
import 'dart:developer';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

//JSON
import 'user.dart';
import 'dart:convert'; //jsonDecode를 사용하기 위해
import 'package:json_annotation/json_annotation.dart';

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
    client = new MqttServerClient.withPort(
        'broker.emqx.io', 'clientIdentifier1234', 1883);
    client.keepAlivePeriod = 60;
    client.autoReconnect = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    // let's connect to mqtt broker
    try {
      await client.connect("inguk", "ccit2"); //이거 Ubuntu Server와 확인해보기
    } on NoConnectionException catch (e) {
      log(e.toString());
    }
  }

  // mqttpublish

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
  }

  @override
  Widget build(BuildContext context) {
    //
    String json = '{"name": "Tom", "email": "Tong@example.com", "number":1189}';

    Map<String, dynamic> userMap = jsonDecode(json);
    // print(userMap);
    // print(mqttSubscribe('ccit/1234'));
    var user = User.fromJson(userMap);

    var jsonData = user.toJson();
    //
    return new Scaffold(
      backgroundColor: Colors.blue[300],
      body: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              //현재온도와 현재습도를 보여주는 ROW
              Row(
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
                        stream: mqttSubscribe('ccit/1234'),
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
                            var user = User.fromJson(payloadMap);
                            print(user.tmp);
                            return Center(
                              child: Text("현재온도\n" + user.tmp + "\u{2103}"),
                            );
                          }

                          return Center(
                              child: CircularProgressIndicator()); // 이건 뭘까??
                        },
                      )), // 이건 뭘까??
                  // child: Center(
                  //     child: Text(
                  //   '현재온도',
                  //   style: TextStyle(color: Colors.black, fontSize: 25),
                  // ))
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
                        stream: mqttSubscribe('ccit/1234'),
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
                            var user = User.fromJson(payloadMap);
                            return Center(
                              child: Text("현재습도\n" + user.hum + "\u{0025}"),
                            );
                          }

                          return Center(child: CircularProgressIndicator());
                        },
                      ))),
                  // child: Center(
                  //     child: Text(
                  //   '현재습도',
                  //   style: TextStyle(color: Colors.black, fontSize: 25),
                  // ))
                ],
              ),
              SizedBox(height: 10),
              //파란색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        'NULL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ))),
                  Container(
                      width: 100,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text(
                        'NULL',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                      ))),
                ],
              ),
              // 간격 30
              SizedBox(height: 20),
              //현재 실내 상태를 출력해 줌
              /////////////////////////////////////
              Container(
                  height: 60,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: StreamBuilder(
                    stream: mqttSubscribe('ccit/1234'),
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
                        var user = User.fromJson(payloadMap);
                        return Center(
                          child: Text(user.key),
                        );
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  ))),
              /////////////////////////////////////
              // 간격 30
              SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: () {
              //     debugPrint('승환이가 눌렀데요');
              //   },
              //   child: Container(
              //       height: 80,
              //       width: 300,
              //       decoration: BoxDecoration(
              //           color: Colors.grey,
              //           borderRadius: BorderRadius.circular(12)),
              //       child: Center(child: Text('가습기'))),
              // ),
              //
              // LED를 켜고 끄는 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.blueAccent,
                        textStyle:
                            TextStyle(color: Colors.black, fontSize: 20)),
                    onPressed: () {
                      debugPrint('가습기를 켭니다.');
                      humiOnToast();
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      //   content: Text('Hello'),
                      // ));
                    },
                    child: Text(
                      '가습기 On',
                      style: TextStyle(color: Colors.black),
                    ),
                    // child: Container(
                    //     margin: EdgeInsets.all(10),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('on')))
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.blueAccent,
                        textStyle:
                            TextStyle(color: Colors.black, fontSize: 20)),
                    onPressed: () {
                      debugPrint('가습기를 끕니다.');
                      humiOffToast();
                    },
                    child: Text(
                      '가습기 Off',
                      style: TextStyle(color: Colors.black),
                    ),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                ],
              ),
              // 간격 30
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[700],
                        onPrimary: Colors.white,
                        textStyle:
                            TextStyle(color: Colors.black, fontSize: 20)),
                    onPressed: () {
                      debugPrint('LED를 켭니다.');
                      ledOnToast();
                    },
                    child: Text('LED On'),
                    // child: Container(
                    //     margin: EdgeInsets.all(10),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('on')))
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.yellow[700],
                        onPrimary: Colors.white,
                        textStyle:
                            TextStyle(color: Colors.black, fontSize: 20)),
                    onPressed: () {
                      debugPrint('LED를 끕니다.');
                      ledOffToast();
                    },
                    child: Text('LED Off'),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                ],
              ),
              // 간격 30
              SizedBox(height: 10),
              //빨간색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  // Container(
                  //     width: 80,
                  //     height: 35,
                  //     decoration: BoxDecoration(
                  //         color: Colors.red[600],
                  //         borderRadius: BorderRadius.circular(12)),
                  //     child: Center(
                  //         child: Text(
                  //       '빨간색',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //           color: Colors.black),
                  //     ))),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('RED 1단계');
                      r1toast();
                    },
                    child: Text('1'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[200])),
                    // child: Container(
                    //     margin: EdgeInsets.all(10),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('on')))
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('RED 2단계');
                      r2toast();
                    },
                    child: Text('2'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[500])),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('RED 3단계');
                      r3toast();
                    },
                    child: Text('3'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[800])),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                ],
              ),
              // 간격 30
              SizedBox(height: 10),
              // 초록색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  // Container(
                  //     width: 80,
                  //     height: 35,
                  //     decoration: BoxDecoration(
                  //         color: Colors.green[600],
                  //         borderRadius: BorderRadius.circular(12)),
                  //     child: Center(
                  //         child: Text(
                  //       '초록색',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //           color: Colors.black),
                  //     ))),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('GREEN 1단계');
                      g1toast();
                    },
                    child: Text('1'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green[200])),
                    // child: Container(
                    //     margin: EdgeInsets.all(10),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('on')))
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('GREEN 2단계');
                      g2toast();
                    },
                    child: Text('2'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green[500])),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('GREEN 3단계');
                      g3toast();
                    },
                    child: Text('3'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.green[800])),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                ],
              ),
              // 간격 30
              SizedBox(height: 10),
              //파란색 LED 색 조절 ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, //위젯 간격 균등 배분
                children: [
                  // Container(
                  //     width: 80,
                  //     height: 35,
                  //     decoration: BoxDecoration(
                  //         color: Colors.blue[700],
                  //         borderRadius: BorderRadius.circular(12)),
                  //     child: Center(
                  //         child: Text(
                  //       '파란색',
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 20,
                  //           color: Colors.black),
                  //     ))),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('BLUE 1단계');
                      b1toast();
                    },
                    child: Text('1'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[200])),
                    // child: Container(
                    //     margin: EdgeInsets.all(10),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('on')))
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('BLUE 2단계');
                      b2toast();
                    },
                    child: Text('2'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[500])),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint('BLUE 3단계');
                      b3toast();
                    },
                    child: Text('3'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue[800])),
                    // child: Container(
                    //     margin: EdgeInsets.all(5),
                    //     height: 150,
                    //     width: 150,
                    //     decoration: BoxDecoration(
                    //         color: Colors.lightGreen,
                    //         borderRadius: BorderRadius.circular(100)),
                    //     child: Center(child: Text('off')))
                  ),
                ],
              ), // 간격 30
            ],
          )),
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
    );
  }
}

// _body() {
//   // Center(
//   //   child: FlatButton(
//   //     onPressed: () {
//   //       flutterToast();
//   //     },
//   //     child: Text('Toast'),
//   //     color: Colors.blue,
//   //   ),
//   // );
//   return
// }
