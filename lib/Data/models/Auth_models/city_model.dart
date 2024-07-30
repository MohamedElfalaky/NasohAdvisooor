
import 'dart:convert';

CityModel cityModelFromJson(dynamic str) => CityModel.fromJson(str);

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  final List<CityData>? data;
  final dynamic status;
  final String? message;
  // final List<dynamic>? pagination;

  CityModel({
    this.data,
    this.status,
    this.message,
    // this.pagination,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        data: json["data"] == null
            ? []
            : List<CityData>.from(
                json["data"]!.map((x) => CityData.fromJson(x))),
        status: json["status"],
        message: json["message"],
        // pagination: json["pagination"] == null
        //     ? []
        //     : List<dynamic>.from(json["pagination"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
        "message": message,
        // "pagination": pagination == null
        //     ? []
        //     : List<dynamic>.from(pagination!.map((x) => x)),
      };
}

class CityData {
  final dynamic id;
  final Country? country;
  final String? name;

  CityData({
    this.id,
    this.country,
    this.name,
  });

  factory CityData.fromJson(Map<String, dynamic> json) => CityData(
        id: json["id"],
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country?.toJson(),
        "name": name,
      };
}

class Country {
  final dynamic id;
  final String? name;

  Country({
    this.id,
    this.name,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
