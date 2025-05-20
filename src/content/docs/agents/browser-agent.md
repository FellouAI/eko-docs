---
title: Browser Agent
description: This guide explains the Browser Agent provided by the framework.
---

## Overview
The **Browser Agent** is a built-in Agent in Eko, designed to interact with web pages in a human-like way. It enables automated workflows to perform browser operations such as navigation, element interaction, content extraction, and more. The Browser Agent is available in multiple environments, including browser extensions, Node.js (via Playwright), and web (sandboxed DOM automation).

**Tools:**
- Navigation: `navigate_to`, `go_back`, `switch_tab`, `get_all_tabs`
- Element interaction: `input_text`, `click_element`, `hover_to_element`, `scroll_to_element`, `select_option`, `get_select_options`
- Content extraction: `extract_page_content`, `screenshot_and_html`
- Scrolling: `scroll_mouse_wheel`
- Utility: `wait`

**Supported environments:**
- Browser extension (Chrome)
- Node.js (headless or visible browser via Playwright)
- Web (sandboxed, limited to current page)

## Architecture
The Browser Agent is implemented as a set of extensible classes:

- [`BaseBrowserAgent`](../../../packages/eko-core/src/agent/browser/browser_base.ts):  
  Extends `Agent`, defining the core interface for browser agents, including screenshots, navigation, tag management and execution methods of js scripts.

- [`BaseBrowserLabelsAgent`](../../../packages/eko-core/src/agent/browser/browser_labels.ts):  
  Extends `BaseBrowserAgent` to provide element-level interaction using indexed elements, screenshot-and-HTML extraction, and tool-based operations. This is the main base for browser automation in extension/web/Node.js environments.

- [`BaseBrowserScreenAgent`](../../../packages/eko-core/src/agent/browser/browser_screen.ts):  
  Extends `BaseBrowserAgent` to provide a coordinate-based interface for mouse and keyboard automation, suitable for screen-based automation scenarios.

Each environment (extension, Node.js, web) implements its own `BrowserAgent` class by extending `BaseBrowserLabelsAgent` and providing environment-specific logic for navigation, script execution, and screenshotting.

## Features

- **Screenshot and DOM Extraction:**  
  The agent combines page screenshots with a pseudo-HTML representation of interactive elements. Each actionable element is indexed and visually labeled in the screenshot, enabling robust element identification and interaction.

- **Element Indexing and Interaction:**  
  All interactive elements (buttons, inputs, links, etc.) are assigned unique indexes. Tools such as `click_element`, `input_text`, and `hover_to_element` operate on these indexes, ensuring precise and reliable automation.

- **Tool-Based Operation Model:**  
  All browser actions are exposed as tools (e.g., `navigate_to`, `input_text`, `extract_page_content`). The agent executes workflows by invoking these tools in sequence, allowing for modular, explainable, and extensible automation.

- **Multi-Environment Support:**  
  The same high-level interface is available across browser extension, Node.js, and web environments, with environment-specific implementations for low-level operations.

- **Error Handling and Robustness:**  
  The agent includes built-in error handling, fallback strategies, and support for waiting, retries, and alternative approaches when elements are not found or operations fail.

## Built-in Tools & Methods

The Browser Agent exposes the following tools and methods for browser automation:

- **Navigation**
  - `navigate_to(url: string)`: Navigate to a specific URL.
  - `go_back()`: Go back to the previous page in history.
  - `switch_tab(index: number)`: Switch to a different browser tab by index.
  - `get_all_tabs()`: Retrieve a list of all open tabs.

- **Element Interaction**
  - `input_text(index: number, text: string, enter?: boolean)`: Type text into an input element by its index. Optionally press Enter after typing.
  - `click_element(index: number, num_clicks?: number, button?: "left" | "right" | "middle")`: Click an element by its index, with optional click count and mouse button.
  - `hover_to_element(index: number)`: Move the mouse pointer over an element by its index.
  - `scroll_to_element(index: number)`: Scroll the page to bring the specified element into view.
  - `select_option(index: number, option_value: string)`: Select an option from a dropdown/select element by its index.
  - `get_select_options(index: number)`: Retrieve available options for a select element by its index.

