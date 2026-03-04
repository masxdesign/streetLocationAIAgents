Summarise the following street post into a compact capsule JSON. Follow your system prompt schema exactly.

Post ID: {{ $json.post_id }}
Street: {{ $json.street }}
Postcode: {{ $json.postcode }}
Primary keyword: {{ $json.primary_keyword }}

--- SOURCE ARTICLE ---
{{ $json.article_html }}
--- END SOURCE ARTICLE ---
