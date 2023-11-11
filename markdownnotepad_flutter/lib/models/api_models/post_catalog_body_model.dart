import 'package:json_annotation/json_annotation.dart';

part 'post_catalog_body_model.g.dart';

@JsonSerializable()
class PostCatalogBodyModel {
  final String title;

  PostCatalogBodyModel({
    required this.title,
  });

  factory PostCatalogBodyModel.fromJson(Map<String, dynamic> json) =>
      _$PostCatalogBodyModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostCatalogBodyModelToJson(this);
}
