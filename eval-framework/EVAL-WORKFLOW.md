# AI 每日简报 · 评估工作流说明 v1.1

> **用途**：指导执行 Agent 将质量评估流程嵌入现有日报生成 Skill（Step 6.5），以及每周汇总报告的触发机制。  
> **变更记录**：v1.1 — 总分改为归一化计算（原始110分→100分），eval-history 独立文件

---

## 一、嵌入方式：Step 6.5（在现有 Skill 的 Step 5 和 Step 6 之间插入）

### 整体流程变更

```
原流程：
Step 1 → Step 2 → Step 3 → Step 4 → Step 4.5 → Step 5 → Step 6

新流程：
Step 1 → Step 2 → Step 3 → Step 4 → Step 4.5 → Step 5 → [Step 6.5 自评] → Step 6（附带评分摘要）
```

---

## 二、Step 6.5 详细执行规范

### 触发条件

Step 4（学城推送）成功返回文档链接后，**立即**执行 Step 6.5，不得跳过。

若 Step 4 失败（学城推送失败），**跳过** Step 6.5，在 Step 6 中注明「评估未执行（学城推送失败）」。

---

### Step 6.5-A：运行 Layer 1 硬规则检测

对本次生成的日报正文（Step 3 输出的 Markdown 内容）执行以下 5 项检测：

#### 检测 1：source_url 完整性
```
扫描日报中所有格式为 `来源：[xxx](url)` 的链接
对每个 url 判断：
  - 若 url 路径深度 ≤ 1（仅域名或一级路径），记录为 FAIL 项
  - 统计 FAIL 数量
```

#### 检测 2：日期合规性
```
扫描日报中所有反引号内的日期，格式为 `YYYY-MM-DD`
对每个日期计算：距当前时间的小时数
  - 超过 36 小时：记录为「时效超标」项
  - 统计超标数量和总条目数量
  - 若超标比例 ≥ 30%：整体标记 FAIL
```

#### 检测 3：结构完整性
```
检查以下 6 个字符串是否存在于日报正文：
  1. "## 今日概览"
  2. "## 🔥 最值得关注"
  3. "## 📦 产品与技术动态"
  4. "## 📰 行业与资本动态"
  5. "## 💡 今日观点"
  6. "## 🧭 今日 AI 产品决策速记"
任意一个不存在：FAIL
```

#### 检测 4：标题层级合规性
```
统计正文中以 `# `（单个 # 后跟空格）开头的行数
  - 若 > 1：FAIL（正文出现多个 H1）
统计正文中 H2（## ）下直接跟着 H2 而非 H3 的新闻条目：FAIL
```

#### 检测 5：速记格式完整性
```
定位 `🧭 今日 AI 产品决策速记` 板块
扫描其中所有 `📌` 开头的条目
对每条：
  - 检查是否包含 ` — `（破折号前后有空格）
  - 检查破折号后的内容是否非空，且不在禁用词列表中
    禁用词：["持续关注", "保持关注", "值得关注", "持续跟进", "关注进展"]
  - 不合规：FAIL
```

---

### Step 6.5-B：运行 Layer 2 量化评分

按照 `EVAL-RUBRIC.md` 中 L2-1 到 L2-5 的规则，依次计算每项得分（每项满分 10 分，共 50 分）。

**每项评分后，记录：**
- 得分数值
- 得分依据（一句话说明）
- 若有扣分，列出具体扣分项

---

### Step 6.5-C：运行 Layer 3 定性评估

按照 `EVAL-RUBRIC.md` 中 L3-1 到 L3-5 的规则，对日报内容进行定性评估。

**各项满分**：
- L3-1 分析独特性：**15 分**（加权项 ⭐）
- L3-2 跨事件关联质量：10 分
- L3-3 行动建议可操作性：**15 分**（加权项 ⭐）
- L3-4 今日概览叙事感：10 分
- L3-5 信息筛选眼光：10 分

**重要：AI 评估 Agent 的自我标注规则**

在进行 L3 评估时，若遇到以下情况，**必须在对应项旁标注 `⚠️ 建议人工复核`**：

1. 无法确定某条分析是否属于"第二层推导结论"还是"第一层直接影响"
2. 对某条新闻的重要性判断不确定（不知道今天 AI 界实际发生了什么重磅事件）
3. 对「信息筛选眼光」（L3-5）的评分，由于 AI 自身训练数据限制，**所有 L3-5 评分默认标注 `⚠️ 建议人工复核`**

---

### Step 6.5-D：计算总分并生成评分摘要

**总分计算**（归一化方式，原始满分 110 分 → 归一化 100 分）：

```
Step 1：Layer 1 违规判断
  若任何一项 FAIL：硬规则违规标志 = True

