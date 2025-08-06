import 'package:ecomagara/datasource/remote/profile_datasource.dart';
import 'package:ecomagara/domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl({required this.datasource});

  @override
  Future<void> updateProfilePicture(String newImageUrl) {
    return datasource.updateProfilePicture(newImageUrl);
  }

  @override
  Future<void> updateCurrentIslandTheme(int newIslandThemeId) {
    return datasource.updateCurrentIslandTheme(newIslandThemeId);
  }

  // @override
  // Future<UserModel> fetchUser() {
  //   return datasource.fetchUser();
  // }
}
