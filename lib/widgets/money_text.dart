import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCents(int cents, {bool showSign = false}) {
  final euros = cents / 100;
  final formatter = NumberFormat.currency(locale: 'de_DE', symbol: '€');
  final text = formatter.format(euros.abs());
  if (!showSign) return text;
  if (cents > 0) return '+$text';
  if (cents < 0) return '-$text';
  return text;
}

class MoneyText extends StatelessWidget {
  const MoneyText(this.cents, {super.key, this.style, this.showSign = false});

  final int cents;
  final TextStyle? style;
  final bool showSign;

  @override
  Widget build(BuildContext context) {
    return Text(formatCents(cents, showSign: showSign), style: style);
  }
}