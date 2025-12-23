import 'package:get/get.dart';
enum Track {income , expense}
class BottomController extends GetxController{
  var trackView = Track.income.obs;
}
