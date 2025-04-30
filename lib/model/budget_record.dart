import 'package:flutter/material.dart';

class BudgetRecord {
  final DateTime inputTime;   // 기록 시간
  final String? wallet;       // 지갑 (선택)
  final String? category;     // 카테고리 (선택)
  final int amount;           // 금액
  final String? memo;         // 메모 (선택)
  final bool isIncome;        // 수입/지출 구분

  BudgetRecord({
    required this.inputTime,
    this.wallet,
    this.category,
    required this.amount,
    this.memo,
    required this.isIncome,
  });
}
