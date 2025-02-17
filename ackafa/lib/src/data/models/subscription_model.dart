import 'dart:convert';

class SubscriptionModel {
  final String id;
  final int amount;
  final DateTime? lastRenewed;
  final DateTime? expiryDate;
  final String status;
  final String currency;

  SubscriptionModel({
    required this.id,
    required this.amount,
    this.lastRenewed,
    this.expiryDate,
    required this.status,
    required this.currency,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['_id'] ?? '',
      amount: json['amount'] ?? 0,
      lastRenewed: json['lastRenewed'] != null ? DateTime.tryParse(json['lastRenewed']) : null,
      expiryDate: json['expiryDate'] != null ? DateTime.tryParse(json['expiryDate']) : null,
      status: json['status'] ?? '',
      currency: json['currency'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'amount': amount,
      'lastRenewed': lastRenewed?.toUtc().toIso8601String(),
      'expiryDate': expiryDate?.toUtc().toIso8601String(),
      'status': status,
      'currency': currency,
    };
  }

  SubscriptionModel copyWith({
    String? id,
    int? amount,
    DateTime? lastRenewed,
    DateTime? expiryDate,
    String? status,
    String? currency,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      lastRenewed: lastRenewed ?? this.lastRenewed,
      expiryDate: expiryDate ?? this.expiryDate,
      status: status ?? this.status,
      currency: currency ?? this.currency,
    );
  }
}
