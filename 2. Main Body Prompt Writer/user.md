Primary Keyword: {{ $("For Each Street w/ report").item.json.report_rawdata['keywords.primary_keyword'] }}
Title: {{ $("For Each Street w/ report").item.json.report_rawdata.new_title }}

Location:
- street: {{ $("For Each Street w/ report").item.json.street.street }}
- suburb: {{ $("For Each Street w/ report").item.json.street.suburb }}
- postcode: {{ $("For Each Street w/ report").item.json.street.postcode }}
- borough: {{ $("For Each Street w/ report").item.json.street.borough }}
- neighbourhood: {{ $("For Each Street w/ report").item.json.street.neighbourhood || "not provided" }}
- reference_point: {{ $("For Each Street w/ report").item.json.street.reference_point }}

Nearest Stations (pre-fetched from reliable API):
{{ $("For Each Street w/ report").item.json.street.nearest_stations ? JSON.stringify($("For Each Street w/ report").item.json.street.nearest_stations) : "[]" }}

Key Local Anchors (pre-fetched from reliable API):
{{ $("For Each Street w/ report").item.json.street.key_anchors ? JSON.stringify($("For Each Street w/ report").item.json.street.key_anchors) : "[]" }}

Hidden insight: 
{{ $("For Each Street w/ report").item.json.report_rawdata.hidden_insight }}

Search intent: {{ $("For Each Street w/ report").item.json.report_rawdata.search_intent }}.

Semantic analysis:
  - common_subtopics: {{ $("For Each Street w/ report").item.json.report_rawdata['semantic_analysis.common_subtopics'] }}.
  - related_questions: {{ $("For Each Street w/ report").item.json.report_rawdata['semantic_analysis.related_questions'] }}.

Secondary keywords: {{ $("For Each Street w/ report").item.json.report_rawdata['keywords.secondary_keyword'] }}.
Writing style: {{ $("For Each Street w/ report").item.json.report_rawdata.writing_style }}.
Writing tone: {{ $("For Each Street w/ report").item.json.report_rawdata.writing_tone }}.
Article goal: {{ $("For Each Street w/ report").item.json.report_rawdata.goal_of_article }}.

Outline (source content from previous AI agent):
{{ $("For Each Street w/ report").item.json.report_rawdata.outline }}

CRITICAL REMINDER:
- This article is about {{ $("For Each Street w/ report").item.json.street.street }} ONLY.
- Do NOT merge {{ $("For Each Street w/ report").item.json.street.street }} with any other places in titles or body.
- Transport stations and key anchors have been pre-fetched from reliable third-party APIs.
- Use the provided nearest_stations array (with name, mode, lines, distance_m, walk_time_min) for the Transport section.
- Use the provided key_anchors array (with name, category, distance_m, why_relevant) for the Key Local Anchors section.
- If either array is empty, state "not available" rather than inventing.
- Area: Use the provided borough and neighbourhood exactly as given. They are now accurate.
  Borough: {{ $("For Each Street w/ report").item.json.street.borough }}
  Neighbourhood: {{ $("For Each Street w/ report").item.json.street.neighbourhood || "not provided" }}