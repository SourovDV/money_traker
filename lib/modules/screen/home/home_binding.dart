import 'package:get/get.dart';
import 'package:money_traker/modules/screen/home/home_controller.dart';

class HomeBindings extends Bindings{
  @override
  void dependencies() {
    Get.put(HomeController());
  }

}