import 'package:flutter/material.dart';

class DrawerCreateNewNoteButton extends StatelessWidget {
  const DrawerCreateNewNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: ElevatedButton(
        onLongPress: () {}, //nie dopuść, by longPress aktywował onPressed
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Nowa Notatka'),
                content: const Text('TBD'),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      foregroundColor: Colors.white.withOpacity(.8),
                    ),
                    child: const Text('Anuluj'),
                    onPressed: () {
                      debugPrint("Clicked 'Cancel'!");
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      debugPrint("Clicked 'OK'!");
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          foregroundColor: Colors.white.withOpacity(0.5),
          backgroundColor: Colors.white.withOpacity(0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                "Nowa Notatka",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
