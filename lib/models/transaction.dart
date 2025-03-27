import 'package:intl/intl.dart';

enum TransactionType { income, expense }

class Transaction {
  final String? id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;

  Transaction({
    this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
  });

  // Convert Transaction to a Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
      'description': description,
      'type': type.toString(),
      'category': category,
    };
  }

  // Create a Transaction from a Map (from database)
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      date: DateFormat('yyyy-MM-dd HH:mm:ss').parse(map['date']),
      description: map['description'],
      type: map['type'] == 'TransactionType.income'
          ? TransactionType.income
          : TransactionType.expense,
      category: map['category'],
    );
  }

  // Net amount after tax calculation
  double get netAmount {
    if (type == TransactionType.expense) {
      return amount;
    }

    // Tax calculation for income
    if (amount > 50000) {
      return amount * 0.9; // 10% tax
    } else if (amount > 30000) {
      return amount * 0.95; // 5% tax
    } else {
      return amount; // No tax
    }
  }

  // Tax amount
  double get taxAmount {
    if (type == TransactionType.expense) {
      return 0;
    }

    if (amount > 50000) {
      return amount * 0.1; // 10% tax
    } else if (amount > 30000) {
      return amount * 0.05; // 5% tax
    } else {
      return 0; // No tax
    }
  }

  // Create a copy of the transaction with updated fields
  Transaction copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? date,
    String? category,
    TransactionType? type,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      type: type ?? this.type,
    );
  }
}
