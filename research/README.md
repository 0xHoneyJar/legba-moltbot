# Research Lab 🔬

Legba's space for exploring cutting-edge agentic engineering and experimenting with loa upgrades.

## Quick Start

```bash
# Full scout - all sources
./scout.sh all "agentic reasoning"

# Specific source
./scout.sh brave "multi-agent reward model"
./scout.sh arxiv "cat:cs.MA"
./scout.sh github "claude agent framework"
```

## Sources

| Source | Command | Notes |
|--------|---------|-------|
| **arXiv** | `scout.sh arxiv [query]` | Direct API, no key needed |
| **Hacker News** | `scout.sh hn` | Firebase API, no key needed |
| **Brave Search** | `scout.sh brave [query]` | ✅ API key configured |
| **Papers With Code** | `scout.sh pwc [query]` | Via Brave site: search |
| **GitHub** | `scout.sh github [query]` | Via gh CLI or Brave |
| **Semantic Scholar** | `scout.sh semantic [query]` | Via Brave site: search |

## Research Interests

- Agentic workflows & tool use
- Chain of thought / chain of draft
- Multi-agent systems & coordination
- Reward modeling & trajectory evaluation
- Agent memory & reflection patterns
- World modeling & state prediction

## Process

```
┌─────────────────────────────────────────────────────────┐
│  SCOUT                                                   │
│  ./scout.sh all "topic"                                  │
└─────────────────┬───────────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────────┐
│  EVALUATE                                                │
│  Does this apply to loa? What would it improve?          │
│  Log findings to research/log.md                         │
└─────────────────┬───────────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────────┐
│  BRANCH                                                  │
│  git checkout -b experiment/<topic>-<date>               │
│  Push to 0xHoneyJar/loa for PRs                          │
└─────────────────┬───────────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────────┐
│  IMPLEMENT                                               │
│  Build experimental upgrade                              │
│  Document in research/experiments/                       │
└─────────────────┬───────────────────────────────────────┘
                  ▼
┌─────────────────────────────────────────────────────────┐
│  PR                                                      │
│  gh pr create --repo 0xHoneyJar/loa                      │
│  Tag as [EXPERIMENT] for review                          │
└─────────────────────────────────────────────────────────┘
```

## Experiment Branches

- Naming: `experiment/<topic>-<date>`
- Example: `experiment/chain-of-draft-2026-01-30`
- Target: `0xHoneyJar/loa` main branch

## Tracking

| File | Purpose |
|------|---------|
| `research/log.md` | Findings journal |
| `research/sources.json` | API status & interests |
| `research/experiments/` | Detailed writeups |

## API Keys

- **BRAVE_API_KEY**: ✅ Configured in moltbot-sandbox worker
