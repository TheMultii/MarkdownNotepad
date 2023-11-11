import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog.dart';

part 'get_catalog_response_model.g.dart';

@JsonSerializable()
class GetCatalogResponseModel {
  @JsonKey(toJson: Catalog.catalogToJson, fromJson: Catalog.catalogFromJson)
  Catalog catalog;

  GetCatalogResponseModel({
    required this.catalog,
  });

  factory GetCatalogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetCatalogResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetCatalogResponseModelToJson(this);
}
