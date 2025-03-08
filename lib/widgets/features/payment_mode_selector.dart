import 'package:flutter/material.dart';

class PaymentModeSelector extends StatefulWidget {
  const PaymentModeSelector({Key? key}) : super(key: key);

  @override
  State<PaymentModeSelector> createState() => _PaymentModeSelectorState();
}

class _PaymentModeSelectorState extends State<PaymentModeSelector> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
      child: Row(children: [_buildOption(0, 'pay'), _buildOption(1, 'card')]),
    );
  }

  Expanded _buildOption(int index, String label) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color:
                isSelected
                    ? (index == 1
                        ? Colors.red.withOpacity(0.2)
                        : Colors.transparent)
                    : Colors.transparent,
            border:
                isSelected && index == 1
                    ? Border.all(color: Colors.red, width: 1)
                    : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected
                        ? (index == 1 ? Colors.red : Colors.white)
                        : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
