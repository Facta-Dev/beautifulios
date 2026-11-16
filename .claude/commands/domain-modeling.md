---
name: domain-modeling
description: "Delegate to the domain-modeling skill, sharpening the <app> domain model: challenge terminology, record exact terms in the glossary, and write an ADR only for hard-to-reverse decisions."
division: core
---

# /domain-modeling

## Delegate

Delegate to the **domain-modeling** skill. Activate when the request changes
the `<app>` domain model itself: a term is disputed or overloaded, a new
concept is being named, or a decision worth recording is being made.

Steps:

1. Challenge the wording against the recorded glossary and propose one
   canonical term per concept.
2. Stress-test the domain relationships with concrete edge-case scenarios.
3. Cross-check the stated behaviour against the code and report every
   mismatch.
4. Update the glossary in place as terms resolve, definitions free of
   implementation detail.
5. Offer an ADR only when the decision is hard to reverse, surprising
   without context, and the result of a real trade-off.
6. Create the glossary or ADR files lazily, and never renumber an existing
   ADR.
