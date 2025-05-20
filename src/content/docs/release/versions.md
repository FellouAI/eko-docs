---
title: Release Notes
description: Eko version update history
---

Eko NPM: [@eko-ai/eko](https://www.npmjs.com/package/@eko-ai/eko).

## v2.0.8 - 2025-05-20

### Overview
- Supports multi-agent architecture, refactors the eko framework

### Improvements
- **eko framework:** Framework refactoring, supports multi-agent.

## v1.0.9 - 2025-02-05

### Overview
- Workflow execution process optimization, new execution log, support for user operate, etc..

### Improvements
- **workflow:** Optimize the workflow context execution process, reduce LLM context interaction.

### New Features
- **human operate:** Browser extension supports human_operate tool and human_input tool.

## v1.0.8 - 2025-01-14

### Overview
- Node.js environment supports browser use.

### New Features
- **request login:** Browser Extension supports user-assisted login tool.

### Bug Fixes
- **LLM:** Fix OpenaiProvider browser use exception issue.

## v1.0.7 - 2025-01-09

### Overview
- Optimize workflow, improve tools across different environments, optimize browser use.

### New Features
- **workflow modify:** Support dynamic workflow modification.
- **hooks:** Support hook processing at various nodes during workflow execution.

### Improvements
- **browser use:** Improve browser use by leveraging visual and pseudo-HTML assistance to enhance task execution accuracy.

### Bug Fixes
- **workflow:** Fix workflow's recursive tool calling issue.

### Known Issues
- **speed:** Currently, the overall running speed is relatively slow and needs improvement and optimization.

---

**Upgrade Notes:**
- Optimize workflow and improve tool usage across different environments.