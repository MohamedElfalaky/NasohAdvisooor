import 'dart:convert';

CountyModel countyModelFromJson(dynamic str) => CountyModel.fromJson(str);

String countyModelToJson(CountyModel data) => json.encode(data.toJson());

class CountyModel {
  final List<CountryData>? data;
  final int? status;
  final String? message;
  // final Pagination? pagination;

  CountyModel({
    this.data,
    this.status,
    this.message,
    // this.pagination,
  });

  factory CountyModel.fromJson(Map<String, dynamic> json) => CountyModel(
        data: json["data"] == null
            ? []
            : List<CountryData>.from(
                json["data"]!.map((x) => CountryData.fromJson(x))),
        status: json["status"],
        message: json["message"],
        // pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status,
        "message": message,
        // "pagination": pagination?.toJson(),
      };
}

class CountryData {
  final int? id;
  final String? name;

  CountryData({
    this.id,
    this.name,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Pagination {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? totalPages;

  Pagination({
    this.total,
    this.perPage,
    this.currentPage,
    this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        perPage: json["perPage"],
        currentPage: json["currentPage"],
        totalPages: json["total_pages"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "perPage": perPage,
        "currentPage": currentPage,
        "total_pages": totalPages,
      };
}
