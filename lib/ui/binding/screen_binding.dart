import 'package:gandiv/ui/controllers/dashboard_page_cotroller.dart';
import 'package:gandiv/ui/controllers/dashboard_status_page_controller.dart';
import 'package:gandiv/ui/controllers/forgot_password_page_controller.dart';
import 'package:gandiv/ui/controllers/news_details_page_controller.dart';
import 'package:gandiv/ui/controllers/news_type_page_controller.dart';
import 'package:gandiv/ui/controllers/profile_page_controller.dart';
import 'package:gandiv/ui/controllers/splash_page_controller.dart';
import 'package:gandiv/ui/controllers/upload_news_page_controller.dart';
import 'package:get/instance_manager.dart';
import '../controllers/about_us_page_controller.dart';
import '../controllers/audio_player_page_controller.dart';
import '../controllers/change_password_page_cotroller.dart';
import '../controllers/edit_profile_page_controller.dart';
import '../controllers/news_list_status_page_controller.dart';
import '../controllers/login_page_cotroller.dart';
import '../controllers/search_page_controller.dart';
import '../controllers/signup_page_cotroller.dart';
import '../controllers/video_player_page_controller.dart';

class ScreenBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardPageController());
    Get.lazyPut(() => LoginPageController());
    Get.lazyPut(() => SearchPageController());
    Get.lazyPut(() => AboutUsPageController());
    Get.lazyPut(() => SignupPageController());
    Get.lazyPut(() => ProfilePageController());
    Get.lazyPut(() => EditProfilePageController());
    Get.lazyPut(() => UploadNewsPagePageController());
    Get.lazyPut(() => NewsListStatusPageController());
    Get.lazyPut(() => SplashPageController());
    Get.lazyPut(() => ForgotPasswordPageController());
    Get.lazyPut(() => DashboardStatusPageController());
    Get.lazyPut(() => ChangePasswordPageController());
    Get.lazyPut(() => VideoPlayerPageController());
    Get.lazyPut(() => AudioPlayerPageController());
    Get.lazyPut(() => NewsListStatusPageController());
    Get.lazyPut(() => NewsTypePageController());
    Get.lazyPut<NewsDetailsPageController>(() => NewsDetailsPageController(),
        fenix: false);
  }
}
