---
name: tdd
description: "Delegate to the tdd skill, driving an <app> change test-first through the red, green, refactor loop, one agreed seam at a time."
division: testing
---

# /tdd

## Delegate

Delegate to the **tdd** skill. Activate when a change to `<app>` is driven
test-first, whether a new feature, a bug fix, or a request for integration
tests.

Steps:

1. Agree the seams under test up front, each with a one-line note on what
   it catches and what it misses.
2. Run one vertical slice at a time: write the failing test, watch it fail
   for the right reason, then write the minimum code that makes it pass.
3. Keep the tests behavioural, non-tautological and independent of the
   implementation's internals.
4. Exercise the real boundary for integration coverage: the use case over a
   fake port, the model over a fake adapter, or the wired composition
   root.
5. Run the owning package's test command and report the real result; never
   claim a test passes without running it.
6. Leave the suite green at the end of every slice, and leave refactoring
   to the review stage.
