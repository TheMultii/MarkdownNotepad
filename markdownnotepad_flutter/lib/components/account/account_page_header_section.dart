import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:markdownnotepad/components/circle_arc.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

class AccountPageHeaderSection extends StatelessWidget {
  final LoggedInUser? loggedInUser;
  final TextStyle w60style;
  final CurrentLoggedInUserProvider notifier;

  const AccountPageHeaderSection({
    super.key,
    required this.loggedInUser,
    required this.w60style,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: notifier.avatarUrl,
                width: 77,
                height: 77,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(
                  strokeWidth: 3.0,
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                ),
              ),
            ),
            CustomPaint(
              size: const Size(80, 80),
              painter: CircleArc(
                size: 90,
                strokeWidth: 4,
                color: Theme.of(context).colorScheme.primary.withOpacity(.2),
                startDegree: 155.98,
                endDegree: 155.98 + (.1302 * 360),
              ),
            ),
            CustomPaint(
              size: const Size(80, 80),
              painter: CircleArc(
                size: 90,
                strokeWidth: 4,
                color: Theme.of(context).colorScheme.primary.withOpacity(.4),
                startDegree: 206.86,
                endDegree: 206.86 + (.1686 * 360),
              ),
            ),
            CustomPaint(
              size: const Size(80, 80),
              painter: CircleArc(
                size: 90,
                strokeWidth: 4,
                color: Theme.of(context).colorScheme.primary.withOpacity(.6),
                startDegree: 271.38,
                endDegree: 271.38 + (.1593 * 360),
              ),
            ),
            CustomPaint(
              size: const Size(80, 80),
              painter: CircleArc(
                size: 90,
                strokeWidth: 4,
                color: Theme.of(context).colorScheme.primary.withOpacity(.8),
                startDegree: 332.77,
                endDegree: 332.77 + (.1474 * 360),
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 25,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loggedInUser!.user.name.isNotEmpty
                    ? "${loggedInUser!.user.name} ${loggedInUser!.user.surname}"
                    : loggedInUser!.user.username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                (loggedInUser!.user.bio?.isEmpty ?? true)
                    ? loggedInUser!.user.email
                    : loggedInUser!.user.bio!,
                style: w60style,
              ),
              if (loggedInUser!.user.bio != null &&
                  loggedInUser!.user.bio!.isNotEmpty)
                Text(
                  loggedInUser!.user.email,
                  style: w60style,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
