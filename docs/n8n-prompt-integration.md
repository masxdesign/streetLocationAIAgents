# N8N Integration: Fetching Prompts from Database

Prompts are stored in `dbo.a_magPrompts` with `{{ $json.xxx }}` template expressions preserved as literal strings. N8N cannot recursively evaluate expressions inside fetched strings, so a Code node handles the rendering.

Each workflow needs two nodes added at the start: a query node to fetch prompts, and a Code node to build a lookup object and render user templates.

---

## 1. Fetch Prompts Node

Add an **Execute SQL** or **HTTP Request** node at workflow init that queries:

```sql
SELECT agent, prompt_type, content
FROM dbo.a_magPrompts
WHERE workflow = 'post-blog'
```

Replace `'post-blog'` with the appropriate workflow value:
- `'seo'` for the SEO phase
- `'pre-blog'` for the Pre-blog phase
- `'post-blog'` for the Post-blog phase

This returns one row per agent per prompt type (system/user).

---

## 2. Code Node: Build Lookup + Render User Templates

Add a **Code** node after the fetch node. This does two things:
1. Builds a keyed lookup object from all fetched rows
2. Renders `{{ $json.xxx }}` expressions in user prompts using runtime data

There are two approaches depending on when data is available.

### Approach A: Eager rendering (all data available upfront)

Use this when the Code node runs **after** all data the user templates reference is already in `$json`. The Code node renders everything in one pass.

```javascript
// ---------------------------------------------------------------
// Eager: render user prompts immediately
// Output: { prompts: { "Agent__system": "...", "Agent__user": "rendered..." } }
// ---------------------------------------------------------------

const promptRows = $input.all();
const prompts = {};

for (const row of promptRows) {
  const { agent, prompt_type, content } = row.json;
  const key = `${agent}__${prompt_type}`;

  if (prompt_type === 'system') {
    prompts[key] = content;
  } else {
    prompts[key] = renderTemplate(content, $json);
  }
}

return [{ json: { ...$json, prompts } }];

function renderTemplate(template, data) {
  return template.replace(/\{\{\s*(.+?)\s*\}\}/g, (match, expr) => {
    try {
      const fn = new Function('$json', 'return ' + expr);
      const result = fn(data);
      if (result === null || result === undefined) return '';
      if (typeof result === 'object') return JSON.stringify(result);
      return String(result);
    } catch (e) {
      return '';
    }
  });
}
```

### Approach B: Deferred rendering (data arrives at different stages)

Use this when different agents need data that only exists later in the workflow (e.g. Introduction Writer needs `$json.output.main_body` which is produced by an earlier agent).

**Node 1 — "Load Prompts" Code node (runs at workflow init):**

Store system prompts ready-to-use. Store user prompts as raw templates under a `__user_raw` key — do NOT render them yet.

```javascript
// ---------------------------------------------------------------
// Deferred: store user prompts as raw templates for later rendering
// Output keys:
//   "Agent__system"   → ready to use
//   "Agent__user_raw" → raw template with {{ $json.xxx }} intact
// ---------------------------------------------------------------

const promptRows = $input.all();
const prompts = {};

for (const row of promptRows) {
  const { agent, prompt_type, content } = row.json;

  if (prompt_type === 'system') {
    prompts[`${agent}__system`] = content;
  } else {
    // Store as raw — will be rendered just-in-time before each agent
    prompts[`${agent}__user_raw`] = content;
  }
}

return [{ json: { ...$json, prompts } }];
```

**Node 2+ — "Render Prompt" Code node (place one before each agent):**

By the time this node runs, `$json` has the data that agent needs. Render the raw template now.

```javascript
// ---------------------------------------------------------------
// Render one agent's user prompt just-in-time
// Place this Code node immediately before the agent node
// ---------------------------------------------------------------

const agentName = 'Introduction Writer'; // change per agent
const template = $json.prompts[`${agentName}__user_raw`];
const rendered = renderTemplate(template, $json);

return [{ json: { ...$json, rendered_user_prompt: rendered } }];

function renderTemplate(template, data) {
  return template.replace(/\{\{\s*(.+?)\s*\}\}/g, (match, expr) => {
    try {
      const fn = new Function('$json', 'return ' + expr);
      const result = fn(data);
      if (result === null || result === undefined) return '';
      if (typeof result === 'object') return JSON.stringify(result);
      return String(result);
    } catch (e) {
      return '';
    }
  });
}
```

The agent node's user prompt field then references:
```
{{ $json.rendered_user_prompt }}
```

### Which approach to use?

| Scenario | Approach |
|----------|----------|
| All agents in the workflow receive the same `$json` context | A (eager) |
| Agents run sequentially and later agents need output from earlier ones | B (deferred) |
| Mixed — some agents have full context, others don't | B (deferred) for safety |

The post-blog workflow is a clear case for **Approach B** because the Introduction Writer and Market Implications Writer both reference `$json.output.main_body`, which is only produced after the Content Writer Agent finishes.

### How `renderTemplate` works

