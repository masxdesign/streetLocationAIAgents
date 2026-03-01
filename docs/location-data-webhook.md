## POST `/webhook/fb8dbea2-9b64-4e01-bfbf-019fe7dd0128`

**Base URL:** `https://n8n.srv1293825.hstgr.cloud`

---

### Request

**Content-Type:** `application/json`

#### Body Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `street` | string | Yes | Street name |
| `postcode` | string | Yes | UK postcode |
| `lat` | number | Yes | Latitude coordinate |
| `lon` | number | Yes | Longitude coordinate |
| `radius` | number | No | Search radius in metres (defaults to 800 if omitted) |

#### Example Request

```bash
curl -X POST https://n8n.srv1293825.hstgr.cloud/webhook/fb8dbea2-9b64-4e01-bfbf-019fe7dd0128 \
  -H "Content-Type: application/json" \
  -d '{
    "street": "Oxford Street",
    "postcode": "W1D 1BS",
    "lat": 51.5145,
    "lon": -0.1301
  }'
```

---

### Response

**Content-Type:** `application/json`

Returns an array with a single object containing:

| Field | Type | Description |
|-------|------|-------------|
| `street` | string | Echo of input street |
| `postcode` | string | Echo of input postcode |
| `lat` | number | Echo of input latitude |
| `lon` | number | Echo of input longitude |
| `radius` | number | Radius used (default 800) |
| `nearest_stations` | array | Stations within radius |
| `key_anchors` | array | Notable landmarks/attractions within radius |
| `street_profile` | object | Derived street-level commercial profile |

#### `nearest_stations[]`

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Station name |
| `mode` | string | Transport mode (`tube`, `elizabeth-line`, `national-rail`) |
| `lines` | string[] | Lines served |
| `distance_m` | number | Distance from coordinates in metres |
| `walk_time_min` | number | Estimated walking time in minutes |

#### `key_anchors[]`

| Field | Type | Description |
|-------|------|-------------|
| `name` | string | Anchor name |
| `category` | string | Type (`landmark`, `museum`, etc.) |
| `lat` | number | Latitude of the anchor |
| `lon` | number | Longitude of the anchor |
| `distance_m` | number | Distance from coordinates in metres |
| `why_relevant` | string | Brief relevance description |

#### `street_profile`

| Field | Type | Description |
|-------|------|-------------|
| `footfall_signal` | string | Foot traffic intensity (`prime`, `strong`, `moderate`, `low`) |
| `retail_mix` | string | Diversity of retail types (`mixed`, `specialist`, `homogeneous`) |
| `evening_economy` | string | Evening activity level (`strong`, `moderate`, `limited`) |
| `connectivity` | string | Transport connectivity rating (`excellent`, `good`, `moderate`, `limited`) |
| `blog_angle` | string | Editorial summary guiding the article's commercial narrative |
