// To parse this JSON data, do
//
//     final nationalityModel = nationalityModelFromJson(jsonString);

import 'dart:convert';

NationalityModel nationalityModelFromJson(dynamic str) => NationalityModel.fromJson(str);

String nationalityModelToJson(NationalityModel data) => json.encode(data.toJson());

class NationalityModel {
  final List<NationalityData>? data;
  final int? status;
  final String? message;
  // final List<dynamic>? pagination;

  NationalityModel({
    this.data,
    this.status,
    this.message,
    // this.pagination,
  });

  factory NationalityModel.fromJson(Map<String, dynamic> json) => NationalityModel(
    data: json["data"] == null ? [] : List<NationalityData>.from(json["data"]!.map((x) => NationalityData.fromJson(x))),
    status: json["status"],
    message: json["message"],
    // pagination: json["pagination"] == null ? [] : List<dynamic>.from(json["pagination"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "message": message,
    // "pagination": pagination == null ? [] : List<dynamic>.from(pagination!.map((x) => x)),
  };
}

class NationalityData {
  final int? id;
  final String? name;
  final String? code;
  final String? logo;

  NationalityData({
    this.id,
    this.name,
    this.code,
    this.logo,
  });

  factory NationalityData.fromJson(Map<String, dynamic> json) => NationalityData(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "logo": logo,
  };
}
