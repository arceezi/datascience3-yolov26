---
name: discussion-writer
description: Draft or improve the Discussion section for the YOLOv26 scientific report. Use when explaining likely reasons behind model differences, analyzing class-specific struggles, framing limitations, or tightening evidence-based interpretation without overclaiming.
---

# Discussion Writer

Explain why the results likely behaved the way they did.

## Workflow

1. Start from the strongest factual findings.
2. Explain likely drivers:
- optimizer behavior
- learning-rate behavior
- batch-size or epoch differences
- dataset characteristics
- class difficulty

3. Add limits and implications:
- what the experiment does not prove
- what the results suggest for practice or future work

## Guardrails

- Keep explanation tied to reported evidence.
- Avoid pretending that one variable caused the outcome if several changed together.
- Flag confounded comparisons instead of hiding them.
- Do not oversell deployment suitability.

## Output Shape

Return:
- a Discussion draft
- explicit limitation notes
- any claims that should be softened or supported better
