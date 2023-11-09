import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:gandiv/ui/controllers/splash_page_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';
import '../../constants/constant.dart';
import '../../constants/emuns.dart';
import '../../constants/values/app_images.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController videoPlayerController =
      VideoPlayerController.asset("videos/splash_video.mp4");
  bool looping = false;
  late ChewieController _chewieController;

  String dropdownvalue = 'Please select location';
  @override
  void initState() {
    super.initState();
    final languageId = GetStorage().read(Constant.selectedLanguage);
    if (languageId == Language.english) {
      GetStorage().write(Constant.selectedLanguage, Language.english);
    } else {
      GetStorage().write(Constant.selectedLanguage, Language.hindi);
    }
    GetStorage().write(Constant.selectedLocation, 'Varanasi');
    Get.find<SplashPageController>();
    // _chewieController = ChewieController(
    //   videoPlayerController: videoPlayerController,
    //   aspectRatio: 16 / 9,
    //   autoInitialize: true,
    //   looping: looping,
    //   errorBuilder: (context, errorMessage) {
    //     return Center(
    //       child: Text(
    //         errorMessage,
    //         style: TextStyle(color: Colors.white),
    //       ),
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      width: double.infinity,
      height: double.infinity,
      AppImages.splash,
      fit: BoxFit.cover,
    );
    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Chewie(
    //     controller: _chewieController,
    //   ),
    // );
  }
}
