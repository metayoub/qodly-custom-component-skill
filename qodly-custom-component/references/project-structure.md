# Qodly Custom Component — Project Structure

## Root Files

| File | Purpose |
|------|---------|
| `package.json` | app_id, name, scripts, @qodly/cli, @ws-ui peer deps |
| `vite.config.ts` | Vite + React + Module Federation + Monaco + proxy |
| `proxy.config.ts` | `initProxy(env)` mapping /rest, /api, etc. to Qodly server |
| `tsconfig.json` | TypeScript config |

## package.json Fields

```json
{
  "app_id": "qodly_<unique_id>",
  "name": "component-name",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "qodly build",
    "generate:component": "qodly new component"
  },
  "dependencies": {
    "@ws-ui/webform-editor": "^1.x",
    "@ws-ui/craftjs-core": "^0.2.x",
    "react": "^17.0.2",
    "react-dom": "^17.0.2"
  },
  "devDependencies": {
    "@qodly/cli": "^0.4.x",
    "@module-federation/vite": "^1.x",
    "@ws-ui/vite-plugins": "^1.x",
    "vite": "^6.x"
  },
  "peerDependencies": {
    "@ws-ui/code-editor": "^1.x",
    "@ws-ui/icons": "^1.x",
    "@ws-ui/shared": "^1.x",
    "@ws-ui/store": "^1.x"
  }
}
```

## vite.config.ts Highlights

- `federation()`: name = app_id, exposes `./components`, library type `var`
- Shared: react, react-dom, @ws-ui/webform-editor, craftjs-*
- Dev: monacoEditorPlugin, standaloneEditorPlugin
- Server: proxy from `initProxy(env)`, port from `PORT` env

## proxy.config.ts

Proxies these paths to Qodly server (default `https://127.0.0.1:7443`):

- `/rest`, `/$lib`, `/api`, `/login.html`, `/css`, `/img`, `/js`
- `/LSP`, `/remoteDebugger`, `/dataexplorer`, `/$shared`

Env: `PROXY_SERVER`, `API_SECURE`, `API_KEY`.

## src/ Layout

```
src/
├── main.tsx           # ReactDOM.render(<App />)
├── App.tsx            # WebformEditorStandalone userComponents={components}
├── index.css          # Global styles
├── vite-env.d.ts      # Vite types
└── components/
    ├── index.tsx      # export default { Comp1, Comp2, ... }
    └── MyComponent/
        ├── index.tsx
        ├── MyComponent.config.tsx
        ├── MyComponent.settings.ts
        ├── MyComponent.build.tsx
        └── MyComponent.render.tsx
```
