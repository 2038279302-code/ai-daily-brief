#!/bin/bash
# ============================================================
# sync.sh — 将最新文件同步到 GitHub 仓库
# 用法：cd /tmp/ai-daily-brief-repo && bash scripts/sync.sh "你的提交说明"
# ============================================================

set -e

REPO_DIR="/tmp/ai-daily-brief-repo"
SKILL_SRC="/Users/horizon/.catpaw/skills/ai-daily-brief"
WORKSPACE_SRC="/Users/horizon/Desktop/try/ai-daily-brief-workspace"
MSG="${1:-sync: 同步最新内容 $(date '+%Y-%m-%d %H:%M')}"

echo "📦 同步 skill/ 目录..."
rsync -av --delete \
  --exclude='.DS_Store' \
  --exclude='.git' \
  --exclude='scripts/' \
  "$SKILL_SRC/" "$REPO_DIR/skill/"

echo "📦 同步 workspace/ 目录..."
rsync -av --delete \
  --exclude='.DS_Store' \
  --exclude='.git' \
  "$WORKSPACE_SRC/" "$REPO_DIR/workspace/"

echo "📝 提交变更..."
cd "$REPO_DIR"
git add .
if git diff --cached --quiet; then
  echo "✅ 没有新的变更，无需提交。"
else
  git commit -m "$MSG"
  git push origin main
  echo "✅ 已成功同步到 GitHub！"
  echo "🔗 https://github.com/2038279302-code/ai-daily-brief"
fi
