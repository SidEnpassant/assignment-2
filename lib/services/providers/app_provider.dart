import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

class AppProvider extends ChangeNotifier {
  bool _isFrozen = false;
  String _cardNumber = '';
  String _expiryDate = '';
  String _cvv = '';

  bool get isFrozen => _isFrozen;
  String get cardNumber => _cardNumber;
  String get expiryDate => _expiryDate;
  String get cvv => _cvv;

  AppProvider() {
    _generateCardDetails();
  }

  void _generateCardDetails() {
    final faker = Faker();

    // Generate card number in groups of 4 digits
    _cardNumber =
        '${faker.randomGenerator.integer(9999, min: 1000)} '
        '${faker.randomGenerator.integer(9999, min: 1000)} '
        '${faker.randomGenerator.integer(9999, min: 1000)} '
        '${faker.randomGenerator.integer(9999, min: 1000)}';

    // Generate expiry date (MM/YY format)
    final month = faker.randomGenerator
        .integer(12, min: 1)
        .toString()
        .padLeft(2, '0');
    final year = (faker.randomGenerator.integer(5, min: 1) + 28).toString();
    _expiryDate = '$month/$year';

    // Generate CVV
    _cvv = faker.randomGenerator.integer(999, min: 100).toString();

    notifyListeners();
  }

  void toggleFreezeStatus() {
    _isFrozen = !_isFrozen;
    notifyListeners();
  }
}
