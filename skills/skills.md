# Agent Skills

Agent Skills are modular capabilities that extend Claude's functionality. Each Skill packages instructions, metadata, and optional resources (scripts, templates) that Claude uses automatically when relevant.

---

## Why use Skills

Skills are reusable, filesystem-based resources that provide Claude with domain-specific expertise: workflows, context, and best practices that transform general-purpose agents into specialists. Unlike prompts (conversation-level instructions for one-off tasks), Skills load on-demand and eliminate the need to repeatedly provide the same guidance across multiple conversations.

**Key benefits**:

* **Specialize Claude**: Tailor capabilities for domain-specific tasks.
* **Reduce repetition**: Create once, use automatically.
* **Compose capabilities**: Combine Skills to build complex workflows.

> [!NOTE]
> **Engineering Deep Dive**: For a deep dive into the architecture and real-world applications of Agent Skills, read our engineering blog: [Equipping agents for the real world with Agent Skills](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills).

---

## Using Skills

Anthropic provides pre-built Agent Skills for common document tasks (PowerPoint, Excel, Word, PDF), and you can create your own custom Skills. Both work the same way. Claude automatically uses them when relevant to your request.

* **Pre-built Agent Skills** are available to all users on claude.ai and via the Claude API. See the [Available Skills](https://www.google.com/search?q=%23available-skills) section below.
* **Custom Skills** let you package domain expertise and organizational knowledge. They're available across Claude's products: create them in Claude Code, upload them via the API, or add them in claude.ai settings.

> [!TIP]
> **Get started:**
> * **For pre-built Agent Skills**: See the [quickstart tutorial](https://www.google.com/search?q=/docs/en/agents-and-tools/agent-skills/quickstart) to start using PowerPoint, Excel, Word, and PDF skills in the API.
> * **For custom Skills**: See the [Agent Skills Cookbook](https://platform.claude.com/cookbook/skills-notebooks-01-skills-introduction) to learn how to create your own Skills.
> 
> 

---

## How Skills work

Skills leverage Claude's VM environment to provide capabilities beyond what's possible with prompts alone. Claude operates in a virtual machine with filesystem access, allowing Skills to exist as directories containing instructions, executable code, and reference materials.

This filesystem-based architecture enables **progressive disclosure**: Claude loads information in stages as needed, rather than consuming context upfront.

### Three types of Skill content, three levels of loading

#### Level 1: Metadata (always loaded)

**Content type: Instructions**. The Skill's YAML frontmatter provides discovery information:

```yaml
---
name: pdf-processing
description: Extract text and tables from PDF files, fill forms, merge documents. Use when working with PDF files or when the user mentions PDFs, forms, or document extraction.
---

```

Claude loads this metadata at startup. This lightweight approach means you can install many Skills without context penalty.

#### Level 2: Instructions (loaded when triggered)

**Content type: Instructions**. The main body of `SKILL.md` contains procedural knowledge and workflows:

```markdown
# PDF Processing

## Quick start
Use pdfplumber to extract text from PDFs:

```python
import pdfplumber
with pdfplumber.open("document.pdf") as pdf:
    text = pdf.pages[0].extract_text()

```

```

#### Level 3: Resources and code (loaded as needed)
**Content types: Instructions, code, and resources**. Skills can bundle additional materials:

* **Instructions**: Additional markdown files (e.g., `FORMS.md`) for specialized guidance.
* **Code**: Executable scripts (e.g., `fill_form.py`) that Claude runs via bash.
* **Resources**: Reference materials like schemas, API documentation, or templates.

| Level | When Loaded | Token Cost | Content |
| :--- | :--- | :--- | :--- |
| **Level 1: Metadata** | Always (at startup) | ~100 tokens per Skill | `name` and `description` from YAML |
| **Level 2: Instructions** | When Skill is triggered | Under 5k tokens | `SKILL.md` body and guidance |
| **Level 3+: Resources** | As needed | Effectively unlimited | Bundled files executed via bash |

---

## Where Skills work

### Claude API
Supports both pre-built and custom Skills. Specify the `skill_id` in the `container` parameter.
* **Required Beta Headers**: `code-execution-2025-08-25`, `skills-2025-10-02`, and `files-api-2025-04-14`.

### Claude Code
Supports **Custom Skills** only. Create Skills as directories with `SKILL.md` files; Claude discovers them automatically via the filesystem.

### Claude Agent SDK
Supports custom Skills through filesystem-based configuration in `.claude/skills/`. Enable by including `"Skill"` in your `allowed_tools`.

### Claude.ai
Supports both types.
* **Pre-built**: Works automatically behind the scenes.
* **Custom**: Upload as zip files through **Settings > Features**. (Available on Pro, Max, Team, and Enterprise).

---

## Skill structure

Every Skill requires a `SKILL.md` file with YAML frontmatter:

```yaml
---
name: your-skill-name
description: Brief description of what this Skill does and when to use it
---

# Your Skill Name

## Instructions
[Clear, step-by-step guidance for Claude to follow]

```

**Field requirements**:

* **Name**: Max 64 chars, lowercase, numbers, and hyphens only.
* **Description**: Max 1024 chars; should define *what* it does and *when* to use it.

---

## Security considerations

> [!WARNING]
> Only use Skills from trusted sources. A malicious Skill can direct Claude to execute code or invoke tools in ways that compromise data security.

* **Audit thoroughly**: Review all scripts and markdown files.
* **External sources**: Be wary of Skills that fetch data from external URLs.
* **Treat like software**: Only install Skills you would trust as much as a local application.

---

## Available Skills

### Pre-built Agent Skills

* **PowerPoint (pptx)**: Create and edit slide decks.
* **Excel (xlsx)**: Data analysis and spreadsheet generation.
* **Word (docx)**: Document creation and formatting.
* **PDF (pdf)**: Generation of formatted reports.

---

## Limitations and constraints

* **No Cross-surface Sync**: Skills uploaded to Claude.ai do not appear in the API or Claude Code automatically.
* **Sharing Scope**:
* *Claude.ai*: Individual only.
* *API*: Workspace-wide.
* *Claude Code*: Personal or project-based.


* **Network Access**: The API environment has **no network access** and no runtime package installation. Claude Code, however, allows full network access.



# Skill Authoring Best Practices

Learn how to write effective Skills that Claude can discover and use successfully. Good Skills are concise, well-structured, and tested with real usage.

---

## Core Principles

### 1. Concise is Key

The context window is a shared resource. At startup, only **metadata** (name and description) is loaded. Claude only reads `SKILL.md` when it becomes relevant. However, once loaded, every token competes with conversation history.

* **Assumption**: Assume Claude is already highly capable.
* **Challenge**: "Does Claude really need this explanation?"

**Example Comparison**:

* ✅ **Concise (~50 tokens)**: Direct code snippet using `pdfplumber`.
* ❌ **Verbose (~150 tokens)**: Explaining what a PDF is and why libraries are used.

### 2. Set Appropriate Degrees of Freedom

Match specificity to the task’s fragility.

| Freedom Level | When to Use | Example |
| --- | --- | --- |
| **High** | Valid multiple approaches | "Analyze code structure and suggest improvements." |
| **Medium** | Preferred patterns exist | "Use this template and customize logic as needed." |
| **Low** | Fragile/Critical tasks | "Run exactly `python scripts/migrate.py --verify`." |

### 3. Test Across Models

What works for **Claude Opus** might need more detail for **Claude Haiku**. Aim for instructions that are clear enough for smaller models without over-explaining for larger ones.

---

## Skill Structure

> [!NOTE]
> **YAML Frontmatter Requirements**:
> * **name**: Max 64 chars, lowercase, numbers, and hyphens only. No XML tags.
> * **description**: Max 1024 chars. Must describe *what* it does and *when* to use it.
> 
> 

### Naming Conventions

Use **gerund form** (verb + -ing) for clarity.

* ✅ `processing-pdfs`, `analyzing-spreadsheets`, `testing-code`
* ❌ `helper`, `utils`, `claude-tools`

### Writing Effective Descriptions

Discovery depends on the description. It is injected into the system prompt.

* **Use Third Person**: "Processes Excel files..." (Avoid: "I can help you...")
* **Be Specific**: Include triggers like "Use when the user mentions PDFs or document extraction."

---

## Progressive Disclosure Patterns

Keep `SKILL.md` under 500 lines. Use it as a "Table of Contents" to point Claude toward specialized files.

**Directory Structure Example:**

```text
pdf/
├── SKILL.md          # Main instructions (Discovery & Navigation)
├── FORMS.md          # Specialized guide (Loaded as needed)
├── reference.md      # API reference (Loaded as needed)
└── scripts/
    └── fill_form.py  # Utility script (Executed, not loaded into context)

```

### Best Practices for Disclosure:

* **One Level Deep**: Don't link `SKILL.md` → `advanced.md` → `details.md`. Claude may only partially read nested links.
* **Table of Contents**: For reference files >100 lines, include a TOC at the top so Claude can preview the scope.

---

## Workflows and Feedback Loops

### Checklist Pattern

For complex tasks, provide a checklist Claude can copy into its response. This prevents skipping critical validation steps.

**Research Synthesis Checklist:**

1. [ ] Read all source documents.
2. [ ] Identify key themes.
3. [ ] Cross-reference claims.
4. [ ] Verify citations.

### Feedback Loops

Implement a **"Run → Validate → Fix → Repeat"** pattern.

* ✅ **Content Review**: "Draft content → Check against `STYLE_GUIDE.md` → Revise if inconsistent."
* ✅ **Code Validation**: "Edit XML → Run `validate.py` → Fix errors → Only pack when passing."

---

## Evaluation and Iteration

1. **Build Evals First**: Create three scenarios that test your Skill before writing deep documentation.
2. **Iterate with Claude**:
* **Claude A (Architect)**: Helps you design and refine the Skill.
* **Claude B (User)**: A fresh instance that tests the Skill in real tasks.


3. **Observe Navigation**: Watch if Claude ignores bundled files or follows references correctly.

---

## Advanced: Skills with Executable Code

### Solve, Don't Punt

Handle errors within scripts (e.g., `try/except`) rather than letting the script crash and forcing Claude to figure it out.

### Use Visual Analysis

If an input (like a complex PDF layout) is hard to parse as text, provide a script to convert it to images for Claude's vision capabilities to analyze.

### MCP Tool References

Always use fully qualified names: `ServerName:tool_name` (e.g., `GitHub:create_issue`).

---

## Checklist for Effective Skills

* [ ] **Discovery**: Description is specific, third-person, and defines triggers.
* [ ] **Size**: `SKILL.md` is under 500 lines.
* [ ] **Pathing**: Uses forward slashes (`/`) even for Windows-style environments.
* [ ] **Freedom**: Specificity matches the risk level of the task.
* [ ] **Testing**: Verified with Haiku, Sonnet, and Opus.
* [ ] **Logic**: Scripts handle errors and don't rely on "voodoo constants."

---

**Next Steps**

* **Build**: [Get started with the Quickstart Tutorial](https://www.google.com/search?q=/docs/en/agents-and-tools/agent-skills/quickstart)
* **Integrate**: [Use Skills with the Claude API](https://www.google.com/search?q=/docs/en/build-with-claude/skills-guide)
* **Deep Dive**: [Authoring Best Practices](https://www.google.com/search?q=/docs/en/agents-and-tools/agent-skills/best-practices)
