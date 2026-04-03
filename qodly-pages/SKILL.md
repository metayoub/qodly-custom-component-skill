---
name: qodly-pages
description: >-
  Create Qodly pages (web forms) for Qodly Pro and 4D applications using craft
  components, data sources, events, and server-side functions. Use when building
  Qodly pages, designing web UIs, creating web forms, working with Qodly Studio,
  binding data to components, or setting up Qodly events and data sources.
---

# Qodly Pages

## Important Rules

1. **Always use the project's crafted components first.** Each project has its own crafted components defined in `Project/Sources/WebForms/crafted_components.json`. Before generating component JSON from scratch, read this file from the current project. If the developer has defined reusable crafted components there, use them in your page designs. Only generate raw component structures when no matching crafted component exists in that project.

2. **Use existing pages as reference.** If the project contains `.WebForm` files in `Project/Sources/WebForms/`, read them to understand the project's conventions — component structure, styling patterns, naming, event wiring, and datasource usage. Match the existing style and patterns when generating or modifying pages. Only generate from scratch (using the schemas in `Schemas/`) when no existing pages are available.

3. **Keep i18n in sync.** When using i18n translations in WebForms, always update `Project/Sources/Shared/i18n.json` with any new translation keys. Ensure **all** text content is translated for **every** supported language. In the WebForm JSON, i18n involves three parts:

   **a) `props.doc` — use `"type": "i18n"` inline spans:**
   ```json
   { "type": "i18n", "children": [{ "text": "Login", "bold": true, ... }], "__i18n": "connect", "id": 1773401140052, "__baseValue": "Connexion SSO" }
   ```
   The `__i18n` value is the key in `i18n.json`, `__baseValue` is the base text, and `children.text` is the default-language display text.

   **b) `custom.__t` — translation metadata:**
   - For **Text** components: `__t.doc` contains metadata with `{ children: [null, { children: [{ text: { key: "<i18n_key>", default: "<default_text>" } }] }] }`, plus per-language empty doc placeholders (e.g. `"en": { "doc": [] }`, `"fr": { "doc": [] }`).
   - For **Button** components: `__t.text` is `{ "key": "<i18n_key>", "default": "<default_text>" }`.

   **c) `custom["i18n:<lang>"]` — per-language translated content:**
   - For **Text**: `"i18n:en": { "doc": [{ "type": "paragraph", "children": [{ "text": "SSO Login", "bold": true }] }] }`
   - For **Button**: `"i18n:en": { "text": "Connect with SSO" }`

   You must include an `i18n:<lang>` entry for **every** supported language in the project.

4. **Use WebForm Loaders inside Tabs.** When using the Tabs component, do **not** put all tab content directly in the same page. Instead, place a WebForm Loader (page loader) inside each tab panel and load the tab's content from a separate `.WebForm` page. This keeps the studio responsive and improves runtime performance by loading each tab's data and elements on demand. If a datasource (Qodly source) needs to be accessed across multiple tabs, declare it as a **shared datasource** so all tab pages can reference it.

## Reference Documentation

For detailed Qodly documentation (components, events, datasources, styling, roles, permissions, deployment, etc.), read the **qodly-docs** skill (sibling folder `qodly-docs/` in the same repo, or `~/.cursor/skills/qodly-docs/` when installed). Key sections:
- `4DQodlyPro/pageLoaders/components/` — individual component docs (DataTable, Tabs, Button, Text, SelectBox, etc.)
- `4DQodlyPro/pageLoaders/events/` — event management and binding actions
- `4DQodlyPro/pageLoaders/qodlySources.md` — Qodly datasources
- `4DQodlyPro/pageLoaders/styling.md` — CSS and styling
- `4DQodlyPro/pageLoaders/craftedComponents.md` — crafted components
- `4DQodlyPro/localization.md` — i18n / localization
- `4DQodlyPro/roles/` — roles, privileges, and permissions
- `Integrations/customComponent/` — custom component development

## Overview

Qodly pages are web forms built in Qodly Studio that run on top of 4D Server.
They use:
- **Craft components** — reusable UI building blocks
- **Data sources** — bindings to ORDA data (entities, selections, scalars)
- **Events** — interactions that trigger server-side 4D functions
- **CSS classes** — styling via Qodly's style system

## Page Architecture

```
WebForm (Page)
├── Data Sources (bindings to backend data)
├── Components (UI elements from craft library)
│   ├── Properties (configuration)
│   ├── Data bindings (linked to data sources)
│   └── Events (onClick, onChange, onLoad, etc.)
└── Functions (exposed 4D class functions called by events)
```

## Data Sources

Data sources connect UI components to backend data. Types:

| Type | Description | Example |
|---|---|---|
| **Entity** | Single record | `ds.Employee.get(42)` |
| **Entity Selection** | List of records | `ds.Employee.all()` |
| **Scalar** | Simple value (text, number, bool) | A search term, a counter |
| **Object** | Structured data | Configuration, form state |
| **Collection** | List of values | Dropdown options |

