import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Json {
  final String tmp;
  final String hum;
  final String key;

  Json(this.tmp, this.hum, this.key);

  Json.fromJson(Map<String, dynamic> json)
      : tmp = json['tmp'],
        hum = json['hum'],
        key = json['key'];

  Map<String, dynamic> toJson() => {
        'tmp': tmp,
        'hum': hum,
        'key': key,
      };
}
