import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'catalog_simple.g.dart';

@JsonSerializable()
@HiveType(typeId: 12)
class CatalogSimple extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String createdAt;
  @HiveField(3)
  String updatedAt;

  CatalogSimple({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CatalogSimple.fromJson(Map<String, dynamic> json) =>
      _$CatalogSimpleFromJson(json);
  Map<String, dynamic> toJson() => _$CatalogSimpleToJson(this);

  static List<CatalogSimple> catalogsFromJson(List<dynamic> json) {
    List<CatalogSimple> catalogs = [];
    for (var catalog in json) {
      catalogs.add(CatalogSimple.fromJson(catalog));
    }
    return catalogs;
  }

  static List<Map<String, dynamic>> catalogsToJson(
      List<CatalogSimple>? catalogs) {
    if (catalogs == null) return [];
    List<Map<String, dynamic>> json = [];
    for (var catalog in catalogs) {
      json.add(catalog.toJson());
    }
    return json;
  }

  static CatalogSimple catalogFromJson(Map<String, dynamic> json) =>
      CatalogSimple.fromJson(json);

  static Map<String, dynamic> catalogToJson(CatalogSimple catalog) =>
      catalog.toJson();

  static CatalogSimple? catalogOptionalFromJson(Map<String, dynamic>? json) =>
      json == null ? null : CatalogSimple.fromJson(json);

  static Map<String, dynamic>? catalogOptionalToJson(CatalogSimple? catalog) =>
      catalog?.toJson();
}