Step 2：计算原始总分
  Layer 2 原始总分 = L2-1 + L2-2 + L2-3 + L2-4 + L2-5（满分 50）
  Layer 3 原始总分 = L3-1 + L3-2 + L3-3 + L3-4 + L3-5（满分 60）
  原始总分 = Layer 2 + Layer 3（满分 110）

Step 3：归一化
  归一化总分 = round(原始总分 ÷ 110 × 100)

Step 4：L1 违规上限修正
  最终总分 = 若硬规则违规：min(归一化总分, 60)
             否则：归一化总分
```

**生成评分摘要字符串**（用于大象通知和学城报告标题）：

```
格式：{最终总分}/100（时效 {L2-1得分} · 深度 {L3-1得分}/15 · 结构 {L1结果}）
示例：85/100（时效 9 · 深度 13/15 · 结构 ✅）
示例：57/100（时效 5 · 深度 7/15 · 结构 ⚠️）
```

---

### Step 6.5-E：输出评估报告

**报告内容**：使用 `EVAL-REPORT-TEMPLATE.md` 中的模板，填入本次评估结果。

**输出方式**：读取 `references/sources.md` 中的 `eval_output_mode` 字段，路由如下：

```
eval_output_mode = "same"     → 跟随 output_mode（默认）
eval_output_mode = "file"     → 写入本地文件（路径：{output_path}/eval-{YYYY-MM-DD}.md）
eval_output_mode = "km"       → 写入学城（需 CatPaw + 内网，失败则降级为 file）
eval_output_mode = "notion"   → 写入 Notion（与日报同父页面）
eval_output_mode = "obsidian" → 写入 Obsidian vault（路径：{obsidian_vault_path}/eval/eval-{YYYY-MM-DD}.md）
eval_output_mode = "terminal" → 仅在对话中展示，不持久化
```

**各模式处理细节：**

**file / obsidian / same→file 模式：**
```
文件路径：{output_path}/eval-{YYYY-MM-DD}.md
内容：EVAL-REPORT-TEMPLATE.md 模板填充后的 Markdown
```

**km 模式（美团内网专属）：**
```bash
# 1. 将评估报告写入临时文件：/tmp/ai-daily-brief-eval-{日期}.xml
# 2. 调用 citadel createDocument
#    parent_id 与日报相同（km_parent_id）
#    标题格式：【AI 日报评估】{YYYY-MM-DD}
```

**notion 模式：**
```bash
curl -s -X POST "https://api.notion.com/v1/pages" \
  -H "Authorization: Bearer {notion_token}" \
  -H "Notion-Version: 2022-06-28" \
  -H "Content-Type: application/json" \
  -d '{"parent": {"page_id": "{notion_page_id}"}, "properties": {"title": {"title": [{"text": {"content": "AI Brief Eval {YYYY-MM-DD}"}}]}}, ...}'
```

**terminal 模式：**
直接在对话中展示完整评估报告内容，不写文件。

**注意**：无论哪种模式，若输出失败，**不影响整体流程**，在 Step 6 返回结果中注明「评估报告输出失败：{原因}」。

---

### Step 6.5-F：更新历史评分记录

评估完成后，将本次评分追加到 **`references/eval-framework/eval-history.md`** 的每日评分表格中。

**文件路径**：与本 SKILL 文件同目录下的 `references/eval-framework/eval-history.md`（相对路径，不使用硬编码绝对路径）。

**追加格式**：
```
| {YYYY-MM-DD} | {最终总分} | {L2原始总分}/50 | {L3原始总分}/60 | {L1是否有FAIL项} | {评估报告位置（文件路径或URL）} |
```

**注意**：若 `eval-history.md` 文件不存在，先创建（使用下方表头），再追加数据：
```markdown
# AI 日报评估历史

## 每日评分

| 日期 | 最终得分 | L2得分 | L3得分 | L1违规 | 评估报告 |
|------|----------|--------|--------|--------|----------|
```

---

## 三、通知格式变更（Step 5）

Step 6.5 完成后，Step 5 的通知消息（无论 `notify_mode` 是哪种）在原有基础上，末尾统一追加评分摘要：

```
📰 AI Brief ready!

