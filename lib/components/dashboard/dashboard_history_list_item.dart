import 'package:flutter/material.dart';
import 'package:markdownnotepad/enums/dashboard_history_item_actions.dart';
import 'package:markdownnotepad/helpers/add_zero.dart';
import 'package:markdownnotepad/helpers/pluralize_helper.dart';

class DashboardHistoryListItem extends StatelessWidget {
  final bool isLast;
  final Map<String, dynamic> user;
  final DateTime actionDateTime;
  final Map<String, dynamic> note;
  final DashboardHistoryItemActions action;
  final List<String> tags;

  const DashboardHistoryListItem({
    super.key,
    required this.isLast,
    required this.user,
    required this.actionDateTime,
    required this.note,
    required this.action,
    this.tags = const [],
  });

  TextSpan getRelativeTimeTextSpan() {
    String relativeTime = "";

    final timeDifference = DateTime.now().difference(actionDateTime);

    if (timeDifference.inDays >= 365) {
      final yearsAgo = timeDifference.inDays ~/ 365;
      relativeTime = "$yearsAgo ${Pluralize.pluralizeYears(yearsAgo)} temu";
    } else if (timeDifference.inDays >= 1) {
      final daysAgo = timeDifference.inDays;
      relativeTime = "$daysAgo ${Pluralize.pluralizeDays(daysAgo)} temu";
    } else if (timeDifference.inHours >= 1) {
      final hoursAgo = timeDifference.inHours;
      relativeTime = "$hoursAgo ${Pluralize.pluralizeHours(hoursAgo)} temu";
    } else if (timeDifference.inMinutes >= 1) {
      final minutesAgo = timeDifference.inMinutes;
      relativeTime =
          "$minutesAgo ${Pluralize.pluralizeMinutes(minutesAgo)} temu";
    } else {
      relativeTime = "Przed chwilą";
    }

    String dateString =
        "${actionDateTime.day}.${addZero(actionDateTime.month)}.${actionDateTime.year}";

    return TextSpan(
      text: relativeTime,
      children: [
        const TextSpan(text: " ・ "),
        TextSpan(text: dateString),
      ],
    );
  }

  TextSpan getActionTextSpan(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      color: Colors.white.withOpacity(.4),
    );

    switch (action) {
      case DashboardHistoryItemActions.editedNote:
        return TextSpan(
          text: " edytował(-a) notatkę ",
          style: textStyle,
        );
      case DashboardHistoryItemActions.createdNote:
        return TextSpan(
          text: " utworzył(-a) notatkę ",
          style: textStyle,
        );
      case DashboardHistoryItemActions.deletedNote:
        return TextSpan(
          text: " usunął(-a) notatkę ",
          style: textStyle,
        );
      case DashboardHistoryItemActions.addedTag:
        return TextSpan(
          children: [
            TextSpan(
              text: tags.length > 1 ? " dodał(-a) tagi " : " dodał(-a) tag ",
            ),
            ...tags.take(4).map(
                  (tag) => WidgetSpan(
                    child: TagChipSmall(
                      tag: tag,
                      tags: tags,
                      chipColor: tags.indexOf(tag) % 2 == 0
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            const TextSpan(
              text: " notatce ",
            ),
          ],
          style: textStyle,
        );
      case DashboardHistoryItemActions.removedTag:
        return TextSpan(
          children: [
            TextSpan(
              text: tags.length > 1 ? " usunął(-a) tagi " : " usunął(-a) tag ",
            ),
            ...tags.take(4).map(
                  (tag) => WidgetSpan(
                    child: TagChipSmall(
                      tag: tag,
                      tags: tags,
                      chipColor: tags.indexOf(tag) % 2 == 0
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            const TextSpan(
              text: " notatce ",
            ),
          ],
          style: textStyle,
        );
      default:
        return TextSpan(
          text: " wykonał akcję na notatce ",
          style: textStyle,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isLast ? EdgeInsets.zero : const EdgeInsets.only(bottom: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 28, 28, 28),
              borderRadius: const BorderRadius.all(
                Radius.circular(9999),
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.background,
                width: 2.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("Go to user profile: ${user['id']}");
                          },
                          child: Text(
                            user['name'],
                          ),
                        ),
                      ),
                    ),
                    getActionTextSpan(context),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            debugPrint("Go to note: ${note['id']}");
                          },
                          child: Text(
                            note['title'],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
              Text.rich(
                getRelativeTimeTextSpan(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(.4),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
