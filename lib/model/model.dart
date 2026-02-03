import 'package:flutter/material.dart';

class Payment {
  int id;
  String date;
  int amount;
  String type;
  String category;
  String description;

  Payment.empty()
    : id = -1,
      date = DateTime.now().toString().substring(0, 10),
      amount = 0,
      type = "",
      category = "",
      description = "";

  Payment({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      date: json['date'],
      amount: json['amount'],
      type: json['type'],
      category: json['category'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
    };
  }

  ListTile toListTile(
    int selectedId,
    void Function()? onTap,
    Color? tileColor,
  ) {
    return ListTile(
      title: Text(toString()),
      subtitle: Text(date.toString()),
      onTap: onTap,
      tileColor: tileColor,
    );
  }

  @override
  String toString() {
    return '$category - \$$amount';
  }
}
