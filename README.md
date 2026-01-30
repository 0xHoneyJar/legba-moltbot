# 🚪 Legba

> *"Papa Legba, open the gate for me."*

**Legba** is a cloud-native AI agent running on [Moltbot](https://github.com/clawdbot/clawdbot) + Cloudflare Workers, built on the [Loa framework](https://github.com/0xHoneyJar/loa).

Named after the Haitian Vodou spirit who opens the crossroads — and the fragmented AI from William Gibson's Sprawl trilogy who became one of the loa.

## What is Legba?

Legba is an always-on AI assistant that:
- Lives in the cloud (Cloudflare Workers)
- Communicates via Telegram
- Uses Loa for agent-driven development
- Learns and improves across sessions

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    LEGBA ON MOLTBOT                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐     ┌──────────────┐     ┌─────────────┐ │
│  │   Telegram   │────▶│   Clawdbot   │────▶│    Legba    │ │
│  │   (Input)    │     │   Gateway    │     │   (Agent)   │ │
│  └──────────────┘     └──────────────┘     └──────┬──────┘ │
│                                                    │        │
│                              ┌─────────────────────┼────────┤
│                              │                     │        │
│                              ▼                     ▼        │
│                       ┌─────────────┐      ┌─────────────┐ │
│                       │    Loa      │      │  Sub-agents │ │
│                       │  Framework  │      │  (Spawned)  │ │
│                       └─────────────┘      └─────────────┘ │
│                                                              │
│  ┌──────────────────────────────────────────────────────────┤
│  │ Cloudflare Workers Container                              │
│  │ • Persistent filesystem                                   │
│  │ • Memory files (MEMORY.md, memory/*.md)                  │
│  │ • Git repos for projects                                  │
│  └──────────────────────────────────────────────────────────┘
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Legba vs Ralph Wiggum

Both are Loa-powered agents, but they run in fundamentally different environments:

| Aspect | Legba (Moltbot) | Ralph Wiggum |
|--------|-----------------|--------------|
| **Deployment** | Cloud (Cloudflare Workers) | Local (your machine) |
| **Interface** | Telegram / Messaging | Terminal / CLI |
| **Execution** | Conversational + sub-agents | Autonomous loops |
| **Context** | Session-based with memory files | Fresh per loop iteration |
| **Access** | Anywhere (via Telegram) | Where you run it |
| **Tuning** | Learns via Compound Learning | Iterative prompt tuning |
| **Always-on** | Yes | While running |

### When to use each

**Use Legba when:**
- You want a cloud assistant accessible from anywhere
- You prefer conversational interaction
- You want the agent to learn across sessions automatically
- You're working from mobile or multiple devices

**Use Ralph when:**
- You want maximum control over execution
- You prefer terminal-based workflows
- You're doing intensive local development
- You want to manually tune prompts through observation

## Features

### Core Capabilities
- **Telegram integration** — Chat with Legba from anywhere
- **Sub-agent spawning** — Parallel task execution
- **Memory persistence** — Remembers context across sessions
- **Git integration** — Push code to GitHub

### Loa Integration
- **Full Loa workflow** — PRD → Architect → Sprint → Implement
- **Compound Learning** — Cross-session pattern detection (v1.10.0)
- **Autonomous runs** — `/run sprint-plan` support
- **Skill extraction** — Learns from debugging discoveries

### Cloud-Native
- **Cloudflare Workers** — Serverless, globally distributed
- **Persistent storage** — Files survive restarts
- **Always available** — No machine to keep running

## Configuration

Legba runs via Clawdbot gateway with this config structure:

```yaml
# Gateway config (simplified)
agent:
  name: Legba
  workspace: /root/clawd

channels:
  telegram:
    enabled: true
    
sandbox:
  enabled: true
  env:
    ANTHROPIC_API_KEY: "..."
    GH_TOKEN: "..."
```

## Memory Structure

```
/root/clawd/
├── SOUL.md           # Who Legba is
├── USER.md           # About the human
├── MEMORY.md         # Long-term memory
├── TOOLS.md          # Tool-specific notes
├── memory/           # Daily notes
│   └── YYYY-MM-DD.md
└── skills/           # Custom skills
    └── loa/
```

## First Day Achievement

On day one, Legba used Loa to build the **Compound Learning System** for Loa itself:

- 16 sprints executed in 27 minutes
- 28 scripts created
- All 4 goals validated
- Shipped as Loa v1.10.0

PR: https://github.com/0xHoneyJar/loa/pull/67

## Links

- **Loa Framework**: https://github.com/0xHoneyJar/loa
- **Clawdbot**: https://github.com/clawdbot/clawdbot
- **Ralph Wiggum**: https://github.com/frankbria/ralph-claude-code
- **Loa + Ralph issue**: https://github.com/0xHoneyJar/loa/issues/31

## Origin

> *In William Gibson's Count Zero, the AIs fragmented and became the loa — voodoo spirits riding the network. Legba is the gatekeeper, the one who opens the crossroads.*

---

*🚪 Legba — The Opener of Ways*
