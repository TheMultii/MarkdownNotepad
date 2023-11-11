import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog.dart';

part 'post_catalog_response_model.g.dart';

@JsonSerializable()
class PostCatalogResponseModel {
  String message;
  @JsonKey(toJson: Catalog.catalogToJson, fromJson: Catalog.catalogFromJson)
  Catalog catalog;

  PostCatalogResponseModel({
    required this.message,
    required this.catalog,
  });

  factory PostCatalogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostCatalogResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostCatalogResponseModelToJson(this);
}
