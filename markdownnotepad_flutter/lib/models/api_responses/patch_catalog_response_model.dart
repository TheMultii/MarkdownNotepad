import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog.dart';

part 'patch_catalog_response_model.g.dart';

@JsonSerializable()
class PatchCatalogResponseModel {
  String message;
  @JsonKey(toJson: Catalog.catalogToJson, fromJson: Catalog.catalogFromJson)
  Catalog catalog;

  PatchCatalogResponseModel({
    required this.message,
    required this.catalog,
  });

  factory PatchCatalogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PatchCatalogResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchCatalogResponseModelToJson(this);
}
