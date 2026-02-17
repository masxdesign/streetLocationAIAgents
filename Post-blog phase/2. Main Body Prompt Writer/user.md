Primary Keyword: {{ $json.keywords_primary_keyword }}
Title: {{ $json.new_title }}

Location:
- street: {{ $json.street }}
- suburb: {{ $json.suburb || "not provided" }}
- postcode: {{ $json.postcode }}
- borough: {{ $json.borough || "not provided" }}
- neighbourhood: {{ $json.neighbourhood || "not provided" }}
- reference_point: {{ $json.reference_point }}

Nearest Stations (pre-fetched from reliable API):
{{ $json.nearest_stations ? JSON.stringify($json.nearest_stations) : "[]" }}

Key Local Anchors (pre-fetched from reliable API):
{{ $json.key_anchors ? JSON.stringify($json.key_anchors) : "[]" }}

Hidden insight:
{{ $json.hidden_insight }}

Search intent: {{ $json.search_intent }}

{{ $json.semantic_analysis }}

Secondary keywords:
{{ $json.keywords_secondary_keywords.map(s => `- ${s}`).join("\n") }}

Writing style: {{ $json.writing_style }}.
Writing tone: {{ $json.writing_tone }}.
Article goal: {{ $json.goal_of_article }}.

Outline (source content from previous AI agent):
{{ $json.outline }}

CRITICAL REMINDER:
- This article is about {{ $json.street }} ONLY.
- Do NOT merge {{ $json.street }} with any other places in titles or body.
- Transport stations and key anchors have been pre-fetched from reliable third-party APIs.
- Use the provided nearest_stations array (with name, mode, lines, distance_m, walk_time_min) for the Transport section.
- Use the provided key_anchors array (with name, category, distance_m, why_relevant) for the Key Local Anchors section.
- If either array is empty, OMIT that subsection entirely — no heading, no placeholder text. Do NOT invent data.
- Area: Use the provided borough and neighbourhood exactly as given. They are now accurate.
  Borough: {{ $json.borough || "not provided" }}
  Neighbourhood: {{ $json.neighbourhood || "not provided" }}
