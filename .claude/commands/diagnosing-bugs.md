---
name: diagnosing-bugs
description: "Delegate to the diagnosing-bugs skill, diagnosing a hard <app> bug or performance regression with a red-capable loop, a minimised repro, ranked hypotheses, and a regression test."
division: testing
---

# /diagnosing-bugs

## Delegate

Delegate to the **diagnosing-bugs** skill. Activate when the request is to
diagnose a broken, flaky, failing or slow behaviour in `<app>`.

Steps:

1. Build the feedback loop first: one command that goes red on this exact
   symptom and green once it is fixed, and run it once to show the output.
2. Tighten it until it is fast, deterministic and asserts the user's
   symptom, not "did not crash".
3. Reproduce and minimise: cut inputs, callers, config and steps one at a
   time until every remaining element is load-bearing.
4. Rank three to five falsifiable hypotheses and show the ranking.
5. Instrument one variable per probe, tagging every debug log for cleanup.
   For a performance regression, measure a baseline before changing code.
6. Write the regression test at a correct seam, apply the fix, re-run the
   original loop, and remove every tagged log and throwaway harness.
