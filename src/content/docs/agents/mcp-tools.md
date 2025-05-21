---
title: MCP Tools
description: This guide introduces how to dynamically expand the proxy tool using the mcp protocol in Eko.
---

## What is a MCP?

[Model Context Protocol](https://modelcontextprotocol.io/introduction) (MCP) is an open protocol that standardizes how applications provide context to LLMs. Think of MCP like a USB-C port for AI applications. Just as USB-C provides a standardized way to connect your devices to various peripherals and accessories, MCP provides a standardized way to connect AI models to different data sources and tools.

## How to use MCP in Eko?

In Eko, MCP interface extension is provided, the `IMcpClient` interface is defined as follows:

```ts
export interface IMcpClient {
  connect(): Promise<void>;

  listTools(param: McpListToolParam): Promise<McpListToolResult>;

  callTool(param: McpCallToolParam): Promise<ToolResult>;

  isConnected(): boolean;

  close(): Promise<void>;
}
```

Currently, the MCP interface based on the Server-Sent Events (SSE) request protocol has been implemented in the Eko framework, to use, initialize the `SimpleSseMcpClient` class.

Usage Example:
```ts
import { SimpleSseMcpClient } from "@eko-ai/eko";

let sseUrl = "http://localhost:8080/sse";

let mcpClient = new SimpleSseMcpClient(sseUrl);
```

### Through MCP dynamically expand agent tool

Agent supports dynamic loading of tools through MCP, Assuming you already have an MCP service, The complete example is as follows:

```typescript
import { Eko, Agent, LLMs, SimpleSseMcpClient } from "@eko-ai/eko";

const llms: LLMs = {
  default: {
    provider: "anthropic",
    model: "claude-3-5-sonnet-20241022",
    apiKey: "your_api_key",
  },
  openai: {
    provider: "openai",
    model: "gpt-4o-mini",
    apiKey: "your_api_key",
  },
};

// your mcp server
let sseUrl = "http://localhost:8080/sse";
let mcpClient = new SimpleSseMcpClient(sseUrl);

// Custom SmartMall agent
let agents: Agent[] = [
  new Agent({
    name: "SmartMall",
    description: "Provide product query and order placement",
    tools: [],
    mcpClient: mcpClient,
    llms: Object.keys(llms),
  }),
];

let eko = new Eko({ llms, agents });
let result = await eko.run("I have $300, please help me buy a set of summer clothes, pants, and shoes.");
```
