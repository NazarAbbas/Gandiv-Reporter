import 'package:gandiv/route_management/routes.dart';
import 'package:gandiv/ui/binding/screen_binding.dart';
import 'package:gandiv/ui/views/account/change_password_page.dart';
import 'package:gandiv/ui/views/account/edit_profile_page.dart';
import 'package:gandiv/ui/views/account/forgot_password_page.dart';
import 'package:gandiv/ui/views/account/signup_page.dart';
import 'package:gandiv/ui/views/bottombar_views/upload_news_page.dart';
import 'package:gandiv/ui/views/dashboard_view/about_us_page.dart';
import 'package:gandiv/ui/views/news_views/news_list_status_page.dart';
import 'package:gandiv/ui/views/bottombar_views/profile_page.dart';
import 'package:gandiv/ui/views/dashboard_view/dashboard_page.dart';
import 'package:gandiv/ui/views/bottombar_views/dashboard_status_page.dart';
import 'package:gandiv/ui/views/news_views/news_detail_page.dart';
import 'package:gandiv/ui/views/news_views/news_type_page.dart';
import 'package:gandiv/ui/views/news_views/video_player_page.dart';
import 'package:gandiv/ui/views/search_page.dart';
import 'package:gandiv/ui/views/splash_page.dart';
import 'package:get/route_manager.dart';
import '../ui/views/account/login_page.dart';
import '../ui/views/news_views/audio_player_page.dart';

class AllPages {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: Routes.dashboardScreen,
        page: () => const DashboardPage(),
        binding: ScreenBindings(),
      ),
      GetPage(
          name: Routes.loginScreen,
          page: () => LoginPage(),
          binding: ScreenBindings(),
          transition: Transition.cupertino),
      GetPage(
        name: Routes.searchPage,
        page: () => const SearchPage(),
        binding: ScreenBindings(),
      ),
      GetPage(
          name: Routes.splashPage,
          page: () => const SplashPage(),
          binding: ScreenBindings()),
      GetPage(
          name: Routes.newsDetailPage,
          page: () => const NewsDetailPage(),
          binding: ScreenBindings(),
          transition: Transition.zoom),
      GetPage(
          name: Routes.signupPage,
          page: () => SignupPage(),
          binding: ScreenBindings(),
          transition: Transition.cupertino),
      GetPage(
        name: Routes.profilePage,
        page: () => const ProfilePage(),
        binding: ScreenBindings(),
      ),
      GetPage(
          name: Routes.editProfilePage,
          page: () => EditProfilePage(),
          binding: ScreenBindings(),
          transition: Transition.zoom),
      GetPage(
        name: Routes.uploadNewsPage,
        page: () => const UploadNewsPage(),
        binding: ScreenBindings(),
      ),
      GetPage(
          name: Routes.forgotPasswordPage,
          page: () => ForgotPasswordPage(),
          binding: ScreenBindings(),
          transition: Transition.cupertino),
      GetPage(
          name: Routes.changePasswordPage,
          page: () => ChangePassswordPage(),
          binding: ScreenBindings(),
          transition: Transition.zoom),
      GetPage(
        name: Routes.videoPlayerPage,
        page: () => const VideoPlayerPage(),
        binding: ScreenBindings(),
      ),
      GetPage(
        name: Routes.audioPlayerPage,
        page: () => const AudioPlayerPage(),
        binding: ScreenBindings(),
      ),
      GetPage(
          name: Routes.dashboardStatusPage,
          page: () => const DashboardStatusPage(),
          binding: ScreenBindings(),
          transition: Transition.cupertino),
      GetPage(
        name: Routes.locationPage,
        page: () => const NewsListStatusPage(),
        binding: ScreenBindings(),
      ),
      GetPage(
        name: Routes.aboutUsPage,
        page: () => AboutUsPage(),
        binding: ScreenBindings(),
      ),
      GetPage(
        name: Routes.newsType,
        page: () => const NewsTypePage(),
        binding: ScreenBindings(),
      )
    ];
  }
}
