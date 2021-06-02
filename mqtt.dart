import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:developer';

MqttServerClient client;

class Mqtt {
  void mqttConnect() async {
    // init client
    client = new MqttServerClient.withPort(
        'broker.emqx.io', 'clientIdentifier1234', 1883);
    client.keepAlivePeriod = 60;
    client.autoReconnect = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;

    // let's connect to mqtt broker
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      log(e.toString());
    }
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

  // @override
  // void initState() {
  //   super.initState();
  //   mqttConnect();
  // }
}
