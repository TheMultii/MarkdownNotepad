import 'dart:io';

import 'package:dio/dio.dart';
import 'package:markdownnotepad/models/api_models/login_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_note_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_note_tag_body_model.dart';
import 'package:markdownnotepad/models/api_models/patch_user_body_model.dart';
import 'package:markdownnotepad/models/api_models/post_note_body_model.dart';
import 'package:markdownnotepad/models/api_models/post_note_tag_body_model.dart';
import 'package:markdownnotepad/models/api_models/register_body_model.dart';
import 'package:markdownnotepad/models/api_responses/access_token_response_model.dart';
import 'package:markdownnotepad/models/api_responses/event_logs_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_catalogs_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_note_tags_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_notes_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_catalog_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_note_response_model.dart';
import 'package:markdownnotepad/models/api_responses/get_note_tag_response_model.dart';
import 'package:markdownnotepad/models/api_responses/message_success_model.dart';
import 'package:markdownnotepad/models/api_responses/miscellaneous_response_model.dart';
import 'package:markdownnotepad/models/api_responses/patch_note_response_model.dart';
import 'package:markdownnotepad/models/api_responses/patch_note_tag_response_model.dart';
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

  @DELETE("/users")
  Future<MessageSuccessModel>? deleteUser(
    @Header("Authorization") String authorization,
  );

  @POST("/avatar")
  @MultiPart()
  Future<MessageSuccessModel>? postAvatar(
    @Part() File avatar,
    @Header("Authorization") String authorization,
  );

  @DELETE("/avatar")
  Future<MessageSuccessModel>? deleteAvatar(
    @Header("Authorization") String authorization,
  );

  @GET("notes/getNotes")
  Future<GetAllNotesResponseModel>? getNotes(
    @Header("Authorization") String authorization,
  );

  @GET("notes/{id}")
  Future<GetNoteResponseModel>? getNote(
    @Path("id") int id,
    @Header("Authorization") String authorization,
  );

  @POST("notes")
  Future<PostNoteResponseModel>? postNote(
    @Body() PostNoteBodyModel body,
    @Header("Authorization") String authorization,
  );

  @PATCH("notes/{id}")
  Future<PatchNoteResponseModel>? patchNote(
    @Path("id") int id,
    @Body() PatchNoteBodyModel body,
    @Header("Authorization") String authorization,
  );

  @DELETE("notes/{id}")
  Future<MessageSuccessModel>? deleteNote(
    @Path("id") int id,
    @Header("Authorization") String authorization,
  );

  @GET("/notetags/getNoteTags")
  Future<GetAllNoteTagsResponseModel>? getNoteTags(
    @Header("Authorization") String authorization,
  );

  @GET("/notetags/{id}")
  Future<GetNoteTagResponseModel>? getNoteTag(
    @Path("id") int id,
    @Header("Authorization") String authorization,
  );

  @PATCH("/notetags")
  Future<PatchNoteTagResponseModel>? patchNoteTag(
    @Body() PatchNoteTagBodyModel body,
    @Header("Authorization") String authorization,
  );

  @DELETE("/notetags/{id}")
  Future<MessageSuccessModel>? deleteNoteTag(
    @Path("id") int id,
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
    @Path("id") int id,
    @Header("Authorization") String authorization,
  );
}
