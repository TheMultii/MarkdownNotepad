import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog.dart';

part 'disconnect_catalog_response_model.g.dart';

@JsonSerializable()
class DisconnectCatalogResponseModel {
  String message;
  @JsonKey(toJson: Catalog.catalogToJson, fromJson: Catalog.catalogFromJson)
  Catalog catalog;

  DisconnectCatalogResponseModel({
    required this.message,
    required this.catalog,
  });

  factory DisconnectCatalogResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DisconnectCatalogResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DisconnectCatalogResponseModelToJson(this);
}
