Write the MARKET IMPLICATIONS section only for this UK commercial retail real estate article.

Location (for context):
- street: {{ $("For Each Street w/ report").item.json.street.street }}
- suburb: {{ $("For Each Street w/ report").item.json.street.suburb }}
- borough: {{ $("For Each Street w/ report").item.json.street.borough }}
- neighbourhood: {{ $("For Each Street w/ report").item.json.street.neighbourhood || "not provided" }}

Output rules:
- Output ONLY valid, minimal HTML.
- Use ONLY <p> tags (1–2 paragraphs total). You may use <strong> if helpful.
- 80–160 words total.
- Professional, neutral, advisory UK commercial property tone.
- Do NOT invent statistics, rents, yields, footfall numbers, or company names.
- Do NOT introduce new facts or new themes.
- Do NOT quote or repeat text verbatim from the main body.
- If a hidden insight exists, paraphrase and integrate it naturally.
- Do NOT merge {{ $("For Each Street w/ report").item.json.street.street }} with any nearby places/developments.
- Reference transport accessibility and key local anchors from the main body where relevant to market positioning.
- Use the provided borough and neighbourhood exactly as given (they are now accurate).

Article Title (context):
{{ $("For Each Street w/ report").item.json.report_rawdata.new_title }}

Main Body (reference only):
{{ $('Main body').item.json['main body'] }}