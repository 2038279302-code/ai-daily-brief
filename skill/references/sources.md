# AI 每日简报信息源配置

本文件是 `ai-daily-brief` Skill 的核心配置文件。维护所有信息源的 URL、抓取说明和推送配置。
当用户需要添加/修改/删除信息源时，直接编辑本文件对应部分。

---

## 推送配置

```yaml
# 学城父文档 ID（日报将创建为该文档的子文档）
# 首次运行时若为空，Skill 会主动询问用户
km_parent_id: "2766983616"

# 日报文档标题前缀（最终标题格式：{title_prefix} YYYY-MM-DD）
title_prefix: "【AI 日报】"

# 大象通知接收人 MIS 号（日报推送学城后，会给此 MIS 发一条大象消息）
# 留空则跳过大象通知
daxiang_mis: "huanglindi"
```

---

## 信息源列表

每个信息源包含以下字段：
- `name`: 信息源名称
- `url`: 抓取 URL（优先使用 RSS/JSON feed，否则用网页 URL）
- `type`: 类型（`rss` / `web` / `x-aggregator`）
- `priority`: 优先级（`high` / `medium` / `low`）
- `enabled`: 是否启用（`true` / `false`）
- `note`: 抓取说明（可选）

---

### 📡 一手官方信息源

| 名称 | URL | 类型 | 优先级 | 启用 |
|------|-----|------|--------|------|
| OpenAI 官方博客 | https://openai.com/blog | web | high | true |
| Anthropic 官方博客 | https://www.anthropic.com/news | web | high | true |
| Google DeepMind 博客 | https://deepmind.google/discover/blog/ | web | high | true |
| Google AI 博客 | https://blog.google/technology/ai/ | web | high | true |
| Meta AI 博客 | https://ai.meta.com/blog/ | web | medium | true |
| Mistral AI 博客 | https://mistral.ai/news/ | web | medium | true |
| xAI 官方博客 | https://x.ai/blog | web | medium | true |
| Hugging Face 博客 | https://huggingface.co/blog | web | medium | true |
| LangChain 博客 | https://blog.langchain.dev/ | web | low | true |

---

### 📰 中文科技媒体

| 名称 | URL | 类型 | 优先级 | 启用 |
|------|-----|------|--------|------|
| 36氪 AI 频道 | https://36kr.com/information/AI/ | web | high | true |
| 机器之心 | https://www.jiqizhixin.com/ | web | high | true |
| 量子位 | https://www.qbitai.com/ | web | high | true |
| 新智元 | https://www.aiera.com/ | web | medium | true |
| AI科技评论 | https://www.aitechtalk.com/ | web | medium | false |

---

### 📚 学术论文

| 名称 | URL | 类型 | 优先级 | 启用 | 说明 |
|------|-----|------|--------|------|------|
| arXiv cs.AI 最新 | https://arxiv.org/list/cs.AI/recent | web | medium | true | 抓取最近 1 天的论文列表 |
| arXiv cs.LG 最新 | https://arxiv.org/list/cs.LG/recent | web | medium | true | 机器学习方向 |
| arXiv cs.CL 最新 | https://arxiv.org/list/cs.CL/recent | web | medium | true | 自然语言处理方向 |
| Papers With Code | https://paperswithcode.com/latest | web | low | true | 有代码实现的热门论文 |

---

### 🐦 X（Twitter）头部 AI Builder 动态

**数据来源：[follow-builders](https://github.com/zarazhangrui/follow-builders)（Zara Zhang 维护）**

该项目维护了一份经过精心筛选的 AI builders 名单（26 位），提供每日更新的公开 JSON feed，无需任何 API key 即可直接访问。优先使用这三个 feed 作为 X 内容的**一手来源**。

**三个 Feed URL（直接 `web_fetch` 抓取）：**

| Feed | URL | 内容 |
|------|-----|------|
| X/Twitter Builders | `https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-x.json` | 26 位顶级 AI builder 的当日推文（含原文、likes、retweets、URL） |
| Podcast | `https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-podcasts.json` | Latent Space / No Priors / Training Data 等 6 档播客最新内容 |
| Official Blogs | `https://raw.githubusercontent.com/zarazhangrui/follow-builders/main/feed-blogs.json` | Anthropic Engineering + Claude Blog 最新文章 |

**覆盖的 26 位 AI Builders（X 账号）：**
Andrej Karpathy、Swyx、Josh Woodward（Google Labs VP）、Boris Cherny（Anthropic）、Thibault Sottiaux（OpenAI Codex）、Peter Yang、Nan Yu、Madhu Guru、Amanda Askell（Anthropic）、Cat Wu、Thariq、Google Labs、Amjad Masad（Replit）、Guillermo Rauch（Vercel）、Alex Albert（Anthropic）、Aaron Levie（Box）、Ryo Lu、Garry Tan（YC）、Matt Turck、Zara Zhang、Nikunj Kothari、Peter Steinberger、Dan Shipper（Every）、Aditya Agarwal、Sam Altman（OpenAI）、Claude AI

**覆盖的 6 档 Podcast（YouTube）：**
Latent Space、Training Data、No Priors、Unsupervised Learning、The MAD Podcast with Matt Turck、AI & I by Every

**抓取规则：**
- `feed-x.json` 数据结构：`{ "generatedAt": "...", "x": [{ "name": "...", "handle": "...", "tweets": [{ "text": "...", "url": "...", "likes": N, "createdAt": "..." }] }] }`
- `tweet.url` 字段即为该推文的 `source_url`，可直接引用
- 按 `likes + retweets` 排序，优先提取互动量高的推文进入日报
- 若 feed 当日未更新（`generatedAt` 超过 36 小时），则跳过，在日报中注明

---

### 🌐 英文科技媒体

| 名称 | URL | 类型 | 优先级 | 启用 |
|------|-----|------|--------|------|
| TechCrunch AI | https://techcrunch.com/category/artificial-intelligence/ | web | medium | true |
| The Verge AI | https://www.theverge.com/ai-artificial-intelligence | web | medium | true |
| Wired AI | https://www.wired.com/tag/artificial-intelligence/ | web | low | true |
| VentureBeat AI | https://venturebeat.com/category/ai/ | web | low | false |

---

### 🔍 聚合与社区

| 名称 | URL | 类型 | 优先级 | 启用 | 说明 |
|------|-----|------|--------|------|------|
| Hacker News（AI 相关） | https://news.ycombinator.com/front | web | medium | true | 抓取后过滤 AI 相关帖子 |
| Product Hunt（AI 分类） | https://www.producthunt.com/categories/artificial-intelligence | web | medium | true | 关注新 AI 产品发布 |

---

## 如何添加新信息源

在对应分类下按表格格式添加一行即可，例如：

```markdown
| ByteDance AI 博客 | https://ai.bytedance.com/blog | web | medium | true |
```

添加后告诉 Skill「我已更新信息源，请重新加载」，下次生成日报时即生效。

---

## 抓取失败处理策略

| 失败类型 | 处理方式 |
|----------|----------|
| 网络超时 | 跳过该源，日报末尾注明 |
| 403/401 权限拒绝 | 跳过，建议用户检查是否有替代 URL |
| 内容为空 | 跳过，不影响整体 |
| follow-builders feed 未更新 | 跳过 X/Podcast 板块，注明「follow-builders feed 本次未获取到（超过 36 小时未更新）」|

---

*最后更新：由 ai-daily-brief Skill 自动维护*
