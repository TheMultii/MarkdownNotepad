import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LegalPage extends StatefulWidget {
  const LegalPage({super.key});

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  String appVersion = "";
  String applicationLegalese = "";

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();

    getAppVersion().then(
      (value) => setState(
        () => appVersion = value,
      ),
    );

    final String year = DateTime.now().year.toString();
    setState(
      () => applicationLegalese = year == '2023' ? year : '2023 - $year',
    );
  }

  @override
  Widget build(BuildContext context) {
    return LicensePage(
      applicationName: 'Markdown Notepad',
      applicationVersion: appVersion,
      applicationIcon: Image.asset(
        'assets/icon.png',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
      applicationLegalese: '$applicationLegalese Marcel Gańczarczyk',
    );
  }
}
