import 'package:get/get.dart';
import 'package:money_traker/modules/screen/home/home_binding.dart';
import 'package:money_traker/modules/screen/home/home_view.dart';
import 'package:money_traker/routes/app_pages.dart';

class AppRoutes{
  static final String initialRoute= AppPages.home;

  static final List<GetPage> routes = [
    GetPage(name:AppPages.home, page:()=>HomeView(),binding: HomeBindings())
  ];
}