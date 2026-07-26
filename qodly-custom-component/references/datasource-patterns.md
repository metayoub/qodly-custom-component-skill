# Qodly Custom Component — Datasource Patterns

## Accept Types

In `*.config.tsx`, `info.datasources.accept` defines which datasource types the component accepts:

| Type | Use Case |
|------|----------|
| `['array']` | Array of objects (charts, lists, trees) |
| `['entitySel', 'array']` | Entity selection or array — iterable rows |
| `['entity', 'object']` | Single entity or object |

Some older components use `entitysel`; when matching current Qodly examples, prefer `entitySel`.

## Settings

Datasource-backed components should expose the binding in settings:

```ts
const dataAccessSettings: TSetting[] = [
  {
    key: 'datasource',
    label: 'Data Source',
    type: ESetting.DS_AUTO_SUGGEST,
  },
  {
    key: 'serverSideRef',
    label: 'Server Side',
    type: ESetting.TEXT_FIELD,
    validateOnEnter: true,
  },
];
```

Add this group to `Settings`, and include at least `datasource` in `BasicSettings` when the component can be configured from the basic panel.

## Datasource Declarations

Declare the root datasource and every child path the component reads. This lets Qodly fetch the attributes the component needs.

**Single entity/object fields:**

```tsx
import {
  splitDatasourceID,
  T4DComponentDatasourceDeclaration,
} from '@ws-ui/webform-editor';

datasources: {
  accept: ['entity', 'object'],
  declarations: (props: any) => {
    const { datasource = '' } = props;
    const declarations: T4DComponentDatasourceDeclaration[] = [
      { path: datasource, iterable: true },
    ];
    const { id: ds, namespace } = splitDatasourceID(datasource.trim()) || {};
    if (!ds) return declarations;

    [props.nameAttr, props.emailAttr, props.phoneAttr]
      .map((attr) => attr?.trim())
      .filter((attr): attr is string => !!attr)
      .forEach((attr) => {
        const path = `${ds}.${attr}`;
        declarations.push({ path: namespace ? `${namespace}:${path}` : path });
      });

    return declarations;
  },
}
```

**Iterable entity selection/array fields:**

```tsx
datasources: {
  accept: ['entitySel', 'array'],
  declarations: (props: any) => {
    const { datasource = '' } = props;
    const declarations: T4DComponentDatasourceDeclaration[] = [
      { path: datasource, iterable: true },
    ];
    const { id: ds, namespace } = splitDatasourceID(datasource.trim()) || {};
    if (!ds) return declarations;

    [props.titleAttr, props.statusAttr, props.dueDateAttr]
      .map((attr) => attr?.trim())
      .filter((attr): attr is string => !!attr)
      .forEach((attr) => {
        const path = `${ds}.[].${attr}`;
        declarations.push({ path: namespace ? `${namespace}:${path}` : path });
      });

    return declarations;
  },
}
```

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

## Single Entity/Object

For detail components that render one selected entity or object. Pattern is the same as `qodly_map` `SingleMap`.

**Config:**
```tsx
datasources: { accept: ['entity', 'object'] },
sanityCheck: { keys: [{ name: 'datasource', require: true, isDatasource: true }] },
requiredFields: { keys: ['datasource'], all: false },
```

**Render — useSources + getValue + listener:**
```tsx
const { sources: { datasource: ds } } = useSources();
const [value, setValue] = useState<any>();

useEffect(() => {
  if (!ds) return;
  const listener = async () => {
    const v = await ds.getValue();
    setValue(v);
  };
  listener();
  ds.addListener('changed', listener);
  return () => ds.removeListener('changed', listener);
}, [ds]);
```

For nested fields, read from the root object first, then optionally fall back to `ds.getValue(attr)`.

## Entity Selection / Iterable Rows

For components that render rows from an entity selection or array. Pattern is the same as `qodly_map` `MultiMap`.

**Config:**
```tsx
datasources: { accept: ['entitySel', 'array'] },
sanityCheck: { keys: [{ name: 'datasource', require: true, isDatasource: true }] },
requiredFields: { keys: ['datasource'], all: false },
```

**Render — useDataLoader + fetchIndex:**
```tsx
import { useDataLoader, useSources } from '@ws-ui/webform-editor';

function cloneDatasource(source: datasources.DataSource): datasources.DataSource {
  const clone = Object.create(Object.getPrototypeOf(source)) as datasources.DataSource & {
    id: string;
    children: Record<string, unknown>;
  };
  Object.assign(clone, source);
  clone.id = `${source.id}_clone`;
  clone.children = {};
  return clone;
}

const { sources: { datasource } } = useSources({ acceptIteratorSel: true });
const source = useMemo(() => (datasource ? cloneDatasource(datasource) : null), [datasource]);
const { entities, fetchIndex } = useDataLoader({
  source: source as datasources.DataSource,
});

useEffect(() => {
  if (!source) return;
  fetchIndex(0);
}, [source, fetchIndex]);
```

Use `entities` as the rows. Do not rely on `datasource.getValue()` alone for entity selections; it may not send the network request.

**Build — IteratorProvider + StyleBox for nested row content:**
```tsx
import { useEnhancedEditor, selectResolver, IteratorProvider } from '@ws-ui/webform-editor';
import { Element } from '@ws-ui/craftjs-core';

const { resolver } = useEnhancedEditor(selectResolver);

return (
  <IteratorProvider>
    <Element id="container" is={resolver.StyleBox} deletable={false} canvas />
  </IteratorProvider>
);
```

## Shared Datasource (TreeNode actions)

For cross-component state. Use `window.DataSource.getSource(name, path)`:

```ts
const myDS = window.DataSource.getSource('myDS', 'shared');
myDS.setValue(null, { key: 'value' });
```

`sourcePath` is typically `'shared'`.
