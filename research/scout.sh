#!/bin/bash
# Research Scout - Legba's exploration helper
# Usage: ./scout.sh [source]
# Sources: arxiv, hn, all

set -e

RESEARCH_DIR="$(dirname "$0")"
DATE=$(date +%Y-%m-%d)

case "${1:-all}" in
  arxiv)
    echo "📚 Fetching arXiv cs.AI recent..."
    curl -s "https://export.arxiv.org/api/query?search_query=cat:cs.AI&start=0&max_results=20&sortBy=submittedDate&sortOrder=descending" \
      | grep -E '<title>|<summary>|<id>http' | head -60
    ;;
  hn)
    echo "🔶 Fetching HN top stories..."
    # Get top 10 story IDs
    STORIES=$(curl -s "https://hacker-news.firebaseio.com/v0/topstories.json" | jq '.[0:10][]')
    for ID in $STORIES; do
      curl -s "https://hacker-news.firebaseio.com/v0/item/${ID}.json" | jq -r '"\(.score) | \(.title) | \(.url // "self")"'
    done
    ;;
  all)
    $0 arxiv
    echo ""
    $0 hn
    ;;
  *)
    echo "Usage: $0 [arxiv|hn|all]"
    exit 1
    ;;
esac
