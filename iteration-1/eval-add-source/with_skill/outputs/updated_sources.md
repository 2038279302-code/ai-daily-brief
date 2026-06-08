# AI 每日简报信息源配置

本文件是 `ai-daily-brief` Skill 的核心配置文件。维护所有信息源的 URL、抓取说明和推送配置。
当用户需要添加/修改/删除信息源时，直接编辑本文件对应部分。

---

## 推送配置

```yaml
# 学城父文档 ID（日报将创建为该文档的子文档）
# 首次运行时若为空，Skill 会主动询问用户
km_parent_id: ""

# 日报文档标题前缀（最终标题格式：{title_prefix} YYYY-MM-DD）
title_prefix: "【AI 日报】"
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
| 豆包官方博客 | https://team.doubao.com/blog | web | high | true |
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

由于 X 平台访问限制，通过以下聚合工具抓取：

| 人物 | X 主页 | 领域 | 启用 |
|------|--------|------|------|
| Sam Altman | https://twitter.com/sama | OpenAI CEO | true |
| Andrej Karpathy | https://twitter.com/karpathy | AI 研究/教育 | true |
| Yann LeCun | https://twitter.com/ylecun | Meta 首席 AI 科学家 | true |
| Ilya Sutskever | https://twitter.com/ilyasut | SSI | true |
| Demis Hassabis | https://twitter.com/demishassabis | Google DeepMind CEO | true |
| Dario Amodei | https://twitter.com/DarioAmodei | Anthropic CEO | true |
| Greg Brockman | https://twitter.com/gdb | OpenAI 联合创始人 | true |
| Emad Mostaque | https://twitter.com/EMostaque | AI 独立研究员 | true |
| Jim Fan | https://twitter.com/DrJimFan | NVIDIA AI | true |
| Fei-Fei Li | https://twitter.com/drfeifei | World Labs | true |

**X 内容抓取备用方案**（按优先级尝试）：
1. 尝试 `https://nitter.net/{username}` 镜像
2. 尝试 `https://nitter.privacydev.net/{username}`
3. 若均失败，跳过 X 部分，在日报中注明

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
| X 平台全部镜像失败 | 跳过 X 板块，注明「X 平台本次未抓取到」|

---

*最后更新：由 ai-daily-brief Skill 自动维护*
