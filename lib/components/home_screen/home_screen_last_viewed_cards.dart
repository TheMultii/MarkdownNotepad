import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mdn/components/home_screen/home_screen_card.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreenLastView extends StatefulWidget {
  const HomeScreenLastView({super.key, required this.minWidth});

  final double minWidth;

  @override
  State<HomeScreenLastView> createState() => _HomeScreenLastViewState();
}

class _HomeScreenLastViewState extends State<HomeScreenLastView>
    with WindowListener {
  final _scr = ScrollController();
  final int homeScreenCardsCount = 3;

  int? calculatedWidth;
  List<int> dummyNumbers = [1, 2, 3];

  bool _onKeyPressed(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (event is KeyDownEvent) {
      if (key != "F5") return false;

      setState(() {
        dummyNumbers = List.generate(3, (index) => Random().nextInt(100));
      });
      debugPrint("Refreshing image -> $dummyNumbers");
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    calculateCardWidth(widget.minWidth.floor());
    windowManager.addListener(this);
    ServicesBinding.instance.keyboard.addHandler(_onKeyPressed);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => calculateCardWidth(null));
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    ServicesBinding.instance.keyboard.removeHandler(_onKeyPressed);
    super.dispose();
  }

  @override
  void onWindowEvent(String eventName) {
    super.onWindowEvent(eventName);
    if (["resize", "enter-full-screen", "leave-full-screen"]
        .contains(eventName)) {
      Future.delayed(
          const Duration(milliseconds: 100), () => calculateCardWidth(null));
    }
  }

  void calculateCardWidth(int? useWidth) {
    double mw = ((useWidth ?? MediaQuery.of(context).size.width) / 9) * 7;
    if (mw == 0) return;
    mw -= 72 + 20 * (homeScreenCardsCount - 1);
    setState(() {
      calculatedWidth = (mw / homeScreenCardsCount).floor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Scrollbar(
          controller: _scr,
          child: SingleChildScrollView(
            controller: _scr,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                homeScreenCardsCount,
                (index) => Padding(
                  padding: EdgeInsets.only(
                      right: (index + 1 != homeScreenCardsCount) ? 20 : 0),
                  child: HomeScreenCard(
                    title: "Sample title (${index + 1})",
                    subtitle: "Przykładowy skrócony opis notatki",
                    editDate: DateTime.now(),
                    width: calculatedWidth ?? widget.minWidth.floor(),
                    imageurl:
                        "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&id=${dummyNumbers[index]}",
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 38,
        ),
      ],
    );
  }
}
