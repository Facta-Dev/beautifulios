---
name: grilling
description: "Delegate to the grilling skill, stress-testing an <app> plan round by round against a design tree until assumptions, failure modes and scope are settled."
division: core
---

# /grilling

## Delegate

Delegate to the **grilling** skill. Activate when a plan, decision or idea
for `<app>` needs to be stress-tested before implementation.

Steps:

1. Map the decisions as a design tree: every decision branches into the
   decisions that hang off it.
2. Compute the frontier, the decisions whose prerequisites are already
   settled, and ask the whole frontier in one numbered round.
3. Attach a recommended answer to every question, worded so "yes" accepts
   it.
4. Look the facts up yourself (code, filesystem, tooling) instead of asking
   the user; dispatch a background exploration for the slow ones and keep
   asking the rest of the frontier meanwhile.
5. Recompute the frontier from the answers and ask the next round; a
   question whose answer depends on another open question waits.
6. Stop when the frontier is empty and the user confirms the shared
   understanding. Do not implement during the session.
