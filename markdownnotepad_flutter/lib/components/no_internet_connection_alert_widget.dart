import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class NoInternetConnectionAlertWidget extends StatelessWidget {
  final Function() checkIsConnectedToTheServer;

  const NoInternetConnectionAlertWidget({
    super.key,
    required this.checkIsConnectedToTheServer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      color: Theme.of(context).extension<MarkdownNotepadTheme>()?.cardColor,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Brak połączenia z serwerem. Wkrótce zostanie podjęta próba ponownego połączenia.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => checkIsConnectedToTheServer(),
                borderRadius: BorderRadius.circular(3),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.refresh_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Ponów",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY();
  }
}
