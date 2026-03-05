# Cluster Pillar Post Workflow

This directory contains the system and user prompts to power an 8-agent n8n workflow designed to generate comprehensive, SEO-optimized "Cluster Pillar Posts".

## Workflow Overview

When building out a topic cluster strategy, the **Pillar Post** acts as the central hub that links out to deeper, more specific **Supporting Posts**. This workflow takes your existing supporting content and generates a cohesive, high-quality pillar post formatted in pure Markdown.

The workflow uses eight sequential AI agents:

1. **The Content Summarizer:** Distills a full-length supporting post into a 2-3 sentence summary.
2. **The Information Architect:** Analyses the summaries, identifies 3–6 analytical themes, and generates a structured JSON outline grouped by theme.
3. **The Section Context Generator:** Reads the outline and produces a concise context brief per section (purpose, narrative angle, key points) to guide the writer.
4. **The Internal Linking Strategist:** Generates exactly one CTA sentence per supporting post with correct anchors and placeholder URLs, plus validation checks.
5. **The Main Body Writer:** Consumes the section context and link plan to write focused H2 sections — no link generation, no ID matching.
6. **The Introduction Writer:** Reads the main body draft and writes a compelling introduction that sets up the article naturally.
7. **The Conclusion Writer:** Reads the main body draft and writes a closing section that synthesises the key themes.
8. **The SEO Optimizer & Editor:** Receives the fully assembled draft (title + intro + body + conclusion) and polishes it, enforcing strict Markdown output and validating that no link placeholders were lost.

| # | Agent | Input Variables |
|---|-------|----------------|
| 1 | Content Summarizer | `new_title`, `draft_markdown` |
| 2 | Information Architect | `pillar_topic`, `supporting_posts` |
| 3 | Section Context Generator | `pillar_topic`, `outline`, `supporting_posts` |
| 4 | Internal Linking Strategist | `pillar_topic`, `outline`, `supporting_posts` |
| 5 | Main Body Writer | `link_plan`, `section_context` |
| 6 | Introduction Writer | `main_body` |
| 7 | Conclusion Writer | `main_body` |
| 8 | SEO Optimizer | `draft_markdown` (assembled: title + intro + body + conclusion) |

> **Assembly note:** A Merge/Set node between agents 7 and 8 should concatenate the outputs into a single `draft_markdown` string in the format: `# {title}\n\n{intro}\n\n{body}\n\n{conclusion}`.

---

### Model Recommendations (via OpenRouter)

Since each agent specializes in a different task, you can mix and match models based on budget and output quality. The table below optimises for **mid-range cost with reliable quality**.

| # | Agent | Recommended Model | Why |
|---|-------|-------------------|-----|
| 1 | Content Summarizer | `openai/gpt-4.1-mini` | Simple extraction — 2-3 sentence output, no reasoning needed. |
| 2 | Information Architect | `openai/gpt-4.1-mini` | Structured JSON output with analytical grouping. 4.1 mini handles classification and JSON well. |
| 3 | Section Context Generator | `openai/gpt-4.1-mini` | Straightforward extraction — reads summaries, outputs brief JSON. |
| 4 | Internal Linking Strategist | `openai/gpt-4.1-mini` | Mechanical task: map posts to CTAs, validate IDs, vary language. |
| 5 | **Main Body Writer** | **`openai/gpt-4.1`** | Heaviest creative writing task. Needs varied sentence openings, coherent sections, quality prose. Worth the step up. |
| 6 | Introduction Writer | `openai/gpt-4.1-mini` | Short output, constrained task. Reads the body and frames it. |
| 7 | Conclusion Writer | `openai/gpt-4.1-mini` | Short, constrained, derivative of body content. |
| 8 | **SEO Optimizer** | **`openai/gpt-4.1`** | Must scan full draft, validate every link, fix anchors without breaking anything. Precision matters. |

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

### 1. `{{ $json.new_title }}`

