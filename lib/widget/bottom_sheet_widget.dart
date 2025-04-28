import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  final DateTime selectedDay;
  final double rowHeight;

  const CustomBottomSheet({super.key, required this.selectedDay, required this.rowHeight});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingTop = MediaQuery.of(context).padding.top;

    // 고정된 상단 영역 높이 계산
    const appBarHeight = 56.0;
    const yearMonthHeight = 56.0;
    const summaryHeight = 80.0;
    const daysOfWeekHeight = 32.0;
    const AdHeight = 60.0;

    final bottomSheetHeight = screenHeight
        - paddingTop
        - appBarHeight
        - yearMonthHeight
        - summaryHeight
        - daysOfWeekHeight
        - widget.rowHeight
        - AdHeight;

    // 예시 수입/지출 합계
    final incomeTotal = 450000;
    final expenseTotal = 61000;

    return Container(
      width: double.infinity,
      height: bottomSheetHeight,
      decoration: BoxDecoration(
        color: Color(0xFFF1F1FD),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 날짜 정보 (선택된 날짜를 표시)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 왼쪽: 날짜 + 요일 + 연/월
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 노란색 박스 안 일자
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amberAccent, width: 2),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        widget.selectedDay.day.toString().padLeft(2, '0'),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 4),

                    // 노란색 동그라미 요일
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.amberAccent.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _weekdayString(widget.selectedDay.weekday),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 4),

                    // 연/월 표시
                    Text(
                      '${widget.selectedDay.year}.${widget.selectedDay.month.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                ),
                SizedBox(width: 36),

                // 수입/지출 금액 표시
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '+450,000원',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '-61,000원',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 구분선
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey.shade400,
          ),
          // 내용
          Expanded(
            child: Container(
              color: Color(0xFFF8F8FF),
            ),
          ),

          // 광고 영역
          Container(
            height: 50,
            width: double.infinity,
            color: Colors.grey.shade300,
            child: Center(
              child: Text('광고 자리', style: TextStyle(color: Colors.black54)),
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }
}
