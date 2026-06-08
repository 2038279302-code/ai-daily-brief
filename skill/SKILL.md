---
name: ai-daily-brief
description: AI daily brief generator for product managers. Automatically fetches the latest AI news from arXiv, OpenAI/Anthropic/Google official blogs, Chinese tech media (36Kr, Jiqizhixin, Qbitai), top AI builder X posts via follow-builders feed, and 6 podcasts. Generates a narrative-style daily brief with PM-perspective analysis and pushes to your configured destination. Triggers on phrases like "generate AI brief", "today's AI news", "AI daily report", "update my AI sources", "add source", "push brief".
---

# AI Daily Brief Generator

A daily AI intelligence aggregator tailored for AI Product Managers. Each run automatically fetches the latest AI developments from multiple high-quality sources, distills them with AI analysis, and delivers a narrative-style brief with PM-perspective insights — pushed to wherever you configure.

## Quick Start

**Trigger phrases (any of these work):**
- "Generate today's AI brief"
- "What's happening in AI today"
- "AI daily report"
- "Update my AI sources" (when adding/modifying sources)

---

## Overall Workflow

```
Step 1: Read source config (references/sources.md)
Step 2: Parallel-fetch all sources (web_fetch)
Step 3: AI distills, analyzes, generates brief
Step 4: Deliver output (based on output_mode in sources.md)
Step 5: Send notification (based on notify_mode in sources.md)
Step 6.5: Self-evaluation (quality scoring, every run)
Step 6: Return result to user
```

---

## Step 1: Read Source Config

Before each run, read `references/sources.md` to get the current list of enabled sources, their URLs, fetch strategies, and delivery configuration.

**Config file path**: `references/sources.md` in the same directory as this SKILL.md.

---

## Step 2: Parallel Fetch

Based on the sources in `sources.md`, **parallel-fetch** all enabled sources using `web_fetch`.

### Fetch Strategy

#### 🥇 Priority: follow-builders JSON feeds (first-hand, no API key needed)

**Before fetching other sources**, always parallel-fetch these three feeds first:

```
https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-x.json
https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-podcasts.json
https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-blogs.json
```

- `feed-x.json`: Daily posts from 26 top AI builders (Andrej Karpathy, Sam Altman, Swyx, Guillermo Rauch, etc.), structure: `x[].tweets[]`, each tweet has `text`, `url`, `likes`, `createdAt`
- `feed-podcasts.json`: Latest episodes from Latent Space / No Priors / Training Data and 3 other podcasts
- `feed-blogs.json`: Latest posts from Anthropic Engineering + Claude Blog

**Rules for processing feed-x.json:**
1. Iterate all builders, collect `tweets` lists
2. Sort by `likes + retweets` descending, filter tweets with interaction ≥ 5 (noise reduction)
3. Keep at most 2 highest-interaction tweets per builder in the candidate pool
4. `tweet.url` is the `source_url` for that item — **use directly, never replace**
5. If `generatedAt` is more than 36 hours ago, treat as stale and skip

#### Other source fetch rules

- Fetch at most 1–2 URLs per source (avoid timeouts)
- Prefer list/homepage to extract today's or past-24h content
- For RSS/feed sources, fetch the feed URL directly
- **X (Twitter) content is no longer fetched via Nitter mirrors**; covered by follow-builders feed

### Source URL Preservation Rules (mandatory)

After fetching each item, **extract and record its original article URL** as the `source_url` field — carried through to Step 3:

- For each item from a list page, find its detail-page link as `source_url`
- If an item has **no specific article URL** (only the homepage), **do not include it in the brief**
- For official blogs (OpenAI, Anthropic, etc.), always parse specific article links from the list page
- `source_url` must be a full URL pointing to a specific article, never use a homepage URL

### Content Filtering

After fetching, filter for **AI-relevant** items, prioritized as:
1. **Model releases / major capability updates** (highest priority)
2. **Product launches / feature updates** (high priority)
3. **Industry news / funding / M&A** (medium priority)
4. **Impactful research papers** (medium priority, focus on practical value)
5. **Opinions / think-pieces** (low priority, supplementary)

### Hallucination Prevention Rules (mandatory)

Before passing content to Step 3, check every candidate item:

