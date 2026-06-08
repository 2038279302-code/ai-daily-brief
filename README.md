# AI Daily Brief

> 专为产品经理设计的 AI 领域每日信息聚合 Skill，自动抓取 → AI 提炼 → 推送到你用的任意平台。

---

## 这是什么

一个 AI Skill（为 [CatPaw IDE](https://catpaw.com) 设计，核心逻辑可适配任何支持 LLM Agent 的环境）。每天触发一次，自动完成：

1. **抓取** — 从 10+ 优质信息源并行获取当日 AI 领域动态
2. **提炼** — 用 PM 三层分析框架生成有深度的日报内容
3. **推送** — 发送到你配置的任意目的地（本地文件、Notion、Obsidian、Slack、Webhook 等）
4. **通知** — 通过你偏好的渠道推送摘要
5. **自评** — 每次自动执行三层质量评分，追踪日报质量趋势

区别于普通资讯聚合工具：每条重点新闻必须给出「**直接影响 → 推导结论 → 行动建议**」三层分析，明确禁止"值得关注"式的空洞表达。

---

## 目录结构

```
ai-daily-brief/
├── skill/                              ← Skill 主体（在 CatPaw 中安装，或移植到其他 Agent 环境）
│   ├── SKILL.md                        ← 主工作流定义
│   ├── evals/
│   │   └── evals.json                  ← Eval 测试用例
│   └── references/
│       ├── sources.md                  ← 信息源与推送配置（按需修改）
│       └── eval-framework/             ← 质量评估框架
│           ├── EVAL-RUBRIC.md          ← 三层评分标准（v1.1）
│           ├── EVAL-WORKFLOW.md        ← Step 6.5 执行规范（v1.2）
│           ├── EVAL-REPORT-TEMPLATE.md ← 单次评估报告模板
│           ├── EVAL-WEEKLY-TEMPLATE.md ← 每周汇总报告模板
│           └── eval-history.md         ← 历史评分记录（自动维护）
│
├── eval-framework/                     ← 评估框架设计文档（与 skill/references/eval-framework/ 同步）
│
├── iteration-1/                        ← 第一轮 Eval 实验结果（有/无 Skill 的对比记录）
│   └── eval-add-source/
│       ├── with_skill/outputs/         ← 有 Skill 时的输出
│       └── without_skill/outputs/      ← 无 Skill 时的输出（基线对照）
│
├── scripts/
│   └── sync.sh                         ← 一键将本地 Skill 修改同步到此仓库
└── .gitignore
```

---

## 信息源覆盖

| 类型 | 来源 |
|------|------|
| 🥇 X 一手动态 | follow-builders feed（Andrej Karpathy、Sam Altman、Swyx 等 26 位顶级 AI Builder） |
| 🎙️ Podcast | Latent Space / No Priors / Training Data / Unsupervised Learning / MAD Podcast / AI & I |
| 📝 官方博客 | OpenAI、Anthropic Engineering、Claude Blog、Google DeepMind、Meta AI、Mistral、xAI |
| 📰 中文科技媒体 | 36氪 AI、机器之心、量子位 |
| 🔬 论文 | arXiv AI / ML / NLP 最新，Papers With Code |
| 🌐 英文媒体 | TechCrunch AI、The Verge AI、Wired AI、Hacker News、Product Hunt AI |

X/Twitter 内容全部来自 [follow-builders](https://github.com/zarazhangrui/follow-builders) 公开 JSON feed，**无需任何 API Key**。

---

## 工作流

```
Step 1    读取 references/sources.md 信息源配置
Step 2    并行抓取（follow-builders feed 优先）
Step 3    AI 提炼 + 按 PM 三层分析规范生成日报
Step 4    推送输出（file / clipboard / webhook / Notion / Obsidian / KM）
Step 4.5  可选同步到个人 Journal 应用
Step 5    发送通知（terminal / Slack / 飞书 / 钉钉 / none）
Step 6.5  质量自评（三层评分 + 评估报告）
Step 6    返回结果摘要
```

---

## 推送与通知配置

在 `skill/references/sources.md` 中设置 `output_mode` 和 `notify_mode`：

**输出方式（output_mode）**

| 值 | 说明 |
|----|------|
| `file` | 写入本地 Markdown 文件（默认，零依赖） |
| `clipboard` | 在对话中展示，复制粘贴到任意平台 |
| `webhook` | POST 到任意 HTTP 接口（Slack / 飞书 / 钉钉 / 自建服务） |
| `notion` | 通过 Notion API 推送到指定页面 |
| `obsidian` | 写入 Obsidian Vault 目录 |
| `km` | 推送到美团学城（需 CatPaw + 内网环境） |

**通知方式（notify_mode）**

| 值 | 说明 |
|----|------|
| `terminal` | 在对话中展示摘要（默认） |
| `slack` | POST 到 Slack Incoming Webhook |
| `feishu` | POST 到飞书机器人 Webhook |
| `dingtalk` | POST 到钉钉机器人 Webhook |
| `daxiang` | 美团大象 IM（需 CatPaw + 内网环境） |
| `none` | 不发送通知 |

---

## 质量评估体系（v1.1）

每次生成日报后，Step 6.5 自动执行三层评估，结果写入评估报告并追加到 `eval-history.md`：

| 层级 | 说明 | 满分 |
|------|------|------|
| Layer 1 | 硬规则检测（source_url 完整性、日期时效、结构完整、标题层级、速记格式，共 5 项） | Pass/Fail（一票否决） |
| Layer 2 | 量化指标（时效性、信息源命中率、内容密度、禁用词、PM 三层覆盖） | 50 分 |
| Layer 3 | 定性深度（分析独特性 ⭐、跨事件关联、行动可操作性 ⭐、叙事感、筛选眼光） | 60 分（加权） |
| **归一化总分** | `round((L2 + L3) ÷ 110 × 100)` | **100 分** |

> ⭐ 加权项：L3-1「分析独特性」和 L3-3「行动建议可操作性」各 15 分（其余 10 分），对应 PM 日报最核心的价值诉求。

---

## 快速上手

### 在 CatPaw 中使用

安装 Skill 后，直接触发：
- `帮我生成今天的 AI 日报`
- `看看今天 AI 有什么新动态`
- `把 XXX 博客添加到我的信息源`

首次使用前，在 `skill/references/sources.md` 中配置 `output_mode` 和 `notify_mode`。

### 在其他 Agent 环境中使用

将 `skill/SKILL.md` 的内容作为 System Prompt 或 Workflow 指令使用，以 `references/sources.md` 作为配置文件。抓取、分析、写作逻辑完全可移植，手动处理推送输出部分即可。

---

## 同步本地改动

修改 Skill 或评估框架后，运行：

```bash
bash scripts/sync.sh "你的更新说明"
```

脚本会自动识别仓库位置，并默认从 CatPaw 的 Skill 安装目录同步。如需指定其他路径：

```bash
SKILL_SRC=/path/to/your/skill bash scripts/sync.sh "更新说明"
```

---

## 相关链接

- [follow-builders](https://github.com/zarazhangrui/follow-builders) — 为本 Skill 提供 X Builder 动态的数据源
- 质量评分历史：`skill/references/eval-framework/eval-history.md`（每次运行自动更新）
