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
- Structured anchor data (categories, distances, bold formatting) belongs ONLY in the "Key local anchors" subsection instruction. In other subsections like "Purpose of visits", anchor names may appear as plain-text references in flowing prose — but NEVER with (category, X m) formatting.
- If either data array below is empty, OMIT that subsection entirely — no heading, no placeholder text. Do NOT invent data.
- Area: Use the provided borough and neighbourhood exactly as given. They are now accurate.
  Borough: {{ $json.borough }}
  Neighbourhood: {{ $json.neighbourhood }}

---
APPENDIX A — TRANSPORT DATA (for "Transport and accessibility" subsection ONLY):
{{ $json.nearest_stations }}

---
APPENDIX B — ANCHOR DATA (structured format for "Key local anchors" subsection ONLY — in other subsections, mention names as natural plain-text references only):
{{ $json.key_anchors }}
Translate raw API category values (e.g. "poi") to professional labels (e.g. "retail", "specialist retail", "dining"). Integrate why_relevant as natural prose — do NOT prefix with "Commercial relevance:" or similar labels.

---
APPENDIX C — STREET PROFILE (use to inform editorial direction, tone emphasis, and commercial narrative throughout the article):
{{ $json.street_profile }}

---
APPENDIX D — LONG-TAIL SEARCH QUERIES (weave answers to these naturally into the article prose — do NOT create a FAQ section or list them explicitly):
{{ $json.keywords_long_tail_keywords }}
