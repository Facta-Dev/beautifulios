---
name: research
description: "Delegate to the research skill, investigating a question about <app> against primary sources and capturing the findings as a cited Markdown brief in the repo."
division: core
---

# /research

## Delegate

Delegate to the **research** skill. Activate when a question needs evidence
from outside the session, such as a platform API's real behaviour, a
specification, or an upstream dependency's contract.

Steps:

1. Run the reading in a background agent with a fresh context window, so
   the main session keeps its own context for the decision.
2. Investigate against primary sources only: the vendor's documentation,
   the source code, the specification. Treat second-hand write-ups as
   leads, not citations.
3. Follow every claim back to the source that owns it and cite it inline.
4. Separate what the source states from what the agent infers from it, and
   tag anything unverified.
5. Record the version or date each source was read at.
6. Write the findings to a single Markdown file where the repo already
   keeps such notes, and state the path in the summary.
