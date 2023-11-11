import 'package:json_annotation/json_annotation.dart';

part 'patch_catalog_body_model.g.dart';

@JsonSerializable()
class PatchCatalogBodyModel {
  final String? title;

  PatchCatalogBodyModel({
    this.title,
  });

  factory PatchCatalogBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PatchCatalogBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PatchCatalogBodyModelToJson(this);
}
