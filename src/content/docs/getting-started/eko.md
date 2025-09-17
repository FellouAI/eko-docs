---
title: Eko 3.0 Overview
description: Eko (pronounced like “echo”) is a powerful framework designed for building production-ready Agent workflows.
---

![](../../../assets/eko-colorful.png)

## What is Eko?
Eko (pronounced like “echo”) is a powerful framework designed for building production-ready Agent workflows. It provides an efficient, cross-platform solution for automating the planning and execution of workflows. Additionally, Eko offers highly customizable interfaces that empower developers to design workflows freely, ensuring they meet production-level requirements.

## SOTA on Online-mind2web benchmark
![](../../../assets/Fellouwithekov2_online_mind2web.png)
## Eko 3.0 High level Architecture
![](../assets/architecture-new-placeholder.png)

## What's new in Eko 3.0
- Dependency-aware parallel agent execution shortens long-running workflows.
- Built-in pause, resume, and interrupt controls capture `task_snapshot` state for recovery.
- The monorepo now standardizes on pnpm, so install and link steps stay consistent across packages.

## Eko 3.0 vs Eko 2.0
| Feature | Eko 3.0 | Eko 2.0 |
| --- | --- | --- |
| Agent orchestration | Parallel + sequential execution via dependency trees | Sequential multi-agent execution |
| Task control | Pause, resume, and abort with recovery snapshots | Manual stop/restart only |
| Workflow compatibility | v3 workflow schema (breaking change) | v2 workflow schema |
| Built-in tooling | `task_snapshot` recovery tool, improved context management | No snapshot tooling |
| Package management | pnpm workspace with unified scripts | Mixed npm/yarn setup |

Eko 3.0 maintains the 80% success rate on the Online-Mind2web benchmark introduced in 2.0, while adding concurrency and recovery controls for production stability.

## Eko 2.0 vs Eko 1.0
| Feature                                 | Eko 2.0                | Eko 1.0   |
| --------------------------------------- | ------------------- | ----------- |
| **Speed**                  | **1.2x Fast**    | Slow |
| **Multi Agent** | ✅                   | ❌           |
| **Watch to DOM event & loop tasks**     | ✅ | ❌           |
| **MCP / Tools**                     | ✅                   | ❌           |
| **A2A**     | ✅ (Coming Soon) | ❌           |
| **Dynamic LLM Config**              | ✅            | ❌         |
| **Planning**                         | Stream Planning & RePlan                   | Simple Plan           |
| **ReAct**     | ✅ | ✅           |
| **Callback**     | Stream Callback & Human Callback | Simple Hooks           |
| **Callback Chain**     | Stream Callback & Human Callback | Simple Hooks           |
| **Node.js with Playwright**     | ✅ | ✅           |

Eko 2.0 achieves 80% success rate on the Online-Mind2web benchmark, compared to 31% for Eko 1.0. This performance improvement reflects the architectural enhancements and optimizations Fellou has implemented in the new version, making Eko 2.0 significantly more reliable for production workflows.
![](../assets/Fellouwithekov2_Fellouwithekov1_Browseruse.png)
# Framework Comparison

| Feature                                 | Eko                 | Langchain   | Browser-use | Dify.ai | Coze |
| --------------------------------------- | ------------------- | ----------- | ----------- | ------- | ---- |
| **Supported Platform**                  | **All platform**    | Server side | Browser     | Web     | Web  |
| **One sentence to multi-step workflow** | ✅                   | ❌           | ✅           | ❌       | ❌    |
| **Intervenability**                     | ✅                   | ✅           | ❌           | ❌       | ❌    |
| **Development Efficiency**              | **High**            | Low         | Middle      | Middle  | Low  |
| **Open-source**                         | ✅                   | ✅           | ✅           | ✅       | ❌    |
| **Access to private web resources**     | ✅ **(Coming soon)** | ❌           | ❌           | ❌       | ❌    |

<!-- *TODO: update demos* -->

<!-- ## Eko's Abilities

- **Browser Use**

> Collect the latest NASDAQ data on Yahoo Finance, including price changes, market capitalization, trading volume of major stocks, analyze the data and generate visualization reports.

<video controls>
  <source src="/docs/demo_stock_analysis.mp4" />
</video>

> Based on the README of FellouAI/eko on github, search for competitors, highlight the key contributions of Eko, write a blog post advertising Eko, and post it on Write.as.

<video controls>
  <source src="/docs/demo_SEO.mp4" />
</video>

> Current login page automation test: 
1. Correct account and password are: admin / 666666 
2. Please randomly combine usernames and passwords for testing to verify if login validation works properly, such as: username cannot be empty, password cannot be empty, incorrect username, incorrect password 
3. Finally, try to login with the correct account and password to verify if login is successful 
4. Generate test report and export

<video controls>
  <source src="/docs/demo_web_test.mp4" />
</video>

- **Computer Use**:

> Clean up all files in the current directory larger than 1MB.

<video controls>
  <source src="/docs/demo_clean_computer.mp4" />
</video>


Learn more: [Eko Demos](https://github.com/FellouAI/eko-demos). -->


## Supported environment
![ENVS](../assets/envs.png)

Learn more:
- [Browser Extension Environment](installation#browser-extension)
- [Web Environment](installation#web-environment)
- [Node.js Environment](installation#nodejs-environment)
- [Next-Gen AI Browser Fellou Environment](https://fellou.ai/)

## Getting started
- [Quickstart](quickstart)
- [Installation](installation)
- [Configuration](configuration)

## Support and Community
- [GitHub Issues](https://github.com/FellouAI/eko/issues) for bug reports and feature requests
- [Documentation](https://eko.fellou.ai/docs) for detailed guides and API reference
