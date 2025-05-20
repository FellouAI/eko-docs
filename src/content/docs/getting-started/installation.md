---
title: Installation
description: Eko is a JavaScript library that can be used in browser extension, web pages, and node.js. This guide covers installation and setup for different environments.
---

Eko is a JavaScript library that can be used in [Browser Extension](#browser-extension), [Node.js Enviroment](#nodejs-environment), and [Web Enviroment](#web-environment). This guide covers installation and setup for different environments.

Before starting, we should clone the repository:

```bash
git clone git@github.com:FellouAI/eko.git
cd eko
```

You may need to `git checkout v2` to checkout the correct branch.

And make sure you have [pnpm](https://pnpm.io/zh/installation) installed (or other JavaScript package managers).

> Due to space limitations, only the minimal working example is demonstrated here.

## Browser Extension

In the quickstart, we have seen how to use the browser extension. Now let's build one.

When building a browser extension that uses Eko, you'll need to:

### Install

```bash
# Go to the example dictory
cd example/extension

# Install dependencies
pnpm install

# Build the extension
pnpm run build
```

### Usage Example
```typescript
// example/extension/src/background/main.ts
import { Eko, LLMs } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-extension";

export async function main(prompt: string): Promise<Eko> {
  let config = await chrome.storage.sync.get(["llmConfig"])["llmConfig"];

  const llms: LLMs = {
    default: {
      provider: config.llm as any,
      model: config.modelName,
      apiKey: config.apiKey,
      config: {
        baseURL: config.options.baseURL,
      },
    },
  };

  let agents = [new BrowserAgent()];
  let eko = new Eko({ llms, agents });
  eko
    .run(prompt)
    .finally(() => {
      chrome.storage.local.set({ running: false });
      chrome.runtime.sendMessage({ type: "stop" });
    });
  return eko;
}
```

## Node.js Environment

Eko can also run in a Node.js environment, where it can achieve both browser use and computer use. Here is an example of browser use:

### Install

```bash
# Go to the example dictory
cd example/nodejs

# Install dependencies
pnpm install

# Build and run
pnpm run dev
```

### Usage Example
```typescript
// example/nodejs/src/index.ts
import { BrowserAgent } from "@eko-ai/eko-nodejs";
import { Eko, Agent, LLMs } from "@eko-ai/eko";

const llms: LLMs = {
  default: {
    provider: "anthropic",
    model: "claude-3-5-sonnet-20241022",
    apiKey: "sk-xxx", // NOTE: replace it with your API KEY
  },
};

async function run() {
  let agents: Agent[] = [new BrowserAgent()];
  let eko = new Eko({ llms, agents,  });
  let result = await eko.run("Search for the latest news about Musk");
  console.log("result: ", result.result);
}

run().catch(e => {
  console.log(e)
});
```

## Web Environment

Eko can also be directly embedded into a web page environment. In this example, Eko will automate a web page test.

### Install
```bash
# Go to the example dictory
cd example/web

# Install dependencies
pnpm install

# Build and run
pnpm run dev
```

### Usage Example
```typescript
// example/web/src/main.ts
import { Eko, LLMs } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-web";

export async function auto_test_case() {
  const llms: LLMs = {
    default: {
      provider: "anthropic",
      model: "claude-3-5-sonnet-20241022",
      apiKey: "sk-xxx", // NOTE: replace it with your API KEY
    },
  };

  let agents = [new BrowserAgent()];
  let eko = new Eko({ llms, agents });
  const result = await eko.run("Browser automation testing with steps: 1. ...");
  alert(result.result);
}
```
