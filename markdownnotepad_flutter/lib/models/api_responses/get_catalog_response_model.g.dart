// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_catalog_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCatalogResponseModel _$GetCatalogResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetCatalogResponseModel(
      catalog: Catalog.catalogFromJson(json['catalog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GetCatalogResponseModelToJson(
        GetCatalogResponseModel instance) =>
    <String, dynamic>{
      'catalog': Catalog.catalogToJson(instance.catalog),
    };
