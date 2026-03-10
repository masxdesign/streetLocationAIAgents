# Reverse Internal Linking Workflow

This directory contains the system and user prompts for a 2-agent workflow that adds upward interlinking to published posts. It runs after a post has been generated, injecting a contextual reference to the parent post into the introduction and producing copy for a styled aside card.

## Workflow Overview

The hierarchy is:

```
Region Post (pillar)
  └── Postcode Post (cluster)
        └── Street Post (supporting)
```

Downward links (pillar → supporting) are handled by the Internal Linking Strategist inside the Region Post and Postcode Post workflows. This workflow handles the **reverse direction** — linking each post back up to its parent.

Two agents, one per level:

1. **Street Parent Linker** — used after generating a Street Post. Rewrites the introduction to weave in a contextual link to the parent Postcode Post, and generates copy for the aside card (heading, subtext, CTA text).
2. **Postcode Parent Linker** — used after generating a Postcode Post. Rewrites the introduction to weave in a contextual link to the parent Region Post, and generates copy for the aside card.

### Output JSON schema (both agents)

```json
{
  "heading": "Explore the wider W3 area guide",
  "subtext": "This street is covered in our broader look at commercial opportunities across the Acton W3 postcode area.",
  "cta_text": "Read the W3 area guide",
  "rewritten_introduction": "..."
}
```

The N8N code node then:
1. Replaces `PARENT_ID` in `rewritten_introduction` with the actual parent post ID
2. Swaps the original introduction with `rewritten_introduction`
3. Assembles the aside card HTML using `heading`, `subtext`, `cta_text`, and the parent URL
4. Injects the aside after the introduction, before the first `##`
5. Appends BreadcrumbList JSON-LD at the end of the post

### Aside card HTML template

```html
<aside class="not-prose my-8 rounded-2xl border border-primary/20 bg-primary/5 p-5 sm:p-6">
  <p class="text-base font-semibold text-slate-800 mb-1">{heading}</p>
  <p class="text-sm text-slate-500 mb-4">{subtext}</p>
  <div class="flex flex-col sm:flex-row flex-wrap gap-2">
    <a href="/placeholder/id/{parent_id}" class="flex items-center justify-between gap-2 text-sm font-semibold text-white bg-primary rounded-lg px-4 py-2.5 hover:bg-primary/85 transition-colors">
      <span>{cta_text}</span>
      <span>→</span>
    </a>
  </div>
</aside>
```

### BreadcrumbList JSON-LD template

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "{parent_title}", "item": "/placeholder/id/{parent_id}" },
    { "@type": "ListItem", "position": 2, "name": "{current_post_title}" }
  ]
}
</script>
```

| # | Agent | Input Variables |
|---|-------|----------------|
| 1 | Street Parent Linker | `current_post_title`, `current_post_introduction`, `parent_post_title`, `parent_post_summary` |
| 2 | Postcode Parent Linker | `current_post_title`, `current_post_introduction`, `parent_post_title`, `parent_post_summary` |

---

### Model Recommendations (via OpenRouter)

| # | Agent | DB Key | Recommended Model | Temperature | Max Tokens | Why |
|---|-------|--------|-------------------|-------------|------------|-----|
| 1 | Street Parent Linker | `street-parent-linker` | `openai/gpt-4.1-mini` | `0.6` | `600` | Short creative output — prose rewrite of an introduction plus three brief copy fields. Moderate temp for natural, varied phrasing. |
| 2 | Postcode Parent Linker | `postcode-parent-linker` | `openai/gpt-4.1-mini` | `0.6` | `600` | Identical task to Street Parent Linker at a different hierarchy level. Same model and settings apply. |

**Temperature guidance:**
- `0.6` balances natural prose variation with faithfulness to the original introduction
- Lower temp risks robotic phrasing; higher temp risks drifting from the source content

**Max tokens guidance:**
- `600` covers the rewritten introduction (typically 100–300 words) plus the three short copy fields with headroom
- Do not cap below `400` — truncation would corrupt the JSON output

**Pricing reference (per 1M tokens):**

| Model | Input | Output |
|-------|-------|--------|
| GPT-4.1 mini | $0.40 | $1.60 |

**Estimated cost per run:** under $0.01 per post.
