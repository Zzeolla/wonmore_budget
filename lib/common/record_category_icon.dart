import 'package:flutter/material.dart';

/// 카테고리 별 아이콘과 색상 매칭
final Map<String, (IconData, Color)> defaultCategoryIconMap = {
  '식비': (Icons.lunch_dining, Colors.orange),
  '교통비': (Icons.directions_bus, Colors.blue),
  '쇼핑': (Icons.shopping_bag, Colors.pink),
  '월급': (Icons.attach_money, Colors.green),
  '용돈': (Icons.account_balance_wallet, Colors.teal),
  '문화생활': (Icons.movie, Colors.purple),
  '주거비': (Icons.home, Colors.brown),
  '통신비': (Icons.phone_android, Colors.indigo),
  '보험료': (Icons.security, Colors.red),
  '교육비': (Icons.school, Colors.deepPurple),
  '기타': (Icons.category, Colors.grey),
};