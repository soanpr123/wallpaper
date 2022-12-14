// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactionModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WallTransactionAdapter extends TypeAdapter<WallTransaction> {
  @override
  final int typeId = 13;

  @override
  WallTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallTransaction(
      name: fields[0] as String,
      description: fields[6] as String,
      id: fields[2] as String,
      amount: fields[5] as String,
      credit: fields[4] as bool,
      by: fields[1] as String,
      processedAt: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WallTransaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.by)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.processedAt)
      ..writeByte(4)
      ..write(obj.credit)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallTransaction _$WallTransactionFromJson(Map<String, dynamic> json) =>
    WallTransaction(
      name: json['name'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
      amount: json['amount'] as String,
      credit: json['credit'] as bool,
      by: json['by'] as String,
      processedAt: json['processedAt'] as String,
    );

Map<String, dynamic> _$WallTransactionToJson(WallTransaction instance) =>
    <String, dynamic>{
      'name': instance.name,
      'by': instance.by,
      'id': instance.id,
      'processedAt': instance.processedAt,
      'credit': instance.credit,
      'amount': instance.amount,
      'description': instance.description,
    };
