import 'package:flutter/material.dart';

class BottomDrawerProfile extends StatelessWidget {
  const BottomDrawerProfile({
    super.key,
    required this.loggedInUserColorStatus,
    required this.loggedInUserName,
    required this.loggedInUserThumbnail,
  });

  final Color loggedInUserColorStatus;
  final String loggedInUserName, loggedInUserThumbnail;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1,
          width: double.infinity,
          child: Container(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(64)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(loggedInUserThumbnail),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 25,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: loggedInUserColorStatus,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text(
                loggedInUserName,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
