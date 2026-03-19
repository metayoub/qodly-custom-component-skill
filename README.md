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

- Initializing new custom component projects (`qodly new component`)
- Scaffolding new components (`scripts/scaffold-component.sh`)
- Project structure (config, build, render, settings)
- `@ws-ui/webform-editor` patterns (T4DComponentConfig, useEnhancedNode, useRenderer, useSources)
- Datasource patterns (array, entitysel, IteratorProvider)
- Vite + Module Federation + proxy setup for Qodly development
- Settings API (ESetting types, DATAGRID, etc.)
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

## Scaffold Script

To scaffold a new component inside an existing Qodly project:

```bash
# Copy script to your project root
cp qodly-custom-component/scripts/scaffold-component.sh /path/to/your/qodly-project/
cd /path/to/your/qodly-project
chmod +x scaffold-component.sh
./scaffold-component.sh MyComponent
./scaffold-component.sh Carousel --datasource entitysel
```

Then add the import/export to `src/components/index.tsx`.

## References

- [skills.sh](https://skills.sh/metayoub/qodly-custom-component-skill/qodly-custom-component) — Install via `npx skills add metayoub/qodly-custom-component-skill`
- [Qodly Custom Component Docs](https://developer.4d.com/qodly/Integrations/customComponent/overview)
- [Community Components (GitHub)](https://github.com/qodly/custom-components)

## Version

Compatible with Qodly Studio - 4D 21.

## License

MIT
