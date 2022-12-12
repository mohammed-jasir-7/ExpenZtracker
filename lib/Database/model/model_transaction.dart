import 'package:hive_flutter/hive_flutter.dart';
part 'model_transaction.g.dart';

// =======================================   transaction model  ================================================
@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(1)
  late DateTime date;
  @HiveField(2)
  late double amount;
  @HiveField(3)
  //category Like Salary , transport
  final Category category;
  @HiveField(4)
  late String note;
  //this spacify income or expense
  @HiveField(5)
  final CategoryType categoryType;

  Transaction(
      {required this.date,
      required this.amount,
      required this.category,
      required this.note,
      required this.categoryType});
}

//======================================================== category type ================================================================
// income or expense selection model
@HiveType(typeId: 3)
enum CategoryType {
  @HiveField(1)
  income,
  @HiveField(2)
  expense,
}
//========================================================  category Model =============================================================

//model of category
//add categories(salary transport.....etc)
@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(1)
  final int icon;
  @HiveField(2)
  final String categoryName;
  @HiveField(3)
  final int color;
  @HiveField(4)
  final CategoryType categoryType;
  @HiveField(5)
  final String? imagePath;

  Category(
    this.icon,
    this.color, {
    required this.categoryType,
    required this.categoryName,
    this.imagePath,
  });
}

//===========================================================================================================================
