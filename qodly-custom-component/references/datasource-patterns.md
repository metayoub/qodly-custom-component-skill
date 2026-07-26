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

For detail components that render one selected entity or object.

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

For components that render rows from an entity selection or array. Choose the refresh strategy based on whether the component owns row selection.

**Config:**
```tsx
datasources: { accept: ['entitySel', 'array'] },
sanityCheck: { keys: [{ name: 'datasource', require: true, isDatasource: true }] },
requiredFields: { keys: ['datasource'], all: false },
```

**Render baseline — useDataLoader + fetchIndex:**
```tsx
import { useDataLoader, useSources } from '@ws-ui/webform-editor';

const {
  sources: { datasource: ds },
} = useSources({ acceptIteratorSel: true });

const { entities, fetchIndex } = useDataLoader({
  source: ds as datasources.DataSource,
});

useEffect(() => {
  if (!ds) return;
  void fetchIndex(0);
}, [ds]);
```

Use `entities` as the UI rows. Do not rely on `datasource.getValue()` alone for entity selections; it may not send the network request.

**Display-only iterable refresh:**

Use this when the component does not manage `currentElement` or selected row state.

```tsx
const fetchRef = useRef(fetchIndex);

useEffect(() => {
  fetchRef.current = fetchIndex;
}, [fetchIndex]);

useEffect(() => {
  if (!ds) return;

  const fetch = () => {
    void fetchRef.current(0);
  };

  fetch();
  ds.addListener('changed', fetch);
  return () => ds.removeListener('changed', fetch);
}, [ds]);
```

Keep fetch functions in refs when needed. Avoid effects that depend on unstable `fetchIndex`/`setStep` and also call them; that can create a render/fetch loop and freeze the browser.

**Selection-aware iterable refresh — useDsChangeHandler:**

Use this only when the component has a selected row/current element or writes the selected row to `currentElement`.

```tsx
import { useDataLoader, useDsChangeHandler, useSources } from '@ws-ui/webform-editor';

const {
  sources: { datasource: ds, currentElement: currentDs },
} = useSources({ acceptIteratorSel: true });

const { setStep, page, entities, fetchIndex } = useDataLoader({
  source: ds as datasources.DataSource,
});

const [selected, setSelected] = useState(-1);
const [scrollIndex, setScrollIndex] = useState(0);
const [count, setCount] = useState(0);
const [pageSize, setPageSize] = useState(100);

useDsChangeHandler({
  source: ds as datasources.DataSource,
  currentDs: currentDs as datasources.DataSource,
  selected,
  scrollIndex,
  setSelected,
  setScrollIndex,
  setCount,
  fetchIndex,
  onDsChange: ({ length, selected }) => {
    if (selected >= 0 && selected >= length) {
      setSelected(0);
    }
  },
});

useEffect(() => {
  if (!ds) return;

  const isScalarArray = ds.type === 'scalar' && ds.dataType === 'array';
  const isRootIterator = !ds.parentSource;

  if (!isScalarArray && isRootIterator) {
    const nextPageSize = ds.getPageSize();
    setPageSize(nextPageSize);
    setStep({ start: 0, end: nextPageSize });
  }

  void fetchIndex(0);
}, []);

useEffect(() => {
  if (count > entities.length) {
    setStep({ start: 0, end: Math.max(count, page.end, pageSize) });
    void fetchIndex(0);
  }
}, [count]);
```

Do not call `useDsChangeHandler` conditionally. Do not use `count !== entities.length` as a fetch trigger; when the datasource shrinks or loader state lags, that can loop. Prefer `count > entities.length` or another monotonic/guarded condition.

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
