import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:finflow/main.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('de_DE');
  });

  testWidgets('shows supabase setup when not configured', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: FinFlowApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('FinFlow'), findsOneWidget);
    expect(find.textContaining('Supabase'), findsOneWidget);
  });
}
