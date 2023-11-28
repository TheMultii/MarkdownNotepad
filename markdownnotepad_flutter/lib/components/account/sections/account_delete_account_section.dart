import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart' show Modular;
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:markdownnotepad/components/notifications/error_notify_toast.dart';
import 'package:markdownnotepad/core/notify_toast.dart';
import 'package:markdownnotepad/providers/api_service_provider.dart';
import 'package:markdownnotepad/providers/current_logged_in_user_provider.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class AccountDeleteAccountSection extends StatefulWidget {
  const AccountDeleteAccountSection({
    super.key,
  });

  @override
  State<AccountDeleteAccountSection> createState() =>
      _AccountDeleteAccountSectionState();
}

class _AccountDeleteAccountSectionState
    extends State<AccountDeleteAccountSection> {
  late MDNApiService apiService;
  final NotifyToast notifyToast = NotifyToast();

  @override
  void initState() {
    super.initState();

    apiService = context.read<ApiServiceProvider>().apiService;

    final loggedInUserBox = Hive.box<LoggedInUser>('logged_in_user');
    final loggedInUser = loggedInUserBox.get('logged_in_user');

    if (loggedInUser == null) {
      Modular.to.navigate('/auth/login');
      return;
    }
  }

  void deleteAccount() async {
    try {
      final currentUserProvider = context.read<CurrentLoggedInUserProvider>();

      await apiService.deleteUser(
        "Bearer ${currentUserProvider.currentUser!.accessToken}",
      );

      currentUserProvider.logout();
      Modular.to.navigate('/auth/login');
    } catch (e) {
      // ignore: use_build_context_synchronously
      notifyToast.show(
        context: context,
        child: const ErrorNotifyToast(
          title: "Wystąpił błąd.",
          body: "Nie udało się usunąć konta.",
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 50.0,
      ),
      child: IntrinsicHeight(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Symbols.delete_forever,
                fill: 1,
                size: 28,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Usuń konto",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                "Usuń swoje konto. Uwaga! Operacja jest nieodwracalna.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ButtonStyle(
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
                onPressed: () => deleteAccount(),
                child: Text(
                  "Usuń konto",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
