---
name: qodly-custom-component
description: Create, scaffold, and develop Qodly Studio Custom Components. Use when building React-based custom components for Qodly, scaffolding new component projects, extending Qodly Pages with custom UI, working with @ws-ui/webform-editor, @qodly/cli, Module Federation, proxy.config, T4DComponent, useEnhancedNode, useRenderer, useSources, useI18n, ESetting.I18NFIELD, i18n translations, craftjs, IteratorProvider, entitysel datasource, or qodly build. For Qodly product docs (components, page loaders, roles, webform-editor API notes), use the qodly-docs skill. For generating or editing .WebForm JSON and page schemas, use the qodly-pages skill.
---

# Qodly Custom Component

Guidance for creating and developing Custom Components for Qodly Studio—React-based building blocks that extend Qodly Pages.

## Companion skills (same repository)

When this skill is installed from the **Qodly skills** bundle (or you copied sibling folders into `.cursor/skills/`):

- **qodly-docs** — Read markdown/mdx under `qodly-docs/` for Qodly Pro reference: built-in components, page loaders, events, datasources, localization, roles, and custom-component integration topics.
- **qodly-pages** — Use `qodly-pages/` when authoring **web pages** (`.WebForm` JSON), JSON schemas, craft-component catalogs, and Studio page/i18n rules—not for React custom component code.

## Overview

