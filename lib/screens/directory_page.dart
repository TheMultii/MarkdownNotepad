import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_card.dart';
import 'package:markdownnotepad/components/directory/directory_page_empty.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';

class DirectoryPage extends StatefulWidget {
  final String directoryId;

  const DirectoryPage({
    super.key,
    required this.directoryId,
  });

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  late int cardsCount;

  @override
  void initState() {
    super.initState();
    cardsCount = Modular.args.data?['cardsCount'] ?? 7;
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Folder ${widget.directoryId}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (cardsCount > 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Ilość notatek: ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .extension<MarkdownNotepadTheme>()
                                ?.text
                                ?.withOpacity(.6),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .extension<MarkdownNotepadTheme>()
                                ?.cardColor,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: Text(
                            "7 z $cardsCount",
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .extension<MarkdownNotepadTheme>()
                                  ?.text
                                  ?.withOpacity(.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: cardsCount > 0
                    ? DynamicHeightGridView(
                        shrinkWrap: true,
                        itemCount: cardsCount,
                        crossAxisCount: Responsive.isDesktop(context)
                            ? 3
                            : Responsive.isTablet(context)
                                ? 2
                                : 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        builder: (BuildContext context, int index) {
                          return DashboardCard(
                            title: "Test ${index + 1}",
                            subtitle: 'Text ${index + 1}',
                            editDate: DateTime.now(),
                            isLocalImage: false,
                            backgroundImage:
                                "https://api.mganczarczyk.pl/tairiku/random/streetmoe?safety=true&seed=${index % 4}",
                            onTap: () {},
                          );
                        },
                      )
                    : const DirectoryPageEmpty(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
