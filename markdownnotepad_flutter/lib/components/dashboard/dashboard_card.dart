import 'package:flutter/material.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/helpers/add_zero.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime editDate;
  final bool isLocalImage;
  final String backgroundImage;
  final Function onTap;
  final Alignment imageAlignment;
  final BoxFit imageFit;

  const DashboardCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.editDate,
    required this.isLocalImage,
    required this.backgroundImage,
    required this.onTap,
    this.imageAlignment = Alignment.topCenter,
    this.imageFit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
          child: InkWell(
            onTap: () => onTap(),
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 140,
                  decoration: BoxDecoration(
                    image: isLocalImage
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Text(
                                  subtitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context)
                                        .extension<MarkdownNotepadTheme>()
                                        ?.text!
                                        .withOpacity(.6),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "${editDate.day}.${addZero(editDate.month)}.${editDate.year}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .extension<MarkdownNotepadTheme>()
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
    );
  }
}
