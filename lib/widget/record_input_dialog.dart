import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum RecordType { income, expense, transfer }

class RecordInputDialog extends StatefulWidget {
  final DateTime initialDate;

  const RecordInputDialog({super.key, required this.initialDate,});

  @override
  State<RecordInputDialog> createState() => _RecordInputDialogState();
}

class _RecordInputDialogState extends State<RecordInputDialog> {
  late DateTime selectedDate = widget.initialDate;
  RecordType _selectedType = RecordType.income;

  final amountController = TextEditingController();
  final contentController = TextEditingController();
  final memoController = TextEditingController();

  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedWallet;

  final mainCategoryList = ['식비', '쇼핑', '교통'];
  final subCategoryMap = {
    '식비': ['점심', '저녁', '카페'],
    '쇼핑': ['의류', '잡화', '온라인'],
    '교통': ['지하철', '버스', '택시'],
  };
  final walletList = ['카카오뱅크', '신한은행', '토스'];

  String _iconSubtitleText() {
    return switch (_selectedType) {
      RecordType.income => '반복',
      RecordType.expense => '반복/할부',
      RecordType.transfer => '반복',
    };
  }

  @override
  Widget build(BuildContext context) {
    final String title = switch (_selectedType) {
      RecordType.income => '수입내역',
      RecordType.expense => '지출내역',
      RecordType.transfer => '이체',
    };
    final subCategoryList = subCategoryMap[selectedMainCategory] ?? [];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 제목 + 아이콘 영역
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F1FD),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.repeat, size: 28, color: Colors.black54),
                                const SizedBox(height: 2),
                                Text(
                                  _iconSubtitleText(),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(height: 1, thickness: 1, color: Color(0xFFDADCE0)),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildTypeButton('수입', RecordType.income),
                              const SizedBox(width: 8),
                              _buildTypeButton('지출', RecordType.expense),
                              const SizedBox(width: 8),
                              _buildTypeButton('이체', RecordType.transfer),
                            ],
                          ),
                          const SizedBox(height: 32),
                          _buildFieldRow('날짜', _buildDateField()),
                          _buildFieldRow('금액', _buildTextBox(amountController, TextInputType.number)),
                          _buildFieldRow('내역', _buildTextBox(contentController, TextInputType.text)),
                          _buildFieldRow('분류', Row(
                            children: [
                              Expanded(
                                child: _buildDropdown(
                                  value: selectedMainCategory,
                                  items: mainCategoryList,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMainCategory = value;
                                      selectedSubCategory = null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildDropdown(
                                  value: selectedSubCategory,
                                  items: subCategoryList,
                                  onChanged: (value) => setState(() => selectedSubCategory = value),
                                ),
                              ),
                            ],
                          )),
                          _buildFieldRow('자산', _buildDropdown(
                            value: selectedWallet,
                            items: walletList,
                            onChanged: (value) => setState(() => selectedWallet = value),
                          )),
                          _buildFieldRow('메모', _buildTextBox(memoController, TextInputType.text, maxLines: 3)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.star_border, size: 32),
                                tooltip: '즐겨찾기',
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.delete_outline, size: 32),
                                tooltip: '취소',
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.check, size: 32),
                                tooltip: '확인',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTypeButton(String label, RecordType type) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () => setState(() => _selectedType = type),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.amber : Colors.grey.shade300,
            foregroundColor: Colors.black,
            minimumSize: const Size.fromHeight(52),
            textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: label == '메모' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            child: Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(child: field),
        ],
      ),
    );
  }

  Widget _buildTextBox(TextEditingController controller, TextInputType type, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF1F1FD),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFF1F1FD),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (picked != null) {
          setState(() {
            selectedDate = DateTime(
              picked.year,
              picked.month,
              picked.day,
              selectedDate.hour,
              selectedDate.minute,
            );
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF1F1FD),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          DateFormat('yyyy.MM.dd (E), HH:mm', 'ko_KR').format(selectedDate),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
