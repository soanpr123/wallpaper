import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallpaper/logger/logger.dart';

part 'transactionModel.g.dart';

@HiveType(typeId: 13)
@JsonSerializable(
  explicitToJson: false,
)
class WallTransaction {
  @HiveField(0)
  String name;
  @HiveField(1)
  String by;
  @HiveField(2)
  String id;
  @HiveField(3)
  String processedAt;
  @HiveField(4)
  bool credit;
  @HiveField(5)
  String amount;
  @HiveField(6)
  String description;

  WallTransaction({
    required this.name,
    required this.description,
    required this.id,
    required this.amount,
    required this.credit,
    required this.by,
    required this.processedAt,
  }) {
    logger.d("Default constructor !!!!");
  }

  factory WallTransaction.fromJson(Map<String, dynamic> json) => _$WallTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$WallTransactionToJson(this);
}
