import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_traker/data/models/data_models.dart';
import 'package:money_traker/modules/helper/db_helper/db_helper.dart';
import 'package:money_traker/routes/app_pages.dart';

enum Calender { all, income, expense, report }

class HomeController extends GetxController {
  final double part1Height = 70;
  final double part2Height = 170;
  var calenderView = Calender.all.obs;
  RxList<TransactionModel> transaction = <TransactionModel>[].obs;
  RxBool getLoading = false.obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  RxInt balance = 0.obs;
  RxList<TransactionModel> filteredTransaction = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTransaction();
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
}
