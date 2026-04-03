---
id: release-notes
title: Release Notes
---



## 4D 21

### Highlights

- [Localization (i18n)](./localization.md): Launched built-in Localization support, allowing you to create multilingual applications visually—without coding. You can define supported locales, manage translation keys and literals, preview translations directly in the Studio, and allow users to switch languages at runtime using the [UserLanguage](pageLoaders/qodlySources.md#qodlysource-userlanguage) shared source.

- [Page Zoom Controls](pageLoaders/pageLoaderOverview.md#page-zoom-controls): in the header panel, allowing users to adjust the page’s zoom level for more precise component placement and layout editing.

- [Events Report](pageLoaders/pageLoaderOverview.md#events-report): Introduced the Events Report, a visual overview of all page events for components and Qodly sources complete with filtering, editing, and navigation options.

... more to come...



## 4D 20 R10

### Highlights

- [Saved Condition Go To Button](pageLoaders/states/conditionalState.md#saved-condition-integration): When a saved condition is integrated into a state, a **Go to** button now appears next to its name. Clicking it opens the full saved condition in edit mode—so you can quickly review or update it without leaving the schema view.

- [Interval Range Validation for Text Input](pageLoaders/components/textinput.md#intervals-for-date-input): For text inputs using the **interval type `Range`**, if the **start date is later than the end date**, an error message will be shown and the dates will be temporarily disabled until corrected. 

- [Matrix Selection Behavior Options](pageLoaders/components/matrix.md#properties-customization): You can now control how the **Matrix** behaves after a data update (like reloading or filtering).

- [Debugger Sidebar](./debugging.md#debugger-sidebar): A new sidebar in the code editor lets you monitor, group, enable/disable, delete, and jump to breakpoints across your entire app. It also shows a [Variables panel](./debugging.md#variables-panel) during debug sessions, so you can view local variables, current line variables, and method arguments—all in one place.

- [Built-in Shared Qodly Namespace](pageLoaders/qodlySources.md#built-in-shared-qodly-namespace): Introduced a built-in Qodly namespace available across all application pages. It provides ready-to-use qodlysources for shared data handling, including a [Location shared qodlysource](pageLoaders/qodlySources.md#qodlysource-location) that simplifies working with URL segments, query parameters, and anchors. As well as, a [UserLanguage shared qodlysource](pageLoaders/qodlySources.md#qodlysource-userlanguage) that allows runtime management of user-selected languages and lists supported locales dynamically; and a [Title shared qodlysource](pageLoaders/qodlySources.md#qodlysource-title) that enables setting the browser tab title dynamically at runtime.

- [Connection Status Handling in Renderer](rendering.md#connection-status-handling): The Renderer now displays connection status messages when the network is lost or restored during rendering. A red banner appears when disconnected, and a green banner confirms when the connection is restored.

### Behavior Changes

- **Renamed properties in the [intervals datasource](pageLoaders/components/textinput.md#params-object-properties)** of the text input component for consistency:

    - `toDay` is now `today`
    - `startingfrom` is now `startingFrom`
    - `untilto` is now `until`

- **Include Option and Interval Card Toggle**: Added visual controls to improve interval management. The [Include checkbox](pageLoaders/components/textinput.md#include-checkbox-within-the-card) lets users include or exclude specific date ranges, while the [card toggle](pageLoaders/components/textinput.md#card-toggle-top-right) allows enabling or disabling intervals without losing their configuration.

- [HTTP Handlers UI Redesign](./httpHandlers.md): Updated the UI to provide a clearer and more intuitive layout, making it easier to configure and manage request handlers.

- [Roles and Privileges UI – Button Label Update](./roles/permissionsOverview.md#clean-non-existing-resources): In the Roles and Privileges interface, the **Clear** button was renamed to **Clean** for clarity. This button appears when a resource (like an attribute) is no longer available, and lets users remove outdated permissions. 

- [Initial Value Editing in Qodly Source](pageLoaders/qodlySources.md#editing-a-qodly-source): For qodlysources with editable properties, initial values now include a **Maximize** button for fields of type `object` or `array`. Clicking the maximize icon opens a popup editor, which can also be expanded to fill the contextual panel, making it easier to edit complex or long values.

- [Date Picker Navigation in Text Input](pageLoaders/components/textinput.md#embedded-input): Users can now navigate to the next/previous month and next/previous year directly within the date picker for a smoother selection experience.
