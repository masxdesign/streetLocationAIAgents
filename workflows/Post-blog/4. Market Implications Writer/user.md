Write the closing "What This Means for Businesses" section only for this London location guide article.

Location (for context):
- street: {{ $json.street }}
- suburb: {{ $json.suburb }}
- borough: {{ $json.borough }}
- neighbourhood: {{ $json.neighbourhood }}

Output rules:
- Output ONLY valid, minimal HTML.
- Use ONLY <p> tags (1–2 paragraphs total). Do NOT use <strong> or any other formatting tags.
- 80–160 words total.
- Professional, approachable, helpful tone — avoid commercial real estate jargon.
- Do NOT invent statistics, rents, or company names.
- Do NOT introduce new facts or new themes.
- Do NOT quote or repeat text verbatim from the main body.
- Your content must be distinct from the introduction. Focus on practical takeaways, not restating the same framing.
- If a hidden insight exists, paraphrase and integrate it naturally.
- Do NOT merge {{ $json.street }} with any nearby places/developments.
- Reference transport links and nearby landmarks from the main body where relevant.
- Use the provided borough and neighbourhood exactly as given (they are now accurate).

Article Title (context):
{{ $json.new_title }}

Main Body (reference only):
{{ $json.output.main_body }}