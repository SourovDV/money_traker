import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_traker/core/utils/appColor/app_color.dart';
import 'package:money_traker/modules/screen/home/home_controller.dart';
import 'package:money_traker/modules/widgets/money_item.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FB),
      body: SafeArea(
        child: Stack(
          children: [
            buildContainer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _partOne(),
                  Obx(() {
                    return _partTwo();
                  }),
                  SizedBox(height: 10.h),
                  _buildObx(),
                  SizedBox(height: 15.h,),
                  Expanded(
                    child: Obx(() {
                      if (controller.calenderView.value == Calender.report) {
                        return SingleChildScrollView(child: _buildReportView());
                      }
                      if (controller.getLoading.value) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (controller.filteredTransaction.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset(
                                "assets/lottie/empty.json",
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                controller.calenderView.value == Calender.income
                                    ? "কোনো আয় পাওয়া যায়নি"
                                    : controller.calenderView.value == Calender.expense
                                    ? "কোনো ব্যয় পাওয়া যায়নি"
                                    : "কোনো ডাটা পাওয়া যায়নি",
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: controller.filteredTransaction.length,
                        itemBuilder: (context, index) {
                          final item = controller.filteredTransaction[index];
                          final bool isIncome = item.category == "income";
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Divider(
                                      color: Colors.grey, thickness: 1)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(controller.formatDate(item.date)),
                                  ),
                                  Expanded(child: Divider(
                                      color: Colors.grey, thickness: 1)),
                                ],
                              ),

                              Card(
                                color: isIncome
                                    ? AppColors.incomeColor
                                    : AppColors.expenseColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            item.category,
                                          ),
                                          Text(item.note),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "৳ ${item.money}",
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (value) {
                                              if (value == "delete" && item.id != null) {
                                                controller.confirmDelete(item.id!);
                                              }
                                              if(value =="edit"){
                                                controller.editPage(item);
                                              }
                                            },
                                            itemBuilder: (_) =>
                                            [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      endDrawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.addItems();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildReportView() {
    final data = controller.getLast7Days();
    final summary = controller.calculateSummary(data);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Last 7 Days Report",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),

          Text("মোট আয়: ৳ ${summary["income"]}"),
          Text("মোট ব্যয়: ৳ ${summary["expense"]}"),
          Text("ব্যালেন্স: ৳ ${summary["balance"]}"),

          SizedBox(height: 60),
         _buildBarChart(summary),
        ],
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> summary) {
    final maxY = controller.getMaxValue(summary);

    return SizedBox(
      height: 260,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,

          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: summary["income"]!.toDouble(),
                  color: Colors.green,
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: summary["expense"]!.toDouble(),
                  color: Colors.red,
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: summary["balance"]!.abs().toDouble(),
                  color: Colors.blue,
                  width: 20,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ],

          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return const Text("Income");
                    case 1:
                      return const Text("Expense");
                    case 2:
                      return const Text("Balance");
                  }
                  return const SizedBox();
                },
              ),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40, // 🔥 overlap fix
                interval: maxY / 4, // 🔥 only 4 labels
                getTitlesWidget: (value, meta) {
                  return Text(
                    controller.formatYAxis(value),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),

            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),

          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Obx _buildObx() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        child: SegmentedButton<Calender>(
          segments: [
            ButtonSegment(value: Calender.all, label: Text("All")),
            ButtonSegment(value: Calender.income, label: Text("Income")),
            ButtonSegment(value: Calender.expense, label: Text("Expense")),
            ButtonSegment(value: Calender.report, label: Text("Report")),
          ],
          selected: {controller.calenderView.value},
          onSelectionChanged: (value) {
            controller.calenderView.value = value.first;
            controller.applyFilter();
          },
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      );
    });
  }

  Container buildContainer() {
    return Container(
      height: controller.part1Height + (controller.part2Height / 1.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryColor, AppColors.onPrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
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
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoneyItem(
                title: "মোট আয়",
                amount: "৳ ${controller.totalIncome}",
                color: Colors.green,
              ),
              MoneyItem(
                title: "মোট ব্যয়",
                amount: "৳ ${controller.totalExpense}",
                color: Colors.red,
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Column(
            children: [
              Text("ব্যালেন্স"),
              Text("৳ ${controller.balance}",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold,color: controller.getMoneyColor(controller.balance.value)),
              ),
            ],
          )
        ],
      ),
    );
  }

  SizedBox _partOne() {
    return SizedBox(
      height: controller.part1Height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Drawer open button

              SizedBox(width: 8.w),
              Icon(Icons.monetization_on, color: Colors.green),
              SizedBox(width: 8.w),
              Text(
                "টাকার হিসাব",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: Colors.blueGrey),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

}

Drawer _buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
          ),
          child: Text(
            'টাকার হিসাব',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        ListTile(
          leading: Icon(Icons.picture_as_pdf),
          title: Text('Income Expense pdf'),
          onTap: () {
            // Notifications page action
          },
        ),
        ListTile(
          leading: Icon(Icons.star),
          title: Text('Rating Us'),
          onTap: () {
            // Settings page action
          },
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Share App'),
          onTap: () {
            // Logout action
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined),
          title: Text('Privacy Policy'),
          onTap: () {
            // Logout action
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text("App Version",style: TextStyle(fontSize: 18),),
        ),
        ListTile(
          leading: Icon(Icons.developer_board_sharp),
          title: Text('App Developer'),
          onTap: () {
            // Logout action
          },
        ),
        ListTile(
          leading: Icon(Icons.diversity_1_outlined),
          title: Text('Version'),
          onTap: () {
            // Logout action
          },
        ),
      ],
    ),
  );
}
