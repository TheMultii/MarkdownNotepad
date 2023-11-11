import 'package:flutter/material.dart';

class SearchBarItem extends StatelessWidget {
  final int e;
  final bool isLast;
  final String text;
  final Function() dismiss;

  const SearchBarItem({
    super.key,
    required this.e,
    required this.isLast,
    required this.text,
    required this.dismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(8.0),
            onTap: () {
              debugPrint(
                "Search invoked with value: $text $e",
              );
              dismiss();
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=$e",
                      width: 50,
                      height: 40,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      "$text $e",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: isLast ? 0 : 5,
        ),
      ],
    );
  }
}
