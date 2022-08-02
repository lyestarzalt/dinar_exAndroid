import 'package:get/get.dart';
import 'package:dinar_ex/theme/controller/theme_controller.dart';

class SettignsController extends GetxController {
  final ThemeController _themeController = Get.find<ThemeController>();

  Rx<String> currentModeName = ''.obs;

  RxBool isDarkMode = false.obs; // Current Theme Stage

  // Change Theme  Method That will call From HomeView
  void changeAppTheme() => _changeTheme();

  // Toggleing the Theme
  bool toggleTheme() {
    _changeTheme();
    return isDarkMode.value;
  }

  // Changeing Vale for Animation

  // Calling the changeTheme Method from ThemeController
  void _changeTheme() {
    _themeController.changeTheme(
      isDarkMode: isDarkMode,
      modeName: currentModeName,
    );
  }


  //

  @override
  void onInit() {
    isDarkMode.value = _themeController.isDarkTheme;
    currentModeName.value = _themeController.isDarkTheme ? 'Dark' : 'Light';

    super.onInit();
  }
}
