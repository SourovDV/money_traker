import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_traker/modules/screen/bottom_sheet/bottom_controller.dart';

class BottomSheetView extends GetView<BottomController> {
  const BottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(

          title: Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
            child: Text("যোগ করুন",style: TextStyle(fontSize: 20),),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 10.h,),
              Obx((){
                return SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<Track>(segments: [
                    ButtonSegment(value:Track.income , label: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Income"),
                    )),
                    ButtonSegment(value: Track.expense,label: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Expense"),
                    ))
                  ], selected:{controller.trackView.value},
                    // showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                      )
                    ),
                  onSelectionChanged: (value){
                    controller.trackView.value = value.first;
                  },
                  ),
                );
              }),
              Form(
                  key: controller.addKey,
                  child: Column(
                children: [
                  SizedBox(height: 20.h,),
                  TextFormField(
                    keyboardType:TextInputType.number,
                    decoration:InputDecoration(
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                      labelText: "টাকার পরিমান ",

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)
                      ),
                    ),
                    controller: controller.moneyController,
                    validator: controller.moneyValidation,
                    autovalidateMode:AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 15.h,),
                  TextFormField(
                    decoration:InputDecoration(
                        prefixIcon: Icon(Icons.description_outlined),
                        labelText: "বিবরন",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                    maxLength: 30,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: controller.explainController,
                    validator: controller.moneyValidation,
                  ),
                  SizedBox(height: 15.h,),
                  InkWell(
                    onTap: controller.submitData,
                    child: Container(
                      height: 53,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Center(child: Text("অ্যাড",style: TextStyle(fontSize: 18,color: Colors.black),),),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