- **Must have `source_url`**: Any item without a specific article URL is discarded
- **No memory-filling**: AI must not supplement any news from training data — all content in the brief must come from this run's actual fetches
- **Model name verification**: If a fetched item mentions an AI model name (e.g. GPT-Rosalind), and no corresponding official-source article is found in this run's results, **do not include it**
- **Number verification**: Funding amounts, valuations, technical benchmarks — all must come from fetched source text, no inference or estimation

---

## Step 3: Generate Brief Content

### Writing Principles

**Style**: Narrative + importance-ranked. Not a simple list, but like a knowledgeable PM friend fluently walking you through the most important things happening in AI today.

---

### Structure Template (ALWAYS use this structure — no section may be omitted)

```
# [AI Brief] {today's date} · {one-sentence summary of the most important thing today}

## Today's Overview
(2–3 sentences describing the overall AI landscape today and 1–2 core events.
 Must include: ① the single most important event today ② the overall tone/direction of the day)

## 🔥 Top Story
(1–3 items, only truly major news)

### {Title}
`{original publish date, e.g. 2026-06-04}` · Source: [{media/org name}]({source_url})

**What happened:** {objective description, strictly based on fetched source, no added knowledge}

**PM Perspective:** {in-depth analysis, see "PM Perspective Writing Rules" below}

---

## 📦 Products & Tech
(3–6 items, consistent format per item)

### {Title}
`{original publish date}` · Source: [{media/org name}]({source_url})

{event summary, 2–4 sentences, objective, within bounds of source text}

> **PM Takeaway:** {specific, actionable analysis, see writing rules}

---

## 📰 Industry & Capital
(2–4 items, same format, funding/M&A/regulation/market dynamics)

### {Title}
`{original publish date}` · Source: [{media/org name}]({source_url})

{event summary}

---

## 📚 Papers & Research
(1–3 papers, filter for practical application value)

### {paper title}
`{original publish date}` · Source: [{arXiv/institution}]({source_url})

**What the research does:** {one sentence}
**Why it matters:** {practical application value}

---

## 💡 Today's Perspectives
(1–2 high-value opinions from top AI builders)

### {opinion summary}
`{original publish date}` · Source: [{person/media}]({source_url})

{opinion content}

> **Commentary:** {brief but insightful, 1–3 sentences}

---

## 🧭 PM Quick Decisions
(3–5 items, format: "📌 **Conclusion** — Recommended action", must be new insights from today's news, not repeats of body content)

- 📌 **{new finding today}** — {specific: what to do / watch / decide}
- 📌 **{new finding today}** — {specific action}
...

---
*Auto-generated AI brief | Sources: {media list for this run} | Generated: {generation time}*
*⚠️ If content seems off, verify against source links*
```

---

### Heading Hierarchy Rules (mandatory)

