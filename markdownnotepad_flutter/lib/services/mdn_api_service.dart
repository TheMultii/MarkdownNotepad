import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'mdn_api_service.g.dart';

@RestApi()
abstract class MDNApiService {
  factory MDNApiService(Dio dio, {required String baseUrl}) = _MDNApiService;

  @GET("{id}")
  Future<String>? get(@Path("id") String id);
}
