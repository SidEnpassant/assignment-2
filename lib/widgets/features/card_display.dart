import 'package:assignment1/widgets/features/freeze_effect.dart';
import 'package:flutter/material.dart';

class CardDisplay extends StatelessWidget {
  final bool isFrozen;
  final String cardNumber;
  final String expiryDate;
  final String cvv;
  final VoidCallback onFreezeToggle;

  const CardDisplay({
    Key? key,
    required this.isFrozen,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.onFreezeToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.70,
            //0.65, // Increased aspect ratio to make card smaller/shorter
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                // color: Colors.black,
                border: Border.all(color: Colors.grey.shade800, width: 1),
              ),
              child: isFrozen ? const FreezeEffect() : _buildCardDetails(),
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: onFreezeToggle,

          child: Column(
            children: [
              Icon(
                Icons.ac_unit_rounded,
                color: const Color.fromARGB(255, 255, 255, 255),
                size: 24,
              ),
              const SizedBox(height: 5),
              Text(
                isFrozen ? 'unfreeze' : 'freeze',
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 100),
      ],
    );
  }

  Widget _buildCardDetails() {
    return Padding(
      padding: const EdgeInsets.all(
        14.0,
      ), // Reduced padding to make content fit better
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/yolo_logo.png',
                height: 16,
              ), // Reduced logo size
              Image.asset(
                'assets/yes_bank.png',
                height: 22,
              ), // Reduced logo size
            ],
          ),
          SizedBox(height: 20), // Reduced spacing
          // Card number and expiry date side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildCardNumberDisplay()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'expiry',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    expiryDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'cvv',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '***',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 3),
                          Icon(
                            Icons.visibility_off,
                            color: Colors.red,
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          // Copy details directly below the card number
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    Icon(Icons.copy_outlined, color: Colors.red, size: 14),
                    const SizedBox(width: 5),
                    const Text(
                      'copy details',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 60),
            ],
          ),
          const SizedBox(height: 12),

          // RuPay logo at bottom with PREPAID below it
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/rupay_logo.png',
                  height: 20,
                ), // Reduced logo size
                const Text(
                  'PREPAID',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumberDisplay() {
    // Card number styling to match the image (boxed digits)
    final numbers = cardNumber.split(' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < numbers.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0), // Reduced spacing
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 1,
              ), // Smaller container
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade800, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                numbers[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16, // Smaller font
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3, // Slightly reduced letter spacing
                ),
              ),
            ),
          ),
      ],
    );
  }
}
