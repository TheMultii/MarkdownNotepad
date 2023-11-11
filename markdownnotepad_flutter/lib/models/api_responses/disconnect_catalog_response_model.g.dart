// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disconnect_catalog_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisconnectCatalogResponseModel _$DisconnectCatalogResponseModelFromJson(
        Map<String, dynamic> json) =>
    DisconnectCatalogResponseModel(
      message: json['message'] as String,
      catalog: Catalog.catalogFromJson(json['catalog'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DisconnectCatalogResponseModelToJson(
        DisconnectCatalogResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'catalog': Catalog.catalogToJson(instance.catalog),
    };
