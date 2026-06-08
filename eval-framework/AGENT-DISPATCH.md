# AI 每日简报评估体系 · 执行 Agent 任务派发说明 v1.1

> **用途**：评审 Agent（框架设计方）向执行 Agent 派发具体落地任务的说明文档。  
> **阅读者**：负责改造 SKILL.md 和相关文件的执行 Agent  
> **变更**：v1.1 — eval-history 改为独立文件（不再写入 sources.md）

---

## 评估框架文件总览

本目录（`eval-framework/`）包含以下 5 个规范文件，**执行 Agent 在修改任何文件前必须全部阅读**：

| 文件 | 用途 |
|------|------|
| `EVAL-RUBRIC.md` | 完整的三层评分标准（L1硬规则 / L2量化 / L3定性，含归一化说明） |
| `EVAL-WORKFLOW.md` | Step 6.5 的嵌入方案 + 每周汇总触发机制 + 对 SKILL.md 的修改指引 |
| `EVAL-REPORT-TEMPLATE.md` | 单次评估报告的学城文档模板（每次生成日报后输出） |
| `EVAL-WEEKLY-TEMPLATE.md` | 每周汇总趋势报告的学城文档模板（每周一输出） |
| `EVAL-HISTORY-INIT.md`（待创建） | eval-history.md 的初始内容，由执行 Agent 在 references/eval-framework/ 下创建 |

---

## 执行任务清单

### 任务 A：修改 SKILL.md（核心）

**文件路径**：`/Users/horizon/.catpaw/skills/ai-daily-brief/SKILL.md`

**必须完成的 3 处修改**（详细说明见 `EVAL-WORKFLOW.md` 第五章「对现有 SKILL.md 的修改指引」）：

1. **在 Step 5 和 Step 6 之间插入 Step 6.5 章节**  
   内容：嵌入式质量自评的简要说明，引用 `references/eval-framework/EVAL-WORKFLOW.md`  
   注意 Step 6.5 简要说明中需包含归一化总分计算公式

2. **修改 Step 5 大象通知格式**  
   在消息末尾追加评分摘要行（格式含 `/15` 的深度得分）和评估报告链接行

3. **修改 Step 6 返回结果内容**  
   在返回给用户的内容中追加评分摘要

**注意事项**：
- SKILL.md 中原有的 Step 1-5 内容和 Step 6 的其他内容**不得修改**
- Step 6.5 章节应引用外部文档（`EVAL-WORKFLOW.md`），而非把所有规则内联写入 SKILL.md

---

### 任务 B：在 eval-framework 目录下创建 eval-history.md

**目标文件路径**：`/Users/horizon/.catpaw/skills/ai-daily-brief/references/eval-framework/eval-history.md`

**文件初始内容**（建好空表格即可，数据由 Step 6.5 自动写入）：

```markdown
# AI 每日简报 · 评分历史记录

> 此文件由 Step 6.5 自动维护，请勿手动修改数据行。  
> 最后更新：由 ai-daily-brief Skill 自动维护

---

## 每日评分记录

| 日期 | 归一化总分(/100) | L2原始(/50) | L3原始(/60) | L1违规 | 日报链接 | 评估报告链接 |
|------|----------------|------------|------------|--------|---------|------------|

---

## 每周均分记录

| 周起始 | 周结束 | 周均分(/100) | L2均分(/50) | L3均分(/60) | L1违规次数 | 周报链接 |
|--------|--------|------------|------------|------------|-----------|---------|
```

---

### 任务 C：将 eval-framework 目录复制到 Skill references 目录

**当前位置**：`/Users/horizon/Desktop/try/ai-daily-brief-workspace/eval-framework/`

**目标位置**：`/Users/horizon/.catpaw/skills/ai-daily-brief/references/eval-framework/`

将以下 4 个文件复制过去（不包含本 AGENT-DISPATCH.md 文件）：
- `EVAL-RUBRIC.md`
- `EVAL-WORKFLOW.md`
- `EVAL-REPORT-TEMPLATE.md`
- `EVAL-WEEKLY-TEMPLATE.md`

然后在目标目录下执行任务 B，创建 `eval-history.md`。

这样 SKILL.md 中的引用路径 `references/eval-framework/EVAL-WORKFLOW.md` 才能正确解析。

---

## 完成验证

执行 Agent 完成所有任务后，请验证以下内容：

- [ ] `SKILL.md` 中存在 `## Step 6.5：质量自评` 章节，且包含归一化公式说明
- [ ] `SKILL.md` 中 Step 5 的大象通知格式包含评分摘要行（含 `/15` 格式）
- [ ] `SKILL.md` 中 Step 6 的返回结果包含评分摘要
- [ ] `/Users/horizon/.catpaw/skills/ai-daily-brief/references/eval-framework/` 目录存在且包含 4 个规范文件 + `eval-history.md`
- [ ] `eval-history.md` 包含「每日评分记录」和「每周均分记录」两个空表格

---

*派发说明版本：v1.1 | 评审 Agent 输出 | 日期：2026-06-08 | 变更：eval-history 独立文件*
