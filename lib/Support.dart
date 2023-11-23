import 'dart:convert';

Support supportFromJson(String str) => Support.fromJson(json.decode(str));
String supportToJson(Support data) => json.encode(data.toJson());
class Support {
  Support({
      this.url, 
      this.text,});

  Support.fromJson(dynamic json) {
    url = json['url'];
    text = json['text'];
  }
  String? url;
  String? text;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['text'] = text;
    return map;
  }

}