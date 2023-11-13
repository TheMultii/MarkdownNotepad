import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdownnotepad/core/app_theme_extension.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:markdownnotepad/viewmodels/server_settings.dart';

class AccountEditProfileSectionColumn2 extends StatefulWidget {
  final LoggedInUser loggedInUser;
  final ServerSettings serverSettings;
  final Function(File, Uint8List) setUploadedImage;
  final File? uploadedImage;
  final Uint8List? uploadedImageBytes;
  final Function() updateUserProfile;
  final String randomAvatarString;

  const AccountEditProfileSectionColumn2({
    super.key,
    required this.loggedInUser,
    required this.serverSettings,
    required this.setUploadedImage,
    required this.uploadedImageBytes,
    required this.updateUserProfile,
    required this.randomAvatarString,
    this.uploadedImage,
  });

  @override
  State<AccountEditProfileSectionColumn2> createState() =>
      _AccountEditProfileSectionColumn2State();
}

class _AccountEditProfileSectionColumn2State
    extends State<AccountEditProfileSectionColumn2> {
  bool isAvatarInputHovered = false;

  void startFilePicker() async {
    try {
      final FilePickerResult? picked = await FilePicker.platform.pickFiles(
        dialogTitle: "Wybierz nowy avatar",
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
        withData: true,
      );

      if (picked == null || picked.files.isEmpty) return;

      final String? extension = picked.files.first.extension;

      if (extension == null || !['jpg', 'png', 'jpeg'].contains(extension)) {
        return;
      }

      if (picked.files.first.bytes != null) {
        widget.setUploadedImage(
          File.fromRawPath(
            picked.files.first.bytes!,
          ),
          picked.files.first.bytes!,
        );
      } else {
        debugPrint("Error: Bytes are null");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) => setState(() => isAvatarInputHovered = true),
          onExit: (event) => setState(() => isAvatarInputHovered = false),
          child: GestureDetector(
            onTap: () => startFilePicker(),
            child: AnimatedContainer(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .extension<MarkdownNotepadTheme>()
                    ?.cardColor
                    ?.withOpacity(
                      isAvatarInputHovered ? 0.7 : 1,
                    ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: widget.uploadedImageBytes != null
                          ? Image.memory(
                              widget.uploadedImageBytes!,
                              width: 175,
                              height: 175,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              "http://${widget.serverSettings.ipAddress}:${widget.serverSettings.port}/avatar/${widget.loggedInUser.user.id}?seed=${widget.randomAvatarString}",
                              width: 175,
                              height: 175,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const Text(
                      "Zmień avatar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(const Size(300, 50)),
            backgroundColor: MaterialStateProperty.all<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              Colors.white,
            ),
            overlayColor: MaterialStateProperty.all<Color>(
              Colors.white.withOpacity(.075),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          onPressed: () => widget.updateUserProfile(),
          child: Text(
            "Zapisz zmiany",
            style: GoogleFonts.getFont(
              'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
