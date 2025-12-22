import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_traker/core/utils/appColor/app_color.dart';
import 'package:money_traker/modules/screen/home/home_controller.dart';
import 'package:money_traker/modules/widgets/money_item.dart';

import '../bottom_sheet/bottom_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height:controller.part1Height + (controller.part2Height / 1.2),
              decoration:  BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor,
                    AppColors.onPrimaryColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _partOne(),
                  _partTwo(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BottomSheetView(),

    );
  }
  Container _partTwo() {
    return Container(
                  height: controller.part2Height,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blackColor.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: const [

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          MoneyItem(
                            title: "মোট আয়",
                            amount: "৳ ২৫,০০০",
                            color: Colors.green,
                          ),
                          MoneyItem(
                            title: "মোট ব্যয়",
                            amount: "৳ ১৫,০০০",
                            color: Colors.red,
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      Divider(),
                      SizedBox(height: 12),

                      Text(
                        "৳ ১০,০০০",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
  }
  SizedBox _partOne() {
    return SizedBox(
                  height: controller.part1Height,
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.monetization_on,
                              color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            "টাকার হিসাব",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Icon(Icons.notifications_none),
                          SizedBox(width: 8),
                          Icon(Icons.settings),
                        ],
                      )
                    ],
                  ),
                );
  }
}


