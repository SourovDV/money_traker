import 'package:get/get.dart';
import 'package:money_traker/routes/app_pages.dart';
enum Calender { all, income,expense,report}
class HomeController extends GetxController{
   final double part1Height = 70;
   final double part2Height = 170;
   var calenderView = Calender.all.obs;

   void addItems(){
     Get.toNamed(AppPages.bottomSheetView);
   }

}