import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/helpers/color_converter.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/post_note_tag_body_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_note_tags_response_model.dart';
import 'package:markdownnotepad/models/api_responses/post_note_tag_response_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:provider/provider.dart';

class CreateNewNoteTagAlertDialog extends StatefulWidget {
  const CreateNewNoteTagAlertDialog({super.key});

  @override
  State<CreateNewNoteTagAlertDialog> createState() =>
      _CreateNewNoteTagAlertDialogState();
}

class _CreateNewNoteTagAlertDialogState
    extends State<CreateNewNoteTagAlertDialog> {
  final TextEditingController noteTagNameController = TextEditingController();
  Color selectedColor = const Color(0xFFF64793);

  late MDNApiService apiService;
  late DrawerCurrentTabProvider drawerCurrentTabProvider;
  late CurrentLoggedInUserProvider loggedInUserProvider;

  late LoggedInUser? loggedInUser;

  bool isCreating = false;
  bool isFieldValid = false;

  @override
  void initState() {
    super.initState();

    loggedInUserProvider = context.read<CurrentLoggedInUserProvider>();
    drawerCurrentTabProvider = context.read<DrawerCurrentTabProvider>();
    apiService = context.read<ApiServiceProvider>().apiService;

    loggedInUser = loggedInUserProvider.currentUser;
  }

  Future<void> createNewNoteTag() async {
    if (!isFieldValid) {
      return;
    }
    setState(() => isCreating = true);

    try {
      final PostNoteTagBodyModel postModel = PostNoteTagBodyModel(
        title: noteTagNameController.text,
        color: ColorConverter.parseToHex(selectedColor),
      );

      final PostNoteTagResponseModel? resp = await apiService.postNoteTag(
        postModel,
        "Bearer ${loggedInUser!.accessToken}",
      );

      if (resp == null) {
        setState(() {
          isCreating = false;
        });
        return;
      }

      final GetAllNoteTagsResponseModel? noteTags =
          await apiService.getNoteTags(
        "Bearer ${loggedInUser!.accessToken}",
      );

      if (noteTags != null) {
        final newUser = loggedInUser;
        newUser!.user.tags = noteTags.noteTags;
        loggedInUserProvider.setCurrentUser(newUser);
      }

      final String destination = "/tag/${resp.noteTag.id}";

      navigatorPop();
      drawerCurrentTabProvider.setCurrentTab(destination);
      Modular.to.navigate(
        destination,
        arguments: {
          "tagName": resp.noteTag.title,
        },
      );
    } on DioException catch (e) {
      debugPrint(e.message);
      debugPrint(e.response?.data.toString());
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() => isCreating = false);
  }

  void navigatorPop() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      title: const Text(
        "Nowy tag",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: (value) => MDNValidator.validateNoteTagTitle(value),
            onChanged: (value) {
              setState(() {
                isFieldValid = MDNValidator.validateNoteTagTitle(value) == null;
              });
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: (value) => createNewNoteTag(),
            controller: noteTagNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nazwa tagu",
            ),
          ),
          const SizedBox(height: 10),
          ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (Color color) => setState(
              () => selectedColor = color,
            ),
            enableAlpha: false,
            pickerAreaBorderRadius: BorderRadius.circular(4),
            hexInputBar: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => navigatorPop(),
          child: const Text("Anuluj"),
        ),
        TextButton(
          onPressed:
              isCreating || !isFieldValid ? null : () => createNewNoteTag(),
          child: const Text("Utwórz"),
        ),
      ],
    ).animate().fadeIn(duration: 100.ms).scale(
          duration: 100.ms,
          curve: Curves.easeInOut,
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
        );
  }
}
