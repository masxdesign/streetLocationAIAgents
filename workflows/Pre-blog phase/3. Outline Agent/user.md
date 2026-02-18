Create a MARKDOWN OUTLINE ONLY (not the full article) for an 800–1500 word blog post.

Use:
Title: {{ $json.output.new_title }}
Primary keyword: {{ $json.keywords_primary_keyword }}
Secondary keywords: {{ $json.keywords_secondary_keywords }}
Search intent: {{ $json.search_intent }}
Writing style: {{ $json.writing_style }}
Writing tone: {{ $json.writing_tone }}
Article goal: {{ $json.goal_of_article }}

Key takeaways:
{{ $json.output.key_takeaways }}

{{ $json.semantic_analysis }}

STRICT OUTPUT RULES (to prevent truncation):
- Output ONLY headings + bullets. NO paragraphs.
- Use exactly 6 H2 sections.
- Under each H2, include exactly 3 bullet points.
- Include exactly 1 FAQ section as the 6th H2, with exactly 4 questions as bullets.
- Total output must be under 2200 characters.

MARKDOWN FORMAT:
# <H1>
Intro bullets (exactly 3)
## <H2-1>
- ...
- ...
- ...
...
## FAQ
- ...
- ...
- ...
- ...

Do not add commentary or extra text outside the outline.
