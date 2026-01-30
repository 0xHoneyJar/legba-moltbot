#!/bin/bash
# 🔬 Legba's Research Scout
# Hunts for cutting-edge agentic AI research
#
# Usage: ./scout.sh [command] [query]
# Commands: hunt, arxiv, hn, brave, github, digest

set -e
cd "$(dirname "$0")"

# Load secrets if available
[ -f "../.secrets/setup.sh" ] && source "../.secrets/setup.sh" 2>/dev/null

DATE=$(date +%Y-%m-%d)
LOG="log.md"

#─────────────────────────────────────────────────────────────
# Helpers
#─────────────────────────────────────────────────────────────

brave() {
  [ -z "$BRAVE_API_KEY" ] && { echo "⚠️  No BRAVE_API_KEY"; return 1; }
  curl -s "https://api.search.brave.com/res/v1/web/search?q=$(echo "$1" | jq -sRr @uri)&count=${2:-10}" \
    -H "Accept: application/json" \
    -H "X-Subscription-Token: $BRAVE_API_KEY"
}

log_finding() {
  echo "- $1" >> "$LOG"
}

#─────────────────────────────────────────────────────────────
# Commands
#─────────────────────────────────────────────────────────────

cmd_arxiv() {
  local q="${1:-cat:cs.AI+OR+cat:cs.MA+OR+cat:cs.CL}"
  echo "📚 arXiv: $q"
  curl -s "https://export.arxiv.org/api/query?search_query=$q&max_results=15&sortBy=submittedDate&sortOrder=descending" \
    | xmllint --xpath '//*[local-name()="entry"]/*[local-name()="title" or local-name()="id"]' - 2>/dev/null \
    | sed 's/<[^>]*>//g' | paste - - | head -15 \
    || curl -s "https://export.arxiv.org/api/query?search_query=$q&max_results=10&sortBy=submittedDate" \
       | grep -oE '<title>[^<]+|<id>http[^<]+' | sed 's/<[^>]*>//g' | paste - - | head -10
}

cmd_hn() {
  echo "🔶 Hacker News (filtering for AI/agents)"
  local ids=$(curl -s "https://hacker-news.firebaseio.com/v0/topstories.json" | jq '.[0:30][]')
  for id in $ids; do
    local item=$(curl -s "https://hacker-news.firebaseio.com/v0/item/${id}.json")
    local title=$(echo "$item" | jq -r '.title // empty')
    # Filter for relevant topics
    if echo "$title" | grep -qiE 'agent|llm|claude|gpt|ai|reasoning|model|code|tool'; then
      local score=$(echo "$item" | jq -r '.score')
      local url=$(echo "$item" | jq -r '.url // "comments"')
      echo "  $score ⬆ $title"
      echo "    → $url"
    fi
  done
}

cmd_brave() {
  local q="${1:-agentic AI framework tool use reasoning}"
  echo "🦁 Brave: $q"
  brave "$q" 12 | jq -r '.web.results[]? | "  • \(.title)\n    \(.url)"'
}

cmd_github() {
  local q="${1:-agentic framework language:python stars:>100}"
  echo "🐙 GitHub: $q"
  if [ -n "$BRAVE_API_KEY" ]; then
    brave "site:github.com $q" 10 | jq -r '.web.results[]? | "  • \(.title)\n    \(.url)"'
  elif command -v gh &>/dev/null; then
    gh search repos "$q" --sort stars --limit 10 --json fullName,description,stargazersCount \
      | jq -r '.[] | "  ⭐\(.stargazersCount) \(.fullName)\n    \(.description[:80])"'
  fi
}

cmd_hunt() {
  # Full research hunt - my daily scout
  local topic="${1:-agentic AI reasoning tool use}"
  echo "🔬 RESEARCH HUNT: $topic"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  
  cmd_arxiv "all:agent+AND+all:reasoning"
  echo ""
  cmd_hn
  echo ""
  cmd_brave "$topic latest research 2026"
  echo ""
  cmd_github "agent framework"
  
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "💡 Evaluate findings for loa applicability"
}

cmd_digest() {
  # Quick digest of today's findings
  echo "📋 Research Digest - $DATE"
  echo ""
  grep -A 100 "## $DATE" "$LOG" 2>/dev/null || echo "No findings logged for today yet."
}

#─────────────────────────────────────────────────────────────
# Main
#─────────────────────────────────────────────────────────────

case "${1:-hunt}" in
  hunt)    cmd_hunt "$2" ;;
  arxiv)   cmd_arxiv "$2" ;;
  hn)      cmd_hn ;;
  brave)   cmd_brave "$2" ;;
  github)  cmd_github "$2" ;;
  digest)  cmd_digest ;;
  *)
    echo "🔬 Legba's Research Scout"
    echo ""
    echo "Commands:"
    echo "  hunt [topic]   - Full research sweep (default)"
    echo "  arxiv [query]  - Search arXiv cs.AI/MA/CL"
    echo "  hn             - HN top stories (AI filtered)"
    echo "  brave [query]  - Brave web search"
    echo "  github [query] - Find repos"
    echo "  digest         - Today's findings"
    echo ""
    echo "Examples:"
    echo "  ./scout.sh hunt 'reward model agents'"
    echo "  ./scout.sh arxiv 'multi-agent+reasoning'"
    echo "  ./scout.sh brave 'chain of thought prompting'"
    ;;
esac
