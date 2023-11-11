// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_catalogs_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllCatalogsResponseModel _$GetAllCatalogsResponseModelFromJson(
        Map<String, dynamic> json) =>
    GetAllCatalogsResponseModel(
      catalogs: Catalog.catalogsFromJson(json['catalogs'] as List),
    );

Map<String, dynamic> _$GetAllCatalogsResponseModelToJson(
        GetAllCatalogsResponseModel instance) =>
    <String, dynamic>{
      'catalogs': Catalog.catalogsToJson(instance.catalogs),
    };
