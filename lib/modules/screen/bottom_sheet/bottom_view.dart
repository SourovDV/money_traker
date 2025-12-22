import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomSheetView extends StatelessWidget {
  const BottomSheetView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Get.bottomSheet(
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "নতুন এন্ট্রি যোগ করুন",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
          isScrollControlled: true, // Keyboard আসলে expand হবে
          backgroundColor: Colors.transparent,
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
