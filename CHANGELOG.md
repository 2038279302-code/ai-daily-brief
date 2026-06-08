# 变更日志（CHANGELOG）

所有重要变更按版本记录在此，格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

---

## [v1.2] — 2026-06-08

### 通用化改造（面向外部用户）

**核心变更：解除平台锁定，支持多平台输出与通知**

- **新增 `output_mode` 配置项**，支持 6 种输出方式：
  - `file` — 写入本地 Markdown 文件（默认，零依赖）
  - `clipboard` — 在对话中展示，手动复制粘贴
  - `webhook` — POST 到任意 HTTP 接口（通吃 Slack / 飞书 / 钉钉 / 自建服务）
  - `notion` — 通过 Notion API 推送到指定页面
  - `obsidian` — 写入 Obsidian Vault 目录
  - `km` — 推送到美团学城（需 CatPaw + 内网，降级逻辑：失败自动回退到 `file`）

- **新增 `notify_mode` 配置项**，支持 6 种通知方式：
  - `terminal` — 在对话中展示摘要（默认）
  - `slack` / `feishu` / `dingtalk` — 各平台 Webhook 通知
  - `daxiang` — 美团大象（需 CatPaw + 内网，失败降级到 `terminal`）
  - `none` — 不发送通知

- **新增 `eval_output_mode` 配置项**，评估报告输出独立可配置，默认跟随 `output_mode`

- **新增 `brief_language` 配置项**：`en`（默认）/ `zh`，控制日报语言

**评估框架更新（EVAL-WORKFLOW.md v1.2）**

- Step 6.5-E 从「固定写学城」改为「按 `eval_output_mode` 分支路由」
- Step 6.5-F 去掉硬编码绝对路径，改为相对路径
- 每周汇总通知改为按 `notify_mode` 发送，不再绑定大象
- 所有通知消息格式改为英文（兼容中文，可通过 `brief_language` 控制）

**仓库清理**

- 删除 `eval-framework/AGENT-DISPATCH.md`（内部 Agent 派发指令，含硬编码路径，不适合公开）
- 删除 `workspace/` 目录（与顶层内容完全重复的冗余快照）
- 重写 `scripts/sync.sh`，去除硬编码的个人路径，改为可配置的 `SKILL_SRC` 环境变量
- 重写 `README.md`，面向外部用户，去除美团专属描述
- 重写 `skill/evals/evals.json`，去除学城 URL 和美团专属 prompt
- 重写 `skill/references/eval-framework/eval-history.md`，改为英文通用空模板

---

## [v1.1] — 2026-06-08

### 评估框架升级

**核心变更：分析深度加权 + 总分归一化**

- **L3-1「分析独特性」** 满分从 10 分提升至 **15 分**（加权项 ⭐）
  - 分析深度是 PM 日报区别于普通资讯聚合的核心价值，也是当前最突出的优化痛点
- **L3-3「行动建议可操作性」** 满分从 10 分提升至 **15 分**（加权项 ⭐）
  - 空洞建议是用户体验最直接的痛点，加权后更能倒逼 Skill 改进
- **总分改为归一化计算**：原始满分 110 分 → `round(原始总分 ÷ 110 × 100)` → 100 分制
  - L1 违规时，归一化总分上限强制为 60 分

**评分历史独立文件**

- 评分历史从 `sources.md` 中分离，新建独立文件 `references/eval-framework/eval-history.md`
- 包含「每日评分表」和「每周均分表」两个表格，由 Step 6.5 自动维护

**Step 6.5 工作流更新**

- L3 各项满分说明更新（L3-1/L3-3 为 15 分，其余为 10 分）
- 总分计算逻辑改为四步骤：L1 判断 → 计算原始总分 → 归一化 → L1 违规上限修正
- 每周汇总 Step W-4 新增：将周均分写入 eval-history 每周均分表

**模板文件同步更新**

- `EVAL-RUBRIC.md`：总分表格加入「满分」列和「归一化总分」行；L3-1/L3-3 评分区间扩展为 15 分制
- `EVAL-REPORT-TEMPLATE.md`：L3-1/L3-3 标注 ⭐ 加权，人工终评分改为 /15
- `EVAL-WEEKLY-TEMPLATE.md`：周度总分表 L3 改为显示原始分 /60；累计趋势表新增「可操作性均分」列

---

## [v1.0] — 2026-06 初

### Skill 核心功能

**日报生成**

- 支持从 arXiv、OpenAI/Anthropic/Google 博客、36氪/机器之心/量子位、follow-builders feed 等多信息源并行抓取
- follow-builders feed 优先策略：覆盖 26 位顶级 AI Builder 的 X 动态 + 6 档 Podcast，无需 API Key
- 幻觉过滤规则：无 `source_url` 支撑的内容一律丢弃，禁止凭记忆补写

**PM 三层分析写作规范**

- 每条重点新闻必须包含：直接影响 → 推导结论 → 行动建议（三层至少二层）
- 禁用词列表：「值得关注」「意义重大」「影响深远」等空洞表达
- 跨事件关联规范：同日 2 条以上同主题新闻必须在「今日概览」点出共同信号

**质量评估框架（初版）**

- 三层评估体系：L1 硬规则（5 项 Pass/Fail）+ L2 量化（5 项×10分）+ L3 定性（5 项×10分）
- Step 6.5 嵌入日报生成流程，每次必须执行
- 评估报告自动输出，通知末尾附带评分摘要

**Eval 实验框架**

- 设计了三轮 Eval 场景：`eval-add-source`、`eval-generate-brief-with-km`、`eval-show-brief-only`
- 记录了有/无 Skill 对比的输出结果（`iteration-1/`）

---

*格式说明：版本号遵循时间线顺序，Breaking Change 标注需要重新对齐的配置项。*
