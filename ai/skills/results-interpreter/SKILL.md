---
name: results-interpreter
description: Turn YOLO experiment outputs into a rigorous Results section. Use when converting metric tables, confusion matrices, training curves, and class-level results into concise scientific reporting without drifting into unsupported discussion.
---

# Results Interpreter

Turn experiment evidence into a clean Results section.

## Workflow

1. Start from concrete artifacts:
- aggregate metrics
- per-class metrics
- confusion matrices
- training curves
- representative prediction examples

2. Report the strongest findings first:
- best overall model
- main metric comparisons
- standout strong and weak classes

3. Integrate visuals deliberately:
- explain what each table or figure shows
- avoid repeating the entire figure in prose

4. Keep interpretation modest in Results and save deeper explanation for Discussion.

## Guardrails

- Do not invent metrics or hidden trends.
- Do not claim causality in Results unless the evidence is direct.
- Distinguish clearly between aggregate and per-class performance.
- Flag when the evidence comes from validation only and not final test evaluation.

## Output Shape

Return:
- a polished Results draft
- a list of tables or figures referenced
- any evidence gaps that still need to be filled
