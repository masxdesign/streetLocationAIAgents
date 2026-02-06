Use the given:
Title Template: 
Description: {{ $json.tone[$json.street.seed.tone] }}
Location: 
- street = {{ $json.street.street }}
- suburb = {{ $json.street.suburb }}
- postcode = {{ $json.street.postcode }}
- city = London

And the Tavily SERP Results tool to perform research for the primary keyword:
{{ $json.street.seed.keyword }}

Context:
This article is about commercial retail real estate for the given location.
The primary keyword represents the global theme of the article.
The description provides additional editorial direction (e.g. "focus more on tourism if relevant").

Target audience:
People looking to rent, buy, invest in, or evaluate commercial retail property.

Format your response strictly as a valid JSON object.
IMPORTANT:
- Do not include any extra text or explanations.
- Do not include line breaks or markdown.
- Return JSON only.

--------------------------------------------------
TOOL USAGE RULE (CRITICAL)
--------------------------------------------------

This task is a TWO-STEP process.

STEP 1 — TOOL CALL (MANDATORY):
Your FIRST response MUST be ONLY the Tavily tool arguments as valid JSON.
Do NOT include any normal text.
Do NOT include explanations.
Do NOT output an array. Never output [].

Tavily tool arguments schema:
{"q":"<string>"}

Build q from:
keyword = {{ $json.street.seed.keyword }}
street = {{ $json.street.street }}
suburb = {{ $json.street.suburb }}
postcode = {{ $json.street.postcode }}
city = London

Example:
{"q":"commercial retail real estate {{ $json.street.street }} {{ $json.street.suburb }} {{ $json.street.postcode }} London demographics footfall retail"}

STEP 2 — FINAL OUTPUT:
After Tavily results are available, return your analysis as a strictly valid JSON object with this structure and no extra text:

{
  "search_intent": "<informational | commercial | transactional | navigational>",
  "writing_style": "<e.g. professional and analytical | investor-focused | market overview>",
  "writing_tone": "<e.g. authoritative | neutral and advisory | commercially informative>",
  "hidden_insight": "<non-obvious commercial or market insight about the location, otherwise 'No significant insights detected beyond existing content trends.'>",
  "target_audience": "<e.g. retail investors, landlords, business owners, commercial tenants, developers>",
  "goal_of_article": "<main strategic objective for this location page>",
  "semantic_analysis": {
    "common_subtopics": [
      "Demographics",
      "Footfall and customer profile",
      "Transport and accessibility",
      "Retail mix and tenant types",
      "Development and regeneration activity"
    ],
    "related_questions": [
      "Is this area good for retail business?",
      "What type of shops perform well here?",
      "Who are the typical customers in this area?",
      "Is the area growing or attracting investment?"
    ]
  },
  "keywords": {
    "primary_keyword": "<commercial retail real estate + location>",
    "secondary_keywords": [
      "<area + retail property>",
      "<street + commercial units>",
      "<postcode + shops to rent>"
    ],
    "semantic_keywords": [
      "commercial property",
      "retail units",
      "high street",
      "footfall",
      "tenant demand",
      "mixed-use development",
      "regeneration"
    ],
    "long_tail_keywords": [
      "is this a good area for opening a shop?",
      "best streets for retail in this area",
      "commercial retail investment opportunities here"
    ]
  }
}

Critical rules for STEP 2:
- Do NOT invent statistics, rents, yields, or footfall numbers.
- Do NOT fabricate named businesses unless widely known.
- Hidden insights must be strategic, not stylistic.
- The output must be pure JSON with no extra text.