# Qodly Custom Component — Troubleshooting

## Proxy / Dev Server

**Symptom:** 404 or connection refused when loading component in Qodly Studio.

- Ensure Qodly server is running (default `https://127.0.0.1:7443`).
- Check `proxy.config.ts` and env: `PROXY_SERVER`, `API_SECURE`, `API_KEY`.
- Verify `PORT` and `HOST` if dev server fails to start.

**Symptom:** CORS or cookie issues.

- `proxy.config.ts` sanitizes `set-cookie` (removes `secure` for local dev).
- Use `changeOrigin: true` in proxy options.

## Module Federation

**Symptom:** "Shared module is not available" or runtime errors.

- Ensure `shared` in `vite.config.ts` includes `react`, `react-dom`, `@ws-ui/webform-editor`, `@ws-ui/craftjs-core` with `singleton: true`.
- Check `exposes` matches `./src/components/index.tsx`.

**Symptom:** Component not loading in Studio.

- Run `npm run build` and verify `components.js` is produced.
- Confirm `app_id` in `package.json` matches Studio registration.

## Datasource

**Symptom:** `ds` is undefined in Render.

- Ensure `datasources.accept` in config matches the datasource type in Studio.
- Check component has a datasource attached in the page.

**Symptom:** Data not updating when datasource changes.

- Call `ds.addListener('changed', listener)` in `useEffect`.
- Return cleanup: `return () => ds.removeListener('changed', listener)`.

## Build vs Render

**Symptom:** Component shows wrong UI in editor vs runtime.

- Build: use `useEnhancedNode()`, mock data.
- Render: use `useRenderer()`, `useSources()`, real data.
- Index: `enabled ? <Build /> : <Render />` based on `useEnhancedEditor`.

## Peer Dependencies

**Symptom:** Version mismatch with @ws-ui packages.

- Align `@ws-ui/webform-editor`, `@ws-ui/code-editor`, `@ws-ui/icons`, `@ws-ui/shared`, `@ws-ui/store` versions.
- Check Qodly Studio docs for compatible versions.
