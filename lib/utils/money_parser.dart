int parseEuroInput(String input) {
  final normalized = input.replaceAll(',', '.').trim();
  final value = double.tryParse(normalized) ?? 0;
  return (value * 100).round();
}
