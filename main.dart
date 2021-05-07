import 'package:flutter/material.dart';

void main() => runApp(myApp());

Color myColor = const Color(0x59CBE8);

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT서버실무 무드가습기',
      theme: ThemeData(primarySwatch: Colors.red),
      home: Scaffold(
        backgroundColor: Colors.blue[300],
        body: _body(),
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
      ),
    );
  }
}

_body() {
  return Padding(
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
                      border: Border.all(width: 10, color: Colors.orangeAccent),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    '현재온도',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ))),
              Container(
                  margin: EdgeInsets.all(10),
                  height: 100,
                  width: 130,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue[200],
                      border:
                          Border.all(width: 10, color: Colors.lightBlueAccent),
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                      child: Text(
                    '현재습도',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ))),
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
          Container(
              height: 60,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(50)),
              child: Center(
                  child: Text(
                '((현재상태문구를 출력))',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15),
              ))),
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
                    textStyle: TextStyle(color: Colors.black, fontSize: 20)),
                onPressed: () {
                  debugPrint('가습기를 켭니다.');
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
                    textStyle: TextStyle(color: Colors.black, fontSize: 20)),
                onPressed: () {
                  debugPrint('가습기를 끕니다.');
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
                    textStyle: TextStyle(color: Colors.black, fontSize: 20)),
                onPressed: () {
                  debugPrint('LED를 켭니다.');
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
                    textStyle: TextStyle(color: Colors.black, fontSize: 20)),
                onPressed: () {
                  debugPrint('LED를 끕니다.');
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
                },
                child: Text('1'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green[200])),
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
                },
                child: Text('2'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green[500])),
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
                },
                child: Text('3'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green[800])),
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
          ),
          // 간격 30
        ],
      ));
}
