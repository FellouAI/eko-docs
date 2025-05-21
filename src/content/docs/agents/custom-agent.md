---
title: Custom Agent
description: This guide introduces how to customize agent in Eko.
---

## What is a Custom Agent?

In the Eko framework, Agents are core conceptual components that implement different functions. Built-in Agents provide some basic functionalities, such as BrowserAgent for browser operations. However, actual application scenarios vary, and different applications may require specific features to meet their needs. This is where custom Agents come into play.

Custom Agents allow developers to design and implement their own functional modules based on specific business logic or application requirements, without depending on built-in Agents. Through custom Agents, developers can extend the functionality of the Eko framework and enhance its flexibility and adaptability.

## Why Custom Agent?

Custom Agent help developers solve the following problems:

- When existing Agent cannot meet specific needs, custom Agent can be created to implement them.
- Developers can expand Tools under a custom Agent to meet application needs according to the complexity of the business logic.
- Modularize repeated functionality for easier management and debugging.
- Call internal company services and integrate specific business logic.

Agent is defined as follows:
```typescript
class Agent {
  protected name: string;
  protected description: string;
  protected tools: Tool[] = [];
  protected llms?: string[];
  protected mcpClient?: IMcpClient;
  protected planDescription?: string;
}
```

## How to Custom Agent in Eko?

Support the following two methods for customizing Agents, taking File Agent as an example:

1. Direct `new Agent({ name, description, tools })` method
```typescript
import { Agent } from "@eko-ai/eko";

let fileAgent = new Agent({
  name: "File",
  description: "You are a file agent, handling file-related tasks such as creating, finding, reading, modifying files, etc.",
  tools: []
})
```

2. Define a agent class, then extends the Agent method

```typescript
import { Agent } from "@eko-ai/eko";

class FileAgent extends Agent {
  constructor() {
    super({
      name: "File",
      description: "You are a file agent, handling file-related tasks such as creating, finding, reading, modifying files, etc.",
      tools: []
    })
  }
}

let fileAgent = new FileAgent()
```

The complete example code is as follows:
```typescript
import { Agent, AgentContext } from "@eko-ai/eko";
import { Tool, ToolResult } from "@eko-ai/eko/types";

// Define agent tools
let tools: Tool[] = [
  {
    name: "file_read",
    description: "Read file content.",
    parameters: {
      type: "object",
      properties: {
        path: {
          type: "string",
          description: "File path",
        },
      },
      required: ["path"],
    },
    execute: async (
      args: Record<string, unknown>,
      agentContext: AgentContext
    ): Promise<ToolResult> => {
      // TODO Specific read logic
      let file_content = "file content..."; 
      return {
        isError: false,
        content: [{ type: "text", text: file_content }]
      };
    },
  },
  {
    name: "file_write",
    description: "Overwrite or append content to a file.",
    parameters: {
      type: "object",
      properties: {
        path: {
          type: "string",
          description: "File path",
        },
        content: {
          type: "string",
          description: "Text content",
        },
        append: {
          type: "boolean",
          description: "(Optional) Whether to use append mode",
          default: false,
        },
      },
      required: ["path", "content"],
    },
    execute: async (
      args: Record<string, unknown>,
      agentContext: AgentContext
    ): Promise<ToolResult> => {
      // TODO Specific writing logic
      return {
        isError: false,
        content: [{ type: "text", text: "Write successful." }]
      };
    },
  }
];

let fileAgent: Agent;

// Method one
fileAgent = new Agent({
  name: "File",
  description: "You are a file agent, supports reading and writing files.",
  tools: tools
})

// Method two
class FileAgent extends Agent {
  constructor() {
    super({
      name: "File",
      description: "You are a file agent, handling file-related tasks such as creating, finding, reading, modifying files, etc.",
      tools: tools
    })
  }
}

fileAgent = new FileAgent()
```

## Advanced Features

Agent supports some advanced extension features.

### Multiple model fallback calls

By default, the Agent follows the default model configuration, which allows for multiple model configurations to be set up as fallbacks. When model 1 cannot be accessed, it will fall back to model 2, then model 3, and so on.

```typescript
import { Eko, Agent, LLMs } from "@eko-ai/eko";

// Multiple model configurations
let llms: LLMs = {
  default: {
    provider: "anthropic",
    model: "claude-3-7-sonnet",
    apiKey: "your_api_key",
  },
  model1: {
    provider: "openai",
    model: "gpt-mini-4o",
    apiKey: "your_api_key",
  },
  model2: {
    provider: "anthropic",
    model: "claude-3-5-sonnet",
    apiKey: "your_api_key",
  },
  model3: {
    provider: "openrouter",
    model: "openai/gpt-mini-4o",
    apiKey: "your_api_key",
  }
};

// Custom file agent
let fileAgent = new Agent({
  name: "File",
  description: "You are a file agent, supports reading and writing files.",
  tools: tools,
  llms: ["model1", "model2", "model3"] // Model Chain Fallback
});

let eko = new Eko({
  llms: llms,
  agents: [fileAgent],
});

// Run
let result = await eko.run("Read the desktop test.txt file");

```

## Next Steps

Now that you have understood the concept of an custom agent, Let's take a look at how tools are defined:

Learn more: [Agent Tools](/eko/docs/agents/agent-tools).

Learn more: [MCP Tools](/eko/docs/agents/mcp-tools).
