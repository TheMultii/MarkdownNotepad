import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';

class ApiServiceProvider with ChangeNotifier {
  final _serverSettingsBox = Hive.box<ServerSettings>('server_settings');

  late MDNApiService _apiService;

  MDNApiService get apiService => _apiService;

  ApiServiceProvider() {
    updateApiService();
  }

  void updateApiService() {
    final settings = _serverSettingsBox.get('server_settings');

    _apiService = MDNApiService(
      Dio(
        BaseOptions(contentType: "application/json"),
      ),
      baseUrl: "http://${settings?.ipAddress}:${settings?.port}",
    );
  }
}
