import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog_simple.dart';

part 'post_catalog_response_model.g.dart';

@JsonSerializable()
class PostCatalogResponseModel {
  String message;
  @JsonKey(
    toJson: CatalogSimple.catalogToJson,
    fromJson: CatalogSimple.catalogFromJson,
  )
  CatalogSimple catalog;

  PostCatalogResponseModel({
    required this.message,
    required this.catalog,
  });

  factory PostCatalogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostCatalogResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostCatalogResponseModelToJson(this);
}
