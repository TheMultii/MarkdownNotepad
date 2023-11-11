import 'package:json_annotation/json_annotation.dart';
import 'package:markdownnotepad/models/catalog.dart';

part 'get_all_catalogs_response_model.g.dart';

@JsonSerializable()
class GetAllCatalogsResponseModel {
  @JsonKey(toJson: Catalog.catalogsToJson, fromJson: Catalog.catalogsFromJson)
  List<Catalog> catalogs;

  GetAllCatalogsResponseModel({
    required this.catalogs,
  });

  factory GetAllCatalogsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GetAllCatalogsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$GetAllCatalogsResponseModelToJson(this);
}
