Write the MARKET IMPLICATIONS section only for this UK commercial retail real estate article.

Location (for context):
- street: {{ $json.street }}
- suburb: {{ $json.suburb }}
- borough: {{ $json.borough }}
- neighbourhood: {{ $json.neighbourhood }}

Output rules:
- Output ONLY valid, minimal HTML.
- Use ONLY <p> tags (1–2 paragraphs total). Do NOT use <strong> or any other formatting tags.
- 80–160 words total.
- Professional, neutral, advisory UK commercial property tone.
- Do NOT invent statistics, rents, yields, footfall numbers, or company names.
- Do NOT introduce new facts or new themes.
- Do NOT quote or repeat text verbatim from the main body.
- Your content must be distinct from the introduction. Focus on actionable implications, not restating the same framing.
- If a hidden insight exists, paraphrase and integrate it naturally.
- Do NOT merge {{ $json.street }} with any nearby places/developments.
- Reference transport accessibility and key local anchors from the main body where relevant to market positioning.
- Use the provided borough and neighbourhood exactly as given (they are now accurate).

Article Title (context):
{{ $json.new_title }}

Main Body (reference only):
{{ $json.output.main_body }}