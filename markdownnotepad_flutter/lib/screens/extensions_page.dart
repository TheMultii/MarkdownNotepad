// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:markdownnotepad/components/extensions/extension_list_item.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/components/notifications/success_notify_toast.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/core/discord_rpc.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/extensions_helper.dart';
import 'package:markdownnotepad/helpers/pluralize_helper.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';
import 'package:markdownnotepad/viewmodels/imported_extensions.dart';
import 'package:markdownnotepad/viewmodels/load_extension.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {
  final NotifyToast notifyToast = NotifyToast();

  @override
  void initState() {
    super.initState();

    MDNDiscordRPC().clearPresence();
  }

  void loadExtension() async {
    final MDNLoadExtension? mdnLoadExtension =
        await ExtensionsHelper.loadExtension();
    if (mdnLoadExtension == null) return;

    final bool validated =
        ExtensionsHelper.validateLoadExtension(mdnLoadExtension);
    if (!validated) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wybrano nieprawidłowe rozszerzenie",
        ),
      );
      return;
    }

    final MDNExtension extension = MDNExtension.fromJson(
      {
        "status": "active",
        ...mdnLoadExtension.toJson(),
      },
    );

    final MDNExtensionUniqueness uniqueness =
        await ExtensionsHelper.checkExtensionUniqueness(extension);
    if (uniqueness == MDNExtensionUniqueness.notUnique) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Nie można zapisać rozszerzenia",
          body: "Rozszerzenie nie jest unikalne.",
        ),
      );
      return;
    }

    if (uniqueness == MDNExtensionUniqueness.newExtension) {
      final bool saved = await ExtensionsHelper.saveExtension(extension);
      if (!saved) {
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Nie udało się zaimportować rozszerzenia",
          ),
        );
        return;
      }

      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(
          title: "Zaimportowano rozszerzenie",
        ),
      );
    } else if (uniqueness == MDNExtensionUniqueness.editableExtension) {
      final bool patched = await ExtensionsHelper.patchExtension(extension);
      if (!patched) {
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Nie udało się zaktualizować rozszerzenia",
          ),
        );
        return;
      }

      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(
          title: "Zaktualizowano rozszerzenie",
        ),
      );
    } else if (uniqueness == MDNExtensionUniqueness.nonModified) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Rozszerzenie nie zostało zaktualizowane",
          body: "Brak zmian względem już zaimportowanego",
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 15.0 : 35.0,
          ).copyWith(
            top: Responsive.isDesktop(context) ? 48.0 : 32.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Rozszerzenia",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () => loadExtension(),
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
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
                      Hive.box<ImportedExtensions>('imported_extensions')
                          .listenable(
                    keys: ['imported_extensions'],
                  ),
                  builder: (BuildContext ctx, Box box, Widget? child) {
                    final List<MDNExtension> importedExtensions = (box.get(
                      'imported_extensions',
                      defaultValue: ImportedExtensions(
                        extensions: [],
                      ),
                    ) as ImportedExtensions)
                        .extensions;

                    if (importedExtensions.isEmpty) {
                      return const Center(
                        child: Text(
                          "Nie znaleziono żadnych rozszerzeń.",
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
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ExtensionListItem(
                                  extension: importedExtensions[index],
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
