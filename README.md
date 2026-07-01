# FinFlow

Personal finance dashboard — **Flutter**, **Riverpod**, and **Supabase**.

| | |
|---|---|
| **Live demo** | [finflow.lelarge.dev](https://finflow.lelarge.dev) |
| **Portfolio** | [lelarge.dev](https://lelarge.dev) |
| **Author** | [Tim Le Large](https://github.com/tim-le-large) |

Click **Live-Demo starten** on the login screen — no sign-up required.

---

## What this demo shows

- **Backend integration:** Supabase Auth + Postgres with row-level security (RLS) per user
- **State management:** Riverpod `AsyncNotifier` with live sync and pull-to-refresh
- **Data viz:** Monthly category donut chart and month-over-month comparison (`fl_chart`)
- **Portfolio polish:** One-click demo, rich seeded dataset, GitHub Pages deploy

Good reference if you need a **dashboard-style Flutter app** with a real database — not just local mock data.

---

## Features

| Area | Details |
|------|---------|
| **Auth** | Email sign-up / sign-in (Supabase Auth) |
| **Accounts** | Multiple accounts with computed balances |
| **Transactions** | Income & expenses synced to Postgres (RLS) |
| **Charts** | Category breakdown + month comparison |
| **Demo** | Shared demo account with ~96 transactions across 4 accounts |
| **Deploy** | GitHub Actions → GitHub Pages (`finflow.lelarge.dev`) |

---

## Architecture

```
lib/
  config/           # Supabase + demo credentials (dart-define)
  data/             # Categories, demo seed data
  models/           # Account, Transaction, Category
  providers/        # Auth, finance, selected month (Riverpod)
  repositories/     # Supabase CRUD + demo reseed logic
  screens/          # Login, home, add transaction
  widgets/          # Donut chart, transaction tiles, account chips
  utils/            # Money parsing/formatting
supabase/
  schema.sql        # Tables + RLS policies
```

**Data flow:** UI → Riverpod providers → `FinanceRepository` → Supabase client. Demo login auto-seeds rich data when the account has fewer than 45 transactions.

---

## Quick start

### 1. Supabase

1. Create a project at [supabase.com](https://supabase.com)
2. **SQL Editor** → run `supabase/schema.sql`
3. **Authentication** → enable Email provider
4. Copy **Project URL** and **anon / publishable key**

### 2. Credentials

```bash
cp dart_defines.example.json dart_defines.json
# fill in SUPABASE_URL, SUPABASE_ANON_KEY, DEMO_EMAIL, DEMO_PASSWORD
```

### 3. Run

```bash
flutter pub get
flutter run -d chrome --dart-define-from-file=dart_defines.json
```

Or use the **FinFlow (Chrome)** launch config in `.vscode/launch.json`.

### Demo account

Create once in **Supabase Auth**:

- Email: `demo@finflow.lelarge.dev`
- Password: `FinFlowDemo2026!`

Add credentials to `dart_defines.json`. CI uses GitHub Actions secrets — see [DEPLOY.md](DEPLOY.md).

---

## Tech stack

| Layer | Choice |
|-------|--------|
| UI | Flutter, Material 3 |
| State | Riverpod |
| Backend | Supabase (Auth + Postgres, RLS) |
| Charts | fl_chart |
| Deploy | GitHub Pages |

---

## Deploy

See **[DEPLOY.md](DEPLOY.md)** for GitHub Actions secrets, custom domain, and Supabase Auth URL settings.

---

## Roadmap

- CSV bank import + auto-categorization
- Offline-first with drift + sync queue

---

## Disclaimer

Portfolio demo only — not financial advice.
