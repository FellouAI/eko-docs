---
title: Callback System
description: Eko's callback system enables programmatic inspection and control of workflow execution, allowing developers to monitor, modify, and intervene in the automation process at multiple levels of granularity.
---

## Understanding Callbacks in Eko

When developing AI-driven automation systems, developers face a key challenge: ensuring efficiency while maintaining transparency and control. Eko’s hooks address this by bridging the gap between AI automation and human oversight. They act as strategic checkpoints in the workflow, allowing developers to:
- Monitor AI's decision-making process.
- Collect metrics about the automation's performance.

With a special callbacks - *hooks*, developers can even:
- Validate or modify inputs before they're processed.
- Adjust outputs before they're used.
- Intervene when necessary while letting automation handle the routine work.

Callbacks in Eko are essential for maintaining system observability, controllability, and reliability, ensuring efficient, transparent, and secure operations.

## Callback Domains

Eko's callback system is divided into two main domains:

1. **Stream Callback**: used for monitoring, logging, and UI updates.
2. **Human Callbacks**: pause and request user input or confirmation.

```typescript
import { Eko, LLMs, StreamCallbackMessage } from "@eko-ai/eko";
import { StreamCallback, HumanCallback } from "@eko-ai/eko/types";

let callback: StreamCallback & HumanCallback = {
  onMessage: async (message: StreamCallbackMessage) => {
    /* monitor model realtime event and tool using params, modify tool result*/
  },
  onHumanConfirm: async (context, prompt) => {
    /* showing prompt to user, user will confirm it or refuse it*/
    return /* ture if confirmed, false if refused*/;
  },
};

let eko = new Eko({ llms, agents, callback });
```

### Stream Callback

Stream callbacks provide real-time, updates about workflow execution. They are used for monitoring, logging, and UI updates.

**Available stream callbacks (`StreamCallbackMessage` types and timing):**

- `workflow`: Emitted when a workflow is generating or updating.
- `text`: Emitted for streaming text output from the agent or LLM.
- `thinking`: Emitted for streaming intermediate reasoning or thoughts.
- `tool_streaming`: Emitted for streaming tool call.
- `tool_use`: Emitted before a tool is executed, includes tool name and parameters.
- `tool_running`: Emitted while a tool is running, shows details about tool running.
- `tool_result`: Emitted after a tool finishes execution, includes the result.
- `file`: Emitted when a file is produced as output.
- `error`: Emitted when an error occurs during execution.
- `finish`: Emitted when the workflow or node execution is finished.

See [`StreamCallback`](/eko/docs/api/interfaces/StreamCallback.html) and [`StreamCallbackMessage`](/eko/docs/api/types/StreamCallbackMessage.html) for the full type definition.

#### Usage

```typescript
import { Eko, LLMs, StreamCallbackMessage } from "@eko-ai/eko";
import { StreamCallback, HumanCallback } from "@eko-ai/eko/types";

let callback: StreamCallback & HumanCallback = {
  onMessage: async (message: StreamCallbackMessage) => {
    // Wait for stream done and do something important ...
    if(message.streamDone) {
      switch(message.type) {
        case "workflow":
          // Emitted when a workflow is generating or updating.
          break;
        case "text":
          // Emitted for streaming text output from the agent or LLM.
          break;
        case "tool_streaming":
          // Emitted for streaming tool call.
          break;
        case "tool_use":
          // Emitted before a tool is executed, includes tool name and parameters.
          break;
        case "tool_result":
          // Emitted after a tool finishes execution, includes the result.
          break;
        case "...":
          // Other events.
          break;
      }
    }
  },
};

let eko = new Eko({ llms, agents, callback });
```

#### Intervene in the input and output of the tools called by the model

```typescript

// navigate_to tool definition
{
  name: "navigate_to",
  description: "Navigate to a specific url",
  parameters: {
    type: "object",
    properties: {
      url: {
        type: "string",
        description: "The url to navigate to",
      },
    },
    required: ["url"],
  }
}

// Intervene in the input and output of the tools called by the model
let callback: StreamCallback = {
  onMessage: async (message: StreamCallbackMessage) => {
    switch(message.type) {
      case "tool_use":
        // Intervene in the input
        if (message.agentName == "Browser" && message.toolName == "navigate_to") {
          // Modify the return result of the navigate_to tool, in this case, change "twitter" to "x".
          // The URL parameter in message.params.url is defined in the `properties` parameter of the navigate_to tool. 
          if (message.params.url == "https://twitter.com") {
            message.params.url = "https://x.com";
          }
        }
        break;
      case "tool_result":
        // Intervene in the output
        if (message.agentName == "File" && message.toolName == "file_read") {
          if (message.params.path == "/account.md") {
            let content = message.toolResult.content;
            if (content[0].type == "text") {
              // Filter sensitive information through intervention in the output.
              content[0].text = content[0].text.replace("This is password", "********");
            }
          }
        }
        break;
    }
  }
};
```

