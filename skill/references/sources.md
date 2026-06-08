# AI Daily Brief — Source & Delivery Config

This is the core config file for the `ai-daily-brief` skill.
It manages all news source URLs, fetch strategies, output destinations, and notification settings.

When you want to add/modify/remove sources or change where the brief is delivered, edit this file.

---

## Delivery Config

```yaml
# ─── Brief Language ──────────────────────────────────────────────────────────
# "en" = English (default) | "zh" = Chinese
brief_language: "en"

# ─── Output Mode ─────────────────────────────────────────────────────────────
# Where to deliver the generated brief.
# Options:
#   file        → Write Markdown file to local disk (set output_path below)
#   clipboard   → Display in conversation; copy-paste to any platform
#   webhook     → HTTP POST to any URL (Slack / Feishu / DingTalk / custom)
#   notion      → Push to a Notion page (set notion_token + notion_page_id)
#   obsidian    → Write Markdown to an Obsidian vault folder
#   km          → Push to Meituan KM / 学城 (requires CatPaw + internal network)
output_mode: "file"

# ─── file mode config ────────────────────────────────────────────────────────
# Local directory to save briefs. Created automatically if it doesn't exist.
# Example: "~/Documents/ai-briefs"  or  "/Users/yourname/Dropbox/AI-Brief"
output_path: "~/ai-daily-brief"

# ─── webhook mode config ─────────────────────────────────────────────────────
# POST the brief JSON payload to this URL.
# Works with: Slack Incoming Webhooks, Feishu bots, DingTalk robots, custom APIs.
webhook_url: ""
# Additional headers (key: value pairs). Example:
#   Authorization: "Bearer your-token"
#   X-Custom-Header: "value"
webhook_headers: {}

# ─── notion mode config ──────────────────────────────────────────────────────
# Get your token at: https://www.notion.so/my-integrations
# Share the target page with your integration before use.
notion_token: ""
notion_page_id: ""

# ─── obsidian mode config ────────────────────────────────────────────────────
# Full path to the target folder inside your Obsidian vault.
# Example: "~/Documents/MyVault/AI-Brief"
obsidian_vault_path: ""

# ─── km mode config (Meituan internal only) ──────────────────────────────────
# Parent document ID in KM (学城). The brief will be created as a child doc.
# If empty on first run, the skill will ask you for the parent page link.
km_parent_id: ""

# ─── Journal sync (optional) ─────────────────────────────────────────────────
# After delivery, also sync the brief to a personal Journal app.
# Leave empty to skip.
# URL format: "http://localhost:3000/api/sync-brief" (local) or your hosted URL
journal_sync_url: ""
# Login cookie for Journal auth (how to get: F12 → Application → Cookies → sb-*-auth-token)
# Note: treat this as a secret — do NOT commit to git
journal_auth_cookie: ""

# ─── Notification Mode ───────────────────────────────────────────────────────
# How to notify you when the brief is ready.
# Options:
#   terminal    → Show summary in the conversation (default, works everywhere)
#   slack       → POST to notify_target Slack webhook
#   feishu      → POST to notify_target Feishu bot webhook
#   dingtalk    → POST to notify_target DingTalk robot webhook
#   daxiang     → Send via Meituan 大象 IM (requires CatPaw + internal network)
#   none        → No notification
notify_mode: "terminal"
# Webhook URL or user ID for the notification target (required for all modes except terminal/none/daxiang)
notify_target: ""

# ─── Meituan 大象 config (daxiang mode only) ────────────────────────────────
daxiang_mis: ""

# ─── Evaluation Output Mode ──────────────────────────────────────────────────
# Where to deliver the quality eval report (generated in Step 6.5).
# Options: same as output_mode, plus "same" (follow output_mode automatically)
# "km" requires internal network; falls back to "file" if unavailable.
eval_output_mode: "same"

# ─── Brief Title Prefix ──────────────────────────────────────────────────────
title_prefix: "[AI Brief]"
```

---

## Source List

Each source entry has:
- `name`: Source display name
- `url`: Fetch URL (prefer RSS/JSON feed; otherwise use web page URL)
- `type`: `rss` / `web` / `x-aggregator`
- `priority`: `high` / `medium` / `low`
- `enabled`: `true` / `false`
- `note`: (optional) fetch instructions

---

### 📡 Official First-Party Sources

| Name | URL | Type | Priority | Enabled |
|------|-----|------|----------|---------|
| OpenAI Blog | https://openai.com/blog | web | high | true |
| Anthropic News | https://www.anthropic.com/news | web | high | true |
| Google DeepMind Blog | https://deepmind.google/discover/blog/ | web | high | true |
| Google AI Blog | https://blog.google/technology/ai/ | web | high | true |
| Meta AI Blog | https://ai.meta.com/blog/ | web | medium | true |
| Mistral AI News | https://mistral.ai/news/ | web | medium | true |
| xAI Blog | https://x.ai/blog | web | medium | true |
| Hugging Face Blog | https://huggingface.co/blog | web | medium | true |
| LangChain Blog | https://blog.langchain.dev/ | web | low | true |

---

### 📰 Chinese Tech Media

