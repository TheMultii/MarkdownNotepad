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
                    ),
                  const DrawerListDivider(title: "Foldery"),
                  for (var folder in drawerFolderTiles)
                    DrawerListTile(
                      title: folder["name"],
                      icon: folder["icon"],
                      onTap: () {},
                      selected: currentSelected == folder["name"],
                    ),
                  const DrawerListDivider(title: "Miscellaneous"),
                  DrawerListTile(
                    title: "Konto",
                    icon: Icons.person_outline,
                    selected: currentSelected == "Konto",
                    onTap: () {},
                  ),
                  DrawerListTile(
                    title: "Rozszerzenia",
                    icon: Icons.extension_outlined,
                    selected: currentSelected == "Rozszerzenia",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          //user profile
          const BottomDrawerProfile(),
        ],
      ),
    );
  }
}

class BottomDrawerProfile extends StatelessWidget {
  const BottomDrawerProfile({
    super.key,
  });

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
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Image.network(
                  "https://api.mganczarczyk.pl/user/TheMultii/profile",
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                "TheMultii",
                style: GoogleFonts.getFont(
                  'Source Sans Pro',
                  textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
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
    this.isItalic = false,
    this.selected = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isItalic, selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor:
          selected ? Theme.of(context).colorScheme.primary : Colors.transparent,
      leading: Icon(
        icon,
        color: Colors.white54,
        size: 22,
      ),
      title: Text(
        title,
        style: GoogleFonts.getFont(
          'Source Sans Pro',
          textStyle: TextStyle(
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
  const DrawerListDivider({super.key, required this.title});

  final String title;

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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
