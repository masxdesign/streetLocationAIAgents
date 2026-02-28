LOCATION_NAME: {{ $json.street }}
CITY: {{ $json.suburb || $json.borough || $json.neighbourhood || 'London' }}