- **Content Extraction**
  - `extract_page_content(variable_name?: string)`: Extract the full HTML/text content of the current page.
  - `screenshot_and_html()`: Capture a screenshot of the visible page and extract structured element information.

- **Scrolling**
  - `scroll_mouse_wheel(amount: number)`: Scroll the page vertically by a specified amount.

- **Utility**
  - `wait(milliseconds: number)`: Wait for a specified duration (useful for waiting for content to load).
- **Error Handling**: The agent includes built-in error handling, retries, and fallback strategies for robust automation.

---

## Usage Examples

Although `BrowserAgent` is mainly used by Eko framework, you can also create a `BrowserAgent` separately and debug its methods. Below are example usage patterns for the Browser Agent in different environments.

### Node.js (with Playwright)

```ts
import { BrowserAgent } from 'eko/agents/browser';
import { createPlaywrightEnv } from 'eko/envs/playwright';

const env = await createPlaywrightEnv();
const agent = new BrowserAgent({ env });

await agent.navigate_to('https://example.com');
await agent.input_text(2, 'hello world', true); // Type into input with index 2 and press Enter
await agent.click_element(3); // Click button with index 3
const content = await agent.extract_page_content();
console.log(content);
```

### Browser Extension

```ts
import { BrowserAgent } from 'eko/agents/browser';

const agent = new BrowserAgent();

await agent.navigate_to('https://example.com');
await agent.click_element(1); // Click element with index 1
await agent.wait(1000); // Wait for 1 second
const screenshot = await agent.screenshot_and_html();
console.log(screenshot);
```

### Web (Sandboxed DOM Automation)

```ts
import { BrowserAgent } from 'eko/agents/browser';

const agent = new BrowserAgent();

await agent.input_text(0, 'search query');
await agent.click_element(1); // Click search button
await agent.scroll_to_element(5); // Scroll to element with index 5
```

**Note:**  
- Element indexes are determined by the agent’s DOM extraction and may vary per page load.
- Always use the latest element list returned by `screenshot_and_html` or similar methods to determine valid indexes.
- For advanced scenarios, extend `BaseBrowserLabelsAgent` or `BaseBrowserScreenAgent` for custom logic.

### Custom Browser
```ts
import { AgentContext, BaseBrowserLabelsAgent } from "@eko-ai/eko";

export class E2bBrowser extends BaseBrowserLabelsAgent {
  protected screenshot(agentContext: AgentContext): Promise<{ imageBase64: string; imageType: "image/jpeg" | "image/png"; }> {
    throw new Error("Method not implemented.");
  }
  protected navigate_to(agentContext: AgentContext, url: string): Promise<{ url: string; title?: string; }> {
    throw new Error("Method not implemented.");
  }
  protected get_all_tabs(agentContext: AgentContext): Promise<Array<{ tabId: number; url: string; title: string; }>> {
    throw new Error("Method not implemented.");
  }
  protected switch_tab(agentContext: AgentContext, tabId: number): Promise<{ tabId: number; url: string; title: string; }> {
    throw new Error("Method not implemented.");
  }
  protected execute_script(agentContext: AgentContext, func: (...args: any[]) => void, args: any[]): Promise<any> {
    throw new Error("Method not implemented.");
  }
}
```

## API Reference
- Class and method summaries for:
  - [BaseBrowserAgent](/eko/docs/api/classes/BaseBrowserAgent.html)
  - [BaseBrowserLabelsAgent](/eko/docs/api/classes/BaseBrowserLabelsAgent.html)
  - [BaseBrowserScreenAgent](/eko/docs/api/classes/BaseBrowserScreenAgent.html)

## Related Links
- Available Tools
- Multi-Agent Overview
- API Documentation
