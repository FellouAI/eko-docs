---
title: Configuration
description: This guide covers how to configure Eko in different environments.
---

As we have seen [before](./installation), [`Eko`](/eko/docs/api/classes/Eko.html) accepts a parameter of type [`EkoConfig`](/eko/docs/api/classes/Eko.html), which is defined as follows:
```ts
type EkoConfig = {
  llms: LLMs;
  agents?: Agent[];
  planLlms?: string[];
  callback?: StreamCallback & HumanCallback;
  defaultMcpClient?: IMcpClient;
  a2aClient?: IA2aClient;
};
```

This guide will walk you through configuring these parameters. You can also see [`EkoConfig`'s Reference](/eko/docs/api/types/EkoConfig.html) for code details.

## `EkoConfig.llms`

`EkoConfig.llms` stores the large models available to Eko in a key-value format, where you can set the following for each model:
- Provider
- Model name
- API key
- Base URL
- TopK
- TopP

The models defined here will be used by the Planner and Agents. You can configure models with different performance levels to meet the varying needs of different components.

Here is an example that configures two models, with Claude 3.5 as the default and another one being GPT-4o:
```ts
let llms = {
  default: {
    provider: "anthropic",
    model: "claude-3-5-sonnet-20241022",
    apiKey: "sk-xxx",
    config: { topK: 5 },
  },
  openai: {
    provider: "openai",
    model: "gpt-4o",
    apiKey: "sk-xxx",
    config: { baseURL: "https://example.com/v1", topP: 0.7 },
  },
};
```

## `EkoConfig.agents`

`EkoConfig.agents` describes the Agents available in the Eko workflow. Each Agent has its own name, description, toolkit, and available models.

For more information about Agents, please refer to the [Agents](../agents) section.

In this simple example, there is only one `BrowserAgent`:
```ts
import { BrowserAgent } from "@eko-ai/eko-extension";
let agents: Agent[] = [new BrowserAgent()];
```

## `EkoConfig.planLlms`

`EkoConfig.planLlms` specifies the models that will be used by the Eko Planner. It is recommended to choose a high-performance model, as it will be responsible for planning the entire workflow. For example:

```ts
let llms = {
  default: {
    provider: "openai",
    model: "gpt-4o-mini",
    apiKey: "sk-xxx",
  },
  powerful: {
    provider: "anthropic",
    model: "claude-3-7-sonnet",
    apiKey: "sk-xxx",
  },
};
let eko = new Eko({ llms, planLlms: ["powerful"] });
```

## `EkoConfig.callback`

`EkoConfig.callback` accepts a set of user-defined callback functions, which can include `StreamCallback` and `HumanCallback`.

- `StreamCallback` allows you to receive streaming updates on workflow progress, tool usage, and results.
- `HumanCallback` enables you to handle cases where human input or confirmation is required (e.g., when a user selects an option, confirms an action, or provides input).

For more information, please refer to the [Callbacks](../architecture/callback-system) section.

Example:
```ts
let callback = {
  onMessage: async (msg) => { /* handle streaming updates */ },
  onHumanInput: async (ctx, prompt) => { /* prompt user for input */ return "user input"; }
};
```

## `EkoConfig.defaultMcpClient`

`EkoConfig.defaultMcpClient` is an instance of `IMcpClient` used to handle communication with an MCP (Multi-Component Platform) backend. Set this if your agents/tools require backend orchestration or state management.

## `EkoConfig.a2aClient`

`EkoConfig.a2aClient` is an instance of `IA2aClient` for agent-to-agent communication. Use this if your workflow involves coordination or messaging between multiple agents.
