---
title: Quickstart
description: This guide will walk you through running your first Eko workflow.
---

Here are two quick ways to get started:
1. [**Using a browser extension**](#using-a-browser-extension): Suitable for those who just want to try it out or are not professionals.
2. [**Running a Node.js script**](#writing-and-running-a-nodejs-script): Suitable for professionals who want to review or modify the code details.

## Using a browser extension

Let's run an Eko workflow together in a browser extension to automate the task that `Open Twitter, search for "Fellou AI" and follow`. 

### Load extension

- Download the *[precompiled extension](https://github.com/FellouAI/eko-demos/raw/refs/heads/main/browser-extension-dist/dist.zip)* (or you can also [build it](./installation.md#install) yourself). Unzip the ZIP file to a suitable location, and you should see a `dist` folder.
- Open the [Chrome browser](https://www.google.com/chrome/) and navigate to `chrome://extensions/`.
- Turn on `Developer mode` (toggle switch in the top right corner).
- Click `Load unpacked` button (the blue text in the top-left corner) and select the `dist` folder in the first step.
![](../assets/load-1.jpeg)
![](../assets/load-2.jpeg)
![](../assets/load-3.jpeg)
![](../assets/load-4.jpeg)

### Configure LLM model API Key

- If it's inconvenient to obtain an API key from the OpenAI or Claude platform, consider using proxy sites or services (such as [OpenRouter](https://openrouter.ai/)), and then replace the *Base URL* and *API key* with the corresponding values.

![](../assets/configure-1.jpeg)
![](../assets/configure-2.jpeg)

### Let's run it!
Open the side-bar of the extension:
![](../assets/open-side-bar.jpeg)

input your prompt, and click the Run button.
![](../assets/run_extension3.jpeg)

## Writing and running a Node.js script

```bash
# First we need to clone the Eko repository:
git clone git@github.com:FellouAI/eko.git

# And `cd` to the `example/nodejs` floder:
cd eko/example/nodejs

# Remember to set the environment variables (one of OpenAI/Claude):
export OPENAI_BASE_URL=your_value
export OPENAI_API_KEY=your_value
export ANTHROPIC_BASE_URL=your_value
export ANTHROPIC_API_KEY=your_value

# Finally install dependencies and run:
npm install
npm run dev
```

## Next Steps

Now that you have run the first workflow, you can:

- Understand the [Installation](/docs/getting-started/installation) of Eko in different environments
- Learn about Eko's [Configuration](/docs/getting-started/configuration) in different environments
- Learn more core concepts of Eko: [Dive deep into Eko](/docs/getting-started/dive-deep)
- Build the browser extension from source: [Build from source](/docs/getting-started/build-from-source)
- Join our [Discard](https://discord.gg/XpFfk2e5): 
![](../assets/discard.png)
