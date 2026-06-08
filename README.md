# AI 每日简报（AI Daily Brief）

> 专为 AI 产品经理设计的每日信息聚合 Skill，自动抓取 → AI 提炼 → 推送学城，附带三层质量评估体系。

---

## 这是什么

一个运行在 CatPaw IDE 里的 AI Skill。每天触发一次，自动从十余个优质信息源并行抓取当日 AI 领域动态，经 AI 提炼分析后，以「叙事性 + 重要性排序」风格生成日报，并一键推送到学城文档，同时发送大象消息通知。

区别于普通的信息聚合工具，本 Skill 特别针对**产品经理视角**设计写作规范：要求每条重点新闻必须给出「直接影响 → 推导结论 → 行动建议」三层分析，避免空洞的"值得关注"式输出。

---

## 目录结构

```
ai-daily-brief/
├── skill/                              ← Skill 主体（部署在 CatPaw）
│   ├── SKILL.md                        ← 主工作流定义
│   ├── evals/
│   │   └── evals.json                  ← Eval 测试用例
│   └── references/
│       ├── sources.md                  ← 信息源配置（URL、推送配置、大象通知）
│       └── eval-framework/             ← 质量评估框架
│           ├── EVAL-RUBRIC.md          ← 三层评分标准（v1.1）
│           ├── EVAL-WORKFLOW.md        ← Step 6.5 执行规范
│           ├── EVAL-REPORT-TEMPLATE.md ← 单次评估报告模板
│           ├── EVAL-WEEKLY-TEMPLATE.md ← 每周汇总报告模板
│           └── eval-history.md         ← 历史评分记录（自动维护）
│
├── workspace/                          ← 设计工作区（规范草稿、实验记录）
│   ├── eval-framework/                 ← 评估框架设计稿（含 AGENT-DISPATCH）
│   └── iteration-1/                    ← 第一轮 Eval 实验结果
│       └── eval-add-source/            ← "添加信息源"场景的有/无 Skill 对比
│
├── scripts/
│   └── sync.sh                         ← 一键同步本地改动到 GitHub
└── .gitignore
```

---

## 信息源覆盖

| 类型 | 来源 |
|------|------|
| 🥇 X 一手动态 | follow-builders feed（Andrej Karpathy、Sam Altman、Swyx 等 26 位顶级 AI Builder） |
| 🎙️ Podcast | Latent Space / No Priors / Training Data 等 6 档 |
| 📝 官方博客 | Anthropic Engineering、Claude Blog |
| 📰 中文科技媒体 | 36氪、机器之心、量子位 |
| 🔬 论文 | arXiv AI/ML 最新 |
| 🌐 英文媒体 | OpenAI 博客、Google DeepMind Blog 等 |

---

## 工作流

```
Step 1  读取 references/sources.md 信息源配置
Step 2  并行抓取（follow-builders feed 优先）
Step 3  AI 提炼 + 按 PM 三层分析规范生成日报
Step 4  推送到学城文档（citadel skill）
Step 4.5 同步到个人 Journal（可选）
Step 5  大象消息通知
Step 6.5 质量自评（三层评分 + 学城评估报告）
Step 6  返回结果摘要
```

---

## 质量评估体系（v1.1）

每次生成日报后自动执行三层评估，结果写入学城评估报告并追加到 `eval-history.md`：

| 层级 | 说明 | 满分 |
|------|------|------|
| Layer 1 | 硬规则检测（source_url 完整性、日期合规、结构完整等 5 项） | Pass/Fail（一票否决） |
| Layer 2 | 量化指标（时效性、信息源命中率、内容密度、禁用词、PM三层覆盖） | 50 分 |
| Layer 3 | 定性深度（分析独特性⭐、跨事件关联、行动可操作性⭐、叙事感、筛选眼光） | 60 分（加权） |
| **归一化总分** | round((L2 + L3) ÷ 110 × 100) | **100 分** |

> ⭐ 加权项：L3-1「分析独特性」和 L3-3「行动建议可操作性」各 15 分（其余 10 分），对应 PM 日报最核心的价值诉求。

---

## 快速上手

在 CatPaw 中，直接说任意一句：

- `帮我生成今天的 AI 日报`
- `看看今天 AI 有什么新动态`
- `生成 AI 早报并推送到学城`

首次使用需配置 `references/sources.md` 中的 `km_parent_id`（学城父文档 ID）和 `daxiang_mis`（大象通知接收人）。

---

## 同步到 GitHub

每次修改 Skill 或评估框架后，运行：

```bash
cd /tmp/ai-daily-brief-repo && bash scripts/sync.sh "你的更新说明"
```

---

## 相关链接

- 学城日报父文档：配置在 `skill/references/sources.md`
- 评估报告：每次生成日报后自动创建，与日报同父目录
- 质量评分历史：`skill/references/eval-framework/eval-history.md`