The user.md files contain N8N-style expressions like:

```
Location:
- street: {{ $json.street }}
- borough: {{ $json.borough }}
```

When stored in the database, these are literal strings. The `renderTemplate` function:

1. Finds all `{{ ... }}` patterns via regex
2. Extracts the expression inside (e.g. `$json.street`)
3. Creates a function: `new Function('$json', 'return $json.street')`
4. Calls it with the current workflow data object
5. Returns the evaluated value as a string

This supports:
- Simple property access: `$json.street` → `"Kensington High Street"`
- Fallback expressions: `$json.suburb || "not provided"` → `"Kensington"` or `"not provided"`
- Nested access: `$json.seed.title` → `"Commercial Retail Real Estate Guide"`
- Nested output access: `$json.output.main_body` → the generated main body HTML
- Ternary expressions: `$json.nearest_stations ? JSON.stringify($json.nearest_stations) : "[]"`

### Expressions found in user.md files

For reference, here are all unique expressions used across the 8 agents:

**SEO phase — SERPs Writing KWs Insights:**
- `$json.seed.title`, `$json.seed.tone_description`, `$json.seed.keyword`
- `$json.street`, `$json.suburb`, `$json.postcode`
- `$json.borough`, `$json.neighbourhood`, `$json.reference_point`

**Pre-blog — Refine Title:**
- `$json.keywords_primary_keyword`, `$json.seed_title`
- `$json.search_intent`, `$json.semantic_analysis`
- `$json.writing_style`, `$json.writing_tone`, `$json.goal_of_article`

**Pre-blog — Key Takeaways:**
- `$json.output.new_title`, `$json.seed_title`
- `$json.hidden_insight`, `$json.search_intent`
- `$json.semantic_analysis`, `$json.keywords_secondary_keywords`
- `$json.writing_style`, `$json.writing_tone`, `$json.goal_of_article`

**Pre-blog — Outline Agent:**
- `$json.output.new_title`, `$json.keywords_primary_keyword`
- `$json.keywords_secondary_keywords`, `$json.search_intent`
- `$json.writing_style`, `$json.writing_tone`, `$json.goal_of_article`
- `$json.output.key_takeaways`, `$json.semantic_analysis`

**Post-blog — Main Body Prompt Writer:**
- `$json.keywords_primary_keyword`, `$json.new_title`
- `$json.street`, `$json.suburb`, `$json.postcode`
- `$json.borough`, `$json.neighbourhood`, `$json.reference_point`
- `$json.nearest_stations`, `$json.key_anchors`
- `$json.hidden_insight`, `$json.search_intent`
- `$json.semantic_analysis`, `$json.keywords_secondary_keywords`
- `$json.writing_style`, `$json.writing_tone`, `$json.goal_of_article`
- `$json.outline`

**Post-blog — Content Writer Agent:**
- `$json.prompt.main_body` (the entire generated prompt from the Prompt Writer agent)

**Post-blog — Introduction Writer:**
- `$json.new_title`, `$json.output.main_body`

**Post-blog — Market Implications Writer:**
- `$json.street`, `$json.suburb`
- `$json.borough`, `$json.neighbourhood`
- `$json.new_title`, `$json.output.main_body`

---

## 3. Wire Agent Nodes to Use Fetched Prompts

Each AI agent node references prompts from the lookup object instead of having them hardcoded. The exact expression depends on which approach you chose.

### System prompt field (same for both approaches)

Set to expression mode (`=`) and use:

```
{{ $json.prompts['Main Body Prompt Writer__system'] }}
```

### User prompt field

**Approach A (eager)** — already rendered in the initial Code node:
```
{{ $json.prompts['Main Body Prompt Writer__user'] }}
```

**Approach B (deferred)** — rendered just-in-time by the per-agent Code node:
```
{{ $json.rendered_user_prompt }}
```

### All agent prompt keys

| Agent | System key | User key (eager) | Raw key (deferred) |
|-------|-----------|-------------------|-------------------|
| SERPs Writing KWs Insights | `__system` | `__user` | `__user_raw` |
| Refine Title | `__system` | `__user` | `__user_raw` |
| Key Takeaways | `__system` | `__user` | `__user_raw` |
| Outline Agent | `__system` | `__user` | `__user_raw` |
| Main Body Prompt Writer | `__system` | `__user` | `__user_raw` |
| Content Writer Agent | `__system` | `__user` | `__user_raw` |
| Introduction Writer | `__system` | `__user` | `__user_raw` |
| Market Implications Writer | `__system` | `__user` | `__user_raw` |

Each key is prefixed with the agent name, e.g. `Introduction Writer__system`.

---

## 5. Testing

1. Add the fetch + Code nodes to your workflow
2. Run the workflow with test data
3. Check the Code node output — inspect `$json.prompts` to verify all keys are present and user prompts have been rendered correctly
4. Verify no `{{ $json.xxx }}` placeholders remain in the rendered user prompts
5. Confirm agent nodes produce the same output quality as when prompts were hardcoded
