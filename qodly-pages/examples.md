# Qodly Page Examples

## Example 1: Employee Directory Page

### Data Sources

| Name | Type | Initial Value |
|---|---|---|
| `employees` | Entity Selection | `ds.Employee.all()` |
| `selectedEmployee` | Entity | — |
| `searchTerm` | Scalar (Text) | `""` |
| `departments` | Collection | — |

### Page Layout

```
┌─────────────────────────────────────────────────────────┐
│ Employee Directory                            [+ New]   │
├────────────────────────┬────────────────────────────────┤
│ Search: [___________]  │ Employee Details               │
│ Dept:   [▼ All      ]  │                                │
│ [Search]               │ First Name: [___________]      │
│                        │ Last Name:  [___________]      │
│ ┌─ DataTable ────────┐ │ Department: [▼ ________]       │
│ │ Name    │ Dept     │ │ Salary:     [___________]      │
│ │─────────┼──────────│ │ Status:     [▼ ________]       │
│ │ Alice   │ Eng      │ │                                │
│ │ Bob     │ Sales    │►│ [Save]  [Cancel]  [Delete]     │
│ │ Carol   │ Eng      │ │                                │
│ └────────────────────┘ │                                │
└────────────────────────┴────────────────────────────────┘
```

### Backend Functions

**Employee.4dm (DataClass):**
```4d
Class extends DataClass

exposed Function loadDirectory($filters : Object) -> $result : Object
    var $query : Text := ""
    var $params : Object := New object()

    If ($filters.search # Null) && ($filters.search # "")
        $query := "(firstName = :search OR lastName = :search)"
        $params.search := $filters.search + "@"
    End if

    If ($filters.department # Null) && ($filters.department # "")
        If ($query # "")
            $query := $query + " AND "
        End if
        $query := $query + "department.name = :dept"
        $params.dept := $filters.department
    End if

    var $sel : cs.EmployeeSelection
    If ($query = "")
        $sel := This.all()
    Else
        $sel := This.query($query; $params)
    End if

    $result := New object()
    $result.employees := $sel.orderBy("lastName asc")
    $result.departments := ds.Department.all().toCollection("name")
```

**EmployeeEntity.4dm (Entity):**
```4d
Class extends Entity

exposed Function saveEmployee() -> $result : Object
    var $status : Object := This.save()
    $result := New object(\
        "success"; $status.success;\
        "message"; Choose($status.success; "Employee saved"; $status.statusText)\
    )

exposed Function deleteEmployee() -> $result : Object
    var $status : Object := This.drop()
    $result := New object("success"; $status.success)
```

### Event Wiring

| Component | Event | Action |
|---|---|---|
| Page | `onLoad` | Call `ds.Employee.loadDirectory({})` → populate `employees` and `departments` |
| Search button | `onClick` | Call `ds.Employee.loadDirectory({search: searchTerm, department: selectedDept})` |
| DataTable | `onSelect` | Set `selectedEmployee` = selected entity |
| Save button | `onClick` | Call `selectedEmployee.saveEmployee()` |
| Delete button | `onClick` | Call `selectedEmployee.deleteEmployee()` → reload list |
| New button | `onClick` | Set `selectedEmployee` = `ds.Employee.new()` |

---

## Example 2: Dashboard Page

### Data Sources

| Name | Type |
|---|---|
| `stats` | Object |
| `recentHires` | Collection |
| `departmentBreakdown` | Collection |

### Backend Function

```4d
// Dashboard.4dm (Singleton)
singleton Class constructor()

exposed Function loadDashboard() -> $result : Object
    $result := New object()

    // Stats
    var $all : cs.EmployeeSelection := ds.Employee.all()
    $result.stats := New object(\
        "totalEmployees"; $all.length;\
        "averageSalary"; $all.average("salary");\
        "activeCount"; ds.Employee.query("status = :1"; "active").length;\
        "newThisMonth"; ds.Employee.query("hireDate >= :1"; (Current date - Day of(Current date) + 1)).length\
    )

    // Recent hires (last 30 days)
    $result.recentHires := ds.Employee\
        .query("hireDate >= :1"; Current date - 30)\
        .orderBy("hireDate desc")\
        .toCollection("firstName, lastName, department.name, hireDate")

    // Department breakdown
    var $depts : cs.DepartmentSelection := ds.Department.all()
    $result.departmentBreakdown := New collection()
    For each ($dept; $depts)
        $result.departmentBreakdown.push(New object(\
            "name"; $dept.name;\
            "count"; $dept.employees.length;\
            "avgSalary"; $dept.employees.average("salary")\
        ))
    End for each
```

### Page Layout

```
┌──────────────────────────────────────────────────────────┐
│ Dashboard                                                │
├──────────────┬──────────────┬──────────────┬────────────┤
│  Total: 150  │  Active: 142 │  Avg: $75K   │  New: 8    │
├──────────────┴──────────────┴──────────────┴────────────┤
│                                                          │
│  Recent Hires (DataTable)     │  By Department (Matrix)  │
│  ┌────────────────────────┐   │  ┌──────────────────┐    │
│  │ Name  │ Dept │ Date    │   │  │ Engineering: 45  │    │
│  │───────┼──────┼─────────│   │  │ Sales: 32        │    │
│  │ Alice │ Eng  │ Mar 1   │   │  │ Marketing: 28    │    │
│  │ Bob   │ HR   │ Feb 28  │   │  │ HR: 20           │    │
│  └────────────────────────┘   │  └──────────────────┘    │
└──────────────────────────────────────────────────────────┘
```

---

## Example 3: Editable Form with Validation

### Backend Function

```4d
// EmployeeEntity.4dm
exposed Function validateAndSave() -> $result : Object
    var $errors : Collection := New collection()

    // Validation rules
    If (This.firstName = Null) || (This.firstName = "")
        $errors.push("First name is required")
    End if

    If (This.lastName = Null) || (This.lastName = "")
        $errors.push("Last name is required")
    End if

    If (This.salary < 0)
        $errors.push("Salary cannot be negative")
    End if

    If (This.email # Null) && (This.email # "")
        If (Position("@"; This.email) = 0)
            $errors.push("Invalid email format")
        End if
    End if

    If ($errors.length > 0)
        $result := New object("success"; False; "errors"; $errors)
    Else
        var $status : Object := This.save()
        $result := New object(\
            "success"; $status.success;\
            "errors"; Choose($status.success; New collection(); New collection($status.statusText))\
        )
    End if
```

### Event Wiring

| Component | Event | Action |
|---|---|---|
| Save button | `onClick` | Call `currentEmployee.validateAndSave()` |
| | | If `result.success` = false → display `result.errors` in error banner |
| | | If `result.success` = true → show success message, reload list |
