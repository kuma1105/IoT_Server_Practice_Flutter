import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class User {
  final String tmp;
  final String hum;
  final String key;

  User(this.tmp, this.hum, this.key);

  User.fromJson(Map<String, dynamic> json)
      : tmp = json['tmp'],
        hum = json['hum'],
        key = json['key'];

  Map<String, dynamic> toJson() => {
        'tmp': tmp,
        'hum': hum,
        'key': key,
      };
}
