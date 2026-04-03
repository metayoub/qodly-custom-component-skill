# Qodly Skills Bundle

This repository ships **three** Cursor/Claude-compatible agent skills:

| Folder | Role |
|--------|------|
| **qodly-custom-component** | Scaffold and develop **React** custom components for Qodly Studio (`@qodly/cli`, `@ws-ui/webform-editor`, build/render, settings, i18n). |
| **qodly-docs** | **Documentation** corpus (markdown/mdx): Qodly Pro, page loaders, built-in components, events, datasources, roles, custom component topics, webform-editor API notes. |
| **qodly-pages** | **Generate and edit** Qodly web pages (`.WebForm` JSON), schemas, craft components, i18n for pages, and Studio page patterns. |

## Quick Install (skills.sh)

```bash
npx skills add metayoub/qodly-custom-component-skill
```

Or install a specific skill only:

```bash
npx skills add metayoub/qodly-custom-component-skill --skill qodly-custom-component
npx skills add metayoub/qodly-custom-component-skill --skill qodly-docs
npx skills add metayoub/qodly-custom-component-skill --skill qodly-pages
```

*(If the remote package does not yet expose `qodly-docs` / `qodly-pages`, copy the folders manually as in [Installation](#installation) below.)*

## What the custom component skill covers

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
cp -r qodly-custom-component qodly-docs qodly-pages .cursor/skills/
```

**Personal scope** (all projects):

```bash
mkdir -p ~/.cursor/skills
cp -r qodly-custom-component qodly-docs qodly-pages ~/.cursor/skills/
```

Install only what you need; the three folders are independent skills (each has its own `SKILL.md`).

### Updating skills (already installed)

**Manual copy (Cursor `~/.cursor/skills` or project `.cursor/skills`)** — Do not run `cp -r` on top of an existing skill folder: the folder name can end up **nested** (e.g. `qodly-docs/qodly-docs/`). Remove the old copy, then copy again.

Update **all three** into a project:

```bash
cd /path/to/this/repo   # "Qodly skills" root
rm -rf .cursor/skills/qodly-custom-component .cursor/skills/qodly-docs .cursor/skills/qodly-pages
mkdir -p .cursor/skills
cp -r qodly-custom-component qodly-docs qodly-pages .cursor/skills/
```

Update **personal** skills the same way, targeting `~/.cursor/skills/`:

```bash
cd /path/to/this/repo
rm -rf ~/.cursor/skills/qodly-custom-component ~/.cursor/skills/qodly-docs ~/.cursor/skills/qodly-pages
mkdir -p ~/.cursor/skills
cp -r qodly-custom-component qodly-docs qodly-pages ~/.cursor/skills/
```

Update **one** skill only:

```bash
rm -rf .cursor/skills/qodly-pages
cp -r qodly-pages .cursor/skills/
```

**skills.sh** — Run the same `npx skills add …` command again; if the CLI prompts to overwrite or refresh, accept it. If your version only installs once, remove the skill from the tool’s skill directory and add again (path depends on the CLI; check `npx skills --help`).

**localskills.sh** — After the publisher runs `localskills publish` for a new version, pull updates:

```bash
localskills pull YOUR_TEAM/qodly-custom-component
localskills pull YOUR_TEAM/qodly-docs
localskills pull YOUR_TEAM/qodly-pages
```

### Option 2: GitHub

Clone or add as submodule:

```bash
git clone https://github.com/metayoub/qodly-custom-component-skill.git
cd qodly-custom-component-skill
cp -r qodly-custom-component qodly-docs qodly-pages /path/to/your/project/.cursor/skills/
```

### Option 3: localskills.sh

1. Install CLI: `npm install -g @localskills/cli`
2. Login: `localskills login`
3. Publish from this repo (repeat per skill):

```bash
cd "Qodly skills"
localskills publish qodly-custom-component/SKILL.md \
  --team YOUR_TEAM \
  --name qodly-custom-component \
  --visibility public \
  --type skill
localskills publish qodly-docs/SKILL.md \
  --team YOUR_TEAM \
  --name qodly-docs \
  --visibility public \
  --type skill
localskills publish qodly-pages/SKILL.md \
  --team YOUR_TEAM \
  --name qodly-pages \
  --visibility public \
  --type skill
```

4. Others install with: `localskills install YOUR_TEAM/qodly-custom-component` (and similarly for `qodly-docs`, `qodly-pages`).

## Renamed the GitHub repository?

### Point `origin` at the new URL (local clone)

GitHub usually redirects the old URL, but you should update the remote so pushes and fetches use the canonical URL:

```bash
git remote -v
git remote set-url origin https://github.com/YOUR_USER/YOUR_NEW_REPO.git
git fetch origin
```

### Default branch (`main`)

- **On GitHub:** Repository **Settings → General → Default branch** — set it to `main` (or whatever you use).
- **Locally** (if your local branch should track it):

```bash
git fetch origin
git branch -u origin/main main
```

(If you still have `master` and want `main`, rename with `git branch -m master main` first, then push and set the default on GitHub.)

### skills.sh and links in this README

Replace the old `owner/repo` everywhere you document it, for example:

- `npx skills add YOUR_USER/YOUR_NEW_REPO`
- Any [skills.sh](https://skills.sh/) page URLs that embed the old path

### Updating skills on localskills.sh after a repo rename

Renaming the repo on **GitHub does not change** your skill on localskills. Listings are identified by **`--team`** and **`--name`**, not by the repository URL.

**Ship a new version of the same skill** (same team + name — what most people want):

1. Commit and push your changes to the renamed repo (after fixing `origin` as above).
2. From this repo root, run **`localskills publish`** again for each skill, using the **same** `--team` and `--name` as before:

```bash
localskills publish qodly-custom-component/SKILL.md \
  --team YOUR_TEAM \
  --name qodly-custom-component \
  --visibility public \
  --type skill \
  -m "Brief note for this version"
```

Repeat for `qodly-docs/SKILL.md` and `qodly-pages/SKILL.md` if you publish those too.

3. **Consumers** update with:

```bash
localskills pull YOUR_TEAM/qodly-custom-component
localskills pull YOUR_TEAM/qodly-docs
localskills pull YOUR_TEAM/qodly-pages
```

**Only if you want a new skill slug** on localskills (separate from the old name): publish with a **new** `--name`, then share the new `YOUR_TEAM/new-name` for `install` / `pull`. The old name’s history stays on localskills unless their product offers rename/delete — check [localskills.sh](https://localskills.sh) docs for your account.

## When each skill triggers

**qodly-custom-component** — Custom React components, `@qodly/cli`, `@ws-ui/webform-editor`, Module Federation, proxy, build vs render, settings/i18n in components.

**qodly-docs** — You need Qodly Pro or Studio **documentation** (behavior of built-in components, page loaders, events, roles, deployment, webform-editor API notes).

**qodly-pages** — You are **generating or editing** Qodly web forms (`.WebForm`), JSON schemas, craft components, or page-level i18n rules.

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