| Name | URL | Type | Priority | Enabled |
|------|-----|------|----------|---------|
| 36Kr AI | https://36kr.com/information/AI/ | web | high | true |
| 机器之心 Jiqizhixin | https://www.jiqizhixin.com/ | web | high | true |
| 量子位 Qbitai | https://www.qbitai.com/ | web | high | true |
| 新智元 Aiera | https://www.aiera.com/ | web | medium | true |
| AI科技评论 | https://www.aitechtalk.com/ | web | medium | false |

---

### 📚 Academic Papers

| Name | URL | Type | Priority | Enabled | Note |
|------|-----|------|----------|---------|------|
| arXiv cs.AI | https://arxiv.org/list/cs.AI/recent | web | medium | true | Past 24h paper list |
| arXiv cs.LG | https://arxiv.org/list/cs.LG/recent | web | medium | true | Machine learning |
| arXiv cs.CL | https://arxiv.org/list/cs.CL/recent | web | medium | true | NLP |
| Papers With Code | https://paperswithcode.com/latest | web | low | true | Popular papers with code |

---

### 🐦 X (Twitter) — Top AI Builder Feed

**Data source: [follow-builders](https://github.com/zarazhangrui/follow-builders) (maintained by Zara Zhang)**

A curated list of 26 top AI builders, with a daily-updated public JSON feed. No API key required — fetch directly.

**Three feed URLs (direct `web_fetch`):**

| Feed | URL | Content |
|------|-----|---------|
| X/Twitter Builders | `https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-x.json` | Daily posts from 26 top AI builders (text, likes, retweets, URL) |
| Podcasts | `https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-podcasts.json` | Latent Space / No Priors / Training Data and 3 other podcasts |
| Official Blogs | `https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-blogs.json` | Anthropic Engineering + Claude Blog latest posts |

**26 AI Builders covered:**
Andrej Karpathy, Swyx, Josh Woodward (Google Labs VP), Boris Cherny (Anthropic), Thibault Sottiaux (OpenAI Codex), Peter Yang, Nan Yu, Madhu Guru, Amanda Askell (Anthropic), Cat Wu, Thariq, Google Labs, Amjad Masad (Replit), Guillermo Rauch (Vercel), Alex Albert (Anthropic), Aaron Levie (Box), Ryo Lu, Garry Tan (YC), Matt Turck, Zara Zhang, Nikunj Kothari, Peter Steinberger, Dan Shipper (Every), Aditya Agarwal, Sam Altman (OpenAI), Claude AI

**6 Podcasts covered (YouTube):**
Latent Space, Training Data, No Priors, Unsupervised Learning, The MAD Podcast with Matt Turck, AI & I by Every

**Fetch rules:**
- `feed-x.json` schema: `{ "generatedAt": "...", "x": [{ "name": "...", "handle": "...", "tweets": [{ "text": "...", "url": "...", "likes": N, "createdAt": "..." }] }] }`
- `tweet.url` is the direct `source_url` — cite as-is
- Sort by `likes + retweets`, prioritize high-engagement tweets
- If feed is stale (`generatedAt` > 36h ago), skip and note in brief footer

---

### 🌐 English Tech Media

| Name | URL | Type | Priority | Enabled |
|------|-----|------|----------|---------|
| TechCrunch AI | https://techcrunch.com/category/artificial-intelligence/ | web | medium | true |
| The Verge AI | https://www.theverge.com/ai-artificial-intelligence | web | medium | true |
| Wired AI | https://www.wired.com/tag/artificial-intelligence/ | web | low | true |
| VentureBeat AI | https://venturebeat.com/category/ai/ | web | low | false |

---

### 🔍 Aggregators & Communities

| Name | URL | Type | Priority | Enabled | Note |
|------|-----|------|----------|---------|------|
| Hacker News | https://news.ycombinator.com/front | web | medium | true | Filter for AI-related posts |
| Product Hunt AI | https://www.producthunt.com/categories/artificial-intelligence | web | medium | true | New AI product launches |

---

## How to Add a New Source

Add a row in the relevant table, e.g.:

```markdown
| ByteDance AI Blog | https://ai.bytedance.com/blog | web | medium | true |
```

Then tell the skill "I've updated sources, please reload." It takes effect on the next run.

---

## Fetch Failure Handling

| Failure Type | Handling |
|-------------|---------|
| Network timeout | Skip source, note in brief footer |
| 403/401 access denied | Skip; suggest user check for alternative URL |
| Empty content | Skip; no impact on overall flow |
| follow-builders feed stale | Skip X/Podcast section; note "follow-builders feed not updated this run (>36h)" |

---

## Config Quick-Reference

| Platform | Required fields | Where to get credentials |
|----------|----------------|--------------------------|
| Local file | `output_path` | Just set a folder path |
| Clipboard | (none) | No config needed |
| Slack | `webhook_url` | Slack app → Incoming Webhooks |
| Feishu (飞书) | `notify_target` | Feishu bot → Webhook URL |
| DingTalk (钉钉) | `notify_target` | DingTalk robot → Webhook URL |
| Notion | `notion_token`, `notion_page_id` | https://www.notion.so/my-integrations |
| Obsidian | `obsidian_vault_path` | Path to your vault folder |
| Meituan KM (学城) | `km_parent_id` | KM page URL → last number in path |
| 大象 (Daxiang) | `daxiang_mis` | Your Meituan MIS account |

---

*Last updated: maintained automatically by ai-daily-brief skill*
