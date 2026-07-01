import 'package:flutter/material.dart';

class SupabaseSetupScreen extends StatelessWidget {
  const SupabaseSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FinFlow',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Supabase ist noch nicht konfiguriert.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              const Text(
                '1. Projekt auf supabase.com anlegen\n'
                '2. SQL aus supabase/schema.sql ausführen\n'
                '3. URL + anon key eintragen:\n\n'
                '   lib/config/supabase_config.dart\n'
                '   oder per --dart-define beim Start\n\n'
                '4. Auth → Email aktivieren\n'
                '5. flutter run -d chrome',
              ),
              const SizedBox(height: 24),
              SelectableText(
                'flutter run -d chrome \\\n'
                '  --dart-define=SUPABASE_URL=https://xxx.supabase.co \\\n'
                '  --dart-define=SUPABASE_ANON_KEY=eyJ...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
