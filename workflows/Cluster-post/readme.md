# Cluster Pillar Post Workflow

This directory contains the system and user prompts to power a 9-agent n8n workflow designed to generate comprehensive, SEO-optimized "Cluster Pillar Posts".

## Workflow Overview

When building out a topic cluster strategy, the **Pillar Post** acts as the central hub that links out to deeper, more specific **Supporting Posts**. This workflow takes your existing supporting content and generates a cohesive, high-quality pillar post formatted in pure Markdown.

The workflow uses nine sequential AI agents:

0. **The Suburb Validator:** Validates and corrects London suburb assignments for each supporting post, and normalizes post titles to a consistent format.
1. **The Content Summarizer:** Distills a full-length supporting post into a 2-3 sentence summary.
2. **The Information Architect:** Analyses the summaries, identifies 3–6 analytical themes, and generates a structured JSON outline grouped by theme.
3. **The Section Context Generator:** Reads the outline and produces a concise context brief per section (purpose, narrative angle, key points) to guide the writer.
4. **The Internal Linking Strategist:** Generates exactly one CTA sentence per supporting post with correct anchors and placeholder URLs, plus validation checks.
5. **The Main Body Writer:** Consumes the section context and link plan to write focused H2 sections — no link generation, no ID matching.
6. **The Introduction Writer:** Reads the main body draft and writes a compelling introduction that sets up the article naturally.
7. **The Conclusion Writer:** Reads the main body draft and writes a closing section that synthesises the key themes.
8. **The SEO Optimizer & Editor:** Receives the fully assembled draft plus upstream planning artifacts (`outline`, `section_context`, `link_plan`, `supporting_posts`). Runs a 7-step pipeline: Markdown validation, readability, keyword placement, link plan validation, section coherence checks, topical gap detection, and a final consistency pass.

| # | Agent | Input Variables |
|---|-------|----------------|
| 0 | Suburb Validator | `id`, `title`, `outward_code` |
| 1 | Content Summarizer | `post_title`, `draft_markdown` |
| 2 | Information Architect | `pillar_topic`, `supporting_posts` |
| 3 | Section Context Generator | `pillar_topic`, `outline`, `supporting_posts` |
| 4 | Internal Linking Strategist | `pillar_topic`, `outline`, `supporting_posts` |
| 5 | Main Body Writer | `link_plan`, `section_context`, `custom_instructions` |
| 6 | Introduction Writer | `pillar_topic`, `main_body` |
| 7 | Conclusion Writer | `pillar_topic`, `main_body` |
| 8 | SEO Optimizer | `pillar_topic`, `supporting_posts`, `outline`, `section_context`, `link_plan`, `draft_markdown`, `custom_instructions` |

> **Assembly note:** A Merge/Set node between agents 7 and 8 should concatenate the outputs into a single `draft_markdown` string in the format: `# {title}\n\n{intro}\n\n{body}\n\n{conclusion}`. It must also forward the upstream planning artifacts (`outline`, `section_context`, `link_plan`, `supporting_posts`, `pillar_topic`) so the SEO Optimizer can validate against them.

---

### Model Recommendations (via OpenRouter)

Since each agent specializes in a different task, you can mix and match models based on budget and output quality. The table below optimises for **mid-range cost with reliable quality**.

| # | Agent | DB Key | Recommended Model | Temperature | Max Tokens | Why |
|---|-------|--------|-------------------|-------------|------------|-----|
| 0 | Suburb Validator | `suburb-validator` | `openai/gpt-4.1-mini` | `0.2` | `500` | Factual lookup and title normalization. Low temp for accuracy. |
| 1 | Content Summarizer | `content-summarizer` | `openai/gpt-4.1-mini` | `0.3` | `150` | Factual extraction, very short output. Low temp keeps it grounded. |
| 2 | Information Architect | `information-architect` | `openai/gpt-4.1-mini` | `0.4` | `800` | JSON outline with analytical grouping. Slight creativity for theme naming, but must stay structured. |
| 3 | Section Context Generator | `section-context-generator` | `openai/gpt-4.1-mini` | `0.3` | `600` | Extraction task — reads summaries, outputs brief JSON. Deterministic preferred. |
| 4 | Internal Linking Strategist | `internal-linking-strategist` | `openai/gpt-4.1-mini` | `0.5` | `700` | Mechanical mapping plus varied CTA language. Small temp lift helps sentence variety. |
| 5 | **Main Body Writer** | `main-body-writer` | **`openai/gpt-4.1`** | `0.7` | `3000` | Heaviest creative writing task. Higher temp for prose variety; high token ceiling for full sections. |
| 6 | Introduction Writer | `introduction-writer` | `openai/gpt-4.1-mini` | `0.6` | `400` | Short creative output. Moderate temp for a natural, engaging opening. |
| 7 | Conclusion Writer | `conclusion-writer` | `openai/gpt-4.1-mini` | `0.6` | `350` | Short, synthesised from body content. Same logic as Introduction. |
| 8 | **SEO Optimizer** | `seo-optimizer` | **`openai/gpt-4.1`** | `0.2` | `4000` | Must reproduce the full draft with surgical edits — low temp for precision and consistency. High ceiling to avoid truncation. |

**Temperature guidance:**
- `0.2–0.4` — structured/extraction tasks (JSON, validation, summarisation)
- `0.5–0.7` — creative writing tasks (prose, CTAs, introductions)
- Never use `0.0` for prose agents — outputs become robotic

