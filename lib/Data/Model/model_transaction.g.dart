// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 1;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      date: fields[1] as DateTime,
      amount: fields[2] as double,
      category: fields[3] as Category,
      note: fields[4] as String,
      categoryType: fields[5] as CategoryType,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.categoryType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      fields[1] as int,
      fields[3] as int,
      categoryType: fields[4] as CategoryType,
      categoryName: fields[2] as String,
      imagePath: fields[5] as String?,
      isDelete: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.categoryName)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.categoryType)
      ..writeByte(5)
      ..write(obj.imagePath)
      ..writeByte(6)
      ..write(obj.isDelete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlannerAdapter extends TypeAdapter<Planner> {
  @override
  final int typeId = 4;

  @override
  Planner read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Planner(
      start: fields[1] as DateTime,
      end: fields[2] as DateTime,
      budget: (fields[3] as List)
          .map((dynamic e) => (e as Map).cast<Category, int>())
          .toList(),
      plannerName: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Planner obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.budget)
      ..writeByte(4)
      ..write(obj.plannerName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlannerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryTypeAdapter extends TypeAdapter<CategoryType> {
  @override
  final int typeId = 3;

  @override
  CategoryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 1:
        return CategoryType.income;
      case 2:
        return CategoryType.expense;
      default:
        return CategoryType.income;
    }
  }

  @override
  void write(BinaryWriter writer, CategoryType obj) {
    switch (obj) {
      case CategoryType.income:
        writer.writeByte(1);
        break;
      case CategoryType.expense:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
