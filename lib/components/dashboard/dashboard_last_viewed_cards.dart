import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/components/dashboard/dashboard_card.dart';
import 'package:markdownnotepad/helpers/scroll_pointer_signal.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:provider/provider.dart';

class DashboardLastViewedCards extends StatefulWidget {
  final List<Map<String, dynamic>> items;

  const DashboardLastViewedCards({
    super.key,
    required this.items,
  });

  @override
  State<DashboardLastViewedCards> createState() =>
      _DashboardLastViewedCardsState();
}

class _DashboardLastViewedCardsState extends State<DashboardLastViewedCards> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Listener(
          onPointerSignal: (pointerSignal) => handleScrollPointerSignal(
            pointerSignal,
            _scrollController,
            speedMultiplier: 0.5,
          ),
          child: Scrollbar(
            controller: _scrollController,
            thickness: 3.0,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 10.0,
                direction: Axis.horizontal,
                children: widget.items
                    .map(
                      (itemCard) => DashboardCard(
                        title: itemCard['title'],
                        subtitle: itemCard['subtitle'],
                        editDate: itemCard['editDate'],
                        isLocalImage: itemCard['isLocalImage'],
                        backgroundImage: itemCard['backgroundImage'],
                        imageAlignment: itemCard['imageAlignment'],
                        onTap: () {
                          final String destination =
                              "/editor/${itemCard['id']}";
                          context
                              .read<DrawerCurrentTabProvider>()
                              .setCurrentTab(destination);
                          Modular.to.navigate(destination);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
