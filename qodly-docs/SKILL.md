---
name: qodly-docs
description: >-
  Qodly Pro and Qodly Studio product documentation (markdown). Use when you need
  authoritative reference for Qodly page loaders, built-in components, events,
  datasources, styling, templates, states, localization, roles and permissions,
  deployment, debugging, HTTP handlers, custom components integration, or
  webform-editor API release notes—prefer reading files in this skill over
  guessing from general 4D knowledge.
---

# Qodly Docs (reference corpus)

This folder is a **documentation bundle** for agents and humans. It is not a runnable app: use it by **reading the markdown (and mdx) files** that match the topic.

## How to use this skill

1. **Search by topic** under the paths below and open the closest matching `.md` or `.mdx` file.
2. For **custom React components** (T4D, `@ws-ui/webform-editor`), start under `Integrations/customComponent/` and the webform-editor versioned API notes.
3. For **Qodly Studio pages** (web forms, craft components, events), start under `4DQodlyPro/pageLoaders/`.
4. Pair with the **qodly-pages** skill when the task is to **author or modify** `.WebForm` JSON, schemas, or page structure; use **qodly-docs** here to **look up** behavior and semantics.

## Layout

| Path | Contents |
|------|----------|
| `4DQodlyPro/` | Qodly Pro: studio, settings, coding, deploy, localization, rendering, HTTP handlers, notes |
| `4DQodlyPro/pageLoaders/` | Page loaders overview, templates, styling, states, events, Qodly sources, date/time formats, crafted components |
| `4DQodlyPro/pageLoaders/components/` | One doc per built-in component (Button, DataTable, Tabs, Text, …) |
| `4DQodlyPro/pageLoaders/events/` | Event management and binding actions |
| `4DQodlyPro/roles/` | Roles, privileges, permissions (datastore, dataclass, attributes, function level) |
| `Integrations/customComponent/` | Custom component overview, setup, structure |
| `Integrations/customComponent/api-reference/webform-editor/` | Versioned webform-editor API reference (`.mdx`) |

## Other files

- `preprocessing.conf` — tooling/config for doc preprocessing; ignore unless you are maintaining the doc pipeline.

## Official sources

When this corpus might be stale, cross-check [Qodly documentation on developer.4d.com](https://developer.4d.com/qodly/).
