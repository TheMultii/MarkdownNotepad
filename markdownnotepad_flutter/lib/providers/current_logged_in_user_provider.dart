import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/helpers/get_logged_in_user_details.dart';
import 'package:markdownnotepad/models/api_responses/access_token_response_model.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';

class CurrentLoggedInUserProvider extends ChangeNotifier {
  final _loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
  final _serverSettingsBox = Hive.box<ServerSettings>('server_settings');

  LoggedInUser? _currentUser;
  LoggedInUser? get currentUser => _currentUser;

  String _avatarUrl = '';
  String get avatarUrl => _avatarUrl;

  CurrentLoggedInUserProvider() {
    final cU = _loggedInUserBox.get('logged_in_user');

    if (cU == null) {
      logout();
      return;
    }

    final DateTime tokenExpirationDate = cU.tokenExpiration;
    final DateTime now = DateTime.now();

    if (tokenExpirationDate.isBefore(now)) {
      logout();
      return;
    } else if (tokenExpirationDate.difference(now) < const Duration(days: 1)) {
      refreshToken();
    } else {
      debugPrint(
        "Token does not need to be refreshed. It expires in ${tokenExpirationDate.difference(now).inDays} days",
      );
    }

    _currentUser = cU;

    updateAvatarUrl();
  }

  void setCurrentUser(LoggedInUser newUser) {
    _currentUser = newUser;
    updateAvatarUrl();
    notifyListeners();
  }

  void updateAvatarUrl() {
    final settings = _serverSettingsBox.get('server_settings');
    if (settings == null || _currentUser == null) return;

    _avatarUrl =
        'http://${settings.ipAddress}:${settings.port}/avatar/${_currentUser!.user.id}?seed=${DateTime.now().millisecondsSinceEpoch}';
    notifyListeners();
  }

  void refreshToken() async {
    if (_currentUser == null) return;

    if (_currentUser!.tokenExpiration.difference(DateTime.now()) >=
        const Duration(days: 1)) {
      debugPrint("Token does not need to be refreshed");
      return;
    }

    final settings = _serverSettingsBox.get('server_settings');
    if (settings == null || _currentUser == null) return;

    final MDNApiService apiService = MDNApiService(
      Dio(
        BaseOptions(contentType: "application/json"),
      ),
      baseUrl: "http://${settings.ipAddress}:${settings.port}",
    );

    try {
      final AccessTokenResponseModel? newToken = await apiService.refreshToken(
        _currentUser!.accessToken,
      );

      if (newToken == null) return;

      final userData = await getLoggedInUserDetails(
        apiService,
        "Bearer ${newToken.accessToken}",
      );

      final loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
      loggedInUserBox.put("logged_in_user", userData);

      _currentUser = userData;
      notifyListeners();
    } on DioException catch (e) {
      debugPrint("DioException: ${e.message}");
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
    }
  }

  void logout() {
    _loggedInUserBox.delete('logged_in_user');
    _currentUser = null;
    notifyListeners();
  }
}
