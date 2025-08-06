// leaderboard_controller.dart
import 'package:ecomagara/domain/repositories/leaderboard_repository.dart';
import 'package:get/get.dart';

class LeaderboardController extends GetxController {
  final LeaderboardRepository repository;

  LeaderboardController(this.repository);

  var leaderboardUsers = <LeaderboardUser>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onReady() {
    super.onReady();
    fetchLeaderboard(); 
  }

  Future<void> fetchLeaderboard() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final users = await repository.getLeaderboard();

      // debugging: print semua user
      for (var user in users) {
        print('Fetched user: $user');
      }

      leaderboardUsers.assignAll(users);
      print('Total leaderboard users: ${leaderboardUsers.length}');
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching leaderboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getUserPosition(String username) {
    final index = leaderboardUsers.indexWhere((u) => u.username == username);
    if (index >= 0) return (index + 1).toString();
    if (leaderboardUsers.length == 1 &&
        leaderboardUsers[0].username == username)
      return "1";
    return "15+";
  }
}
