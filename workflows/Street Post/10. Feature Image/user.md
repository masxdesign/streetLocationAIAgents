LOCATION_NAME: {{ $json.street }}
CITY: {{ $json.suburb || $json.borough || $json.neighbourhood || 'London' }}
STREET_DESCRIPTION: {{ $json.output.street_description || $json.output }}