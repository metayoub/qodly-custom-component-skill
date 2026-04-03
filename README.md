# Qodly Custom Component Skill

A Cursor/Claude Agent Skill for creating and developing **Qodly Studio Custom Components**—React-based building blocks that extend Qodly Pages.

## Quick Install (skills.sh)

```bash
npx skills add metayoub/qodly-custom-component-skill
```

Or install the specific skill only:

```bash
npx skills add metayoub/qodly-custom-component-skill --skill qodly-custom-component
```

## What This Skill Covers

- Initializing new custom component projects (`npx @qodly/cli init`)
- Adding components inside a project (`npx @qodly/cli new component` / `npm run generate:component`)
- Project structure (config, build, render, settings)
- `@ws-ui/webform-editor` patterns (T4DComponentConfig, useEnhancedNode, useRenderer, useSources)
- Datasource patterns (array, entitysel, IteratorProvider)
- Vite + Module Federation + proxy setup for Qodly development
- Settings API (ESetting types, DATAGRID, I18NFIELD, etc.)
- i18n (`getStaticFeaturesExperimentalFlag('i18n')`, `useI18n`, `i18n.keys`)
- Troubleshooting (proxy, federation, datasource)

## Installation

### Option 1: Cursor (Project or Personal)

**Project scope** (shared with repo):

```bash
mkdir -p .cursor/skills
cp -r qodly-custom-component .cursor/skills/
```

**Personal scope** (all projects):

```bash
mkdir -p ~/.cursor/skills
cp -r qodly-custom-component ~/.cursor/skills/
```

### Option 2: GitHub

Clone or add as submodule:

```bash
git clone https://github.com/metayoub/qodly-custom-component-skill.git
cp -r qodly-custom-component-skill/qodly-custom-component .cursor/skills/
```

### Option 3: localskills.sh

1. Install CLI: `npm install -g @localskills/cli`
2. Login: `localskills login`
3. Publish from this repo:

```bash
cd "Qodly skills"
localskills publish qodly-custom-component/SKILL.md \
  --team YOUR_TEAM \
  --name qodly-custom-component \
  --visibility public \
  --type skill
```

4. Others install with: `localskills install YOUR_TEAM/qodly-custom-component`

## When the Skill Triggers

The agent uses this skill when you ask about:

- Qodly custom components
- Scaffolding a new Qodly component
- `@ws-ui/webform-editor`, `@qodly/cli`
- Module Federation for Qodly
- proxy.config for Qodly dev server
- Build vs Render patterns in Qodly components

## CLI: new project vs new component

**New project** (full setup):

```bash
npx @qodly/cli init
```

**New component** inside an existing project:

```bash
npx @qodly/cli new component
```

Then confirm exports in `src/components/index.tsx` if needed.

## References

- [skills.sh](https://skills.sh/metayoub/qodly-custom-component-skill/qodly-custom-component) — Install via `npx skills add metayoub/qodly-custom-component-skill`
- [Qodly Custom Component Docs](https://developer.4d.com/qodly/Integrations/customComponent/overview)
- [Community Components (GitHub)](https://github.com/qodly/custom-components)

## Version

Compatible with Qodly Studio - 4D 21.

## License

MIT
