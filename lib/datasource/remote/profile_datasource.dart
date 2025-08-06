import 'dart:convert';
import 'package:ecomagara/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class ProfileDatasource {

  final String baseUrl = AppConfig.localUrl;


  Future<void> updateProfilePicture(String newImageUrl) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final authToken = await user.getIdToken();
    final url = Uri.parse('$baseUrl/me/profile-picture');

    final response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({'profilePicture': newImageUrl}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile picture: ${response.body}');
    }
  }

  // Future<UserModel> fetchUser() async {
  //   final url = Uri.parse('$baseUrl/me');

  //   final response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return UserModel.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to fetch user: ${response.body}');
  //   }
  // }
}
