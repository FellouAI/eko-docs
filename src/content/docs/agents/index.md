---
title: Multi-Agent Overview
description: This guide introduces the built-in Multi-Agent in Eko and its method definitions.
---

## What are Agent?

In the Eko framework, Agents are core drivers. Typically, an Agent is composed of multiple tools, and each agent has its independent function, for example:

- Browser Agent
- Computer Agent
- File Agent
- Shell Agent
- Custom Agent

## Why Use Agent

### 1. Modular Design
Agents are independent modules, with each Agent responsible for completing a specific function. This design allows developers to break down complex processes into simple, manageable steps. Through this modular approach, developers can reuse these Agents across different projects, reducing code duplication and improving development efficiency.

### 2. Clear Interface Definition
Each Agent follows a unified interface structure, including `name`, `description`, `tools`, and supports mcp extensions and the specification of different LLM models.

```typescript
class Agent {
  name: string;
  description: string;
  tools: Tool[] = [];
  llms?: string[];
  mcpClient?: IMcpClient;
}
```

• name: A unique identifier for the agent (e.g. `Browser`)

• description: Function Description, Explanation of the Role and Usage Scenarios of the Agent

• tools: Specific execution tools, all operations are completed by tools

• llms: Specify the use of the model, support fallback calls, default model

• mcpClient: Support dynamic expansion of tools through the MCP interface


## Using in Eko

The Eko framework provides various built-in Agents for different environments that can be used directly, and you can also customize Agents to complete workflow tasks.

### Built-in agents

Here is a demonstration of the node.js environment

```typescript
import { Eko } from "@eko-ai/eko";
import { BrowserAgent, FileAgent } from "@eko-ai/eko-nodejs";

let eko = new Eko({
  llms: {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    },
  },
  agents: [
    new BrowserAgent(),
    new FileAgent()
  ],
});

let result = await eko.run(`
  Search for the latest news about Musk, summarize it, and save it as musk_news.md file to the desktop.
`);
```

Learn more: [Available Agent](/eko/docs/agents/available-agent).

### Custom agent

```typescript
import { Eko, Agent, AgentContext } from "@eko-ai/eko";
import { ToolResult } from "@eko-ai/eko/types";

let weather_agent = new Agent({
  name: "Weather",
  description: "Provide weather inquiry service",
  tools: [
    {
      name: "get_weather",
      description: "weather query",
      parameters: {
        type: "object",
        properties: {
          city: {
            type: "string"
          },
        },
      },
      execute: async (args: Record<string, unknown>, agentContext: AgentContext): Promise<ToolResult> => {
        return {
          content: [
            {
              type: "text",
              text: `Today, the weather in ${args.city} is cloudy, 25-30° (Celsius), suitable for going out for a walk.`
            }
          ]
        };
      },
    }
  ]
});

let eko = new Eko({
  llms: {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    },
  },
  agents: [weather_agent],
});

let result = await eko.run(`
  How is the weather in Beijing today?
`);
```

Learn more: [Custom Agent](/eko/docs/agents/custom-agent).

## Next Steps

Now that you have understood the concept of an agent, let's take a look at the built-in agents and how to customize agents:

- Built-in [Available Agent](/eko/docs/agents/available-agent) of the framework in different environments
- Learn how to [Custom Agent](/eko/docs/agents/custom-agent)
- Learn how to [Agent Tools](/eko/docs/agents/agent-tools)
