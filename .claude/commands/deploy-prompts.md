Deploy changed prompt files to the production database.

## Change Detection (git-first, hash-fallback)

### Step 1 — Identify changed prompt files

Run this bash command to find dirty prompt `.md` files (unstaged, staged, or untracked):

```
git status --porcelain -- "workflows/*/*/system.md" "workflows/*/*/user.md"
```

Any file with a status indicator (`M`, `A`, `??`, `MM`, `AM`, etc.) is a deploy candidate.

### Step 2 — Hash fallback (if git shows no dirty files)

If git status returns no dirty prompt files, fall back to hash comparison:

1. Use `Glob` to find all `**/system.md` and `**/user.md` under `workflows/`
2. For each file, compute its SHA-256 hash using bash: `shasum -a 256 "<file>"`
3. Query the database via MCP (`mcp__dbhub-4prop-prod__execute_sql`): `SELECT workflow, agent, prompt_type, content_hash FROM dbo.a_magPrompts`
4. Compare hashes. Any mismatch or missing row is a deploy candidate.

If both git and hash checks find zero candidates, report "Nothing to deploy" and stop.

### Step 3 — Derive DB fields from file path

For each candidate file, extract the database fields from its path:

- Path pattern: `workflows/{Workflow Name}/{#. Agent Name}/[system|user].md`
- **workflow**: the workflow folder name, lowercased with spaces replaced by hyphens:
  - `SEO` → `seo`
  - `Pre-blog` → `pre-blog`
  - `Post-blog` → `post-blog`
  - `My New Workflow` → `my-new-workflow`
- **agent**: the agent folder name with the leading number prefix (`#. `) stripped — everything after the first `. ` (dot + space):
  - `2. Main Body Prompt Writer` → `Main Body Prompt Writer`
  - `1. SERPs, Writing, KWs, Insights` → `SERPs, Writing, KWs, Insights`
- **prompt_type**: the filename without extension: `system` or `user`

### Step 4 — Deploy each changed file

For each candidate, run:

```bash
node scripts/deploy-prompt.js --workflow "<workflow>" --agent "<agent>" --type "<prompt_type>" --file "<relative_path_to_file>"
```

The script outputs JSON with an `action` field: `inserted`, `updated`, or `skipped`.

Collect all results.

### Step 5 — Git commit

After all upserts succeed:

1. `git add` all the deployed `.md` files (only the ones that were actually deployed)
2. Create a commit with a message summarising what was deployed. Format:

```
Deploy N prompt update(s): <agent1> <type1>, <agent2> <type2>, ...
```

Example: `Deploy 3 prompt update(s): Main Body Prompt Writer system, Main Body Prompt Writer user, Introduction Writer system`

### Step 6 — Report

Print a summary:
- Number deployed (inserted + updated)
- Number skipped
- List of deployed files with their action
- Git commit SHA
