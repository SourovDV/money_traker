class TransactionModel {
  final int? id;
  final int money;
  final String category;
  final String note;
  final String date;


  TransactionModel({
    this.id,
    required this.money,
    required this.category,
    required this.note,
    required this.date
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map["id"],
      money: map["money"],
      category: map["category"],
      note: map["note"],
      date:map["date"]
    );
  }

  Map<String,dynamic> toMap(){
    return{
      "id":id,
      "money":money,
      "category":category,
      "note":note,
      "date":date
  };
}
}
