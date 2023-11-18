import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:markdownnotepad/core/responsive_layout.dart';
import 'package:markdownnotepad/helpers/validator.dart';
import 'package:markdownnotepad/models/api_models/post_catalog_body_model.dart';
import 'package:markdownnotepad/models/api_responses/get_all_catalogs_response_model.dart';
import 'package:markdownnotepad/models/api_responses/post_catalog_response_model.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/providers/drawer_current_tab_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:provider/provider.dart';

class CreateNewCatalogAlertDialog extends StatefulWidget {
  const CreateNewCatalogAlertDialog({super.key});

  @override
  State<CreateNewCatalogAlertDialog> createState() =>
      _CreateNewCatalogAlertDialogState();
}

class _CreateNewCatalogAlertDialogState
    extends State<CreateNewCatalogAlertDialog> {
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

  Future<void> createNewCatalog() async {
    if (!isFieldValid) {
      return;
    }
    setState(() => isCreating = true);

    try {
      final PostCatalogBodyModel postModel =
          PostCatalogBodyModel(title: catalogNameController.text);

      final PostCatalogResponseModel? resp = await apiService.postCatalog(
        postModel,
        "Bearer ${loggedInUser!.accessToken}",
      );

      if (resp == null) {
        setState(() {
          isCreating = false;
        });
        return;
      }

      final GetAllCatalogsResponseModel? cat = await apiService.getCatalogs(
        "Bearer ${loggedInUser!.accessToken}",
      );
      if (cat != null) {
        for (final c in cat.catalogs) {
          debugPrint(c.title);
        }
      }
      final newUser = loggedInUser;
      newUser!.user.catalogs = cat!.catalogs;
      loggedInUserProvider.setCurrentUser(newUser);

      final String destination = "/dashboard/directory/${resp.catalog.id}";

      navigatorPop();
      drawerCurrentTabProvider.setCurrentTab(destination);
      Modular.to.navigate(
        destination,
        arguments: {
          "catalogName": catalogNameController.text,
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
      title: const Text(
        "Nowy folder",
        textAlign: TextAlign.center,
      ),
      content: Container(
        constraints: BoxConstraints(
          minWidth: Responsive.isMobile(context) ? 0 : 300,
          maxWidth: Responsive.isMobile(context) ? double.infinity : 300,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isCreating
                ? const CircularProgressIndicator(
                    strokeWidth: 3.0,
                  )
                : TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return MDNValidator.validateCatalogName(value);
                    },
                    onChanged: (value) {
                      setState(() {
                        isFieldValid =
                            MDNValidator.validateCatalogName(value) == null;
                      });
                    },
                    onFieldSubmitted: (value) => createNewCatalog(),
                    controller: catalogNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nazwa folderu",
                    ),
                  ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Anuluj"),
        ),
        TextButton(
          onPressed:
              isCreating || !isFieldValid ? null : () => createNewCatalog(),
          child: const Text("Utwórz"),
        ),
      ],
    )
        .animate()
        .fadeIn(
          duration: 100.ms,
        )
        .scale(
          duration: 100.ms,
          curve: Curves.easeInOut,
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
        );
  }
}
