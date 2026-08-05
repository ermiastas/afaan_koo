# Supabase setup

Afaan Koo now uses Supabase instead of Firebase for adult authentication, data,
and media. Supabase is open source and can be self-hosted later.

1. Create a free Supabase project, or self-host Supabase with Docker.
2. In **Authentication → Providers**, enable Email.
3. Run [`supabase/schema.sql`](supabase/schema.sql) in the SQL Editor.
4. Create a private Storage bucket named `media`.
5. Start the app with public client values (never put the service-role key in the app):

```powershell
flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_ANON_KEY=YOUR_PUBLISHABLE_KEY
```

For a release build, place the same `--dart-define` values in the CI build
command. The child learning experience remains usable without configuration;
only adult dashboard login is unavailable.

Before a real school launch, store adult roles in a server-controlled profile
table or custom JWT claim and enforce them with RLS. Do not rely solely on
client-side role metadata for teacher authorization.
