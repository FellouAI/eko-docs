---
title: Architecture Overview
description: This conceptual guide introduces the key architectural principles and design patterns that power Eko's natural language automation capabilities.
---

Eko is a framework designed for building production-ready Agent workflows. It provides an efficient, cross-platform solution for automating the planning and execution of workflows. Additionally, Eko offers highly customizable interfaces that empower developers to design workflows freely, ensuring they meet production-level requirements.

Eko is a multi-agent workflow framework that enables multiple agents to collaborate through workflow planning, providing production-ready capabilities.

After the user inputs a prompt, the Planner will design the Workflow, and Eko will coordinate different Agents to perform various tasks based on the Workflow, finally returning the results to the user.

![](../assets/architecture-new-placeholder.png)

## Core Concepts

### Workflow

Workflow is a DSL based on XML, designed to accurately and efficiently complete complex tasks. For example, if the user inputs the prompt `Open Twitter, search for "Fellou AI" and follow`, the Workflow might look like this:

```xml
<root>
  <name>Follow Fellou AI on Twitter</name>
  <thought>The user wants to search for "Fellou AI" on Twitter and follow the account. This is a simple task that can be accomplished using the Browser agent to navigate Twitter, perform the search, and follow the account.</thought>
  <agents>
    <agent name="Browser">
      <task>Search and follow Fellou AI on Twitter</task>
      <nodes>
        <node>Navigate to https://twitter.com</node>
        <node>Click on the search box</node>
        <node>Input text "Fellou AI" into the search box</node>
        <node>Press Enter to perform the search</node>
        <node>Extract page content to find the Fellou AI account</node>
        <node>Click the "Follow" button for the Fellou AI account</node>
      </nodes>
    </agent>
  </agents>
</root>
```

> You can try running it with a browser extension; or register a [`Stream Callback`](/eko/docs/architecture/callback-system#stream-callback) in your script. The `StreamCallbackMessage` of type `workflow` will provide the Workflow value for inspection.

Here:
- The `<name>` tag is the name of the workflow.
- The `<thought>` tag is the thought process when generating the workflow.
- The `<agents>` tag defines which Agents are needed for this workflow, and `<agent name="Browser">` specifies the use of the Browser Agent.
- The `<node>` tags under `<nodes>` define a series of subtasks.

### Agent

Agent is the core driver of Eko. There is an Agent for each domain, such as the Browser Agent, Chat Agent, etc. Each Agent includes a set of tools, carefully crafted prompts, and a suitable LLM.

Agents follow a unified interface, including `name`, `description`, `tools`, and optional LLM model configuration. They encapsulate domain-specific logic and can be extended or customized for different environments. Agents are responsible for decomposing high-level tasks into actionable subtasks and selecting the appropriate tools for execution.

For more information, please refer to the [Agents](/eko/docs/agents) section.

#### Planner

The Planner is a special Agent responsible for generating Workflows and does not participate in the execution of the Workflow.

Planner analyzes the user's natural language prompt, determines the required subtasks, and produces a structured XML-based Workflow. This planning phase is separate from execution, allowing users to inspect, modify, or reuse the generated plan before running it. The Planner ensures that the workflow is logically sound and that all dependencies between subtasks are respected.

#### Tool

Tools are reusable functional modules that perform specific operations within a workflow. Each Tool implements a standard interface with `name`, `description`, `input_schema`, and an `execute` method. Tools can be built-in (such as file operations, browser automation, or command execution) or custom-defined by users.

#### MCP

MCP (Model Context Protocol) is an architecture layer that enables dynamic expansion of agent capabilities. Through MCP, agents can access additional tools or services at runtime, such as external APIs or plugins. The MCP client manages communication and integration with these external resources, allowing for flexible and extensible workflows.

MCP is especially useful for scenarios requiring integration with third-party systems or for dynamically loading new capabilities without redeploying the core framework.

### Memory

The Memory mechanism is a core function in the task processing system used for efficient management and optimization of contextual information. It extracts the tools actually used in tasks, removes redundant tool calls, compresses proxy messages, and processes large amounts of contextual messages, reducing unnecessary computation, optimizing task execution efficiency.

In addition, the Memory mechanism supports task interruption and resumption by creating task snapshots to retain key information and node states, allowing tasks to continue execution in a more streamlined context.

### LLM

LLM (Large Language Model) integration is at the heart of Eko's planning and reasoning capabilities. Eko supports multiple LLM providers (such as Anthropic Claude and OpenAI) and allows configuration of model parameters, API keys, and endpoints.

LLMs are used for both workflow planning (by the Planner) and for certain agent operations that require language understanding or generation. The framework provides retry and fallback mechanisms to ensure robust LLM interactions.

## Execution Model

Eko employs a unique dual-layer execution model that separates planning and execution, thereby achieving predictable automation and adaptive behavior. 

During the planning phase, the [`Eko.generate`](/eko/docs/api/classes/Eko.html#generate) method breaks down natural language tasks into structured workflows, which are then split into subtasks and tool invocations by the `Planner` and stored as modifiable workflow nodes. 

The execution phase is initiated through [`Eko.execute`](/eko/docs/api/classes/Eko.html#execute) or [`Eko.run`](/eko/docs/api/classes/Eko.html#run), where the system calls the [`Agent.run`](/eko/docs/api/classes/Agent.html#run) method of each agent, iteratively executing tool invocations and updating the context until the task is completed or the iteration limit is reached. Tools are defined and executed by the agents, with the results fed back to the LLM or the user. Finally, the results from all agents are aggregated into the output of the workflow, with the result from the last agent typically being the primary outcome.

There's a sequence diagram visualized the execution process of prompt `Open https://fellou.ai and generate a summary.md`:

![](../assets/sequence-diagram.png)