- **Used in:** `1. Content Summarizer` (Title of the single supporting post)
- **Schema (Data Type):** `String`
- **Description:** Represents the title of an individual supporting post.
- **Example:**
  ```json
  "On-Page SEO Basics for 2024"
  ```

### 2. `{{ $json.pillar_topic }}`

- **Used in:** `2. Information Architect`, `3. Section Context Generator`, `4. Internal Linking Strategist`
- **Schema (Data Type):** `String`
- **Description:** Represents the overarching focus keyword of the pillar post.
- **Example:**
  ```json
  "Content Marketing Strategy for Startups"
  ```

### 3. `{{ $json.draft_markdown }}`

- **Used in:** `1. Content Summarizer` (raw supporting post to summarize), `8. SEO Optimizer` (assembled pillar draft to review)
- **Schema (Data Type):** `String` (Markdown format)
- **Description:** The large chunk of content an agent needs to either summarize or optimize.
- **Example:**
  ```text
  "Title tags and meta descriptions remain the foundation of on-page SEO. While Google sometimes rewrites them, a well-crafted title tag is your first impression in the SERPs..."
  ```

### 4. `{{ $json.supporting_posts }}`

- **Used in:** `2. Information Architect`, `3. Section Context Generator`, `4. Internal Linking Strategist`
- **Schema (Data Type):** `JSON Array of Objects`
- **Description:** The aggregated output of supporting posts. Must include `id` so downstream agents can map posts correctly.
- **Example:**
  ```json
  [
    {
      "id": 101,
      "new_title": "Long-tail keyword research",
      "summary": "Focuses on finding low-competition keywords using free SEO tools."
    },
    {
      "id": 102,
      "new_title": "On-Page SEO Basics",
      "summary": "Best practices for optimizing title tags and meta descriptions."
    }
  ]
  ```

### 5. `{{ $json.outline }}`

- **Used in:** `3. Section Context Generator`, `4. Internal Linking Strategist`
- **Schema (Data Type):** `JSON Object`
- **Description:** The structured JSON outline generated by Agent 2 (Information Architect).
- **Example:**
  ```json
  {
    "outline": {
      "pillar_title": "The Ultimate Guide to SEO",
      "sections": [
        {
          "theme_id": "t1",
          "h2": "Keyword Research Strategies for Low-Competition Markets",
          "theme_description": "How to find and target keywords that larger competitors overlook.",
          "posts": [
            { "post_id": 101, "new_title": "Long-tail keyword research" }
          ]
        }
      ]
    }
  }
  ```

### 6. `{{ $json.section_context }}`

- **Used in:** `5. Main Body Writer`
- **Schema (Data Type):** `JSON Object`
- **Description:** The context brief generated by Agent 3 (Section Context Generator).
- **Example:**
  ```json
  {
    "section_context": {
      "sections": [
        {
          "theme_id": "t1",
          "section_purpose": "Establishes keyword strategy as the foundation of the SEO pillar.",
          "narrative_angle": "Focus on practical tools and methods accessible to small teams.",
          "key_points": ["Free tools like Ubersuggest", "Long-tail vs short-tail trade-offs", "Search intent alignment"]
        }
      ]
    }
  }
  ```

### 7. `{{ $json.link_plan }}`

- **Used in:** `5. Main Body Writer`
- **Schema (Data Type):** `JSON Object`
- **Description:** The link plan generated by Agent 4 (Internal Linking Strategist).
- **Example:**
  ```json
  {
    "link_plan": {
      "sections": [
        {
          "h2": "Keyword Research Strategies for Low-Competition Markets",
          "posts": [
            {
              "post_id": 101,
              "new_title": "Long-tail keyword research",
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
  }
  ```

### 8. `{{ $json.main_body }}`

- **Used in:** `6. Introduction Writer`, `7. Conclusion Writer`
- **Schema (Data Type):** `String` (Markdown format)
- **Description:** The main body draft output by Agent 5 (Main Body Writer).
