import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'leaderboard_controller.dart';

class LeaderboardPage extends StatefulWidget {
  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final Color orangeBox = const Color(0xFFFF7F3F);

  final TextStyle labelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  final Color colorRank4 = const Color(0xFFFDF0C2);

  final Color colorRank5 = const Color(0xFFD2ECFF);

  final Color colorRank6 = const Color(0xFFC7F1D4);

  final Color colorRank7AndBelow = AppColors.background;

  final UserController userController = Get.find();

  final LeaderboardController leaderboardController = Get.find();

  @override
  void initState() {
    super.initState();
    leaderboardController.fetchLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (leaderboardController.isLoading.value) {
          return Center(
            child: LoadingAnimationWidget.progressiveDots(
              color: AppColors.primary,
              size: 30,
            ),
          );
        }

        if (leaderboardController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              leaderboardController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final leaderboard = leaderboardController.leaderboardUsers;
        final userData = userController.userData.value;

        return Column(
          children: [
            // header leaderboard
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 15, bottom: 30),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _podiumUser(
                        leaderboard.length > 2 ? leaderboard[2].username : "-",
                        leaderboard.length > 2 ? leaderboard[2].points : 0,
                        leaderboard.length > 2
                            ? leaderboard[2].profilePicture
                            : null,
                        "3rd",
                        const Color(0xFF9EC5F6),
                        80,
                        70,
                      ),
                      _podiumUser(
                        leaderboard.length > 1 ? leaderboard[1].username : "-",
                        leaderboard.length > 1 ? leaderboard[1].points : 0,
                        leaderboard.length > 1
                            ? leaderboard[1].profilePicture
                            : null,
                        "2nd",
                        const Color(0xFF69D097),
                        100,
                        80,
                      ),
                      _podiumUser(
                        leaderboard.isNotEmpty ? leaderboard[0].username : "-",
                        leaderboard.isNotEmpty ? leaderboard[0].points : 0,
                        leaderboard.isNotEmpty
                            ? leaderboard[0].profilePicture
                            : null,
                        "1st",
                        const Color(0xFFF2D279),
                        120,
                        90,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // user info (you)
            if (userData != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20,
                ),
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7F3F), Color(0xFFFF9F6F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.background,
                            backgroundImage: AssetImage(
                              'assets/images/profilePictures/${userData.profilePicture}',
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "You",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Eco Points :",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.yellow,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                userData.points.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Position :",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            leaderboardController.getUserPosition(
                              userData.username,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                ),
              ),

            // rank list dynamic
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: leaderboard.length > 3 ? leaderboard.length - 3 : 0,
                itemBuilder: (context, index) {
                  final item = leaderboard[index + 3];
                  final int rank = index + 4;
                  final Color tileColor = _getTileColor(rank);

                  return _rankItem(
                    rank.toString().padLeft(2, '0'),
                    item.username,
                    item.points,
                    tileColor,
                    item.profilePicture,
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _podiumUser(
    String username,
    int points,
    String? profilePicture,
    String rank,
    Color boxColor,
    double height,
    double width,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.black,
          backgroundImage:
              profilePicture != null
                  ? AssetImage('assets/images/profilePictures/$profilePicture')
                  : null,
          child:
              profilePicture == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
        ),
        const SizedBox(height: 6),
        Text(username, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          "$points pts",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(rank, style: labelStyle),
        ),
      ],
    );
  }

  Widget _rankItem(
    String number,
    String username,
    int points,
    Color bgColor,
    String? profilePicture,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Text(number, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            backgroundImage:
                profilePicture != null
                    ? AssetImage(
                      'assets/images/profilePictures/$profilePicture',
                    )
                    : null,
            child:
                profilePicture == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 4),
          Text(
            "$points pts",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Color _getTileColor(int rank) {
    if (rank == 4) return colorRank4;
    if (rank == 5) return colorRank5;
    if (rank == 6) return colorRank6;
    return colorRank7AndBelow;
  }
}
