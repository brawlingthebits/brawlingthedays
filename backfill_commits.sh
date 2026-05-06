#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="commit-history"
START_DATE="2021-04-16"
END_DATE="$(date +%Y-%m-%d)"

# Portable date arithmetic: outputs YYYY-MM-DD given an offset in days from epoch
date_from_epoch() {
  local epoch="$1"
  if date -v +0d > /dev/null 2>&1; then
    # macOS
    date -r "$epoch" +%Y-%m-%d
  else
    # Linux
    date -d "@$epoch" +%Y-%m-%d
  fi
}

to_epoch() {
  local d="$1"
  if date -v +0d > /dev/null 2>&1; then
    # macOS
    date -j -f "%Y-%m-%d" "$d" +%s
  else
    # Linux
    date -d "$d" +%s
  fi
}

make_commit_timestamp() {
  local ymd="$1"
  local hour=$(( RANDOM % 14 + 8 ))   # 08–21
  local min=$(( RANDOM % 60 ))
  local sec=$(( RANDOM % 60 ))
  printf "%sT%02d:%02d:%02d" "$ymd" "$hour" "$min" "$sec"
}

echo "Setting up repo in ./${REPO_DIR} ..."
mkdir -p "$REPO_DIR"
cd "$REPO_DIR"

if [ ! -d ".git" ]; then
  git init
  git checkout -b main 2>/dev/null || git checkout -b master
fi

START_EPOCH=$(to_epoch "$START_DATE")
END_EPOCH=$(to_epoch "$END_DATE")

CURRENT_EPOCH=$START_EPOCH

echo "Backfilling commits from $START_DATE to $END_DATE ..."

while [ "$CURRENT_EPOCH" -le "$END_EPOCH" ]; do
  CURRENT_DATE=$(date_from_epoch "$CURRENT_EPOCH")
  TIMESTAMP=$(make_commit_timestamp "$CURRENT_DATE")

  echo "[$CURRENT_DATE] Daily progress log" >> daily_log.txt

  git add daily_log.txt

  GIT_AUTHOR_DATE="$TIMESTAMP" \
  GIT_COMMITTER_DATE="$TIMESTAMP" \
  git commit -m "Daily commit: $CURRENT_DATE 📅"

  # Advance by one day (86400 seconds)
  CURRENT_EPOCH=$(( CURRENT_EPOCH + 86400 ))
done

TOTAL=$(git rev-list --count HEAD)
echo ""
echo "Done! Created $TOTAL commits."
echo ""
echo "============================================================"
echo "  Next steps"
echo "============================================================"
echo ""
echo "1. Create a new GitHub repository (empty, no README) at:"
echo "   https://github.com/new"
echo ""
echo "2. Add the remote and push:"
echo "   cd ${REPO_DIR}"
echo "   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
echo "   git push --force -u origin main"
echo "   (replace 'main' with 'master' if that is your default branch)"
echo ""
echo "3. Copy .github/workflows/daily-commit.yml into the repo and push"
echo "   it so the scheduled Action starts running."
echo "============================================================"
