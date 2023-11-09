import 'package:flutter/material.dart';
import 'package:gandiv/constants/values/app_colors.dart';
import 'package:gandiv/ui/views/bottombar_views/dashboard_status_page.dart';
import 'package:gandiv/ui/views/dashboard_view/drawer_settings.dart';
import 'package:gandiv/ui/views/news_views/news_type_page.dart';
import 'package:get/get.dart';
import '../../../constants/values/size_config.dart';
import '../../controllers/dashboard_page_cotroller.dart';
import '../../../constants/values/app_images.dart';
import '../bottombar_views/profile_page.dart';
import 'drawer_support.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

typedef MyCallback = void Function();

class DashboardPageState extends State<DashboardPage> {
  DashboardPageController controller = Get.find<DashboardPageController>();

  final List<Widget> _bottomBarWidgets = <Widget>[
    const DashboardStatusPage(),
    //const UploadNewsPage(),
    const NewsTypePage(),
    const ProfilePage()
  ];

  void myCallbackFunction() {
    DashboardStatusStatePage dashboardStatusPage = DashboardStatusStatePage();
    controller.setTabbarIndex(0);
    controller.pageController.value.animateToPage(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

    dashboardStatusPage.refreshPage();
    controller.setTabbarIndex(0);

    // DashboardStatusStatePage dashboardStatusPage =
    //     DashboardStatusStatePage();
    // dashboardStatusPage.refreshPage();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _pageController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: buildAppBar(),
          ),
          drawer: Theme(
            data: controller.isDarkTheme.value == true
                ? Theme.of(context).copyWith(canvasColor: AppColors.dartTheme)
                : Theme.of(context).copyWith(canvasColor: AppColors.white),
            child: Drawer(
              child: Column(
                children: <Widget>[
                  DrawerSettings(
                      context: context, callback: myCallbackFunction),
                  DrawerSupport(context: context),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'app_version'.tr + controller.version.value,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
          // body: Center(
          //   child: Obx(() => _bottomBarWidgets
          //       .elementAt(controller.bottomTabbarIndex.value)),
          // ),
          // bottomNavigationBar: buildBottomNavigationMenu(),
          body: Center(
            child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.pageController.value,
                onPageChanged: (index) {},
                children: _bottomBarWidgets),
          ),
          bottomNavigationBar:
              SizedBox(height: 60, child: buildBottomNavigationMenu()),
        ),
      ),
    );
  }

  buildAppBar() {
    return Obx(
      () => AppBar(
        backgroundColor: controller.isDarkTheme.value == true
            ? AppColors.dartTheme
            : AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Image.asset(
            AppImages.appLogo,
            fit: BoxFit.contain,
            color: controller.isDarkTheme.value == true
                ? AppColors.white
                : AppColors.black,
          ),
        ),
        iconTheme: IconThemeData(
            color: controller.isDarkTheme.value == true
                ? AppColors.white
                : AppColors.black),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Image.asset(
        //       AppImages.search,
        //       fit: BoxFit.contain,
        //       width: 35,
        //       height: 35,
        //       color: controller.isDarkTheme.value == true
        //           ? AppColors.white
        //           : AppColors.black,
        //     ),
        //     onPressed: () {
        //       Get.toNamed(Routes.searchPage);
        //     },
        //   ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 5),
        //   child: Stack(
        //     children: <Widget>[
        //       IconButton(
        //         icon: Image.asset(
        //           AppImages.notification,
        //           fit: BoxFit.contain,
        //           width: 35,
        //           height: 35,
        //           color: controller.isDarkTheme.value == true
        //               ? AppColors.white
        //               : AppColors.black,
        //         ),
        //         onPressed: () {
        //           Get.toNamed(Routes.notificationPage);
        //         },
        //       ),
        //     ],
        //   ),
        // )
        // ],
      ),
    );
  }

  buildBottomNavigationMenu() {
    return Obx(() => BottomNavigationBar(
          selectedFontSize: SizeConfig.bottomBarItemSelectedFontSize,
          unselectedFontSize: SizeConfig.bottomBarItemUnselectedFontSize,
          // selectedIconTheme:
          //     const IconThemeData(color: Colors.amberAccent, size: 40),
          selectedItemColor: Get.isDarkMode ? AppColors.white : AppColors.white,
          selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Get.isDarkMode ? AppColors.white : AppColors.white),
          unselectedIconTheme: IconThemeData(
            color: Get.isDarkMode ? AppColors.white : AppColors.white,
          ),
          unselectedItemColor:
              Get.isDarkMode ? AppColors.white : AppColors.white,
          currentIndex: controller.bottomTabbarIndex.value,
          onTap: onItemTapped,
          backgroundColor: AppColors.dartTheme,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                AppImages.dashboard,
                fit: BoxFit.contain,
                height: 25,
                width: 25,
                color: controller.isDarkTheme.value == true
                    ? AppColors.white
                    : AppColors.white,
              ),
              tooltip: 'dashboard'.tr,
              icon: Image.asset(
                AppImages.dashboard,
                fit: BoxFit.contain,
                height: 25,
                width: 25,
                color: controller.isDarkTheme.value == true
                    ? AppColors.white
                    : AppColors.white,
              ),
              label: 'dashboard'.tr,
            ),
            BottomNavigationBarItem(
              tooltip: 'upload_news'.tr,
              activeIcon: Image.asset(AppImages.uploadIcon,
                  fit: BoxFit.contain,
                  height: 25,
                  width: 25,
                  color: controller.isDarkTheme.value == true
                      ? AppColors.white
                      : AppColors.white),
              icon: Image.asset(AppImages.uploadIcon,
                  fit: BoxFit.contain,
                  height: 25,
                  width: 25,
                  color: controller.isDarkTheme.value == true
                      ? AppColors.white
                      : AppColors.white),
              label: 'upload_news'.tr,
            ),
            BottomNavigationBarItem(
              tooltip: 'profile'.tr,
              activeIcon: Image.asset(AppImages.profile,
                  fit: BoxFit.contain,
                  height: 25,
                  width: 25,
                  color: controller.isDarkTheme.value == true
                      ? AppColors.white
                      : AppColors.white),
              icon: Image.asset(AppImages.profile,
                  fit: BoxFit.contain,
                  height: 25,
                  width: 25,
                  color: controller.isDarkTheme.value == true
                      ? AppColors.white
                      : AppColors.white),
              label: 'profile'.tr,
            ),
          ],
        ));
  }

  //New
  void onItemTapped(int index) {
    controller.setTabbarIndex(index);
    //_pageController ??= PageController();
    controller.pageController.value.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
}