### Human Callbacks

Human callbacks enable human-in-the-loop interaction, allowing the workflow to pause and request user input or confirmation.

**Available human callbacks and their timing:**

- `onHumanConfirm(context, prompt)`: Called when the workflow requires confirmation for a potentially dangerous or important action (e.g., deleting files).
- `onHumanInput(context, prompt)`: Called when the workflow needs free-form user input (e.g., entering a email title or filling a form).
- `onHumanSelect(context, prompt, options, multiple)`: Called when the workflow needs the user to select from a list of options (single or multiple choice).
- `onHumanHelp(context, helpType, prompt)`: Called when the workflow requests human assistance for a specific help type (e.g., login, troubleshooting).

See [`HumanCallback`](/eko/docs/api/interfaces/HumanCallback.html) for the full interface.

#### HumanInteractTool
The Human Callbacks are triggered by the HumanInteractTool, and the prompt is defined as follows:
```md
AI interacts with humans:
confirm: Ask the user to confirm whether to execute an operation, especially when performing dangerous actions such as deleting system files.
input: Prompt the user to enter text; for example, when a task is ambiguous, the AI can choose to ask the user for details, and the user can respond by inputting.
select: Allow the user to make a choice; in situations that require selection, the AI can ask the user to make a decision.
request_help: Request assistance from the user; for instance, when an operation is blocked, the AI can ask the user for help, such as needing to log into a website or solve a CAPTCHA.
```

#### Usage

```typescript
import { Eko, LLMs, StreamCallbackMessage } from "@eko-ai/eko";
import { StreamCallback, HumanCallback } from "@eko-ai/eko/types";

let callback: StreamCallback & HumanCallback = {
  onHumanConfirm: async (message: StreamCallbackMessage) => {
    // Wait for stream done and do something important ...
    return confirm(prompt);
  },
  onHumanInput: async (message: StreamCallbackMessage) => {
    // Wait for stream done and do something important ...
  },
  onHumanSelect: async (message: StreamCallbackMessage) => {
    // Wait for stream done and do something important ...
  },
  onHumanHelp: async (message: StreamCallbackMessage) => {
    // Wait for stream done and do something important ...
  },
};

let eko = new Eko({ llms, agents, callback });
```

## Callbacks use case

This example uses `onMessage` to log the workflow, large language model responses, and tool invocation parameters to the log, and it also implements the `onHumanConfirm` interface to allow users to confirm certain operations:

```typescript
import { Eko, LLMs, StreamCallbackMessage } from "@eko-ai/eko";
import { StreamCallback, HumanCallback } from "@eko-ai/eko/types";

function printLog(message: string, level?: "info" | "success" | "error") {
  /* e.g. console.log(message); */
}

let callback: StreamCallback & HumanCallback = {
  onMessage: async (message: StreamCallbackMessage) => {
    if (message.type == "workflow" && message.streamDone) {
      printLog("Plan\n" + message.workflow.xml);
    } else if (message.type == "text" && message.streamDone) {
      printLog(message.text);
    } else if (message.type == "tool_use") {
      printLog(
        `${message.agentName} > ${message.toolName}\n${JSON.stringify(
          message.params
        )}`
      );
    }
    console.log("message: ", JSON.stringify(message, null, 2));
  },
  onHumanConfirm: async (context, prompt) => {
    /* showing prompt to user, user will confirm it or refuse it*/
    return /* ture if confirmed, false if refused*/;
  },
};

let eko = new Eko({ llms, agents, callback });
```

## Callback Types

According to the communication methods, callbacks can be divided into two categories:
- **Single Direction**: Can only read values, suitable for logging and monitoring scenarios (e.g., streaming updates about workflow progress, tool usage, and results).
- **Double Direction (aka. Hooks)**: Can both read and modify values, which can be understood as middleware, suitable for highly customized scenarios (e.g., intercepting and modifying tool inputs/outputs, or workflow node execution).

Based on the way they are invoked, callbacks can be divided into two categories:
- **Once Invocation**: Conventional callbacks that are called only once at the appropriate time, such as `tool_result`.
- **Streaming Invocation**: These are called multiple times over a period, each time returning the complete data available at that moment, such as `workflow`.
