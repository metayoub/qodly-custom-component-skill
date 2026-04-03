# Craft Components Catalog

This file contains the catalog of craft components available for building Qodly pages.
Add your craft component specifications here as you document them.

## Component Template

Use this template to document each craft component:

```
### ComponentName

**Description:** What this component does.

**Category:** Layout | Input | Display | Navigation | Data

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `propertyName` | `type` | `default` | What it does |

**Data Binding:**
- `dataSource`: What data it expects (entity, selection, scalar, etc.)
- `value`: What attribute/path it binds to

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onClick` | `{...}` | When fired and what data is passed |

**Usage Example:**
Description of how to use this component in a page layout.
```

---

## Core Components

### DataTable

**Description:** Displays tabular data from an entity selection or collection.

**Category:** Data

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `dataSource` | Entity Selection / Collection | — | Data to display |
| `columns` | Array of column config | — | Column definitions |
| `pageSize` | Integer | 20 | Rows per page |
| `sortable` | Boolean | true | Allow column sorting |
| `selectable` | Boolean | true | Allow row selection |

**Data Binding:**
- Bind to an entity selection data source
- Columns map to entity attributes

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onSelect` | Selected entity | Row selected |
| `onSort` | Column name, direction | Column header clicked |
| `onHeaderClick` | Column name | Header interaction |

---

### Input (Text)

**Description:** Text input field for data entry.

**Category:** Input

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `value` | Text | — | Current value |
| `placeholder` | Text | — | Placeholder text |
| `label` | Text | — | Field label |
| `required` | Boolean | false | Required validation |
| `readOnly` | Boolean | false | Disable editing |

**Data Binding:**
- `value` binds to a scalar data source or entity attribute path

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onChange` | New value | Value changed |

---

### Button

**Description:** Clickable action button.

**Category:** Input

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `label` | Text | — | Button text |
| `variant` | Text | "primary" | Style variant (primary, secondary, danger) |
| `disabled` | Boolean | false | Disable button |
| `icon` | Text | — | Icon name |

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onClick` | — | Button clicked |

---

### Select (Dropdown)

**Description:** Dropdown selection component.

**Category:** Input

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `value` | Variant | — | Selected value |
| `options` | Collection | — | Available options |
| `placeholder` | Text | "Select..." | Placeholder |
| `label` | Text | — | Field label |

**Data Binding:**
- `options` binds to a collection or entity selection
- `value` binds to a scalar data source

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onChange` | Selected value | Selection changed |

---

### Checkbox

**Description:** Boolean toggle checkbox.

**Category:** Input

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `value` | Boolean | false | Checked state |
| `label` | Text | — | Label text |

**Data Binding:**
- `value` binds to a boolean scalar or entity attribute

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onChange` | Boolean | State toggled |

---

### Text (Label)

**Description:** Static or dynamic text display.

**Category:** Display

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `value` | Text | — | Text content |
| `format` | Text | — | Display format |

**Data Binding:**
- `value` binds to a scalar data source or entity attribute

---

### Image

**Description:** Displays an image from a URL or picture attribute.

**Category:** Display

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `source` | Text / Picture | — | Image source |
| `alt` | Text | — | Alt text |
| `width` | Text | "auto" | Width |
| `height` | Text | "auto" | Height |

---

### Matrix (Repeater)

**Description:** Repeats a template layout for each item in a collection or entity selection.

**Category:** Data

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `dataSource` | Entity Selection / Collection | — | Data to iterate |
| `orientation` | Text | "vertical" | Layout direction |

**Data Binding:**
- Each child component can bind to the current iteration item's attributes

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onSelect` | Current item | Item selected |

---

### Tabs

**Description:** Tabbed container for organizing content sections.

**Category:** Layout

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `tabs` | Collection | — | Tab definitions (label, icon) |
| `selectedIndex` | Integer | 0 | Active tab |

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onChange` | Tab index | Tab switched |

---

### Dialog (Modal)

**Description:** Modal overlay for focused interactions.

**Category:** Layout

**Properties:**
| Property | Type | Default | Description |
|---|---|---|---|
| `visible` | Boolean | false | Show/hide |
| `title` | Text | — | Dialog title |
| `width` | Text | "500px" | Dialog width |
| `closable` | Boolean | true | Show close button |

**Events:**
| Event | Payload | Description |
|---|---|---|
| `onClose` | — | Dialog closed |

---

## Adding Your Custom Components

Document your custom craft components below using the template above.

<!-- 
Add custom craft components here. For each component, include:
- Description
- Properties table
- Data binding info
- Events table
- Usage example

This file will grow as you document more components.
-->
