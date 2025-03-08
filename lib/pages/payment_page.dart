import 'package:assignment1/services/providers/app_provider.dart';
import 'package:assignment1/widgets/features/card_display.dart';
import 'package:assignment1/widgets/features/payment_mode_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatelessWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'select payment mode',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'choose your preferred payment method to make payment.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const PaymentModeSelector(),
            const SizedBox(height: 30),
            const Text(
              'YOUR DIGITAL DEBIT CARD',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<AppProvider>(
                builder: (context, provider, _) {
                  return CardDisplay(
                    isFrozen: provider.isFrozen,
                    cardNumber: provider.cardNumber,
                    expiryDate: provider.expiryDate,
                    cvv: provider.cvv,
                    onFreezeToggle: () {
                      provider.toggleFreezeStatus();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
