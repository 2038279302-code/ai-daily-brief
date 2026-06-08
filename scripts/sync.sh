#!/bin/bash
# ============================================================
# sync.sh — Sync local skill changes to your GitHub repo clone
#
# Usage:
#   1. Clone your fork: git clone https://github.com/YOUR_USER/ai-daily-brief.git /path/to/repo
#   2. Set SKILL_SRC to where your skill is installed:
#      - CatPaw (macOS):  ~/.catpaw/skills/ai-daily-brief
#      - Custom path:     wherever you keep SKILL.md + references/
#   3. Run: bash scripts/sync.sh "your commit message"
# ============================================================

set -e

# ── Configure these two paths ────────────────────────────────
# Path to this cloned GitHub repo (defaults to the directory containing this script)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Path to your locally installed skill
# Default: CatPaw on macOS. Change if you use a different setup.
SKILL_SRC="${SKILL_SRC:-$HOME/.catpaw/skills/ai-daily-brief}"
# ─────────────────────────────────────────────────────────────

MSG="${1:-sync: update skill $(date '+%Y-%m-%d %H:%M')}"

if [ ! -d "$SKILL_SRC" ]; then
  echo "❌ Skill directory not found: $SKILL_SRC"
  echo "   Set SKILL_SRC env variable to your skill installation path, e.g.:"
  echo "   SKILL_SRC=/path/to/skill bash scripts/sync.sh"
  exit 1
fi

echo "📦 Syncing skill/ from: $SKILL_SRC"
rsync -av --delete \
  --exclude='.DS_Store' \
  --exclude='.git' \
  "$SKILL_SRC/" "$REPO_DIR/skill/"

echo "📝 Committing changes..."
cd "$REPO_DIR"
git add skill/
if git diff --cached --quiet; then
  echo "✅ No changes to commit."
else
  git commit -m "$MSG"
  git push origin main
  echo "✅ Synced to GitHub successfully!"
fi
