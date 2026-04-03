---
id: debugging
title: Debugging
---
import Column from '@site/src/components/Column'

Errors are a common occurrence when writing code. It is unusual to write a substantial amount of code without encountering any errors. Fortunately, dealing with and resolving errors is a routine part of the development process.


In the Qodly development environment, you have access to a range of debugging tools to help you tackle different types of errors effectively.


## Starting a debug session

To execute your code line-by-line and evaluate expressions, you must initiate a **debug session** on the server and **attach** it to your browser. Follow these steps:






:::info
<Column.List align="center" justifyContent="between">
    <Column.Item width="75%">
        You can only have one active debug session per instance. If another instance of the application has an active debug session (e.g., started from another browser), the debug button will display a warning message.
    </Column.Item>
    <Column.Item width="20%">
    </Column.Item>
</Column.List>
:::

In such cases, you must wait until the other debug session is closed before starting a new one.

:::tip
Verify that the method or function with the breakpoint is saved and not in [draft state](#breakpoint-status) for the breakpoint to take effect during debugging.
:::

## Stopping a debug session

If you wish to stop a debug session, follow these steps:

1. Click the **Debug** button in Qodly Studio toolbar while a debug session is active.

2. A warning dialog box will prompt you to confirm whether you want to detach the debugger, effectively closing the debug session attached to your browser. You will have several options:  

<Column.List align="center" justifyContent="between">
    <Column.Item width="55%">
        <ul>
            <ul>
                <li><strong>Keep in progress</strong>: Qodly will continue evaluating the code until the end of the current method or function, and then the debugger will be detached.<br/></li>
                <li><strong>Stop</strong>: The debugger will be immediately detached.<br/></li>
                <li><strong>Cancel</strong>: The debugger will not be detached.<br/></li>                                        
            </ul>
        </ul>
    </Column.Item>
    <Column.Item width="40%">
    </Column.Item>
</Column.List>



## Breakpoints

Breakpoints allow you to pause code execution at specific points in your code. You can set breakpoints on any line of code where you want the execution to halt. Here's how to create a breakpoint:



3. At this point, you can use the debugger panel at the bottom of the window to evaluate and debug your code.

:::warning
Should a function appear unexpectedly, even without any breakpoints in your code while the debugger is active, it implies the existence of an error within that specific code section.
:::

### Breakpoint Status

Breakpoints can have different statuses depending on the context, which are represented by their appearance and tip:


|Appearance|Status|Context|
|---|---|---|

## Debugger Sidebar

The **Debugger Sidebar** provides a centralized interface to monitor and manage all breakpoints across an application. It is designed to give developers full visibility into their active, disabled, or grouped breakpoints—regardless of which file or method they belong to.

You can open the Debugger Sidebar from the left-hand panel in the code editor:

<Column.List align="center" justifyContent="between">
    <Column.Item width="55%">
        <ol>
            <li>Open Qodly Studio.<br/></li>
            <li>In the code editor, look for the vertical tab on the left side.<br/></li>
            <li>Click the sidebar icon to open the Debugger Sidebar<br/></li>                                        
        </ol>
    </Column.Item>
    <Column.Item width="40%">
    </Column.Item>
</Column.List>

:::info
You can interact with all breakpoints even if they’re in different files — no need to open each one manually. The Breakpoints Sidebar saves time and helps you stay focused when debugging large apps.
:::

### Sidebar Structure

The Breakpoints Sidebar displays all breakpoints grouped by file path and method or class name. For each breakpoint, the following information and actions are available:

<Column.List align="center" justifyContent="between">
    <Column.Item width="55%">
        <ol>
            <li>Breakpoint label: Indicates the method or class and line number where the breakpoint is defined.<br/></li>
            <li>Status checkbox: Marks whether the breakpoint is currently active or disabled.<br/></li>
            <li>Line number: Shown on the right to indicate the exact position within the code.<br/></li> 
            <li>Action icons: Provide quick access to delete, or navigate to a breakpoint once you hover over a breakpoint.<br/></li>                                        
        </ol>
    </Column.Item>
    <Column.Item width="40%">
    </Column.Item>
</Column.List>

:::info
For more information, please refer to the [Managing Breakpoints](#managing-breakpoints) section.
:::


### Variables Panel

During a debug session, the debugger sidebar also includes a **Variables section**. This panel helps you inspect the state of your code at any given moment by displaying:

- **Local Variables**: Displays all variables that are currently in scope within the method or class being executed. This includes any variables you've defined inside that function or block of code.

- **Current Line Variable**: Highlights the specific variable being accessed or modified on the line of code currently being executed.

- **Arguments**: Lists the arguments passed into the method, function, or class. These represent the input values the current code is working with, as provided by the calling context.

This makes it easier to understand the current context, trace issues, and test assumptions while stepping through your code.


## Managing Breakpoints

### Breakpoint Activation

Each breakpoint is associated with an activation checkbox:



### Breakpoint Deletion

Breakpoints can be removed individually or in groups:


- An overflow menu (⋮) provides additional bulk removal options:
    <Column.List align="center" justifyContent="between">
        <Column.Item width="45%">
            <ul>
                <li><strong>Remove Breakpoints in the Current File</strong>: Clears all breakpoints from your active file.<br/></li>
                <li><strong>Remove Breakpoints in Other Files</strong>: Removes all breakpoints from non-active files.<br/></li>
                <li><strong>Remove Breakpoints in All Files</strong>: Eliminates all breakpoints across the entire project.<br/></li>  
            </ul>
        </Column.Item>
        <Column.Item width="50%">
        </Column.Item>
    </Column.List>

### Breakpoint Navigation



### Collapse/Expand Groups



## Using Qodly debugger on 4D Server

When using Qodly pages in a deployed 4D Server application (interpreted mode), you might encounter some cases where you need to debug your pages on the server, for example when a specific user configuration is required. In this case, you can attach the Qodly Studio debugger to the 4D Server and then, benefit from its features when executing your Qodly pages.

Note that in this case, the Qodly Studio debugger will display all the code executed on the server, in accordance with the [attached debugger rule on 4D Server](https://developer.4d.com/docs/Debugging/debugging-remote#attached-debugger).  

To attach the Qodly Studio debugger to your running 4D Server application:

1. Open Qodly Studio from 4D Server.

:::note

The project must be running in interpreted mode so that **Qodly Studio** menu item is available.

:::

2. In the Qodly Studio toolbar, click on the **Debug** button.<br/>


If the debugger is already attached to a another machine or another Qodly Studio page, an error is displayed. You have to detach it beforehand from the other location.

To detach the Qodly Studio debugger from your running 4D Server application:

1. Click the **Debug** button in the Qodly Studio toolbar while a debug session is active.
A warning dialog box will prompt you to confirm whether you want to detach the debugger.
2. Select **Keep in progress** to continue evaluating the code until the end of the current method or function before detaching the debugger, or **Stop** to detach the debugger immediately.

