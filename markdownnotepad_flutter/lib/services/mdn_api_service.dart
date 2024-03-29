import 'package:dio/dio.dart' hide Headers;
import 'package:markdownnotepad/models/api_models/login_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_catalog_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_note_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_note_tag_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_user_body_model.dart';
import 'package:markdownnotepad/models/api_models/post_catalog_body_model.dart';
import 'package:markdownnotepad/models/api_models/post_note_body_model.dart';
import 'package:markdownnotepad/models/api_models/post_note_tag_body_model.dart';
import 'package:markdownnotepad/models/api_models/register_body_model.dart';
import 'package:markdownnotepad/models/api_responses/access_token_response_model.dart';
import 'package:markdownnotepad/models/api_responses/disconnect_catalog_response_model.dart';
import 'package:markdownnotepad/models/api_responses/event_logs_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_catalogs_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_note_tags_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_notes_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_catalog_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_note_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_note_tag_response_model.dart';
import 'package:markdownnotepad/models/api_responses/message_success_model.dart';
import 'package:markdownnotepad/models/api_responses/miscellaneous_response_model.dart';
import 'package:markdownnotepad/models/api_responses/patch_catalog_response_model.dart';
import 'package:markdownnotepad/models/api_responses/patch_note_response_model.dart';
import 'package:markdownnotepad/models/api_responses/patch_note_tag_response_model.dart';
import 'package:markdownnotepad/models/api_responses/post_catalog_response_model.dart';
import 'package:markdownnotepad/models/api_responses/post_note_response_model.dart';
import 'package:markdownnotepad/models/api_responses/post_note_tag_response_model.dart';
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

  @POST("/auth/refresh")
  Future<AccessTokenResponseModel>? refreshToken(
    @Header("Authorization") String authorization,
  );

  @GET("/users/me")
  Future<UserMeResponseModel>? getMe(
    @Header("Authorization") String authorization,
  );

  @GET("/users/{id}")
  Future<UserIdResponseModel>? getId(
    @Path("id") String id,
    @Header("Authorization") String authorization,
  );

  @PATCH("/users")
  Future<MessageSuccessModel>? patchUser(
    @Body() PatchUserBodyModel body,
    @Header("Authorization") String authorization,
  );

  @DELETE("/users")
  Future<MessageSuccessModel>? deleteUser(
    @Header("Authorization") String authorization,
  );

  @POST("/avatar")
  @MultiPart()
  @Headers(<String, dynamic>{
    "accept": "*/*",
    "Content-Type": "multipart/form-data",
  })
  Future<MessageSuccessModel?> postAvatar(
    @Header("Authorization") String authorization,
    @Part() List<MultipartFile> avatar,
  );

  @DELETE("/avatar")
  Future<MessageSuccessModel>? deleteAvatar(
    @Header("Authorization") String authorization,
  );

  @GET("/notes/getNotes")
  Future<GetAllNotesResponseModel>? getNotes(
    @Header("Authorization") String authorization,
  );

  @GET("/notes/{id}")
  Future<GetNoteResponseModel>? getNote(
    @Path("id") String id,
    @Header("Authorization") String authorization,
  );

  @POST("/notes")
  Future<PostNoteResponseModel>? postNote(
    @Body() PostNoteBodyModel body,
    @Header("Authorization") String authorization,
  );

  @PATCH("/notes/{id}")
  Future<PatchNoteResponseModel>? patchNote(
    @Path("id") String id,
    @Body() PatchNoteBodyModel body,
    @Header("Authorization") String authorization,
  );

  @DELETE("/notes/{id}")
  Future<MessageSuccessModel>? deleteNote(
    @Path("id") String id,
    @Header("Authorization") String authorization,
  );

  @GET("/notetags/getNoteTags")
  Future<GetAllNoteTagsResponseModel>? getNoteTags(
    @Header("Authorization") String authorization,
  );

  @GET("/notetags/{id}")
  Future<GetNoteTagResponseModel>? getNoteTag(
    @Path("id") String id,
    @Header("Authorization") String authorization,
  );

  @PATCH("/notetags/{id}")
  Future<PatchNoteTagResponseModel>? patchNoteTag(
    @Path("id") String id,
    @Body() PatchNoteTagBodyModel body,
    @Header("Authorization") String authorization,
  );

  @DELETE("/notetags/{id}")
  Future<MessageSuccessModel>? deleteNoteTag(
    @Path("id") String id,
    @Header("Authorization") String authorization,
  );

  @POST("/notetags")
  Future<PostNoteTagResponseModel>? postNoteTag(
    @Body() PostNoteTagBodyModel body,
    @Header("Authorization") String authorization,
  );

  @GET("/catalogs/getCatalogs")
  Future<GetAllCatalogsResponseModel>? getCatalogs(
    @Header("Authorization") String authorization,
  );

  @GET("/catalogs/{id}")
  Future<GetCatalogResponseModel>? getCatalog(
    @Path("id") String id,
    @Header("Authorization") String authorization,
  );

  @PATCH("/catalogs/{id}")
  Future<PatchCatalogResponseModel>? patchCatalog(
    @Path("id") String id,
    @Body() PatchCatalogBodyModel body,
    @Header("Authorization") String authorization,
  );

  @DELETE("/catalogs/{id}")
  Future<MessageSuccessModel>? deleteCatalog(
    @Path("id") String id,
    @Header("Authorization") String authorization,
  );

  @POST("/catalogs")
  Future<PostCatalogResponseModel>? postCatalog(
    @Body() PostCatalogBodyModel body,
    @Header("Authorization") String authorization,
  );

  @PATCH("/catalogs/{id}/disconnect/{noteId}")
  Future<DisconnectCatalogResponseModel>? disconnectNoteFromCatalog(
    @Path("id") String id,
    @Path("noteId") String noteId,
    @Header("Authorization") String authorization,
  );
}
