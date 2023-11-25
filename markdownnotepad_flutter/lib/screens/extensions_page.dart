import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/extensions/extension_list_item.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/extensions_helper.dart';
import 'package:markdownnotepad/helpers/pluralize_helper.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/imported_extensions.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {

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
              ValueListenableBuilder(
                  valueListenable:
                      Hive.box<ImportedExtensions>('loaded_extensions')
                          .listenable(
                    keys: ['loaded_extensions'],
                  ),
                  builder: (BuildContext ctx, Box box, Widget? child) {
                    final List<MDNExtension> importedExtensions = (box.get(
                      'loaded_extensions',
                      defaultValue: ImportedExtensions(
                        extensions: [],
                      ),
                    ) as ImportedExtensions)
                        .extensions;

                    if (importedExtensions.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nie znaleziono żadnych rozszerzeń",
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ExtensionListItem(
                                  loadedExtension: importedExtensions[index],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemCount: importedExtensions.length),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Załadowano ${importedExtensions.length} ${Pluralize.pluralizeExtensions(importedExtensions.length)}",
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
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
