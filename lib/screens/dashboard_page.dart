import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late MDNDiscordRPC mdnDiscordRPC;
  late int id;

  @override
  void initState() {
    super.initState();

    id = Modular.args.data?['id'] ?? 0;

    mdnDiscordRPC = MDNDiscordRPC();
    mdnDiscordRPC.clearPresence();
  }

  @override
  Widget build(BuildContext context) {
    final String url =
        "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=$id";

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  url,
                  height: MediaQuery.of(context).size.height * 0.7,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 4),
              Text(
                url,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}