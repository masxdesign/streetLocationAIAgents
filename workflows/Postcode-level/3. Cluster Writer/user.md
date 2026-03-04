Write a postcode-level cluster page for the location below. Follow your system prompt exactly.

Postcode: {{ $json.postcode }}
Borough: {{ $json.borough }}
Neighbourhood: {{ $json.neighbourhood }}
Cluster page title: {{ $json.cluster_title }}

--- POSTCODE RESEARCH ---
{{ $json.postcode_research }}
--- END POSTCODE RESEARCH ---

--- STREET CAPSULES ---
{{ $json.street_capsules }}
--- END STREET CAPSULES ---

--- LINKS ---
{{ $json.interlinks }}
--- END LINKS ---
