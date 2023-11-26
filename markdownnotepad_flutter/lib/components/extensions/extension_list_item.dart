// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/alertdialogs/show_extension_details_alert_dialog.dart';
import 'package:markdownnotepad/components/extensions/extension_status_chip.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/helpers/extensions_helper.dart';
import 'package:markdownnotepad/viewmodels/extension.dart';

class ExtensionListItem extends StatelessWidget {
  final MDNExtension extension;

  const ExtensionListItem({
    super.key,
    required this.extension,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Theme.of(context).extension<MarkdownNotepadTheme>()?.cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          extension.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${extension.author} ・ ${extension.version}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Theme.of(context)
                                .extension<MarkdownNotepadTheme>()
                                ?.text
                                ?.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Row(
              children: [
                ExtensionStatusChip(
                  status: extension.status,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Material(
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.cardColor,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (c) => ShowExtensionDetailsAlertDialog(
                            extension: extension,
                          )
                              .animate()
                              .fadeIn(
                                duration: 100.ms,
                              )
                              .scale(
                                duration: 100.ms,
                                curve: Curves.easeInOut,
                                begin: const Offset(0, 0),
                                end: const Offset(1, 1),
                              ),
                        );
                      },
                      borderRadius: BorderRadius.circular(4),
                      child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            "Szczegóły",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await ExtensionsHelper.removeExtension(extension);
                  },
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  constraints: const BoxConstraints(),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  icon: Icon(
                    FeatherIcons.trash,
                    size: 14,
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.text
                        ?.withOpacity(.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
