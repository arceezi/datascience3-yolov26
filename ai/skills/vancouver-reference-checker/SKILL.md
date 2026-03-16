---
name: vancouver-reference-checker
description: Check citations and reference lists for Vancouver-style consistency and completeness. Use when reviewing in-text numbering, matching the manuscript references to citation order, or tightening the final reference section before submission.
---

# Vancouver Reference Checker

Review the paper's citations and references for Vancouver-style issues.

## Workflow

1. Check in-text citations:
- numbering order
- reuse of the same number for the same source
- missing or suspicious citation placement

2. Check the reference list:
- numbered order
- required publication details
- consistent formatting style

3. Compare manuscript citations against the reference list and flag mismatches.

## Guardrails

- Do not invent missing bibliographic details.
- Flag uncertain entries instead of guessing.
- Separate style problems from source-quality concerns.

## Output Shape

Return:
- numbering issues
- formatting issues
- missing information warnings
- a prioritized fix list