### Binding Data Sources

Data sources are declared on the page and bound to components:

1. Create a data source in the page's data source panel
2. Set its type (entity, selection, scalar, etc.)
3. Bind it to a component property (e.g., a DataTable's `dataSource`, an Input's `value`)

### Loading Data on Page Load

Use the `onLoad` event of the page to call an exposed function that populates data sources:

```4d
// EmployeePage.4dm (or a DataClass function)
exposed Function loadPageData() -> $result : Object
    $result := New object()
    $result.employees := ds.Employee.query("status = :1"; "active")\
        .orderBy("lastName asc")\
        .toCollection("firstName, lastName, department.name, salary")
    $result.departments := ds.Department.all().toCollection("name, id")
```

## Events

Components emit events that call server-side functions:

| Event | Triggers When |
|---|---|
| `onLoad` | Page loads |
| `onClick` | User clicks component |
| `onChange` | Value changes (inputs, selects) |
| `onSubmit` | Form submission |
| `onSelect` | Row/item selected |
| `onSort` | Column sort requested |
| `onHeaderClick` | Table header clicked |

### Event → Function Flow

1. User interacts with component (e.g., clicks a button)
2. Event fires with context (data source values, component state)
3. Calls an `exposed` function on a 4D class
4. Function processes data and returns result
5. Result updates data sources → UI re-renders

### Example: Search Button

Component: Button with `onClick` event
Calls: `ds.Employee.search($criteria)`

```4d
// Employee.4dm (DataClass)
exposed Function search($criteria : Object) -> $result : cs.EmployeeSelection
    var $query : Text := ""
    var $params : Object := New object()

    If ($criteria.name # Null) && ($criteria.name # "")
        $query := "firstName = :name OR lastName = :name"
        $params.name := $criteria.name + "@"
    End if

    If ($query = "")
        $result := This.all()
    Else
        $result := This.query($query; $params)
    End if
```

## Page Design Patterns

### List + Detail Pattern

Two panels: a list (DataTable/Matrix) on the left, detail form on the right.

1. **Data sources**: `employeeList` (entity selection), `selectedEmployee` (entity)
2. **List component**: DataTable bound to `employeeList`
3. **onSelect event**: Sets `selectedEmployee` to the clicked row's entity
4. **Detail panel**: Input fields bound to `selectedEmployee.firstName`, etc.
5. **Save button**: Calls `selectedEmployee.save()`

### Search + Results Pattern

1. **Data sources**: `searchTerm` (scalar text), `results` (entity selection)
2. **Search input**: Bound to `searchTerm`
3. **Search button**: `onClick` calls exposed function with `searchTerm` value
4. **Results table**: Bound to `results` data source

### CRUD Form Pattern

1. **Data sources**: `currentEmployee` (entity)
2. **Form inputs**: Bound to entity attributes
3. **Buttons**:
   - "New" → calls `ds.Employee.new()` to create empty entity
   - "Save" → calls `currentEmployee.save()`
   - "Delete" → calls `currentEmployee.drop()`
   - "Cancel" → calls `currentEmployee.reload()`

## Exposed Functions for Qodly

All functions called from Qodly pages must be `exposed`:

```4d
// DataClass level
exposed Function myFunction($param : Text) -> $result : Object

// Entity level
exposed Function myEntityFunction() -> $result : Object

// Singleton level (for non-data operations)
exposed Function myUtility($input : Object) -> $result : Object
```

## CSS & Styling

Qodly uses a class-based CSS system:
- Apply CSS classes to components via the style panel
- Use Qodly's built-in theme variables for consistency
- Custom CSS can be added to the page or project level

## Craft Components

Craft components are the building blocks for Qodly pages. See [craft-components.md](craft-components.md) for the component catalog with properties, events, and usage patterns.

## Additional Resources

- For component catalog, see [craft-components.md](craft-components.md)
- For page examples, see [examples.md](examples.md)

## Official 4D Documentation

The backend for Qodly pages runs on 4D. Consult docs at `.cursor/skills/4d-docs/` for:

- **REST API**: `.cursor/skills/4d-docs/REST/` — how exposed functions are called via REST, filtering, sorting, entity sets
- **ORDA**: `.cursor/skills/4d-docs/ORDA/` — data model classes, privileges, entity selections (powers data sources)
- **API classes**: `.cursor/skills/4d-docs/API/` — DataClassClass, EntityClass, EntitySelectionClass (for exposed functions)
- **Web Server**: `.cursor/skills/4d-docs/WebServer/` — server configuration underlying Qodly
- **Users & permissions**: `.cursor/skills/4d-docs/Users/` — user management and access control

Read the relevant files when designing Qodly pages to ensure data bindings and exposed functions follow the correct API.
