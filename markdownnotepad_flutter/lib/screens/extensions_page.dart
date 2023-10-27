import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/extensions/extension_list_item.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/enums/extension_status.dart';
import 'package:markdownnotepad/helpers/extensions_helper.dart';
import 'package:markdownnotepad/helpers/pluralize_helper.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {
  final List<Map<String, dynamic>> loadedExtensions = [
    {
      "name": "Ex 1",
      "author": "Marcel Gańczarczyk",
      "version": "1.1.0",
      "status": ExtensionStatus.active,
    },
    {
      "name": "Ex 2",
      "author": "Marcel Gańczarczyk",
      "version": "1.2.0",
      "status": ExtensionStatus.inactive,
    },
    {
      "name": "Ex 3",
      "author": "Marcel Gańczarczyk",
      "version": "1.3.0",
      "status": ExtensionStatus.invalid,
    },
  ];

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
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Rozszerzenia",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => ExtensionsHelper.loadExtension(),
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 15,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "Dodaj rozszerzenie",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
              const SizedBox(height: 32),
              if (loadedExtensions.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ExtensionListItem(
                              loadedExtensions: loadedExtensions,
                              index: index,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemCount: loadedExtensions.length),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Załadowano ${loadedExtensions.length} ${Pluralize.pluralizeExtensions(loadedExtensions.length)}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Theme.of(context)
                              .extension<MarkdownNotepadTheme>()
                              ?.text
                              ?.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                )
              else
                const Center(
                  child: Text(
                    "Nie znaleziono żadnych rozszerzeń",
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
