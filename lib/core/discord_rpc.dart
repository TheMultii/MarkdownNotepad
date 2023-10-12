import 'package:dart_discord_rpc/dart_discord_rpc.dart';

// singleton of DiscordRPC
class MDNDiscordRPC {
  static final MDNDiscordRPC _singleton = MDNDiscordRPC._internal();
  static DiscordRPC? _discordRPCInstance;

  factory MDNDiscordRPC() {
    if (_discordRPCInstance == null) {
      DiscordRPC.initialize();
      _discordRPCInstance = DiscordRPC(
        applicationId: '1123939840669519903',
      );
    }
    return _singleton;
  }

  MDNDiscordRPC._internal() {
    _discordRPCInstance ??= DiscordRPC(
      applicationId: '1123939840669519903',
    );
  }

  static DiscordRPC get discordRPCInstance => _discordRPCInstance!;

  void updatePresence({required DiscordPresence presence}) {
    _discordRPCInstance?.start(autoRegister: true);
    _discordRPCInstance?.updatePresence(presence);
  }

  void setPresence({
    required String state,
    String? details,
    int? startTimeStamp,
    int? endTimeStamp,
  }) {
    _discordRPCInstance?.start(autoRegister: true);
    _discordRPCInstance?.updatePresence(
      DiscordPresence(
        state: state,
        startTimeStamp: startTimeStamp ?? DateTime.now().millisecondsSinceEpoch,
        endTimeStamp: endTimeStamp,
        largeImageKey: 'large_icon',
        largeImageText: 'Markdown Notepad',
      ),
    );
  }

  void clearPresence() => setPresence(state: 'Idle');
}
