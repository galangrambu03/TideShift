import 'package:ecomagara/datasource/models/userModel.dart';

abstract class ProfileRepository {
  Future<void> updateProfilePicture(String newImageUrl);
  Future<void> updateCurrentIslandTheme(int newTheme);
  // Future<UserModel> fetchUser();
}
