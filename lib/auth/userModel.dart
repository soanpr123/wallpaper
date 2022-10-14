import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallpaper/auth/badgeModel.dart';
import 'package:wallpaper/auth/transactionModel.dart';
import 'package:wallpaper/logger/logger.dart';

part 'userModel.g.dart';

@HiveType(typeId: 15)
@JsonSerializable(
  explicitToJson: false,
)
class WallUsersV2 {
  @HiveField(0)
  String username;
  @HiveField(1)
  String email;
  @HiveField(2)
  String id;
  @HiveField(3)
  String createdAt;
  @HiveField(4)
  bool premium;
  @HiveField(5)
  String lastLoginAt;
  @HiveField(6)
  Map links;
  @HiveField(7)
  List followers;
  @HiveField(8)
  List following;
  @HiveField(9)
  String profilePhoto;
  @HiveField(10)
  String bio;
  @HiveField(11)
  bool loggedIn;
  @HiveField(12)
  List badges;
  @HiveField(13)
  List subPrisms;
  @HiveField(14)
  int coins;
  @HiveField(15)
  List<WallTransaction> transactions;
  @HiveField(16)
  String name;
  @HiveField(17)
  String? coverPhoto;

  WallUsersV2({
    required this.username,
    required this.email,
    required this.id,
    required this.createdAt,
    required this.premium,
    required this.lastLoginAt,
    required this.links,
    required this.followers,
    required this.following,
    required this.profilePhoto,
    required this.bio,
    required this.loggedIn,
    required this.badges,
    required this.subPrisms,
    required this.coins,
    required this.transactions,
    required this.name,
    this.coverPhoto,
  }) {
    logger.d("Default constructor !!!!");
  }

  factory WallUsersV2.fromJson(Map<String, dynamic> json) => _$WallUsersV2FromJson(json);
  factory WallUsersV2.fromDocumentSnapshot(DocumentSnapshot doc, User user) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WallUsersV2(
      name: (data["name"] ?? user.displayName).toString(),
      username: (data["username"] ?? user.displayName).toString().replaceAll(RegExp(r"(?: |[^\w\s])+"), ""),
      email: (data["email"] ?? user.email).toString(),
      id: data["id"].toString(),
      createdAt: data["createdAt"].toString(),
      premium: data["premium"] as bool,
      lastLoginAt: data["lastLoginAt"]?.toString() ?? DateTime.now().toUtc().toIso8601String(),
      links: data["links"] ?? {},
      followers: data["followers"] ?? [],
      following: data["following"] ?? [],
      profilePhoto: (data["profilePhoto"] ?? user.photoURL).toString(),
      bio: (data["bio"] ?? "").toString(),
      loggedIn: true,
      badges: data['badges'] ?? [],
      subPrisms: data['subPrisms'] ?? [],
      coins: data['coins'] ?? 0,
      transactions: (data['transactions'] as List<dynamic>).map((e) => WallTransaction.fromJson(e)).toList(),
      coverPhoto: data["coverPhoto"] ?? "",
    );
  }

  factory WallUsersV2.fromDocumentSnapshotWithoutUser(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WallUsersV2(
      name: (data["name"] ?? "").toString(),
      username: (data["username"] ?? "").toString().replaceAll(RegExp(r"(?: |[^\w\s])+"), ""),
      email: (data["email"] ?? "").toString(),
      id: data["id"].toString(),
      createdAt: DateTime.parse(data["createdAt"] as String).toUtc().toIso8601String(),
      premium: data["premium"] as bool,
      lastLoginAt: data["lastLoginAt"]?.toString() ?? DateTime.now().toUtc().toIso8601String(),
      links: data["links"] ?? {},
      followers: data["followers"] ?? [],
      following: data["following"] ?? [],
      profilePhoto: (data["profilePhoto"] ?? "").toString(),
      bio: (data["bio"] ?? "").toString(),
      loggedIn: true,
      badges: data['badges'] ?? [],
      subPrisms: data['subPrisms'] ?? [],
      coins: data['coins'] ?? 0,
      transactions: (data['transactions'] ?? []).map((e) => WallTransaction.fromJson(e)).toList(),
      coverPhoto: data["coverPhoto"] ?? "",
    );
  }
  Map<String, dynamic> toJson() => _$WallUsersV2ToJson(this);
}
