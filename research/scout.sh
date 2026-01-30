#!/bin/bash
# Research Scout - Legba's exploration helper
# Usage: ./scout.sh [source] [query]
# Sources: arxiv, hn, brave, pwc, all
# Requires: BRAVE_API_KEY env var for Brave Search

set -e

RESEARCH_DIR="$(dirname "$0")"
DATE=$(date +%Y-%m-%d)

# Brave Search helper
brave_search() {
  local query="$1"
  local count="${2:-10}"
  
  if [ -z "$BRAVE_API_KEY" ]; then
    echo "⚠️  BRAVE_API_KEY not set - skipping Brave search"
    return 1
  fi
  
  curl -s "https://api.search.brave.com/res/v1/web/search?q=$(echo "$query" | jq -sRr @uri)&count=$count" \
    -H "Accept: application/json" \
    -H "X-Subscription-Token: $BRAVE_API_KEY" \
    | jq -r '.web.results[]? | "• \(.title)\n  \(.url)\n  \(.description[:150])...\n"'
}

case "${1:-all}" in
  arxiv)
    QUERY="${2:-cat:cs.AI}"
    echo "📚 Fetching arXiv: $QUERY..."
    curl -s "https://export.arxiv.org/api/query?search_query=$QUERY&start=0&max_results=20&sortBy=submittedDate&sortOrder=descending" \
      | grep -E '<title>|<summary>|<id>http' | head -60
    ;;
  hn)
    echo "🔶 Fetching HN top stories..."
    STORIES=$(curl -s "https://hacker-news.firebaseio.com/v0/topstories.json" | jq '.[0:10][]')
    for ID in $STORIES; do
      curl -s "https://hacker-news.firebaseio.com/v0/item/${ID}.json" | jq -r '"\(.score) | \(.title) | \(.url // "self")"'
    done
    ;;
  brave)
    QUERY="${2:-agentic AI latest research}"
    echo "🦁 Brave Search: $QUERY..."
    brave_search "$QUERY" 15
    ;;
  pwc)
    QUERY="${2:-agent}"
    echo "📄 Papers With Code search: $QUERY..."
    if [ -n "$BRAVE_API_KEY" ]; then
      brave_search "site:paperswithcode.com $QUERY" 10
    else
      curl -s "https://paperswithcode.com/search?q=$QUERY" | grep -oE 'href="/paper/[^"]+' | head -10 | sed 's/href="/https:\/\/paperswithcode.com/'
    fi
    ;;
  github)
    QUERY="${2:-agentic framework}"
    echo "🐙 GitHub trending/search: $QUERY..."
    if [ -n "$BRAVE_API_KEY" ]; then
      brave_search "site:github.com $QUERY" 10
    else
      gh search repos "$QUERY" --sort stars --limit 10 --json fullName,description,stargazersCount \
        | jq -r '.[] | "⭐ \(.stargazersCount) | \(.fullName) | \(.description[:80])"'
    fi
    ;;
  semantic)
    QUERY="${2:-multi-agent systems}"
    echo "🔬 Semantic Scholar: $QUERY..."
    if [ -n "$BRAVE_API_KEY" ]; then
      brave_search "site:semanticscholar.org $QUERY" 10
    else
      curl -s "https://api.semanticscholar.org/graph/v1/paper/search?query=$(echo "$QUERY" | jq -sRr @uri)&limit=10" \
        | jq -r '.data[]? | "• \(.title) (\(.year)) - \(.citationCount) citations"'
    fi
    ;;
  all)
    echo "🔍 Full research scout for: ${2:-general agentic AI}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    $0 arxiv "${2:-cat:cs.AI}"
    echo ""
    $0 hn
    echo ""
    $0 brave "${2:-agentic AI framework research 2026}"
    echo ""
    $0 pwc "${2:-agent}"
    ;;
  *)
    echo "Usage: $0 [arxiv|hn|brave|pwc|github|semantic|all] [query]"
    echo ""
    echo "Examples:"
    echo "  $0 brave 'reward model agentic'"
    echo "  $0 arxiv 'cat:cs.MA'  # Multi-agent systems"
    echo "  $0 github 'claude agent'"
    echo "  $0 all 'LLM evaluation'"
    exit 1
    ;;
esac
