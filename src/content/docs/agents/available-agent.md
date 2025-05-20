---
title: Available Agent
description: This guide introduces the built-in agents provided by the framework in different environments.
---

Eko provides various built-in agents for different environments including:
- [Browser extension](/eko/docs/agents/available-agent#browser-extension)
- [Node.js](/eko/docs/agents/available-agent#nodejs)
- [Web](/eko/docs/agents/available-agent#web)

## Browser extension

### BrowserAgent
`Browser`: Use browser agent to operate the browser.

```typescript
import { Eko } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-extension";

let eko = new Eko({
  llms: {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    },
  },
  agents: [new BrowserAgent()],
});

let result = await eko.run(`
  Open Twitter, search for "Fellou AI" and follow
`);
```

The agent is built-in with the following tools:
* `navigate_to`: Navigate to a specific url
* `current_page`: Get the information of the current webpage (url, title)
* `go_back`: Navigate back in browser history
* `input_text`: Input text into an element
* `click_element`: Click on an element by index
* `scroll_to_element`: Scroll to the element
* `scroll_mouse_wheel`: Scroll the mouse wheel at current position
* `hover_to_element`: Mouse hover over the element
* `extract_page_content`: Extract the text content of the current webpage
* `get_select_options`: Get all options from a native dropdown element
* `select_option`: Select the native dropdown option
* `get_all_tabs`: Get all tabs of the current browser
* `switch_tab`: Switch to the specified tab page
* `wait`: Wait for specified duration

## Node.js

### BrowserAgent
`Browser`: Use browser agent to operate the browser.

```typescript
import { Eko } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-nodejs";

let eko = new Eko({
  llms: {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    },
  },
  agents: [new BrowserAgent()],
});

let result = await eko.run(`
  Open Twitter, search for "Fellou AI" and follow
`);
```

### FileAgent
`File`: Use file agent to operate the local file.

```typescript
import { Eko } from "@eko-ai/eko";
import { FileAgent } from "@eko-ai/eko-nodejs";

let eko = new Eko({
  llms: {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    },
  },
  agents: [new FileAgent()],
});

let result = await eko.run(`
  Create a test.txt on the desktop and write hello eko.
`);
```

The agent is built-in with the following tools:
* `file_list`: Getting a list of files in a specified directory.
* `file_read`: Read file content. Use to read files or check file content.
* `file_write`: Overwrite or append content to a file.
* `file_str_replace`: Replace specified string in a file.
* `file_find_by_name`: Find files by name pattern in specified directory.

## Web

### BrowserAgent
`Browser`: Use browser agent to operate the current page.

```typescript
import { Eko } from "@eko-ai/eko";
import { BrowserAgent } from "@eko-ai/eko-web";

let eko = new Eko({
  llms: {
    default: {
      provider: "anthropic",
      model: "claude-3-7-sonnet",
      apiKey: "your_api_key"
    },
  },
  agents: [new BrowserAgent()],
});

let result = await eko.run(`
  Find the text box and enter hello eko
`);
```
