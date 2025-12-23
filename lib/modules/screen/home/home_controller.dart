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

  @override
  void onInit() {
    super.onInit();
    loadTransaction();
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
