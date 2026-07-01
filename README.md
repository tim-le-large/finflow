# FinFlow

Personal finance dashboard with **Flutter**, **Riverpod**, and **Supabase**.

**Live:** [finflow.lelarge.dev](https://finflow.lelarge.dev) (coming soon)

## Features

- Email login / sign up (Supabase Auth)
- Multiple accounts with computed balances
- Transactions synced to Supabase (RLS per user)
- Monthly donut chart + month-over-month comparison
- Demo data seeded on first login
- Pull-to-refresh

## Setup

### 1. Supabase project

1. Create a project at [supabase.com](https://supabase.com)
2. **SQL Editor** → run `supabase/schema.sql`
3. **Authentication** → enable Email provider
4. Copy **Project URL** and **anon public key**

### 2. Configure credentials

Copy `dart_defines.example.json` to `dart_defines.json` and fill in your Supabase URL and publishable key.

Local run:

```bash
flutter run -d chrome --dart-define-from-file=dart_defines.json
```

Or use the **FinFlow (Chrome)** launch config in VS Code/Cursor (`.vscode/launch.json`).

CI uses GitHub Actions secrets (`SUPABASE_URL`, `SUPABASE_ANON_KEY`) — see [DEPLOY.md](DEPLOY.md).

### 3. Run

```bash
flutter pub get
flutter run -d chrome
```

Register a new account → demo accounts & transactions are created automatically.

## Tech

| Layer | Choice |
|-------|--------|
| UI | Flutter, Material 3 |
| State | Riverpod (`AsyncNotifier`) |
| Backend | Supabase (Auth + Postgres) |
| Charts | fl_chart |

## Deploy (GitHub Pages)

See **[DEPLOY.md](DEPLOY.md)** for the full guide.

Quick version:

1. Push repo to GitHub (`tim-le-large/finflow`)
2. Add Actions secrets: `SUPABASE_URL`, `SUPABASE_ANON_KEY`
3. Pages → Source: **GitHub Actions**, custom domain `finflow.lelarge.dev`
4. Cloudflare CNAME: `finflow` → `tim-le-large.github.io`
5. Supabase Auth → Site URL: `https://finflow.lelarge.dev`

## Roadmap

- Sprint 3: CSV bank import + auto-categorization
- Sprint 4: Offline-first with drift + sync queue

## Disclaimer

Demo app only — not financial advice.
