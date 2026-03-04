# Cluster Pillar Post Workflow

This directory contains the system and user prompts to power a 6-agent n8n workflow designed to generate comprehensive, SEO-optimized "Cluster Pillar Posts".

## Workflow Overview

When building out a topic cluster strategy, the **Pillar Post** acts as the central hub that links out to deeper, more specific **Supporting Posts**. This workflow takes your existing supporting content and generates a cohesive, high-quality pillar post formatted in pure Markdown.

The workflow uses six sequential AI agents:

1. **The Content Summarizer:** Distills a full-length supporting post into a 2-3 sentence summary.
2. **The Information Architect (Outline Planner):** Analyses the summaries, identifies common themes, and generates a logical Markdown outline grouped by theme.
3. **The Main Body Writer:** Fills in the outline, writing short contextual summaries for each theme section and injecting precise placeholder URLs for internal link building.
4. **The Introduction Writer:** Reads the main body draft and writes a compelling introduction that sets up the article naturally.
5. **The Conclusion Writer:** Reads the main body draft and writes a closing section that synthesises the key themes.
6. **The SEO Optimizer & Editor:** Receives the fully assembled draft (title + intro + body + conclusion) and polishes it, enforcing strict Markdown output and validating that no link placeholders were lost.

| # | Agent | Input variables |
|---|-------|----------------|
| 1 | Content Summarizer | `new_title`, `draft_markdown` |
| 2 | Information Architect | `pillar_topic`, `supporting_posts` |
| 3 | Main Body Writer | `outline`, `supporting_posts` |
| 4 | Introduction Writer | `main_body` |
| 5 | Conclusion Writer | `main_body` |
| 6 | SEO Optimizer | `draft_markdown` (assembled: title + intro + body + conclusion) |

> **Assembly note:** A Merge/Set node between agents 5 and 6 should concatenate the outputs into a single `draft_markdown` string in the format: `# {title}\n\n{intro}\n\n{body}\n\n{conclusion}`.

### Model Choice Recommendations (via OpenRouter)

Since each agent specializes in a different task, you can mix and match models based on your budget and desired output quality.

| Agent Role                  | Cost-Effective Choice             | Highest Premium Quality       | The Best of Both Worlds       |
| --------------------------- | --------------------------------- | ----------------------------- | ----------------------------- |
| **1. Content Summarizer**   | `meta-llama/llama-3-8b-instruct`  | `anthropic/claude-3.5-sonnet` | `anthropic/claude-3-haiku`    |
| **2. Info Architect**       | `meta-llama/llama-3-8b-instruct`  | `openai/gpt-4o`               | `anthropic/claude-3.5-sonnet` |
| **3. Main Body Writer**     | `meta-llama/llama-3-70b-instruct` | `anthropic/claude-3.5-sonnet` | `openai/gpt-4o-mini`          |
| **4. Introduction Writer**  | `meta-llama/llama-3-8b-instruct`  | `anthropic/claude-3.5-sonnet` | `openai/gpt-4o-mini`          |
| **5. Conclusion Writer**    | `meta-llama/llama-3-8b-instruct`  | `anthropic/claude-3.5-sonnet` | `openai/gpt-4o-mini`          |
| **6. SEO Optimizer**        | `google/gemini-flash-1.5`         | `openai/gpt-4o`               | `openai/gpt-4o-mini`          |

- **Why?** Summarization (Agent 1) and short prose pieces (Agents 4 & 5) are simple tasks where fast, cheap models excel. Drafting the main body (Agent 3) benefits from a heavier model. Outline generation (Agent 2) and Markdown enforcement (Agent 6) require strong instruction following.

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

- **Used in:** `2. Information Architect` (The Core Pillar Topic)
- **Schema (Data Type):** `String`
- **Description:** Represents the overarching focus keyword of the pillar post.
- **Example:**
  ```json
  "Content Marketing Strategy for Startups"
  ```

### 3. `{{ $json.draft_markdown }}`

- **Used in:** `1. Content Summarizer` (raw supporting post to summarize), `6. SEO Optimizer` (assembled pillar draft to review)
- **Schema (Data Type):** `String` (Markdown format)
- **Description:** The large chunk of content an agent needs to either summarize or optimize.
- **Example:**
  ```text
  "Title tags and meta descriptions remain the foundation of on-page SEO. While Google sometimes rewrites them, a well-crafted title tag is your first impression in the SERPs..."
  ```

### 4. `{{ $json.supporting_posts }}`

- **Used in:** `2. Information Architect`, `3. Main Body Writer`
- **Schema (Data Type):** `JSON Array of Objects` (or formatted String representing this array)
- **Description:** The aggregated output of supporting posts. Must include `id` so the Main Body Writer can inject the correct placeholder URLs.
- **Example:**
  ```json
  [
    {
      "id": 101,
      "title": "Long-tail keyword research",
      "summary": "Focuses on finding low-competition keywords using free SEO tools."
    },
    {
      "id": 102,
      "title": "On-Page SEO Basics",
      "summary": "Best practices for optimizing title tags and meta descriptions."
    }
  ]
  ```

### 5. `{{ $json.outline }}`

- **Used in:** `3. Main Body Writer`
- **Schema (Data Type):** `String` (Markdown format)
- **Description:** The structural outline generated by Agent 2 (The Information Architect).
- **Example:**
  ```markdown
  # The Ultimate Guide to SEO
  ## Finding Keywords
  - Long-tail keyword research
  - Understanding search intent
  ```

### 6. `{{ $json.main_body }}`

- **Used in:** `4. Introduction Writer`, `5. Conclusion Writer`
- **Schema (Data Type):** `String` (Markdown format)
- **Description:** The main body draft output by Agent 3 (The Main Body Writer).
