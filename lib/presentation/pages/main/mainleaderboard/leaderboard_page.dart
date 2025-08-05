import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LeaderboardPage extends StatelessWidget {
  final Color orangeBox = const Color(0xFFFF7F3F);
  final TextStyle labelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  final List<Map<String, dynamic>> leaderboard = [
    {"rank": 1, "username": "User 1"},
    {"rank": 2, "username": "User 2"},
    {"rank": 3, "username": "User 3"},
    {"rank": 4, "username": "User 4"},
    {"rank": 5, "username": "User 5"},
    {"rank": 6, "username": "User 6"},
    {"rank": 7, "username": "User 7"},
    {"rank": 8, "username": "User 8"},
    {"rank": 9, "username": "User 9"},
  ];

  // warna default untuk masing-masing posisi
  final Color colorRank4 = const Color(0xFFFDF0C2);
  final Color colorRank5 = const Color(0xFFD2ECFF);
  final Color colorRank6 = const Color(0xFFC7F1D4);
  final Color colorRank7AndBelow = AppColors.background;

  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          // Top Gradient and Podium
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
                    _podiumUser("3rd", const Color(0xFF9EC5F6), 80, 70),
                    _podiumUser("2nd", const Color(0xFF69D097), 100, 80),
                    _podiumUser("1st", const Color(0xFFF2D279), 120, 90),
                  ],
                ),
              ],
            ),
          ),

          // User info (You)
          // User info (You)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF7F3F), Color(0xFFFF9F6F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // avatar & name
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.background,
                          backgroundImage: AssetImage(
                            'assets/images/profilePictures/${userController.userData.value!.profilePicture}',
                          ),
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

                  // eco points
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
                          Obx(
                            () => Text(
                              userController.userData.value!.points.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // position
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Position :",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "999+",
                        style: TextStyle(
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

          // Rank List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount:
                  leaderboard
                      .where((item) => item["rank"] > 3)
                      .length, // hanya rank > 3
              itemBuilder: (context, index) {
                final filteredLeaderboard =
                    leaderboard.where((item) => item["rank"] > 3).toList();
                final item = filteredLeaderboard[index];
                final int rank = item["rank"];
                final Color tileColor = _getTileColor(rank);

                return _rankItem(
                  rank.toString().padLeft(2, '0'),
                  item["username"],
                  tileColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _podiumUser(String rank, Color boxColor, double height, double width) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundColor: Colors.black,
          child: Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(height: 10),
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

  Widget _rankItem(String number, String username, Color bgColor) {
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
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: Icon(Icons.person, color: Colors.white, size: 20),
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
          const Text("XXX pts", style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Color _getTileColor(int rank) {
    if (rank == 4) return colorRank4;
    if (rank == 5) return colorRank5;
    if (rank == 6) return colorRank6;
    return colorRank7AndBelow; // untuk 7 ke bawah
  }
}
