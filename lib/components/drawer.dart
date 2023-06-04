import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MDNDrawer extends StatelessWidget {
  const MDNDrawer({
    super.key,
    required this.currentSelected,
    required this.drawerNotesTiles,
    required this.drawerFolderTiles,
  });

  final String currentSelected;
  final List<Map<String, dynamic>> drawerNotesTiles;
  final List<Map<String, dynamic>> drawerFolderTiles;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: ListView(
                children: [
                  //app logo
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          width: 56,
                          height: 56,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Markdown Notepad",
                          style: GoogleFonts.getFont(
                            'Plus Jakarta Sans',
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //scrollable menu list
                  DrawerListTile(
                    title: "Dashboard",
                    selected: currentSelected == "Dashboard",
                    textOpacity: currentSelected == "Dashboard" ? 1.0 : 0.6,
                    icon: Icons.dashboard_outlined,
                    onTap: () {},
                  ),
                  const DrawerListDivider(title: "Ostatnie notatki"),
                  for (var note in drawerNotesTiles)
                    DrawerListTile(
                      title: note["name"],
                      icon: note["icon"],
                      onTap: () {},
                      selected: currentSelected == note["name"],
                      textOpacity: currentSelected == note["name"] ? 1.0 : 0.6,
                    ),
                  const DrawerListDivider(title: "Foldery"),
                  for (var folder in drawerFolderTiles)
                    DrawerListTile(
                      title: folder["name"],
                      icon: folder["icon"],
                      onTap: () {},
                      selected: currentSelected == folder["name"],
                      textOpacity:
                          currentSelected == folder["name"] ? 1.0 : 0.6,
                    ),
                  const DrawerListDivider(title: "Miscellaneous"),
                  DrawerListTile(
                    title: "Konto",
                    icon: Icons.person_outline,
                    selected: currentSelected == "Konto",
                    textOpacity: currentSelected == "Konto" ? 1.0 : 0.6,
                    onTap: () {},
                  ),
                  DrawerListTile(
                    title: "Rozszerzenia",
                    icon: Icons.extension_outlined,
                    selected: currentSelected == "Rozszerzenia",
                    textOpacity: currentSelected == "Rozszerzenia" ? 1.0 : 0.6,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          //user profile
          const BottomDrawerProfile(
            loggedInUserColorStatus: Color(0xFF1CD43A),
            loggedInUserName: "TheMultii",
          ),
        ],
      ),
    );
  }
}

class BottomDrawerProfile extends StatelessWidget {
  const BottomDrawerProfile({
    super.key,
    required this.loggedInUserColorStatus,
    required this.loggedInUserName,
  });

  final Color loggedInUserColorStatus;
  final String loggedInUserName;

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
                backgroundImage: NetworkImage(
                    "https://api.mganczarczyk.pl/user/$loggedInUserName/profile"),
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
                style: GoogleFonts.getFont(
                  'Source Sans Pro',
                  color: Colors.white.withOpacity(0.6),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.textOpacity = 1.0,
    this.isItalic = false,
    this.selected = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isItalic, selected;
  final double textOpacity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:
          selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
      leading: Icon(
        icon,
        color: Colors.white.withOpacity(textOpacity),
        size: 22,
      ),
      title: Text(
        title,
        style: GoogleFonts.getFont(
          'Source Sans Pro',
          textStyle: TextStyle(
            color: Colors.white.withOpacity(textOpacity),
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            fontSize: 13,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

class DrawerListDivider extends StatelessWidget {
  const DrawerListDivider({
    super.key,
    required this.title,
    this.titleColor = const Color(0xFFF2F3F5),
  });

  final String title;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 25,
          bottom: 8,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
