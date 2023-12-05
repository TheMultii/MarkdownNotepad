import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/helpers/get_logged_in_user_details.dart';
import 'package:markdownnotepad/models/api_responses/access_token_response_model.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/event_log_vm_list.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';

class CurrentLoggedInUserProvider extends ChangeNotifier {
  final _loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
  final _serverSettingsBox = Hive.box<ServerSettings>('server_settings');

  late MDNApiService apiService;

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

    final settings = _serverSettingsBox.get('server_settings');
    if (settings == null) return;

    apiService = MDNApiService(
      Dio(
        BaseOptions(contentType: "application/json"),
      ),
      baseUrl: "http://${settings.ipAddress}:${settings.port}",
    );

    if (tokenExpirationDate.isBefore(now)) {
      logout();
      return;
    } else if (tokenExpirationDate.difference(now) < const Duration(days: 1)) {
      refreshToken();
    } else {
      debugPrint(
        "Token does not need to be refreshed. It expires in ${tokenExpirationDate.difference(now).inDays} days",
      );
      _getUserData(cU.accessToken).then((value) async {
        _currentUser =
            value; // TODO: don't update note entries where there is mismatch between local and remote updatedAt
        updateAvatarUrl();
        _loggedInUserBox.put('logged_in_user', value);
        notifyListeners();
      });
    }

    _currentUser = cU;

    updateAvatarUrl();
  }

  Future<LoggedInUser> _getUserData(String token) async {
    return await getLoggedInUserDetails(
      apiService,
      "Bearer $token",
    );
  }

  void setCurrentUser(LoggedInUser newUser) {
    _currentUser = newUser;
    if (avatarUrl.isEmpty) updateAvatarUrl();
    notifyListeners();
    _loggedInUserBox.put('logged_in_user', newUser);
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

    try {
      final AccessTokenResponseModel? newToken = await apiService.refreshToken(
        _currentUser!.accessToken,
      );

      if (newToken == null) return;

      final userData = await _getUserData(newToken.accessToken);

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
    _loggedInUserBox.clear();
    Hive.box<EventLogVMList>('event_logs').clear();

    _currentUser = null;
    notifyListeners();
  }
}
