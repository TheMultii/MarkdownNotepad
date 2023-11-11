import 'package:dio/dio.dart';
import 'package:markdownnotepad/models/api_models/register_body_model.dart';
import 'package:markdownnotepad/models/api_responses/access_token_response_model.dart';
import 'package:markdownnotepad/models/api_responses/event_logs_response_model.dart';
import 'package:markdownnotepad/models/api_responses/miscellaneous_response_model.dart';
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
}
