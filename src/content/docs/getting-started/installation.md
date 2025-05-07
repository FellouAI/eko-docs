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

And make sure you have [pnpm](https://pnpm.io/zh/installation) installed (or other JavaScript package managers).

## Browser Extension

In the quickstart, we have seen how to use the browser extension. Now let's build one.

When building a browser extension that uses Eko, you'll need to:

### Install

```bash
# Set the environment variables for LLM API (one of OpenAI/Claude):
export OPENAI_BASE_URL=your_value
export OPENAI_API_KEY=your_value
export ANTHROPIC_BASE_URL=your_value
export ANTHROPIC_API_KEY=your_value

# Go to the example dictory
cd example/browser-extension

# Install dependencies
pnpm install

# Build the extension
pnpm run build
```

### Usage Example
```typescript
// src/example/browser-extension/src/background/main.ts
import { Eko, LLMs, StreamCallbackMessage } from "@eko-ai/eko";
import { StreamCallback, HumanCallback } from "@eko-ai/eko/types";
import BrowserAgent from "./browser";

export async function getLLMConfig(name: string = "llmConfig"): Promise<any> {
  let result = await chrome.storage.sync.get([name]);
  return result[name];
}

export async function main(prompt: string) {
  let config = await getLLMConfig();
  if (!config || !config.apiKey) {
    printLog("Please configure apiKey, configure in the eko extension options of the browser extensions.", "error");
    return;
  }

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

  // NOTE: You can configure the callbacks here
  let callback: StreamCallback & HumanCallback = {
    onMessage: (message: StreamCallbackMessage) => {
      if (message.type == "workflow" && message.streamDone) {
        printLog("Plan\n" + message.workflow.xml);
      } else if (message.type == "text" && message.streamDone) {
        printLog(message.text);
      } else if (message.type == "tool_use") {
        printLog(
          `${message.agentName} > ${message.toolName}\n${JSON.stringify(message.params)}`
        );
      }
      console.log("message: ", JSON.stringify(message, null, 2));
    },
    onHumanConfirm: async (context, prompt) => {
      return confirm(prompt);
    },
  };

  let agents = [new BrowserAgent()];
  let eko = new Eko({ llms, agents, callback });
  let result = await eko.run(prompt);
  if (result.success) {
    printLog(result.result || "Success", "success");
  } else {
    printLog(result.result || "Error", "error");
  }
}

function printLog(log: string, level?: "info" | "success" | "error") {
  chrome.runtime.sendMessage({ type: "log", log, level: level || "info" });
}
```

## Node.js Environment

Eko can also run in a Node.js environment, where it can achieve both browser use and computer use. Here is an example of browser use:

### Install

```bash
# Set the environment variables for LLM API (one of OpenAI/Claude):
export OPENAI_BASE_URL=your_value
export OPENAI_API_KEY=your_value
export ANTHROPIC_BASE_URL=your_value
export ANTHROPIC_API_KEY=your_value

# Go to the example dictory
cd example/nodejs

# Install dependencies
pnpm install

# Build and run
pnpm run dev
```

### Usage Example
```typescript
// src/example/nodejs/src/index.ts
import dotenv from "dotenv";
import ChatAgent from "./chat";
import BrowserAgent from "./browser";
import { Eko, Agent, Log, LLMs, StreamCallbackMessage } from "@eko-ai/eko";

dotenv.config();

const openaiBaseURL = process.env.OPENAI_BASE_URL;
const openaiApiKey = process.env.OPENAI_API_KEY;
const claudeBaseURL = process.env.ANTHROPIC_BASE_URL;
const claudeApiKey = process.env.ANTHROPIC_API_KEY;

const llms: LLMs = {
  default: {
    provider: "anthropic",
    model: "claude-3-5-sonnet-20241022",
    apiKey: claudeApiKey || "",
    config: {
      baseURL: claudeBaseURL,
    },
  },
  openai: {
    provider: "openai",
    model: "gpt-4o-mini",
    apiKey: openaiApiKey || "",
    config: {
      baseURL: openaiBaseURL,
    },
  },
};

// NOTE: You can configure the callbacks here
const callback = {
  onMessage: (message: StreamCallbackMessage) => {
    if (message.type == "workflow" && !message.streamDone) {
      return;
    }
    if (message.type == "text" && !message.streamDone) {
      return;
    }
    if (message.type == "tool_streaming") {
      return;
    }
    console.log("message: ", JSON.stringify(message, null, 2));
  },
};

async function run() {
  Log.setLevel(0);
  let agents: Agent[] = [new ChatAgent(), new BrowserAgent()];
  let eko = new Eko({ llms, agents, callback });
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
cd example/nodejs

# Install dependencies
pnpm install

# NOTE: you should filling the LLM API key in the source code before building

# Build and run
pnpm run dev
```

### Usage Example
```typescript
// src/example/browser-web/src/main.ts
import { Eko, LLMs } from "@eko-ai/eko";
import BrowserAgent from "./browser.ts";

export async function auto_test_case() {
  // Initialize LLM provider
  const llms: LLMs = {
    default: {
      provider: "anthropic",
      model: "claude-3-5-sonnet-20241022",
      apiKey: "sk-xxx", // TODO Your claude apiKey
      config: {
        baseURL: "https://api.anthropic.com/v1",
      },
    },
  };

  // Initialize eko
  let agents = [new BrowserAgent()];
  let eko = new Eko({ llms, agents });

  // Run: Generate workflow from natural language description
  const result = await eko.run(`
    Current login page automation test:
    1. Correct account and password are: admin / 666666 
    2. Please randomly combine usernames and passwords for testing to verify if login validation works properly, such as: username cannot be empty, password cannot be empty, incorrect username, incorrect password
    3. Finally, try to login with the correct account and password to verify if login is successful
    4. Generate test report and export
  `);

  if (result.success) {
    alert("Execution successful:\n" + result.result);
  } else {
    alert("Execution failed:\n" + result.result);
  }

}
```