Custom Components are user-created React components for Qodly Studio. They use `@ws-ui/webform-editor`, Module Federation for runtime loading, and Vite for builds. Official docs: [developer.4d.com/qodly/Integrations/customComponent/overview](https://developer.4d.com/qodly/Integrations/customComponent/overview).

## Initialize a New Component Project

From the directory where the project should live (or run interactively and choose the target path):

```bash
npx @qodly/cli init
```

This is the supported way to create a new custom component project. Do not rely on custom shell scripts for setup—the CLI provisions the full layout.

**Add another component** inside an existing project (after `init`):

```bash
npx @qodly/cli new component
# or, if @qodly/cli is installed locally: npm run generate:component
```

Then ensure the new component is exported from `src/components/index.tsx` following the pattern the CLI generated for existing components.

`npx @qodly/cli init` produces a project with:
- `package.json` (app_id, name, @qodly/cli, @ws-ui/* peer deps)
- `vite.config.ts` (Module Federation, Monaco editor, proxy)
- `proxy.config.ts` (dev proxy to Qodly server)
- `src/main.tsx`, `src/App.tsx`, `src/components/index.tsx`

## Project Structure

```
component-name/
├── package.json          # app_id, name, @qodly/cli, @ws-ui/* peerDependencies
├── vite.config.ts       # federation, proxy, Monaco/standalone plugins
├── proxy.config.ts      # initProxy(env) for /rest, /api, /$lib, etc.
├── src/
│   ├── main.tsx         # ReactDOM.render(<App />)
│   ├── App.tsx          # <WebformEditorStandalone userComponents={components} />
│   ├── components/
│   │   ├── index.tsx    # export default { Component1, Component2, ... }
│   │   └── MyComponent/
│   │       ├── index.tsx       # T4DComponent wrapper (Build vs Render)
│   │       ├── MyComponent.config.tsx
│   │       ├── MyComponent.settings.ts
│   │       ├── MyComponent.build.tsx   # Editor canvas (mock data)
│   │       └── MyComponent.render.tsx  # Runtime (real datasource)
```

## Component File Roles

| File | Purpose |
|------|---------|
| `*.config.tsx` | `T4DComponentConfig`: craft, info, defaultProps, datasources.accept |
| `*.settings.ts` | `TSetting[]` for Studio property panel (ESetting.TEXT_FIELD, I18NFIELD, DATAGRID, etc.) |
| `*.build.tsx` | Editor mode: `useEnhancedNode`, mock/static data for canvas |
| `*.render.tsx` | Runtime mode: `useRenderer`, `useSources`, real datasource binding |
| `index.tsx` | Wraps Build/Render: `enabled ? <Build /> : <Render />` |

## Key Patterns

### Config (T4DComponentConfig)

```tsx
import { EComponentKind, T4DComponentConfig } from '@ws-ui/webform-editor';
import { Settings } from '@ws-ui/webform-editor';

export default {
  craft: {
    displayName: 'MyComponent',
    kind: EComponentKind.BASIC,
    props: { name: '', classNames: [], events: [] },
    related: { settings: Settings(MySettings, BasicSettings) },
    sanityCheck: { keys: [{ name: 'datasource', require: true, isDatasource: true }] },
    requiredFields: { keys: ['datasource'], all: false },
  },
  info: {
    displayName: 'MyComponent',
    exposed: true,
    icon: MyIcon,
    events: [{ label: 'On Click', value: 'onclick' }, ...],
    datasources: { accept: ['entitysel'] },  // or ['array'], etc.
  },
  defaultProps: { style: { height: '200px' }, ... },
} as T4DComponentConfig<IProps>;
```

### Build vs Render

- **Build**: `useEnhancedNode()`, `connect`, no real datasource. Use for drag-and-drop canvas.
- **Render**: `useRenderer()`, `useSources()`, `ds.getValue()`, `ds.addListener('changed', ...)`. Use for runtime with Qodly data.

### Internationalization (i18n)

**Settings (`*.settings.ts`)** — Import `getStaticFeaturesExperimentalFlag` from `@ws-ui/webform-editor`, then use `ESetting.I18NFIELD` when i18n is enabled:

```ts
import { ESetting, getStaticFeaturesExperimentalFlag } from '@ws-ui/webform-editor';

const isI18nEnabled = getStaticFeaturesExperimentalFlag('i18n');

// Example setting entry:
// type: isI18nEnabled ? ESetting.I18NFIELD : ESetting.TEXT_FIELD,
```

**Render / labels** — Resolve translated strings with `useI18n()`:

```tsx
import { useI18n } from '@ws-ui/webform-editor';

const { i18n } = useI18n();
const lang = i18n?.userLang?.primary ?? 'de';
const entry = i18n?.keys?.[yourKeyName];
const value = entry?.[lang] ?? entry?.de;
```

See [references/i18n.md](references/i18n.md) for full notes.

### Index Wrapper

```tsx
const MyComponent: T4DComponent<IProps> = (props) => {
  const { enabled } = useEnhancedEditor((state) => ({ enabled: state.options.enabled }));
  return enabled ? <Build {...props} /> : <Render {...props} />;
};
MyComponent.craft = config.craft;
MyComponent.info = config.info;
MyComponent.defaultProps = config.defaultProps;
```

## package.json Essentials

- `app_id`: Unique ID (e.g. `qodly_431f853d4e15946ba36f`)
- `name`: Component package name
- Scripts: `dev`, `build` (qodly build), `generate:component` (qodly new component)
- Peer deps: `@ws-ui/code-editor`, `@ws-ui/icons`, `@ws-ui/shared`, `@ws-ui/store`
- Dependencies: `@ws-ui/webform-editor`, `@ws-ui/craftjs-core`, `react`, `react-dom`

## Vite & Proxy

- `proxy.config.ts`: Proxies `/rest`, `/api`, `/$lib`, `/login.html`, etc. to `PROXY_SERVER` (default `https://127.0.0.1:7443`).
- Env: `PROXY_SERVER`, `API_SECURE`, `API_KEY`, `PORT`, `HOST`.
- Module Federation: exposes `./components` as `components.js` for Qodly Studio.

## Development

```bash
npm run dev
```

Runs Vite dev server with proxy. Connect Qodly Studio to the component URL for local development.

## Build & Install in Qodly

```bash
npm run build
```

Produces federated bundle. Install the built component in Qodly Studio per [Custom Components for Qodly Studio](https://github.com/qodly/custom-components).

## Complete Example (Pie Chart)

**index.tsx** — Build vs Render switch:
```tsx
const Pie: T4DComponent<IPieProps> = (props) => {
  const { enabled } = useEnhancedEditor((state) => ({ enabled: state.options.enabled }));
  return enabled ? <Build {...props} /> : <Render {...props} />;
};
Pie.craft = config.craft;
Pie.info = config.info;
Pie.defaultProps = config.defaultProps;
```

**Build** — Mock data, `useEnhancedNode`, `connect`:
```tsx
const { connectors: { connect } } = useEnhancedNode();
const data = useMemo(() => ({ labels: ['A','B','C'], datasets: [{ data: [1,2,3] }] }), []);
return <div ref={connect}><PieChart data={data} options={options} /></div>;
```

**Render** — Real datasource, `useRenderer`, `useSources`:
```tsx
const { connect } = useRenderer();
const { sources: { datasource: ds } } = useSources();
const [value, setValue] = useState(initial);

useEffect(() => {
  if (!ds) return;
  const listener = async () => { const v = await ds.getValue(); setValue(v); };
  listener();
  ds.addListener('changed', listener);
  return () => ds.removeListener('changed', listener);
}, [ds]);
```

## References

- **Project structure**: See [references/project-structure.md](references/project-structure.md)
- **Settings API**: See [references/settings-api.md](references/settings-api.md)
- **i18n**: See [references/i18n.md](references/i18n.md)
- **Datasource patterns**: See [references/datasource-patterns.md](references/datasource-patterns.md)
- **Events**: See [references/events.md](references/events.md)
- **Troubleshooting**: See [references/troubleshooting.md](references/troubleshooting.md)
- **Community**: [github.com/qodly/custom-components](https://github.com/qodly/custom-components)

## Version

Compatible with Qodly Studio - 4D 21. Docs: [developer.4d.com/qodly/Integrations/customComponent](https://developer.4d.com/qodly/Integrations/customComponent/overview).
