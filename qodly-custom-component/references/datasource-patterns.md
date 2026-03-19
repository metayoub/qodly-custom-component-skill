# Qodly Custom Component — Datasource Patterns

## Accept Types

In `*.config.tsx`, `info.datasources.accept` defines which datasource types the component accepts:

| Type | Use Case |
|------|----------|
| `['array']` | Array of objects (charts, lists, trees) |
| `['entitysel']` | Entity selection — iterable rows, use with StyleBox |
| `['object']` | Single object / key-value |

## Array Datasource

For charts, lists, trees. Data shape: `Array<{ label?, value?, ... }>`.

**Config:**
```tsx
datasources: { accept: ['array'] },
```

**Render — useSources + listener:**
```tsx
const { sources: { datasource: ds } } = useSources();
const [value, setValue] = useState<Array<any>>([]);

useEffect(() => {
  if (!ds) return;
  const listener = async () => {
    const v = await ds.getValue<Array<any>>();
    if (v) setValue(v);
  };
  listener();
  ds.addListener('changed', listener);
  return () => ds.removeListener('changed', listener);
}, [ds]);
```

**Parsing nested fields** (e.g. Chart.js):
```tsx
datasets: datasets.map((set) => ({
  parsing: { yAxisKey: set.source },  // e.g. "value" → v[].value
  data: v,
}));
```

## Entity Selection (entitysel)

For iterable components (Carousel, Grid). Each row is a "slide" or "card" with nested components.

**Config:**
```tsx
datasources: { accept: ['entitysel'] },
sanityCheck: { keys: [{ name: 'datasource', require: true, isDatasource: true }] },
requiredFields: { keys: ['datasource'], all: false },
```

**Build — IteratorProvider + StyleBox:**
```tsx
import { useEnhancedEditor, selectResolver, IteratorProvider } from '@ws-ui/webform-editor';
import { Element } from '@ws-ui/craftjs-core';

const { resolver } = useEnhancedEditor(selectResolver);

return (
  <IteratorProvider>
    <Element
      id="carousel"
      is={resolver.StyleBox}
      deletable={false}
      canvas
    />
  </IteratorProvider>
);
```

**Placeholder when no datasource:**
```tsx
{datasource ? (
  <IteratorProvider>...</IteratorProvider>
) : (
  <div>Please attach a datasource</div>
)}
```

## Shared Datasource (TreeNode actions)

For cross-component state. Use `window.DataSource.getSource(name, path)`:

```ts
const myDS = window.DataSource.getSource('myDS', 'shared');
myDS.setValue(null, { key: 'value' });
```

`sourcePath` is typically `'shared'`.
