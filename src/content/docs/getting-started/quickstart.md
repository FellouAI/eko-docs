---
title: Quickstart
description: This guide will walk you through running your first Eko workflow.
---

Here are two quick ways to get started:
1. [**Using a browser extension**](#using-a-browser-extension): Suitable for those who just want to try it out or are not professionals.
2. [**Running a Node.js script**](#running-a-nodejs-script): Suitable for professionals who want to review or modify the code details.

## Using a browser extension

Let's run an Eko workflow together in a browser extension to automate the task that `Open Twitter, search for "Fellou AI" and follow`. 

### Load extension

- Download the *[precompiled extension](https://github.com/FellouAI/eko-demos/raw/refs/heads/main/browser-extension-dist/dist.zip)* (or you can also [build it](./installation#install) yourself). Unzip the ZIP file to a suitable location, and you should see a `dist` folder.
- Open the [Chrome browser](https://www.google.com/chrome/) and navigate to `chrome://extensions/`.
- Turn on `Developer mode` (toggle switch in the top right corner).
- Click `Load unpacked` button (the blue text in the top-left corner) and select the `dist` folder in the first step.

<video controls>
  <source src="/eko/docs/quickstart/Lark20250520-153314.mp4" />
</video>

### Configure LLM model API Key

- If it's inconvenient to obtain an API key from the OpenAI or Claude platform, consider using proxy sites or services (such as [OpenRouter](https://openrouter.ai/)), and then replace the *Base URL* and *API key* with the corresponding values.

<video controls>
  <source src="/eko/docs/quickstart/Lark20250520-153337.mp4" />
</video>

### Let's run it!
Open the side-bar of the extension, input your prompt, and click the Run button:

<video controls>
  <source src="/eko/docs/quickstart/Lark20250520-153339-3x.mp4" />
</video>

## Running a Node.js script

First we need to create a new project:
```bash
mkdir try-eko
cd try-eko
npm init
```

And install dependencies:
```bash
npm add @eko-ai/eko @eko-ai/eko-nodejs ts-node
```

Then write a script named `index.ts`:
```ts
// index.ts
import { Eko, Agent, LLMs } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-nodejs";

async function run() {
  let llms: LLMs = {
    default: {
      provider: "anthropic",
      model: "claude-3-5-sonnet-20241022",
      apiKey: "sk-xxx", // replace it with your API KEY
      config: {
        baseURL: "https://api.anthropic.com/v1",
      },
    },
  };
  let agents: Agent[] = [new BrowserAgent()];
  let eko = new Eko({ llms, agents });
  let result = await eko.run("Search for the latest news about Musk");
  console.log("result: ", result.result);
}

run().catch(e => {
  console.log(e)
});
```

Remember to set the environment variables (one of OpenAI/Claude):
```bash
export OPENAI_BASE_URL=your_value
export OPENAI_API_KEY=your_value
export ANTHROPIC_BASE_URL=your_value
export ANTHROPIC_API_KEY=your_value
```

Finally run it:
```bash
ts-node index.ts
```

## Next Steps

Now that you have run the first workflow, you can:

- Understand the [Installation](/eko/docs/getting-started/installation) of Eko in different environments.
- Try different [Configurations](/eko/docs/getting-started/configuration) of Eko.
- Learn [Architecture](../architecture) of Eko.
- Check [References](../reference/overview) to confirm the code details.
- Join our [Discard](https://discord.gg/XpFfk2e5): 
![](../assets/discard.png)
