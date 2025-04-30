import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wonmore_budget/common/record_category_icon.dart';

class RecordCard extends StatelessWidget {
  final DateTime inputTime;
  final String? wallet;
  final String? category;
  final int amount;
  final String? memo;
  final bool isIncome;

  RecordCard({
    super.key,
    required this.inputTime,
    this.wallet,
    this.category,
    required this.amount,
    this.memo,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final (IconData matchedIcon, Color matchedColor) =
        defaultCategoryIconMap[category ?? ''] ?? (Icons.category, Colors.grey);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8,),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Colors.amberAccent,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /// 1. 시간 + wallet
              SizedBox(
                width: 56,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(inputTime),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      wallet ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.0),

              /// 2. 아이콘 + 카테고리
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(matchedIcon, size: 20, color: matchedColor),
                  SizedBox(height: 4),
                  SizedBox(
                    width: 46,
                    child: Text(
                      category ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),

              SizedBox(width: 20.0),
              /// 3. 메모 텍스트 (남은 공간 다 사용)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    memo ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              /// 4. 금액 표시
              SizedBox(width: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '\\${amount.toString()}원',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isIncome ? Colors.blue : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //   Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(DateFormat('HH:mm').format(inputTime)),
    //     Text(
    //       wallet ?? '',
    //       style: TextStyle(
    //         fontSize: 14,
    //         color: Colors.grey,
    //       ),
    //     ),
    //   ],
    // );
  }
}
