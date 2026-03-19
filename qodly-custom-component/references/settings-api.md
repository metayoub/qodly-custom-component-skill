# Qodly Custom Component — Settings API

## ESetting Types

From `@ws-ui/webform-editor`:

| Type | Use Case |
|------|----------|
| `ESetting.TEXT_FIELD` | Single-line text |
| `ESetting.NUMBER_FIELD` | Numeric value |
| `ESetting.CHECKBOX` | Boolean |
| `ESetting.SELECT` | Dropdown (options: `{ value, label }[]`) |
| `ESetting.RADIOGROUP` | Radio buttons (options with optional `icon`) |
| `ESetting.COLOR_PICKER` | Color |
| `ESetting.DATAGRID` | Table of fields (data: column definitions) |
| `ESetting.GROUP` | Group of settings (components: TSetting[]) |

## Basic Pattern

```ts
import { ESetting, TSetting } from '@ws-ui/webform-editor';
import { BASIC_SETTINGS, DEFAULT_SETTINGS, load } from '@ws-ui/webform-editor';

const commonSettings: TSetting[] = [
  { key: 'label', label: 'Label', type: ESetting.TEXT_FIELD, defaultValue: '' },
  { key: 'count', label: 'Count', type: ESetting.NUMBER_FIELD, defaultValue: 0 },
  { key: 'enabled', label: 'Enabled', type: ESetting.CHECKBOX },
  {
    key: 'variant',
    label: 'Variant',
    type: ESetting.SELECT,
    options: [
      { value: 'a', label: 'Option A' },
      { value: 'b', label: 'Option B' },
    ],
  },
  {
    type: ESetting.DATAGRID,
    key: 'items',
    name: 'Items',
    label: 'Items',
    data: [
      { key: 'label', label: 'Label', type: ESetting.TEXT_FIELD },
      { key: 'value', label: 'Value', type: ESetting.NUMBER_FIELD },
    ],
  },
];

const Settings: TSetting[] = [
  {
    key: 'properties',
    label: 'Properties',
    type: ESetting.GROUP,
    components: commonSettings,
  },
  ...load(DEFAULT_SETTINGS).filter('style.overflow', 'display', ...),
];

export const BasicSettings = [
  ...commonSettings,
  ...load(BASIC_SETTINGS).filter(...),
];
```

## Wiring in Config

```tsx
import { Settings } from '@ws-ui/webform-editor';
import MySettings, { BasicSettings } from './MyComponent.settings';

// In config:
related: {
  settings: Settings(MySettings, BasicSettings),
},
```
