import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'mdn_api_service.g.dart';

@RestApi(baseUrl: "http://localhost:3000/")
abstract class MDNApiService {
  factory MDNApiService(Dio dio) = _MDNApiService;

  @GET("{id}")
  Future<String>? get(@Path("id") String id);
}
