import 'dart:ui';

import 'package:intl/intl.dart';

const bgColor = Color(0xFF212121);
const overlayColor = Color(0xFF2A2A2A);
const subTextColor = Color(0xFF989898);
const primaryColor = Color(0xFFF26624);

const String baseUrl = "https://rapid-raptor-slightly.ngrok-free.app";
const String stockBaseUrl = "https://growing-positive-ewe.ngrok-free.app";

final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹ ');

String displayAccountNumber(String accountNumber, {String maskChar = 'X'}) {
  // Remove any existing spaces or dashes
  String cleanedNumber = accountNumber.replaceAll(RegExp(r'[\s-]'), '');
  
  // Ensure the account number has at least 4 digits
  if (cleanedNumber.length <= 4) {
    return cleanedNumber; // Return as-is if 4 or fewer digits
  }
  
  // Mask all but the last 4 digits
  String maskedPart = maskChar * (cleanedNumber.length - 4);
  String lastFourDigits = cleanedNumber.substring(cleanedNumber.length - 4);
  
  // Combine masked part with last 4 digits
  String maskedNumber = '$maskedPart$lastFourDigits';
  
  // Insert spaces every 4 digits
  String formattedNumber = '';
  for (int i = 0; i < maskedNumber.length; i++) {
    if (i > 0 && i % 4 == 0) {
      formattedNumber += ' ';
    }
    formattedNumber += maskedNumber[i];
  }
  
  return formattedNumber;
}