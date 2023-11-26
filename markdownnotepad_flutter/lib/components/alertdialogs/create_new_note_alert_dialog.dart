import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/post_note_body_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_notes_response_model.dart';
import 'package:markdownnotepad/models/api_responses/post_note_response_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:provider/provider.dart';

class CreateNewNoteAlertDialog extends StatefulWidget {
  const CreateNewNoteAlertDialog({super.key});

  @override
  State<CreateNewNoteAlertDialog> createState() =>
      _CreateNewNoteAlertDialogState();
}

class _CreateNewNoteAlertDialogState extends State<CreateNewNoteAlertDialog> {
  final TextEditingController catalogNameController = TextEditingController();

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

  Future<void> createNewNote() async {
    if (!isFieldValid) {
      return;
    }
    setState(() => isCreating = true);

    try {
      final PostNoteBodyModel postModel = PostNoteBodyModel(
        title: catalogNameController.text,
        content: "",
        tags: [],
      );

      final PostNoteResponseModel? resp = await apiService.postNote(
        postModel,
        "Bearer ${loggedInUser!.accessToken}",
      );

      if (resp == null) {
        setState(() {
          isCreating = false;
        });
        return;
      }

      final GetAllNotesResponseModel? notes = await apiService.getNotes(
        "Bearer ${loggedInUser!.accessToken}",
      );

      if (notes != null) {
        final newUser = loggedInUser;
        newUser!.user.notes = notes.notes;
        loggedInUserProvider.setCurrentUser(newUser);
      }

      final newUser = loggedInUser;
      newUser!.user.notes = notes!.notes;
      loggedInUserProvider.setCurrentUser(newUser);

      final String destination = "/editor/${resp.note.id}";

      navigatorPop();
      drawerCurrentTabProvider.setCurrentTab(destination);
      Modular.to.navigate(
        destination,
        arguments: {
          "noteTitle": resp.note.title,
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
        "Nowa notatka",
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: (value) => MDNValidator.validateNoteTitle(value),
            onChanged: (value) {
              setState(() {
                isFieldValid = MDNValidator.validateCatalogName(value) == null;
              });
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onFieldSubmitted: (value) => createNewNote(),
            controller: catalogNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Nazwa notatki",
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          // TextFormField(
          //   obscureText: true,
          //   validator: (value) => MDNValidator.validateCatalogName(value),
          //   autovalidateMode: AutovalidateMode.onUserInteraction,
          //   decoration: const InputDecoration(
          //     border: OutlineInputBorder(),
          //     labelText: "Hasło notatki",
          //   ),
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => navigatorPop(),
          child: const Text("Anuluj"),
        ),
        TextButton(
          onPressed: isCreating || !isFieldValid ? null : () => createNewNote(),
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
