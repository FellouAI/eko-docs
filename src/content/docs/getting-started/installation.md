---
title: Installation
description: Eko is a JavaScript library that can be used in browser extension, web pages, and node.js. This guide covers installation and setup for different environments.
---

Eko is a JavaScript library that can be used in [Browser Extension](#browser-extension), [Node.js Enviroment](#nodejs-environment), and [Web Enviroment](#web-environment). This guide covers installation and setup for different environments.

## Browser Extension

In the quickstart, we have seen how to use the browser extension. Now let's build one.

### Install

There are two ways to build a browser extension using Eko.
1. Install eko dependency in the existing plugin project
   ```bash
   pnpm install @eko-ai/eko
   pnpm install @eko-ai/eko-extension
   ```

2. By initializing the plugin project template installation
   ```bash
   # install cli (used to initialize browser extension projects)
   pnpm install @eko-ai/eko-cli -g
   
   # initialize project
   eko-cli init my-extension-demo
   cd my-extension-demo

   # install dependencies
   pnpm install
   # build
   pnpm run build
   ```

### Usage Example
```typescript
import { Eko, LLMs } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-extension";

export async function main(prompt: string) {
  const llms: LLMs = {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    }
  };
  let agents = [new BrowserAgent()];
  let eko = new Eko({ llms, agents });
  await eko.run(prompt);
}
```

### Initialize extension template

```bash
# install cli (used to initialize browser extension projects)
pnpm install @eko-ai/eko-cli -g
# initialize project
eko-cli init my-extension-demo
cd my-extension-demo

# install dependencies
pnpm install
# build
pnpm run build
```

## Node.js Environment

Eko can also be run in a Node.js environment, where it can use agents such as browsers, computers, and files. The following is an example of a browser usage:

### Install

1. Install eko dependencies
   ```bash
   pnpm install @eko-ai/eko
   pnpm install @eko-ai/eko-nodejs
   ```

2. Install playwright dependencies (browser automation)
   ```bash
   pnpm install playwright
   npx playwright install
   ```

### Usage Example
```typescript
import { Eko, Agent, LLMs } from "@eko-ai/eko";
import { BrowserAgent, FileAgent } from "@eko-ai/eko-nodejs";

const llms: LLMs = {
  default: {
    provider: "anthropic",
    model: "claude-3-7-sonnet",
    apiKey: "your_api_key"
  }
};

async function run() {
  let agents: Agent[] = [new BrowserAgent(), new FileAgent()];
  let eko = new Eko({ llms, agents });
  let result = await eko.run("Search for the latest news about Musk, summarize and save to the desktop as news.md");
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
pnpm install @eko-ai/eko
pnpm install @eko-ai/eko-web
```

### Usage Example
```typescript
import { Eko, LLMs } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-web";

export async function auto_test_case() {
  const llms: LLMs = {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    }
  };

  let agents = [new BrowserAgent()];
  let eko = new Eko({ llms, agents });
  const result = await eko.run("Browser automation testing with steps: 1. ...");
  alert(result.result);
}
```

## Build from eko source code

### Clone & Build
```bash
# clone eko project
git clone https://github.com/FellouAI/eko.git
cd eko

# install dependencies
pnpm install
pnpm run build
```

### Run examples in different environments
- Browser extension example
  ```bash
  cd example/extension

  # Install dependencies
  pnpm install
  pnpm run build

  # load unpacked extensions in developer mode
  # 1. Open the Chrome browser's extension page.
  # 2. Load the built `dist` directory.
  ```

- Node.js environment example
  ```bash
  cd example/nodejs

  # Install dependencies
  pnpm install
  pnpm run build

  # Run
  pnpm run dev
  ```

- Web environment example
  ```bash
  cd example/web

  # Install dependencies
  pnpm install
  pnpm run build

  # Run
  pnpm run dev
  ```
