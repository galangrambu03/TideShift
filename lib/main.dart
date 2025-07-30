import 'package:ecomagara/config/colors.dart';
import 'package:ecomagara/config/config.dart';
import 'package:ecomagara/datasource/local/carbonUnit.dart';
import 'package:ecomagara/datasource/local/unique_fact.dart';
import 'package:ecomagara/datasource/remote/dailyCarbonLog_remote.dart';
import 'package:ecomagara/datasource/remote/user_remote.dart';
import 'package:ecomagara/datasource/repositories/carbonLog_impl.dart';
import 'package:ecomagara/datasource/repositories/carbonUnit_impl.dart';
import 'package:ecomagara/datasource/repositories/fact_impl.dart';
import 'package:ecomagara/datasource/repositories/user_impl.dart';
import 'package:ecomagara/datasource/services/firebaseAuthServices.dart';
import 'package:ecomagara/domain/repositories/dailyCarbonLog_repository.dart';
import 'package:ecomagara/domain/repositories/fact_repository.dart';
import 'package:ecomagara/domain/repositories/user_repostitory.dart';
import 'package:ecomagara/presentation/pages/auth/SignupPage/signUp_controller.dart';
import 'package:ecomagara/presentation/pages/auth/authController.dart';
import 'package:ecomagara/presentation/pages/auth/authPage/auth_page.dart';
import 'package:ecomagara/presentation/pages/auth/loginPage/login_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/carbonUnit_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/checklist_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainChecklist/checklist_page.dart';
import 'package:ecomagara/presentation/pages/main/mainDisaster/disaster_page.dart';
import 'package:ecomagara/presentation/pages/main/mainDiy/diy_page.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/calendar_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/carbonLog_controller.dart';
import 'package:ecomagara/presentation/pages/main/mainHome/homepage.dart';
import 'package:ecomagara/presentation/pages/main/mainleaderboard/leaderboard_page.dart';
import 'package:ecomagara/presentation/pages/main/splashscreen/splashcreen_controller.dart';
import 'package:ecomagara/presentation/pages/main/splashscreen/splashscreen.dart';
import 'package:ecomagara/user_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // REPOSITORIES
  Get.lazyPut<FactRepository>(
    () => FactImpl(datasource: UniqueFactLocalDatasource()),
    fenix: true,
  );
  Get.lazyPut<UserRepository>(
    () => UserRepositoryImpl(datasource: UserDatasource()),
    fenix: true,
  );
  Get.lazyPut<DailyCarbonLogRepository>(
    () => DailyCarbonLogRepositoryImpl(
      remoteDataSource: DailyCarbonLogRemoteDataSource(),
    ),
    fenix: true,
  );

  // CONTROLLERS
  Get.lazyPut(() => FirebaseAuthService(), fenix: true);
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.put(LoginController(), permanent: true);
  Get.put(SignUpController(), permanent: true);
  Get.put<DailyCarbonLogController>(
    DailyCarbonLogController(repository: Get.find<DailyCarbonLogRepository>()),
    permanent: true,
  );

  Get.lazyPut(() => UserController(), fenix: true);
  Get.lazyPut(() => SplashcreenController(), fenix: true);
  Get.lazyPut(() => CalendarController(), fenix: true);
  Get.put(NavigationController(), permanent: true);
  Get.lazyPut(() => ChecklistController(), fenix: true);
  Get.lazyPut(
    () => CarbonUnitController(
      repository: CarbonUnitRepositoryImpl(
        dataSource: CarbonUnitLocalDataSource(),
      ),
    ),
    fenix: true,
  );
  
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

// MAIN SCREEN
// : Screen that show either main navigation page or auth page
class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<AuthController>();
    // if user already logged in show main page else show auth page
    return Obx(() {
      if (user.user.value != null && user.isSync.value == true) {
        return MainPage();
      } else {
        return AuthPage();
      }
    });
  }
}

// MAIN NAVIGATION PAGE
// Controller
class NavigationController extends GetxController {
  var indexHalaman = 0.obs;

  void ubahHalaman(int index) {
    indexHalaman.value = index;
  }
}

// View
class MainPage extends StatelessWidget {
  final NavigationController navC = Get.find<NavigationController>();

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
          body: halaman[navC.indexHalaman.value],
          bottomNavigationBar: Material(
            elevation: 10,
            child: GNav(
              selectedIndex: navC.indexHalaman.value,
              onTabChange: (index) {
                navC.indexHalaman.value = index;
              },
              backgroundColor: AppColors.surface,
              gap: 5,
              color: AppColors.navbarIcon,
              activeColor: AppColors.primary,
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 13,
                bottom: 15,
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
