Use the given:
Title Template: {{ $json.seed.title }}
Description: {{ $json.seed.tone_description }}
Location: 
- street = {{ $json.street }}
- suburb = {{ $json.suburb }}
- postcode = {{ $json.postcode }}
- city = London
- borough = {{ $json.borough }}
- neighbourhood = {{ $json.neighbourhood }}
- reference_point = {{ $json.reference_point }} (lat/lon)

And the Tavily SERP Results tool to perform research for the primary keyword:
{{ $json.seed.keyword }}

Context:
This article is about commercial retail real estate for the given location.
The primary keyword represents the global theme of the article.
The description provides additional editorial direction (e.g. "focus more on tourism if relevant").

Target audience (ranked priority):
1. Commercial tenants looking to rent retail space
2. Business owners evaluating locations
3. Commercial property investors and landlords
4. Property agents

CRITICAL LOCATION RULES:
- The report is about {{ $json.street }} ONLY – this is the primary location.
- Do NOT merge {{ $json.street }} with any nearby places or developments in titles or headings.
- If nearby places/developments are found, list them in a separate "Nearby notable places" section.
- Area classification: Use the provided borough ({{ $json.borough }}) and neighbourhood ({{ $json.neighbourhood }}) exactly as given.
- The source data has been corrected and is now accurate. Trust it and use it verbatim.

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
keyword = {{ $json.seed.keyword }}
street = {{ $json.street }}
suburb = {{ $json.suburb }}
postcode = {{ $json.postcode }}
city = London

Example:
{"q":"commercial retail real estate {{ $json.street }} {{ $json.suburb }} {{ $json.postcode }} London demographics footfall retail transport stations landmarks"}

STEP 2 — FINAL OUTPUT:
After Tavily results are available, return your analysis as a strictly valid JSON object with this structure and no extra text:

{
  "search_intent": "<informational | commercial | transactional | navigational>",
  "writing_style": "<e.g. commercially informative | market overview | professional and analytical>",
  "writing_tone": "<e.g. neutral and advisory | informative and balanced | commercially focused>",
  "hidden_insight": "<non-obvious commercial or market insight about the location, otherwise 'No significant insights detected beyond existing content trends.'>",
  "target_audience": "<e.g. commercial tenants, business owners, investors, landlords, property agents>",
  "goal_of_article": "<main strategic objective for this location page>",
  "semantic_analysis": {
    "common_subtopics": [
      "Demographics and visitor profile",
      "Foot traffic patterns and demand drivers",
      "Transport and accessibility",
      "Mix of businesses and tenant types",
      "Development and regeneration activity",
      "Rental market conditions",
      "Investment outlook and market implications"
    ],
    "related_questions": [
      "Is this area good for retail business?",
      "What type of shops perform well here?",
      "Who are the typical customers in this area?",
      "What are typical rents for units here?",
      "Is the area growing or attracting investment?",
      "What are the nearest transport links?",
      "What is the rental yield potential in this area?",
      "Is tenant demand strong here?"
    ]
  },
  "keywords": {
    "primary_keyword": "<commercial retail real estate + location>",
    "secondary_keywords": [
      "<area + retail property>",
      "<street + commercial units>",
      "<postcode + shops to rent>",
      "<area + commercial investment>"
    ],
    "semantic_keywords": [
      "commercial property",
      "retail units",
      "high street",
      "foot traffic",
      "tenant demand",
      "mixed-use development",
      "regeneration",
      "rental yields",
      "investment opportunity"
    ],
    "long_tail_keywords": [
      "is this a good area for opening a shop?",
      "best streets for retail in this area",
      "commercial retail investment opportunities here",
      "rental rates for shops in [area]",
      "tenant demand in [street]",
      "nearest tube stations to [street]",
      "should I invest in retail property here?"
    ]
  }
}

Critical rules for STEP 2:
- Do NOT invent statistics, rents, or visitor numbers.
- Do NOT fabricate named businesses unless widely known.
- Hidden insights must be strategic, not stylistic.
- Use the provided borough and neighbourhood exactly as given in the location data.
- Transport stations and key local anchors are pre-fetched separately - do NOT include them in your JSON output.
- Focus your semantic analysis on: demographics, retail character, development activity, market dynamics.
- The output must be pure JSON with no extra text.