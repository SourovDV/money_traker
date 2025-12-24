import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_traker/data/models/data_models.dart';
import 'package:money_traker/modules/helper/db_helper/db_helper.dart';
import 'package:money_traker/routes/app_pages.dart';

enum Calender { all, income, expense, report }
enum ReportRange { sevenDays, thirtyDays }


class HomeController extends GetxController {
  final double part1Height = 70;
  final double part2Height = 190;
  var calenderView = Calender.all.obs;
  RxList<TransactionModel> transaction = <TransactionModel>[].obs;
  RxBool getLoading = false.obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  RxInt balance = 0.obs;
  RxList<TransactionModel> filteredTransaction = <TransactionModel>[].obs;
  Rx<ReportRange> reportRange = ReportRange.sevenDays.obs;


  @override
  void onInit() {
    super.onInit();
    loadTransaction();
  }

  //get date for graph
  List<TransactionModel> getLast7Days() {
    final now = DateTime.now();
    return transaction.where((item) {
      final itemDate = DateTime.parse(item.date);
      return itemDate.isAfter(now.subtract(const Duration(days: 7)));
    }).toList();
  }

  List<TransactionModel> getLast30Days() {
    final now = DateTime.now();
    return transaction.where((item) {
      final itemDate = DateTime.parse(item.date);
      return itemDate.isAfter(now.subtract(const Duration(days: 30)));
    }).toList();
  }

  // 🔹 GRAPH maxY calculation
  double getMaxValue(Map<String, int> summary) {
    final max = [
      summary["income"] ?? 0,
      summary["expense"] ?? 0,
      (summary["balance"] ?? 0).abs(),
    ].reduce((a, b) => a > b ? a : b);

    return max == 0 ? 100 : max * 1.2;
  }

  // 🔹 Y Axis number format
  String formatYAxis(double value) {
    if (value >= 1000000000) {
      return "${(value / 1000000000).toStringAsFixed(1)}B";
    } else if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    } else {
      return value.toInt().toString();
    }
  }


  List<TransactionModel> getReportData() {
    if (reportRange.value == ReportRange.sevenDays) {
      return getLast7Days();
    } else {
      return getLast30Days();
    }
  }


  void applyFilter() {
    if (calenderView.value == Calender.all) {
      filteredTransaction.assignAll(transaction);
    } else if (calenderView.value == Calender.income) {
      filteredTransaction.assignAll(
        transaction.where((e) => e.category == "income").toList(),
      );
    } else if (calenderView.value == Calender.expense) {
      filteredTransaction.assignAll(
        transaction.where((e) => e.category == "expense").toList(),
      );
    }
  }

  void confirmDelete(int id) {
    if (Get.isSnackbarOpen) return;
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("আপনি কি নিশ্চিতভাবে এই ডাটা ডিলিট করতে চান?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // dialog close
            },
            child: const Text("No"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await deleteTransaction(id);
              Get.back(); // dialog close
              Get.snackbar("Deleted", "ডাটা সফলভাবে ডিলিট হয়েছে");
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  String formatDate(String isoDate) {
    final dateTime = DateTime.parse(isoDate);
    return DateFormat("dd MMM yyyy").format(dateTime);
  }

  Map<String, int> calculateSummary(List<TransactionModel> list) {
    int income = 0;
    int expense = 0;

    for (var item in list) {
      if (item.category == "income") {
        income += item.money;
      } else {
        expense += item.money;
      }
    }

    return {"income": income, "expense": expense, "balance": income - expense};
  }

  void calculateTotal() {
    int income = 0;
    int expense = 0;
    for (var item in transaction) {
      if (item.category == "income") {
        income = income + item.money;
      }
      if (item.category == "expense") {
        expense = expense + item.money;
      }
    }
    totalIncome.value = income;
    totalExpense.value = expense;
    balance.value = income - expense;
  }

  Future<void> loadTransaction() async {
    try {
      getLoading.value = true;
      final data = await DbHelper.getAllTransaction();
      transaction.assignAll(data);
      calculateTotal();
      applyFilter();
    } catch (e) {
      print("DB Error: $e");
    } finally {
      getLoading.value = false;
    }
  }

  Future<void> insertTransaction(TransactionModel model) async {
    await DbHelper.insertTransaction(model);
    loadTransaction();
  }

  Future<void> deleteTransaction(int id) async {
    await DbHelper.deleteTransaction(id);
    loadTransaction();
  }

  Future<void> updateTransaction(TransactionModel model) async {
    await DbHelper.updateTransaction(model);
    await loadTransaction();
  }

  void editPage(TransactionModel model) {
    Get.toNamed(AppPages.bottomSheetView, arguments: model);
  }

  void addItems() {
    Get.toNamed(AppPages.bottomSheetView);
  }
  Color getMoneyColor(int money) {
    if (money < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
