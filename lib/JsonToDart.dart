import 'Data.dart';
import 'Support.dart';
import 'dart:convert';

JsonToDart jsonToDartFromJson(String str) => JsonToDart.fromJson(json.decode(str));
String jsonToDartToJson(JsonToDart data) => json.encode(data.toJson());
class JsonToDart {
  JsonToDart({
      this.page, 
      this.perPage, 
      this.total, 
      this.totalPages, 
      this.data, 
      this.support,});

  JsonToDart.fromJson(dynamic json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    support = json['support'] != null ? Support.fromJson(json['support']) : null;
  }
  num? page;
  num? perPage;
  num? total;
  num? totalPages;
  List<Data>? data;
  Support? support;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['per_page'] = perPage;
    map['total'] = total;
    map['total_pages'] = totalPages;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (support != null) {
      map['support'] = support?.toJson();
    }
    return map;
  }

}