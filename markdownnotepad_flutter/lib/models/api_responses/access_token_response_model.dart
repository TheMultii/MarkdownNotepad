import 'package:json_annotation/json_annotation.dart';

part 'access_token_response_model.g.dart';

@JsonSerializable()
class AccessTokenResponseModel {
  @JsonKey(name: 'access_token')
  final String accessToken;

  AccessTokenResponseModel({
    required this.accessToken,
  });

  factory AccessTokenResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenResponseModelToJson(this);
}
