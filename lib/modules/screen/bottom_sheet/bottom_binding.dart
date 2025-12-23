import 'package:get/get.dart';
import 'package:money_traker/modules/screen/bottom_sheet/bottom_controller.dart';

class BottomBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(BottomController());
  }

}