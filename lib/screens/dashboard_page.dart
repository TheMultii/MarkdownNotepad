import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/dashboard/sections/dashboard_favorites_section.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_header_menu_button.dart';
import 'package:markdownnotepad/components/dashboard/sections/dashboard_last_viewed_section.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/enums/dsahboard_tabs.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late MDNDiscordRPC mdnDiscordRPC;
  DashboardTabs selectedTab = DashboardTabs.lastViewed;

  @override
  void initState() {
    super.initState();

    mdnDiscordRPC = MDNDiscordRPC();
    mdnDiscordRPC.clearPresence();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0).copyWith(
            top: Responsive.isDesktop(context) ? 48.0 : 32.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "👋 Cześć, Marcel",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36.0),
                child: Row(
                  children: [
                    DashboardHeaderMenuButton(
                      text: "Ostatnio wyświetlane",
                      tab: DashboardTabs.lastViewed,
                      selectedTab: selectedTab,
                      onTap: () => setState(
                        () => selectedTab = DashboardTabs.lastViewed,
                      ),
                    ),
                    const SizedBox(width: 20.0),
                    DashboardHeaderMenuButton(
                      text: "Dodane do ulubionych",
                      tab: DashboardTabs.addedToFavourites,
                      selectedTab: selectedTab,
                      onTap: () => setState(
                        () => selectedTab = DashboardTabs.addedToFavourites,
                      ),
                    ),
                  ],
                ),
              ),
              selectedTab == DashboardTabs.lastViewed
                  ? const DashboardLastViewedSection()
                  : const DashboardFavouritesSection(),
            ],
          ),
        ),
      ),
    );
  }
}
