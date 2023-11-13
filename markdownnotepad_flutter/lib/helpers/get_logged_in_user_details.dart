import 'package:markdownnotepad/models/user.dart';
import 'package:markdownnotepad/services/mdn_api_service.dart';
import 'package:markdownnotepad/viewmodels/logged_in_user.dart';

Future<LoggedInUser> getLoggedInUserDetails(
    MDNApiService apiService, String authorization) async {
  final userMe = await apiService.getMe(
    authorization,
  );
  final notes = await apiService.getNotes(
    authorization,
  );
  final tags = await apiService.getNoteTags(
    authorization,
  );
  final catalogs = await apiService.getCatalogs(
    authorization,
  );

  return LoggedInUser(
    user: User(
      id: userMe?.id ?? "",
      username: userMe?.username ?? "",
      email: userMe?.email ?? "",
      bio: userMe?.bio ?? "",
      name: userMe?.name ?? "",
      surname: userMe?.surname ?? "",
      createdAt: (userMe?.createdAt ?? DateTime.now()).toString(),
      updatedAt: (userMe?.updatedAt ?? DateTime.now()).toString(),
      notes: notes?.notes ?? [],
      catalogs: catalogs?.catalogs ?? [],
      tags: tags?.noteTags ?? [],
    ),
    accessToken: authorization.replaceAll("Bearer ", ""),
    timeOfLogin: DateTime.now(),
    tokenExpiration: DateTime.now().add(
      const Duration(
        days: 7,
      ),
    ),
  );
}