{日报标题} · {日期}

🔗 {日报输出位置（文件路径或 URL）}

Quick Decisions:
📌 {速记1}
📌 {速记2}
📌 {速记3}

📊 Quality score: {评分摘要字符串}
📋 Full eval report: {评估报告位置（文件路径或 URL）}
```

> **注**：评分摘要字符串格式：`{最终总分}/100（时效 {L2-1} · 深度 {L3-1}/15 · 结构 {L1结果}）`  
> 示例：`85/100（时效 9 · 深度 13/15 · 结构 ✅）`

---

## 四、每周汇总报告触发机制

### 触发条件

每周一，当用户触发日报生成时（或用户主动说「生成本周 AI 日报质量汇总」），在本次日报的 Step 6.5 完成后，**额外**执行每周汇总流程。

### 判断是否为周一

```
当前日期的星期 == 周一（Monday）→ 执行每周汇总
```

### 每周汇总执行步骤

**Step W-1**：读取 `references/eval-framework/eval-history.md`，提取上一整周（周一至周日）的所有评分记录。

**Step W-2**：使用 `EVAL-WEEKLY-TEMPLATE.md` 中的模板，生成汇总报告，计算：
- 本周平均归一化总分
- 各项 L2/L3 得分的均值和变化趋势（相比上周）
- 本周最高分日期 & 最低分日期
- 本周 L1 违规次数

**Step W-3**：将汇总报告按 `eval_output_mode` 输出，标题/文件名格式：`AI Brief Weekly {本周起始日期}~{本周结束日期}`，输出位置与日报评估报告相同。

**Step W-4**：将本周均分记录追加到 `eval-history.md` 的每周均分表格中：
```
| {周起始日期} | {周结束日期} | {周均分} | {L2均分} | {L3均分} | {L1违规次数} | {周报位置（文件路径或URL）} |
```

若 `eval-history.md` 中尚无「每周均分」表格，在文件末尾追加表头：
```markdown
## 每周均分

| 周起始 | 周结束 | 周均分 | L2均分 | L3均分 | L1违规次数 | 周报位置 |
|--------|--------|--------|--------|--------|-----------|----------|
```

**Step W-5**：按 `notify_mode` 发送周报通知，消息格式：

```
📊 AI Brief Weekly Report

🗓️ {本周起始日期} ~ {本周结束日期}
📈 Weekly avg: {平均分}/100 (last week: {上周平均分})

Best: {最高分日期} ({最高分})
Needs attention: {最低分日期} ({最低分})

Top improvement: {Top 1 改进建议}

🔗 {周报位置（文件路径或URL）}
```

---

## 五、对现有 SKILL.md 的修改指引

> **注**：此章节为内部迭代参考，描述如何将评估流程嵌入到 SKILL.md。**通用版 SKILL.md 已内置 Step 6.5**，无需额外操作。

### 修改点 1：在 Step 5 和 Step 6 之间插入 Step 6.5 章节

**在 `## Step 6：返回结果` 章节之前插入**：

```markdown
## Step 6.5: Quality Self-Evaluation (mandatory every run)

After the brief is delivered in Step 4, immediately run the self-evaluation flow.

Full execution spec: `references/eval-framework/EVAL-WORKFLOW.md`

Summary:
1. Run Layer 1 hard rule checks (5 Pass/Fail items)
2. Calculate Layer 2 quantitative score (5 items, max 50 pts)
3. Run Layer 3 qualitative evaluation (L3-1/L3-3 max 15 pts each; others max 10 pts; raw total 60 pts)
4. Normalized total = round((L2 total + L3 total) ÷ 110 × 100)
5. Deliver eval report (based on eval_output_mode in sources.md)
6. Append this run's score to references/eval-framework/eval-history.md
```

### 修改点 2：Step 5 通知格式

将 Step 5 中的消息格式，在末尾追加：
```
📊 Quality score: {评分摘要字符串}
📋 Full eval report: {评估报告位置（文件路径或URL）}
```

### 修改点 3：Step 6 返回结果内容

在返回给用户的内容中追加：
```
- 📊 Quality score: {评分摘要字符串} (full report: {评估报告位置})
```

---

*工作流版本：v1.2 | 创建日期：2026-06-08 | v1.1变更：归一化总分计算，eval-history 独立文件 | v1.2变更：通用化改造，Step 6.5-E 输出跟随 eval_output_mode，去除硬编码学城/大象依赖*
