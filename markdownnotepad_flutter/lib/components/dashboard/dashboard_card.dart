import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/helpers/date_helper.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final DateTime editDate;
  final bool isLocalImage;
  final bool isDisabled;
  final String backgroundImage;
  final Function? onTap;
  final Function? onLongPress;
  final Alignment imageAlignment;
  final BoxFit imageFit;
  final double opacity;

  const DashboardCard({
    super.key,
    required this.title,
    required this.editDate,
    required this.isLocalImage,
    required this.backgroundImage,
    this.onTap,
    this.onLongPress,
    this.subtitle,
    this.isDisabled = false,
    this.imageAlignment = Alignment.topCenter,
    this.imageFit = BoxFit.cover,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 296,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .extension<MarkdownNotepadTheme>()
                ?.text!
                .withOpacity(.1),
            borderRadius: const BorderRadius.all(Radius.circular(3)),
          ),
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: IgnorePointer(
              ignoring: isDisabled,
              child: InkWell(
                onTap: isDisabled ? null : () => onTap!(),
                onLongPress: onLongPress == null ? null : () => onLongPress!(),
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Skeletonizer(
                          enabled: true,
                          child: Container(
                            width: double.infinity,
                            height: subtitle == null ? 130 : 140,
                            color: Colors.cyan,
                          ),
                        ),
                        Container(
                          height: subtitle == null ? 130 : 140,
                          decoration: BoxDecoration(
                            image: isDisabled
                                ? null
                                : isLocalImage
                                    ? DecorationImage(
                                        alignment: imageAlignment,
                                        image: AssetImage(backgroundImage),
                                        fit: imageFit,
                                      )
                                    : DecorationImage(
                                        alignment: imageAlignment,
                                        image: NetworkImage(backgroundImage),
                                        fit: imageFit,
                                      ),
                            color: isDisabled
                                ? Theme.of(context)
                                    .extension<MarkdownNotepadTheme>()
                                    ?.text!
                                    .withOpacity(.1)
                                : null,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(3),
                              topRight: Radius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: subtitle != null
                            ? [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            isDisabled
                                                ? ""
                                                : (subtitle!.isNotEmpty
                                                    ? subtitle!
                                                    : "Notatka pusta"),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontStyle: subtitle!.isEmpty
                                                  ? FontStyle.italic
                                                  : FontStyle.normal,
                                              color: Theme.of(context)
                                                  .extension<
                                                      MarkdownNotepadTheme>()
                                                  ?.text!
                                                  .withOpacity(.6),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          isDisabled
                                              ? ""
                                              : DateHelper.getFormattedDate(
                                                  editDate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .extension<
                                                    MarkdownNotepadTheme>()
                                                ?.text!
                                                .withOpacity(.4),
                                          ),
                                        ),
                                      ]),
                                ),
                              ]
                            : [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            isDisabled ? "" : title,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .extension<
                                                        MarkdownNotepadTheme>()
                                                    ?.text!),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          isDisabled
                                              ? ""
                                              : DateHelper.getFormattedDate(
                                                  editDate),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .extension<
                                                    MarkdownNotepadTheme>()
                                                ?.text!
                                                .withOpacity(.4),
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
