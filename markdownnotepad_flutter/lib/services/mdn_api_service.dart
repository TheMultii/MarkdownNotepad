import 'package:dio/dio.dart';
import 'package:markdownnotepad/models/api_responses/miscellaneous_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'mdn_api_service.g.dart';

@RestApi()
abstract class MDNApiService {
  factory MDNApiService(Dio dio, {required String baseUrl}) = _MDNApiService;

  @GET("/")
  Future<MiscellaneousResponseModel>? getMiscellaneous();
}
