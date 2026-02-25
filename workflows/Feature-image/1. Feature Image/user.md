LOCATION_NAME: {{ $json.street }}
POSTCODE: {{ $json.postcode }}
CITY: {{ $json.suburb || $json.borough || $json.neighbourhood || 'London' }}