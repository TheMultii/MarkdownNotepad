import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FetchUserDataDrawerProvider with ChangeNotifier {
  String _userName = "TheMultii";
  String _thumbnailAvatar =
      "https://api.mganczarczyk.pl/user/TheMultii/profile";

  String get userName => _userName;
  String get thumbnailAvatar => _thumbnailAvatar;

  void updateRandomName() async {
    final data = await http.get(Uri.parse('https://randomuser.me/api/'));
    final jsonData = json.decode(data.body);
    final nameData = jsonData['results'][0]['name'];
    _userName = "${nameData['first']} ${nameData['last']}";
    _thumbnailAvatar = jsonData['results'][0]['picture']['thumbnail'];
    notifyListeners();
  }
}
