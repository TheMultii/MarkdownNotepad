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

  LoggedInUser? _currentUser;
  LoggedInUser? get currentUser => _currentUser;

  String _avatarUrl = '';
  String get avatarUrl => _avatarUrl;

  CurrentLoggedInUserProvider() {
    final cU = _loggedInUserBox.get('logged_in_user');
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

  void logout() {
    _loggedInUserBox.delete('logged_in_user');
    _currentUser = null;
    notifyListeners();
  }
}
