// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:markdownnotepad/components/account/sections/edit_profile_subsections/account_edit_profile_section_column_1.dart';
import 'package:markdownnotepad/components/account/sections/edit_profile_subsections/account_edit_profile_section_column_2.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/components/notifications/success_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/get_logged_in_user_details.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/patch_user_body_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:provider/provider.dart';

class AccountEditProfileSection extends StatefulWidget {
  const AccountEditProfileSection({
    super.key,
  });

  @override
  State<AccountEditProfileSection> createState() =>
      _AccountEditProfileSectionState();
}

class _AccountEditProfileSectionState extends State<AccountEditProfileSection> {
  late MDNApiService apiService;
  late LoggedInUser? loggedInUser;
  final NotifyToast notifyToast = NotifyToast();
  final TextEditingController emailInputController = TextEditingController(),
      firstNameInputController = TextEditingController(),
      lastNameInputController = TextEditingController(),
      bioInputController = TextEditingController(),
      passwordInputController = TextEditingController(),
      passwordRepeatInputController = TextEditingController();
  File? uploadedImage;
  Uint8List? uploadedImageBytes;
  String randomAvatarString = DateTime.now().millisecondsSinceEpoch.toString();

  void setUploadedImage(File image, Uint8List imageBytes) {
    setState(() {
      uploadedImage = image;
      uploadedImageBytes = imageBytes;
    });
  }

  Future<void> updateUserProfile() async {
    if (MDNValidator.validateEmail(emailInputController.text) != null ||
        MDNValidator.validateName(firstNameInputController.text) != null ||
        MDNValidator.validateSurname(lastNameInputController.text) != null ||
        MDNValidator.validateBio(bioInputController.text) != null ||
        (MDNValidator.validatePassword(passwordInputController.text) != null &&
            passwordInputController.text.isNotEmpty) ||
        (MDNValidator.validateRepeatPassword(
                  passwordRepeatInputController.text,
                  passwordInputController.text,
                ) !=
                null &&
            passwordRepeatInputController.text.isNotEmpty)) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Masz błędy w formularzu.",
          body: "Popraw je i spróbuj ponownie.",
        ),
      );
      return;
    }

    bool hasUpdatedAnyField = false;
    final String authString = "Bearer ${loggedInUser!.accessToken}";

    final currentUserProvider = context.read<CurrentLoggedInUserProvider>();

    if (uploadedImageBytes != null) {
      try {
        await apiService.postAvatar(
          authString,
          [
            MultipartFile.fromBytes(
              uploadedImageBytes!,
              filename: "avatar.png",
              contentType: MediaType(
                'image',
                'png',
              ),
            ),
          ],
        );

        currentUserProvider.updateAvatarUrl();
        hasUpdatedAnyField = true;
        setState(() {
          uploadedImage = null;
          uploadedImageBytes = null;
          randomAvatarString = DateTime.now().millisecondsSinceEpoch.toString();
        });
      } catch (e) {
        notifyToast.show(
          context: context,
          child: const ErrorNotifyToast(
            title: "Wystąpił błąd.",
            body: "Nie udało się zaktualizować avataru.",
          ),
        );
        return;
      }
    }

    PatchUserBodyModel patchModel = PatchUserBodyModel();
    if (emailInputController.text != loggedInUser!.user.email) {
      patchModel.email = emailInputController.text;
    }
    if (firstNameInputController.text != loggedInUser!.user.name) {
      patchModel.name = firstNameInputController.text;
    }
    if (lastNameInputController.text != loggedInUser!.user.surname) {
      patchModel.surname = lastNameInputController.text;
    }
    if (bioInputController.text != loggedInUser!.user.bio) {
      patchModel.bio = bioInputController.text;
    }
    if (passwordInputController.text.isNotEmpty &&
        passwordRepeatInputController.text.isNotEmpty &&
        passwordInputController.text == passwordRepeatInputController.text) {
      patchModel.password = passwordInputController.text;
    }

    if (patchModel.isEmpty && !hasUpdatedAnyField) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Nie zaktualizowano profilu.",
          body: "Nie zaktualizowano żadnego pola.",
        ),
      );
      return;
    }

    try {
      await apiService.patchUser(patchModel, authString);

      final loggedInUser = await getLoggedInUserDetails(
        apiService,
        authString,
      );

      final loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
      loggedInUserBox.put("logged_in_user", loggedInUser);

      currentUserProvider.setCurrentUser(loggedInUser);

      if (patchModel.password != null) {
        passwordInputController.text = '';
        passwordRepeatInputController.text = '';
      }

      hasUpdatedAnyField = true;
    } catch (e) {
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wystąpił błąd.",
          body: "Nie udało się zaktualizować profilu.",
        ),
      );
      return;
    }

    if (hasUpdatedAnyField) {
      notifyToast.show(
        context: context,
        child: const SuccessNotifyToast(
          title: "Zaktualizowano profil.",
          body: "Pomyślnie zaktualizowano profil.",
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    apiService = context.read<ApiServiceProvider>().apiService;

    final loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
    loggedInUser = loggedInUserBox.get('logged_in_user');

    if (loggedInUser == null) {
      Modular.to.navigate('/auth/login');
      return;
    }

    emailInputController.text = loggedInUser!.user.email;
    firstNameInputController.text = loggedInUser!.user.name;
    lastNameInputController.text = loggedInUser!.user.surname;
    bioInputController.text = loggedInUser!.user.bio ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentLoggedInUserProvider>(
      builder: (context, notifier, child) {
        if (notifier.currentUser == null) {
          Modular.to.navigate('/auth/login');
          return const SizedBox.shrink();
        }

        final loggedInUser = notifier.currentUser!;

        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: IntrinsicHeight(
            child: Responsive.isMobile(context)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountEditProfileSectionColumn1(
                        loggedInUser: loggedInUser,
                        emailInputController: emailInputController,
                        firstNameInputController: firstNameInputController,
                        lastNameInputController: lastNameInputController,
                        bioInputController: bioInputController,
                        passwordInputController: passwordInputController,
                        passwordRepeatInputController:
                            passwordRepeatInputController,
                        updateUserProfile: updateUserProfile,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AccountEditProfileSectionColumn2(
                        loggedInUser: loggedInUser,
                        setUploadedImage: setUploadedImage,
                        uploadedImage: uploadedImage,
                        uploadedImageBytes: uploadedImageBytes,
                        updateUserProfile: updateUserProfile,
                        randomAvatarString: randomAvatarString,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: AccountEditProfileSectionColumn1(
                          loggedInUser: loggedInUser,
                          emailInputController: emailInputController,
                          firstNameInputController: firstNameInputController,
                          lastNameInputController: lastNameInputController,
                          bioInputController: bioInputController,
                          passwordInputController: passwordInputController,
                          passwordRepeatInputController:
                              passwordRepeatInputController,
                          updateUserProfile: updateUserProfile,
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: AccountEditProfileSectionColumn2(
                          loggedInUser: loggedInUser,
                          setUploadedImage: setUploadedImage,
                          uploadedImage: uploadedImage,
                          uploadedImageBytes: uploadedImageBytes,
                          updateUserProfile: updateUserProfile,
                          randomAvatarString: randomAvatarString,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
