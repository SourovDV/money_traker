import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_traker/data/models/data_models.dart';
import 'package:money_traker/modules/screen/home/home_controller.dart';
enum Track {income , expense}
class BottomController extends GetxController{
  var trackView = Track.income.obs;
  HomeController homeController = Get.find<HomeController>();
  TextEditingController incomeController = TextEditingController();
  TextEditingController expenseController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  TextEditingController explainController =TextEditingController();
  final addKey = GlobalKey<FormState>();
  TransactionModel ?editModel;

  @override
  void onInit() {
    super.onInit();
    // 🔥 EDIT MODE CHECK
    if (Get.arguments != null && Get.arguments is TransactionModel) {
      editModel = Get.arguments;
      moneyController.text ="${editModel!.money}";
      explainController.text = editModel!.note;
    }
  }


  String? moneyValidation(value){
    if(value==null ||  value.isEmpty){
      return "This field is required.";
    }
  }
  void submitData(){
    if(addKey.currentState!.validate()){
      saveData();

    }
  }
  Future<void> saveData() async {
    final model = TransactionModel(
      id: editModel?.id, // null হলে insert হবে
      money: int.parse(moneyController.text),
      category: trackView.value == Track.income ? "income" : "expense",
      note: explainController.text,
      date: DateTime.now().toIso8601String(),
    );


    if (editModel != null) {
      debugPrint("id number ${editModel!.id}");
    }

    if (editModel == null) {
      // Add mode
      await homeController.insertTransaction(model);
    } else {
      // Edit mode
      if (editModel!.id != null) {
        await homeController.updateTransaction(model);
      } else {
        print("ERROR: editModel.id is null!");
      }
    }

    Get.back();
    Get.snackbar("Added", "ডাটা সফলভাবে অ্যাড হয়েছে");
  }


  @override
  void dispose() {
    super.dispose();
    incomeController.dispose();
    expenseController.dispose();
    moneyController.dispose();
    expenseController.dispose();
  }

}
