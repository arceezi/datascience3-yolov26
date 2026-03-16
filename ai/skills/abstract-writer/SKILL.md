---
name: abstract-writer
description: Draft or revise a technical abstract for the YOLOv26 scientific report. Use when writing a first abstract draft, compressing it to the 200-word limit, tightening quantitative findings, or aligning the abstract with the manuscript's actual evidence.
---

# Abstract Writer

Draft a concise, evidence-based abstract for the report.

## Workflow

1. Extract the essentials:
- problem
- dataset or image set
- compared model setups
- strongest result
- practical takeaway

2. Write the abstract in this order:
- context
- objective
- method summary
- key quantitative result
- conclusion or implication

3. Tighten aggressively:
- remove repeated background
- prefer numbers over vague adjectives
- keep claims aligned with the actual experiment

## Guardrails

- Keep the abstract at 200 words or less.
- Do not introduce citations unless explicitly needed for the assignment.
- Do not overclaim real-world deployment readiness.
- Mention the best result only if it is supported by the notebook outputs.

## Output Shape

Return:
- one polished abstract
- an approximate word count
- a short note on any weak or missing evidence