**Max tokens guidance:**
- Agents outputting JSON: set ceiling just above the largest expected response
- Main Body Writer and SEO Optimizer deal with full article length — do not cap below `3000`
- Truncated output from the SEO Optimizer corrupts the final article; `4000` is the safe floor

**Pricing reference (per 1M tokens):**

| Model | Input | Output |
|-------|-------|--------|
| GPT-4.1 mini | $0.40 | $1.60 |
| GPT-4.1 | $2.00 | $8.00 |

**Estimated cost per full pillar post run:** well under $0.10 with typical input sizes.

**Alternative (Anthropic models):** Haiku 3.5 ($0.80/$4.00) can replace GPT-4.1 mini; Sonnet 3.5 ($3.00/$15.00) can replace GPT-4.1 — but roughly 2-4x more expensive.

---

## Dynamic n8n Variables Schema

Inside the `user.md` files for these agents, you will find dynamic n8n expressions formatted as `{{ $json.[variable] }}`.
When setting up this workflow, you must map your database fields or previous node outputs to these exact variables.

Here are the data schemas and examples for the variables used across the agents:

### 1. `{{ $json.post_title }}`

- **Used in:** `1. Content Summarizer` (Title of the single supporting post)
- **Schema (Data Type):** `String`
- **Description:** Represents the title of an individual supporting post.
- **Example:**
  ```json
  "On-Page SEO Basics for 2024"
  ```

### 2. `{{ $json.pillar_topic }}`

- **Used in:** `2. Information Architect`, `3. Section Context Generator`, `4. Internal Linking Strategist`, `6. Introduction Writer`, `7. Conclusion Writer`, `8. SEO Optimizer`
- **Schema (Data Type):** `String`
- **Description:** Represents the overarching focus keyword of the pillar post.
- **Example:**
  ```json
  "Content Marketing Strategy for Startups"
  ```

### 3. `{{ $json.draft_markdown }}`

- **Used in:** `1. Content Summarizer` (raw supporting post to summarize), `8. SEO Optimizer` (assembled pillar draft to optimize)
- **Schema (Data Type):** `String` (Markdown format)
- **Description:** The large chunk of content an agent needs to either summarize or optimize.
- **Example:**
  ```text
  "Title tags and meta descriptions remain the foundation of on-page SEO. While Google sometimes rewrites them, a well-crafted title tag is your first impression in the SERPs..."
  ```

### 4. `{{ $json.supporting_posts }}`

- **Used in:** `2. Information Architect`, `3. Section Context Generator`, `4. Internal Linking Strategist`, `8. SEO Optimizer`
- **Schema (Data Type):** `JSON Array of Objects`
- **Description:** The aggregated output of supporting posts. Must include `post_id` so downstream agents can map posts correctly.
- **Example:**
  ```json
  [
    {
      "post_id": 101,
      "post_title": "Long-tail keyword research",
      "summary": "Focuses on finding low-competition keywords using free SEO tools."
    },
    {
      "post_id": 102,
      "post_title": "On-Page SEO Basics",
      "summary": "Best practices for optimizing title tags and meta descriptions."
    }
  ]
  ```

### 5. `{{ $json.outline }}`

- **Used in:** `3. Section Context Generator`, `4. Internal Linking Strategist`, `8. SEO Optimizer`
- **Schema (Data Type):** `JSON Object`
- **Description:** The structured JSON outline generated by Agent 2 (Information Architect).
- **Example:**
  ```json
  {
    "pillar_title": "The Ultimate Guide to SEO",
    "sections": [
      {
        "theme_id": "t1",
        "h2": "Keyword Research Strategies for Low-Competition Markets",
        "theme_description": "How to find and target keywords that larger competitors overlook.",
        "posts": [
          { "post_id": 101, "post_title": "Long-tail keyword research" }
        ]
      }
    ]
  }
  ```

### 6. `{{ $json.section_context }}`

- **Used in:** `5. Main Body Writer`, `8. SEO Optimizer`
- **Schema (Data Type):** `JSON Object`
- **Description:** The context brief generated by Agent 3 (Section Context Generator).
- **Example:**
  ```json
  {
    "sections": [
      {
        "theme_id": "t1",
        "section_purpose": "Establishes keyword strategy as the foundation of the SEO pillar.",
        "narrative_angle": "Focus on practical tools and methods accessible to small teams.",
        "key_points": ["Free tools like Ubersuggest", "Long-tail vs short-tail trade-offs", "Search intent alignment"]
      }
    ]
  }
  ```

### 7. `{{ $json.link_plan }}`

- **Used in:** `5. Main Body Writer`, `8. SEO Optimizer`
- **Schema (Data Type):** `JSON Object`
- **Description:** The link plan generated by Agent 4 (Internal Linking Strategist).
- **Example:**
  ```json
  {
    "sections": [
      {
        "h2": "Keyword Research Strategies for Low-Competition Markets",
        "posts": [
          {
            "post_id": 101,
            "post_title": "Long-tail keyword research",
            "cta_sentence": "For a step-by-step approach, see our guide to [Long-tail keyword research](/placeholder/id/101)."
          }
        ]
      }
    ],
    "validation": {
      "duplicate_posts": [],
      "missing_posts": [],
      "notes": []
    }
  }
  ```

### 8. `{{ $json.main_body }}`

- **Used in:** `6. Introduction Writer`, `7. Conclusion Writer`
- **Schema (Data Type):** `String` (Markdown format)
- **Description:** The main body draft output by Agent 5 (Main Body Writer).
