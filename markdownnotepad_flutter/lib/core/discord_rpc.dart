import 'dart:io';

import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:flutter/foundation.dart';

// singleton of DiscordRPC
class MDNDiscordRPC {
  static final MDNDiscordRPC _singleton = MDNDiscordRPC._internal();
  static DiscordRPC? _discordRPCInstance;

  factory MDNDiscordRPC() {
    if (_discordRPCInstance == null && isDiscordRPCSupported()) {
      DiscordRPC.initialize();
      _discordRPCInstance = DiscordRPC(
        applicationId: '1123939840669519903',
      );
    }
    return _singleton;
  }

  static bool isDiscordRPCSupported() {
    return !(kIsWeb ||
        Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isMacOS);
  }

  MDNDiscordRPC._internal() {
    _discordRPCInstance ??= isDiscordRPCSupported()
        ? DiscordRPC(
            applicationId: '1123939840669519903',
          )
        : null;
  }

  static DiscordRPC get discordRPCInstance => _discordRPCInstance!;
  static DiscordPresence? currentPresence;

  void updatePresence({
    required DiscordPresence presence,
    bool forceUpdate = true,
  }) {
    if (kIsWeb) return;
    if (!Platform.isLinux && !Platform.isWindows) return;
    if (currentPresence?.state == presence.state && !forceUpdate) return;

    _discordRPCInstance?.start(autoRegister: true);
    _discordRPCInstance?.updatePresence(presence);
    currentPresence = presence;
  }

  void setPresence({
    required String state,
    String? details,
    int? startTimeStamp,
    int? endTimeStamp,
    bool forceUpdate = true,
  }) {
    if (kIsWeb) return;
    if (!Platform.isLinux && !Platform.isWindows) return;
    if (currentPresence?.state == state && !forceUpdate) return;

    _discordRPCInstance?.start(autoRegister: true);

    DiscordPresence presence = DiscordPresence(
      state: state,
      startTimeStamp: startTimeStamp ?? DateTime.now().millisecondsSinceEpoch,
      endTimeStamp: endTimeStamp,
      largeImageKey: 'large_icon',
      largeImageText: 'Markdown Notepad',
    );

    _discordRPCInstance?.updatePresence(
      presence,
    );
    currentPresence = presence;
  }

  void clearPresence() {
    if (kIsWeb) return;
    if (!Platform.isLinux && !Platform.isWindows) return;
    setPresence(state: 'Idle', forceUpdate: false);
  }

  DiscordPresence? getPresence() => currentPresence;
}
