# Publishing Qodly Custom Component Skill

## GitHub

### Option A: Publish as Standalone Repo

1. Create a new GitHub repository (e.g. `qodly-skill`).

2. Copy the skill folder:
   ```bash
   # From Component directory
   cp -r "Qodly skills" /tmp/qodly-skill-repo
   cd /tmp/qodly-skill-repo
   ```

3. Initialize git and push:
   ```bash
   git init
   git add .
   git commit -m "Initial skill: Qodly custom component"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/qodly-skill.git
   git push -u origin main
   ```

4. Add a clear README so users know how to install (see README.md).

### Option B: Publish from Existing Repo

If this lives inside your main project, users can install via:

```bash
git clone https://github.com/YOUR_USERNAME/your-repo.git
cp -r your-repo/"Qodly skills"/qodly-custom-component ~/.cursor/skills/
```

---

## localskills.sh (skills.sh)

[localskills.sh](https://localskills.sh) lets you publish skills for Cursor, Claude Code, Windsurf, and other AI tools.

### Prerequisites

- Account at [localskills.sh](https://localskills.sh)
- Node.js 18+

### Steps

1. **Install CLI**
   ```bash
   npm install -g @localskills/cli
   ```

2. **Login**
   ```bash
   localskills login
   ```
   (Use `localskills login --token YOUR_TOKEN` for CI.)

3. **Publish**
   ```bash
   cd /path/to/qodly-skill   # repo root
   localskills publish qodly-custom-component/SKILL.md \
     --team YOUR_TEAM \
     --name qodly-custom-component \
     --visibility public \
     --type skill \
     -m "Qodly custom component development skill"
   ```

   Visibility options: `private` | `unlisted` | `public`

4. **Install (for others)**
   ```bash
   localskills install YOUR_TEAM/qodly-custom-component
   ```

### Non-interactive Publish (CI/CD)

```bash
localskills publish qodly-custom-component/SKILL.md \
  --team my-team \
  --name qodly-custom-component \
  --visibility public \
  --type skill \
  -m "v1.0"
```

---

## Versioning

When you update the skill:

- **GitHub**: Commit and push; users pull or re-clone.
- **localskills.sh**: Run `localskills publish` again; each run creates a new version. Users run `localskills pull` to get updates.
