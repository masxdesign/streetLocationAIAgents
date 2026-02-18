Primary Keyword: {{ $json.keywords_primary_keyword }}
Title: {{ $json.new_title }}

Location:
- street: {{ $json.street }}
- suburb: {{ $json.suburb }}
- postcode: {{ $json.postcode }}
- borough: {{ $json.borough }}
- neighbourhood: {{ $json.neighbourhood }}
- reference_point: {{ $json.reference_point }}

Hidden insight:
{{ $json.hidden_insight }}

Search intent: {{ $json.search_intent }}

{{ $json.semantic_analysis }}

Secondary keywords:
{{ $json.keywords_secondary_keywords }}

Writing style: {{ $json.writing_style }}.
Writing tone: {{ $json.writing_tone }}.
Article goal: {{ $json.goal_of_article }}.

Outline (source content from previous AI agent):
{{ $json.outline }}

CRITICAL REMINDER:
- This article is about {{ $json.street }} ONLY.
- Do NOT merge {{ $json.street }} with any other places in titles or body.
- "Purpose of visits" subsection = general activity categories ONLY (shopping, dining, tourism, commuting, etc.). ZERO venue names allowed.
- Anchor names, categories, and distances belong ONLY in the "Key local anchors" subsection instruction. NEVER put them in "Purpose of visits" or any other subsection.
- If either data array below is empty, OMIT that subsection entirely — no heading, no placeholder text. Do NOT invent data.
- Area: Use the provided borough and neighbourhood exactly as given. They are now accurate.
  Borough: {{ $json.borough }}
  Neighbourhood: {{ $json.neighbourhood }}

---
APPENDIX A — TRANSPORT DATA (for "Transport and accessibility" subsection ONLY):
{{ $json.nearest_stations }}

---
APPENDIX B — ANCHOR DATA (for "Key local anchors" subsection ONLY — NEVER use in "Purpose of visits"):
{{ $json.key_anchors }}
Translate raw API category values (e.g. "poi") to professional labels (e.g. "retail", "specialist retail", "dining"). Integrate why_relevant as natural prose — do NOT prefix with "Commercial relevance:" or similar labels.
