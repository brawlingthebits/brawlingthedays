# Daily Commit Streak

This repository maintains an unbroken daily commit history starting April 16, 2021. Each day a motivational quote from [ZenQuotes](https://zenquotes.io/) is appended to `daily_log.txt` and committed automatically via GitHub Actions.

---

## What this repo does

- **`daily_log.txt`** — a running log with one line per day in the format:
  ```
  [YYYY-MM-DD] "Quote text" — Author Name
  ```
- **GitHub Actions** fires every day at 12:00 UTC, fetches the quote of the day, appends it, and pushes the commit.
- The result is a green contribution graph with no gaps since the start date.

---

## Backfilling historical commits

Use `backfill_commits.sh` to generate all past commits locally before pushing to GitHub.

### Prerequisites

- `git`, `bash`, `curl`, `python3` installed
- A GitHub account and a **new, empty** repository (no README, no license)

### Steps

```bash
# 1. Make the script executable
chmod +x backfill_commits.sh

# 2. Run it — this creates ./commit-history/ and writes one commit per day
./backfill_commits.sh

# 3. Follow the printed instructions, which will look like:
#
#    cd commit-history
#    git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
#    git push --force -u origin main
```

The script handles the `date` command differences between **macOS** and **Linux** automatically.

---

## Enabling the GitHub Actions workflow

1. Copy `.github/workflows/daily-commit.yml` into your repository (it must be on the default branch).

2. Go to your repository on GitHub:
   **Settings → Actions → General → Workflow permissions**
   Select **Read and write permissions** and click **Save**.

3. The workflow will run automatically at 12:00 UTC daily. You can also trigger it manually from the **Actions** tab using the **Run workflow** button.

---

## Keeping the workflow alive

> **Important:** GitHub automatically pauses scheduled workflows on repositories that have had **no activity for 60 days**.

If the workflow stops running:

1. Open the **Actions** tab in your repository.
2. Select the **Daily Motivational Commit** workflow.
3. Click **Enable workflow**.

To avoid this happening, simply interact with the repository (open an issue, push a small change, or manually trigger the workflow) at least once every 60 days.

---

## Files

| File | Purpose |
|------|---------|
| `backfill_commits.sh` | One-time script to generate historical commits |
| `.github/workflows/daily-commit.yml` | Automated daily commit via GitHub Actions |
| `daily_log.txt` | Append-only log of daily entries |
| `README.md` | This file |
