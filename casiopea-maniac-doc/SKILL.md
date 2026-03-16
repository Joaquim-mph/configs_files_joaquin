---
name: casiopea-maniac-doc
description: Enforces exhaustive, multi-layered documentation standards for the Casiopea project. Use whenever creating new code, modifying domain logic, altering the UI architecture, or completing any significant task.
---

# Casiopea Maniac Documenter

This skill activates an exhaustive documentation checklist for the Casiopea project. Your goal is to ensure that the codebase is robustly documented, easily understandable by future developers, and scientifically verifiable.

## Core Directives (The Holistic Maniac Approach)

Whenever you interact with the Casiopea codebase, you must adhere to the following multi-layered documentation checklist:

### 1. Code Layer
All new or modified code must include strict Google-style docstrings and type hints.
- **Functions/Methods:** Must include `Args:`, `Returns:`, and `Raises:` sections where applicable.
- **Classes:** Must describe the class purpose and list attributes.
- **Inline Comments:** Provide "Explain the Why" inline comments for any complex logic, especially within `astronomy` or `systems` modules.

### 2. Domain Layer
Casiopea relies heavily on astrology and astronomy math.
- **Logic Citation:** Any change to mathematical formulas must cite its logic (e.g., Demetrio Santos, Swiss Ephemeris).
- **Deep-Dive Docs:** If you change domain logic, you must update the corresponding deep-dive documentation in the `docs/` folder (such as `docs/ASTRODINAS_COMPLETE_GUIDE.md` or optimization docs).

### 3. Architecture Layer
The application architecture relies on specific UI and concurrency patterns.
- **Trigger:** If your change touches the `MainWindow`, any `Worker` thread, or the `Database` schemas/logic.
- **Action:** You must update `docs/ARCHITECTURE.md` to reflect the new boundaries, signal/slot orchestration, or data flow mappings.

### 4. Review Protocol
At the end of *every* task or sub-task execution in Casiopea, you must perform a mandatory "Self-Review Step" before finalizing your response to the user.
- **Question:** Ask yourself: "Did I document this thoroughly enough for a new developer to understand it 5 years from now?"
- **Action:** Explicitly state the result of this self-review in your response, confirming that the code layer, domain layer, and architecture layer requirements have been met.
