// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patch_catalog_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatchCatalogResponseModel _$PatchCatalogResponseModelFromJson(
        Map<String, dynamic> json) =>
    PatchCatalogResponseModel(
      message: json['message'] as String,
      catalog: Catalog.catalogFromJson(json['catalog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PatchCatalogResponseModelToJson(
        PatchCatalogResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'catalog': Catalog.catalogToJson(instance.catalog),
    };
