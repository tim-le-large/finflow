# Deploy FinFlow to GitHub Pages

Live target: **https://finflow.lelarge.dev**

## 1. GitHub repository

```bash
cd finflow
git init
git add .
git commit -m "Initial FinFlow app with Supabase and GitHub Pages workflow."
gh repo create finflow --public --source=. --push
```

Or create the repo manually on GitHub, then:

```bash
git remote add origin https://github.com/tim-le-large/finflow.git
git push -u origin main
```

## 2. GitHub Actions secrets

Repo → **Settings → Secrets and variables → Actions → New repository secret**

| Secret | Value |
|--------|--------|
| `SUPABASE_URL` | `https://YOUR_PROJECT.supabase.co` (no `/rest/v1/`) |
| `SUPABASE_ANON_KEY` | Publishable key (`sb_publishable_...`) or anon key (`eyJ...`) |
| `DEMO_EMAIL` | *(optional)* defaults to `demo@finflow.lelarge.dev` |
| `DEMO_PASSWORD` | *(optional)* defaults to portfolio demo password in `DemoConfig` |

Push to `main` or run **Actions → Deploy to GitHub Pages → Run workflow**.

## 3. GitHub Pages settings

Repo → **Settings → Pages**

- **Source:** GitHub Actions
- **Custom domain:** `finflow.lelarge.dev`
- Enable **Enforce HTTPS** when available

## 4. DNS (Cloudflare)

Add a record for `finflow.lelarge.dev`:

| Type | Name | Target |
|------|------|--------|
| CNAME | finflow | `tim-le-large.github.io` |

(Or use the CNAME GitHub shows in Pages settings after the first deploy.)

## 5. Supabase Auth (required for login on live site)

Supabase → **Authentication → URL Configuration**

| Field | Value |
|-------|--------|
| Site URL | `https://finflow.lelarge.dev` |
| Redirect URLs | `https://finflow.lelarge.dev/**` |

Without this, sign-in may fail on the deployed domain.

## 6. Verify

- Actions workflow is green
- https://finflow.lelarge.dev loads
- Register / login works
- New transaction appears in Supabase Table Editor
