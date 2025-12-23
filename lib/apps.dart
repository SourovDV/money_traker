import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_traker/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_,child){
        return GetMaterialApp(
          theme: ThemeData(useMaterial3: true),
          debugShowCheckedModeBanner: false,
          initialRoute:AppRoutes.initialRoute,
          getPages:AppRoutes.routes,
        );
      },
    );
  }
}
