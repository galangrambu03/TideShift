import 'package:ecomagara/datasource/models/userModel.dart';

abstract class ProfileRepository {
  Future<void> updateProfilePicture(String newImageUrl);
  // Future<UserModel> fetchUser();
}
