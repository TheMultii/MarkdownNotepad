import 'package:dart_discord_rpc/dart_discord_rpc.dart';
import 'package:flutter/material.dart';

class DiscordRPCProvider with ChangeNotifier {
  DiscordRPC? _discordPresence;
  DiscordRPC? get discordPresence => _discordPresence;

  DiscordRPCProvider();

  //named constructor
  DiscordRPCProvider.fromDiscordRPC(DiscordRPC discordRPC) {
    setDiscordRPCProider(discordRPC);
  }

  void setDiscordRPCProider(DiscordRPC newDiscordRPC) {
    _discordPresence = newDiscordRPC;
  }

  void setDiscordRPCPresence() {} //TODO
}
