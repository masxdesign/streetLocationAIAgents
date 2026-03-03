# n8n Workflows

This directory contains production-ready n8n workflow files that you can directly import into your n8n workspace.

## 1. Cluster Pillar Post Generation (`cluster-post.json`)

This workflow completely automates the creation of a massive, SEO-optimized "Cluster Pillar Post", sourcing content automatically from your `4prop` GraphQL API.

### How to Import
1. Open your n8n workspace.
2. Click **Add Workflow**.
3. In the top right corner, click on the **...** (Options menu).
4. Click **Import from File**.
5. Select `cluster-post.json` from this folder.

### Configuration Needed
After importing, you will need to map a few custom variables and credentials to your specific n8n setup:

1. **HTTP Request Node ("Fetch Supporting Posts"):**
   - Click this node and adjust your `X-API-Key` to be your real `YOUR_KEY`.
   - The GraphQL request uses `ids: [IDS HERE]`. You will need to replace `[IDS HERE]` dynamically from the starting Trigger or a previous node.
2. **OpenAI Credentials (Agents 1-4):**
   - Click on each of the 4 nodes labeled **1. Content Summarizer**, **2. Information Architect**, **3. Content Synthesizer**, **4. SEO Optimizer** and select your authenticated OpenAI credentials.
3. **Core Topic Variable (`pillar_topic`):**
   - Currently, the generic `{{ $json.pillar_topic }}` variable used for the overarching theme is expected to be fed into the workflow at the start. You can achieve this by adding a "Set Variable" node right after the "Start" node, defining `pillar_topic` (e.g. `"The Ultimate Guide to Moving Properties"`).

### How It Works Under The Hood
- **Item Lists (Split Out):** Converts the array of results returned by the GraphQL query into separate items.
- **Agent 1 (Looping):** The Content Summarizer fires off individually for each of the location posts fetched from the API, shrinking them to 2-3 sentences.
- **Aggregate Summaries (Item Lists):** Reconsolidates the individual summarized Location posts back into a single JSON array list (`[{ id, title, summary }, ...]`).
- **Agent 2:** Reads that massive list and creates a structured Markdown outline.
- **Agent 3:** Writes the draft substituting the respective `ID`s.
- **Agent 4:** Final reviewer for markdown and placeholder safety.
