import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/components/extensions/extension_status_chip.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';

class ExtensionListItem extends StatelessWidget {
  final List<Map<String, dynamic>> loadedExtensions;
  final int index;

  const ExtensionListItem({
    super.key,
    required this.loadedExtensions,
    required this.index,
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
                          loadedExtensions[index]["name"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${loadedExtensions[index]["author"]} ・ ${loadedExtensions[index]["version"]}",
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
                  status: loadedExtensions[index]["status"],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Material(
                    color: Theme.of(context)
                        .extension<MarkdownNotepadTheme>()
                        ?.cardColor,
                    child: InkWell(
                      onTap: () {
                        //
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
                  onPressed: () {},
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
