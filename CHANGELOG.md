# 变更日志（CHANGELOG）

所有重要变更按版本记录在此，格式参考 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。

---

## [v1.1] — 2026-06-08

### 评估框架升级（Breaking Change for Eval）

**核心变更：分析深度加权 + 总分归一化**

- **L3-1「分析独特性」** 满分从 10 分提升至 **15 分**（加权项 ⭐）
  - 原因：分析深度是 PM 日报区别于普通资讯聚合的核心价值，也是当前最突出的优化痛点
- **L3-3「行动建议可操作性」** 满分从 10 分提升至 **15 分**（加权项 ⭐）
  - 原因：空洞建议是用户体验最直接的痛点，加权后更能倒逼 Skill 改进
- **总分改为归一化计算**：原始满分 110 分 → `round(原始总分 ÷ 110 × 100)` → 100 分制对外显示
  - L1 违规时，归一化总分上限强制为 60 分

**评分历史独立文件**

- 评分历史从 `sources.md` 中分离，新建独立文件 `references/eval-framework/eval-history.md`
- 包含「每日评分表」和「每周均分表」两个表格
- 由 Step 6.5 自动维护，禁止手动修改数据行

**Step 6.5 工作流更新**

- L3 各项满分说明更新（L3-1/L3-3 为 15 分，L3-2/4/5 为 10 分）
- 总分计算逻辑改为四步骤：L1 判断 → 计算原始总分 → 归一化 → L1 违规上限修正
- eval-history 文件路径明确为 `references/eval-framework/eval-history.md`
- 每周汇总 Step W-4 追加：将周均分写入 eval-history 每周均分表

**模板文件同步更新**

- `EVAL-RUBRIC.md`：总分表格加入「满分」列和「归一化总分」行；L3-1/L3-3 评分区间扩展为 15 分制
- `EVAL-REPORT-TEMPLATE.md`：L3-1/L3-3 标注 ⭐ 加权，人工终评分改为 /15；改进建议加入满分标注
- `EVAL-WEEKLY-TEMPLATE.md`：周度总分表 L3 改为显示原始分 /60；各维度表加入满分列；累计趋势表新增「可操作性均分」列
- 所有模板版本号升至 v1.1

---

## [v1.0] — 2026-06 初

### Skill 核心功能

**日报生成**

- 支持从 arXiv、OpenAI/Anthropic/Google 博客、36氪/机器之心/量子位、follow-builders feed 等多信息源并行抓取
- follow-builders feed 优先策略：覆盖 26 位顶级 AI Builder 的 X 动态（Andrej Karpathy、Sam Altman 等）+ 6 档 Podcast
- 幻觉过滤规则：无 `source_url` 支撑的内容一律丢弃，禁止凭记忆补写

**PM 三层分析写作规范**

- 每条重点新闻必须包含：直接影响 → 推导结论 → 行动建议（三层至少二层）
- 禁用词列表：「值得关注」「意义重大」「影响深远」等空洞表达
- 跨事件关联规范：同日 2 条以上同主题新闻必须在「今日概览」点出共同信号

**推送与通知**

- Step 4：推送到学城文档（citadel skill），目标父文档 ID 配置在 sources.md
- Step 4.5：可选同步到个人 Journal（`journal_sync_url` 配置项）
- Step 5：大象消息通知（含今日速记 3 条 + 评分摘要）

**质量评估框架（初版）**

- 三层评估体系：L1 硬规则（5 项 Pass/Fail）+ L2 量化（5 项×10分）+ L3 定性（5 项×10分）
- Step 6.5 嵌入日报生成流程，每次必须执行
- 评估报告自动创建为学城文档（与日报同父目录）
- 大象通知末尾附带评分摘要

**Eval 框架（外部）**

- 设计了三轮 Eval 实验场景：`eval-add-source`、`eval-generate-brief-with-km`、`eval-show-brief-only`
- 记录了有/无 Skill 对比的输出结果（`workspace/iteration-1/`）
- 建立了 `AGENT-DISPATCH.md` 多 Agent 协作派发机制

---

*格式说明：版本号遵循 YYYY-MM 的时间线顺序，Breaking Change 标注需要重新对齐的配置或评分历史。*
