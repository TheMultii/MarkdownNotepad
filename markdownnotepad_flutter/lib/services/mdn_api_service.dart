import 'package:dio/dio.dart';
import 'package:markdownnotepad/models/api_models/login_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_user_body_model.dart';
import 'package:markdownnotepad/models/api_models/register_body_model.dart';
import 'package:markdownnotepad/models/api_responses/access_token_response_model.dart';
import 'package:markdownnotepad/models/api_responses/event_logs_response_model.dart';
import 'package:markdownnotepad/models/api_responses/miscellaneous_response_model.dart';
import 'package:markdownnotepad/models/api_responses/user_id_response_model.dart';
import 'package:markdownnotepad/models/api_responses/user_me_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'mdn_api_service.g.dart';

@RestApi()
abstract class MDNApiService {
  factory MDNApiService(Dio dio, {required String baseUrl}) = _MDNApiService;

  @GET("/")
  Future<MiscellaneousResponseModel>? getMiscellaneous();

  @GET("/eventlogs/{page}")
  Future<EventLogsResponseModel>? getEventLogs(
    @Path("page") int page,
    @Header("Authorization") String authorization,
  );

  @POST("/auth/register")
  Future<AccessTokenResponseModel>? register(
    @Body() RegisterBodyModel body,
  );

  @POST("/auth/login")
  Future<AccessTokenResponseModel>? login(
    @Body() LoginBodyModel body,
  );

  @GET("/users/me")
  Future<UserMeResponseModel>? getMe(
    @Header("Authorization") String authorization,
  );

  @GET("/users/{id}")
  Future<UserIdResponseModel>? getId(
    @Path("id") int id,
    @Header("Authorization") String authorization,
  );

  @PATCH("/users")
  Future<MessageSuccessModel>? patchUser(
    @Body() PatchUserBodyModel body,
    @Header("Authorization") String authorization,
  );
}
