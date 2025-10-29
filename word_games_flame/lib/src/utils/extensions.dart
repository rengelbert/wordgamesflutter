import '../config/app_config.dart';

extension DoubleExtesion on double {
  double get dh =>
      (this * AppConfig.screenHeight) / AppConfig.designSize.height;
  double get dw => (this * AppConfig.screenWidth) / AppConfig.designSize.width;
  /*
  use % values for width and height
  ex. in you layout a container is 25% of the screen height
  The container height should be declared:
  height: 25.0.hp
  */
  double get hp => (AppConfig.screenHeight * (this / 100));
  double get wp => (AppConfig.screenWidth * (this / 100));
  /*
  adjust font size provided, based on screen width
  */
  double get sp => AppConfig.screenWidth / 100 * (this / 3);
}
