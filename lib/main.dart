import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/datasource/local/unique_fact.dart';
import 'package:ecomagara/datasource/repositories/fact_impl.dart';
import 'package:ecomagara/datasource/services/firebaseAuthServices.dart';
import 'package:ecomagara/domain/repositories/fact_repository.dart';
import 'package:ecomagara/presentation/pages/auth/SignupPage/signUp_controller.dart';
import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:ecomagara/presentation/pages/auth/authPage/auth_page.dart';
import 'package:ecomagara/presentation/pages/auth/loginPage/login_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/checklist_page.dart';
import 'package:ecomagara/presentation/pages/main/mainDisaster/disaster_page.dart';
import 'package:ecomagara/presentation/pages/main/mainDiy/diy_page.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/calendar_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/homepage.dart';
import 'package:ecomagara/presentation/pages/main/mainleaderboard/leaderboard_page.dart';
import 'package:ecomagara/presentation/pages/main/splashscreen/splashcreen_controller.dart';
import 'package:ecomagara/presentation/pages/main/splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // AUTHENTICATION - controller registration
  Get.lazyPut(() => FirebaseAuthService(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => LoginController(), fenix: true);
  Get.lazyPut(() => SignUpController(), fenix: true);

  // SPLASHSCREEN
  Get.lazyPut(() => SplashcreenController(), fenix: true);

  // FACT FEATURE
  Get.lazyPut<FactRepository>(
    () => FactImpl(datasource: UniqueFactLocalDatasource()),
    fenix: true,
  );

  // CALENDAR FEATURE
  Get.lazyPut(() => CalendarController(), fenix: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Splashscreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen),
      ),
    );
  }
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>();
    // Menggunakan Obx untuk mendeteksi perubahan pada user
    // Jika user sudah login, tampilkan MainPage, jika belum tampilkan AuthPage
    return Obx(() {
      if (user.user.value != null) {
        return MainPage();
      } else {
        return AuthPage();
      }
    });
  }
}

class MainPage extends StatelessWidget {
  final RxInt indexHalaman = 0.obs;

  // Available pages in the main navigation
  final List<Widget> halaman = [
    Homepage(), // Homepage where users can see history and current goals
    ChecklistPage(), // Checklist Page where users can track their caarbon footprint by filling out a checklist
    DiyPage(), // DIY Page where users can learn how to reduce their carbon footprint through DIY projects
    DisasterPage(), // Disaster Page where users can learn about disasters and how to prepare for them
    LeaderboardPage(), // Leaderboard Page where users can see their carbon points ranking
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: halaman[indexHalaman.value],
          bottomNavigationBar: Material(
            elevation: 10,
            child: GNav(
              selectedIndex:
                  indexHalaman.value, 
              onTabChange: (index) {
                indexHalaman.value =
                    index; 
              },
              backgroundColor: AppColors.surface,
              gap: 5,
              color: AppColors.navbarIcon,
              activeColor: AppColors.primary,
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 20,
              ),
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.checklist_rounded, text: 'Checklist'),
                GButton(icon: Icons.build, text: 'DIY'),
                GButton(
                  icon: Icons.local_fire_department_rounded,
                  text: 'Disaster',
                ),
                GButton(icon: Icons.emoji_events_rounded, text: 'Leaderboard'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}