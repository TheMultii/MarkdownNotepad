// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_catalog_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCatalogResponseModel _$PostCatalogResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostCatalogResponseModel(
      message: json['message'] as String,
      catalog: CatalogSimple.catalogFromJson(
          json['catalog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostCatalogResponseModelToJson(
        PostCatalogResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'catalog': CatalogSimple.catalogToJson(instance.catalog),
    };
