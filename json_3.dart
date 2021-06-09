import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Json {
  final double tmp;
  final double hum;
  final String alert;

  Json(this.tmp, this.hum, this.alert);

  Json.fromJson(Map<String, dynamic> json)
      : tmp = json['tmp'],
        hum = json['hum'],
        alert = json['alert'];

  Map<String, dynamic> toJson() => {
        'tmp': tmp,
        'hum': hum,
        'alert': alert,
      };
}