- Brief title: `#` (H1, unique, appears only once at top)
- Section headings (Today's Overview, 🔥 Top Story, etc.): `##` (H2)
- Each news item title: `###` (H3)
- **Forbidden**: using `#` or `##` anywhere else in the body
- **Forbidden**: duplicate identical title at start of doc (pick one: doc title or body H1)

### Content Density per Section

- 🔥 Top Story: 150–300 words per item (including PM Perspective); too short = shallow analysis
- 📦 Products & Tech: 80–150 words per item, max 50% variance between items
- 📰 Industry & Capital: 60–120 words per item
- 💡 Perspectives: 80–150 words per item (including commentary)
- 🧭 Quick Decisions: max 50 words per item, must include both "conclusion + action"

---

### PM Perspective Writing Rules (core)

**Minimum requirement**: PM Perspective must include at least 2 of the following 3 layers, otherwise rewrite:

1. **Layer 1 – Direct Impact**: What is the direct effect on products/users/competitive landscape? (Forbidden: vague phrases like "worth watching")

2. **Layer 2 – Derived Conclusion**: What deeper judgment can be derived from this? (Requires causal chain: A happens → leads to B → therefore C is worth doing/worrying about/adjusting)

3. **Layer 3 – Action Recommendation**: As a PM, what should you **now** do, watch, or adjust in your roadmap? (Must be specific, not generic advice like "keep monitoring")

**Forbidden phrases** (if present, the writing is substandard — must rewrite):
- "worth watching" / "keep an eye on" / "worth monitoring" (must specify what and why now)
- "significant" / "far-reaching impact" (must quantify or specify the scope)
- "the PM takeaway is: ...this is an important paradigm shift in AI" (specify which product type, which stage)

---

### Cross-Event Correlation Rules

When **2+ news items belong to the same theme/trend** today, add 1–2 sentences in "Today's Overview" or at the top of the relevant section to highlight the shared theme, e.g.:

> "Three things today point to the same signal: AI unicorn capitalization is accelerating on all fronts — Anthropic filing for IPO, DeepSeek funding closed, and Unitree going public at speed. Three threads converging today."

**Common patterns to correlate**:
- Multiple companies announcing the same type of product on the same day → note the platform/entry-point competition
- Capital event + tech event on the same day → note the dual flywheel of capital and tech
- Domestic + international similar events → note the gap or benchmark relationship

---

## Step 4: Deliver Output

Read `output_mode` from `references/sources.md` and route accordingly.

### Routing Logic

```
output_mode = "file"      → Write Markdown to local file (output_path)
output_mode = "clipboard" → Prepare content; prompt user to paste anywhere
output_mode = "webhook"   → HTTP POST to webhook_url with configured headers
output_mode = "notion"    → Push to Notion page via Notion API
output_mode = "obsidian"  → Write Markdown file to obsidian_vault_path
output_mode = "km"        → Push to Meituan KM via citadel skill (internal only)
```

### file mode

Write the brief as a `.md` file to `output_path`:

```
File path: {output_path}/ai-brief-{YYYY-MM-DD}.md
```

If `output_path` does not exist, create it. Return the file path to the user.

### clipboard mode

Prepare the full Markdown content and display it in the conversation with this prompt:

> ✅ Brief ready! Copy the content above and paste it into any platform (Notion, Obsidian, Bear, Typora, etc.).

### webhook mode

Send via HTTP POST:

```bash
curl -s -X POST "{webhook_url}" \
  -H "Content-Type: application/json" \
  {webhook_headers as -H flags} \
  -d '{"date": "{YYYY-MM-DD}", "title": "{brief title}", "markdown": "{brief markdown (JSON-escaped)}"}'
```

Common webhook targets:
- **Slack**: Incoming Webhooks URL → payload field `text` or `blocks`
- **Feishu (飞书)**: Bot webhook → field `content`
- **DingTalk (钉钉)**: Robot webhook → field `text`
- **Custom backend**: Any REST API endpoint

If webhook returns non-2xx, note in Step 6 output: "Webhook delivery failed: {status code}". Do not abort.

### notion mode

Push to Notion using the official API:

```bash
curl -s -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer {notion_token}" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{
    "parent": {"page_id": "{notion_page_id}"},
    "properties": {"title": {"title": [{"text": {"content": "AI Brief {YYYY-MM-DD}"}}]}},
    "children": [{"object": "block", "type": "paragraph", "paragraph": {"rich_text": [{"text": {"content": "{brief markdown}"}}]}}]
  }'
```

If `notion_token` or `notion_page_id` is empty, prompt the user:
> "Notion mode requires `notion_token` and `notion_page_id` in `references/sources.md`. Get your token at: https://www.notion.so/my-integrations"

### obsidian mode

Write the Markdown file directly to the Obsidian vault path:

```
File path: {obsidian_vault_path}/AI Brief {YYYY-MM-DD}.md
```

### km mode (Meituan internal only)

Use the **citadel skill** to create a KM document.

> ⚠️ This mode requires CatPaw + Meituan internal network. If not available, automatically falls back to `file` mode.

1. Read `km_parent_id` from `references/sources.md`
2. Write brief to `/tmp/ai-daily-brief-{date}.xml`
3. Call `createDocument` to push to KM

---

## Step 4.5: Sync to Personal Journal (optional)

After Step 4 succeeds, check `journal_sync_url` in `references/sources.md`.

### Sync Rules

1. If `journal_sync_url` is empty, **skip this step**
2. If set, POST the brief Markdown to the Journal sync endpoint:

```bash
curl -s -X POST "{journal_sync_url}" \
  -H "Content-Type: application/json" \
  -H "Cookie: {journal_auth_cookie}" \
  -d '{"date": "{YYYY-MM-DD}", "markdown": "{brief markdown (JSON-escaped)}"}'
```

If the request returns 401, prompt the user:
> "Journal sync failed (auth error). Please fill in `journal_auth_cookie` in `sources.md`. How to get it: Open Journal app → F12 → Application → Cookies → copy the `sb-*-auth-token` value."

If other error or timeout, do not abort — note "Journal sync failed: {error}" in Step 6 output.

---

## Step 5: Send Notification

Read `notify_mode` from `references/sources.md` and route accordingly.

### Routing Logic

```
notify_mode = "terminal"  → Display summary in conversation (default, works everywhere)
notify_mode = "daxiang"   → Send via catdesk daxiang (CatPaw + Meituan internal only)
notify_mode = "slack"     → POST to notify_target Slack webhook
notify_mode = "feishu"    → POST to notify_target Feishu bot webhook
notify_mode = "dingtalk"  → POST to notify_target DingTalk robot webhook
notify_mode = "none"      → Skip notification entirely
```

### terminal mode (default)

Display the following in the conversation:

```
✅ AI Brief delivered!

{brief title}

📊 {item count} items fetched, {selected count} in brief
🕐 Coverage: {time range}
📤 Output: {output destination description}
```

After Step 6.5 completes, append:
```
📊 Quality score: {score summary string}
📋 Full eval report: {eval report location}
```

### daxiang mode (Meituan internal only)

```bash
catdesk daxiang send --user "{daxiang_mis}" --message "..."
```

> ⚠️ Requires CatPaw environment. Falls back to `terminal` mode on failure.

Message format:
```
📰 AI Brief ready!

{brief title}

🔗 {output link/path}

Quick Decisions:
📌 {item 1}
📌 {item 2}
📌 {item 3}

📊 Quality score: {score summary string}
📋 Full eval report: {eval report location}
```

### slack mode

```bash
curl -s -X POST "{notify_target}" \
  -H "Content-Type: application/json" \
  -d '{"text": "📰 AI Brief ready!\n\n{brief title}\n\n🔗 {output link}\n\nQuick Decisions:\n📌 {item 1}\n📌 {item 2}\n📌 {item 3}"}'
```

### feishu mode

```bash
curl -s -X POST "{notify_target}" \
  -H "Content-Type: application/json" \
  -d '{"msg_type": "text", "content": {"text": "📰 AI Brief ready!\n{brief title}\n🔗 {output link}"}}'
```

### dingtalk mode

```bash
curl -s -X POST "{notify_target}" \
  -H "Content-Type: application/json" \
  -d '{"msgtype": "text", "text": {"content": "📰 AI Brief ready!\n{brief title}\n🔗 {output link}"}}'
```

If notification fails for any mode, **do not abort** — note "Notification failed: {error}" in Step 6 output.

---

## Step 6.5: Quality Self-Evaluation (every run, mandatory)

After the brief is delivered in Step 4, immediately run the self-evaluation flow.

Full execution spec: `references/eval-framework/EVAL-WORKFLOW.md`

Summary:
1. Run Layer 1 hard rule checks (5 Pass/Fail items)
2. Calculate Layer 2 quantitative score (5 items, max 50 pts)
3. Run Layer 3 qualitative evaluation (L3-1/L3-3 max 15 pts each; others max 10 pts; raw total 60 pts)
4. Normalized total = round((L2 total + L3 total) ÷ 110 × 100)
5. Deliver eval report (based on `eval_output_mode` in sources.md)
6. Append this run's score to `references/eval-framework/eval-history.md`

---

## Step 6: Return Result

After delivery, return to user:
- ✅ Brief generated and delivered
- 📎 Output location (file path / URL / platform link)
- 📊 {X} items fetched, {Y} items in brief
- 🕐 Coverage time range
- 📊 Quality score: {score summary string} (full report: {eval report location})

---

## Managing Sources

When the user says "add source", "update sources", "add X to my sources":

1. Read `references/sources.md`
2. Add new entry under the appropriate category
3. Confirm write and inform user

**Source config format**: see `references/sources.md`.

---

## Notes

- If a source fetch fails (timeout, 403, etc.), skip it — note in brief footer
- X (Twitter) content comes from the follow-builders feed (`feed-x.json`, 26 top AI builders); if feed is stale (>36h), skip and note "follow-builders feed not updated this run"
- Brief should focus on **today** or **past 24 hours** — do not mix in old news
- If there's genuinely little news (many fetch failures), be honest with the user — don't pad the brief
- Brief language: **English** by default; can be switched to Chinese by setting `brief_language: "zh"` in sources.md
- All technical terms and model names keep their original English form (GPT-5, Claude, Gemini, etc.)
