---
name: methods-writer
description: Draft or improve the Methods section for the YOLOv26 scientific report. Use when documenting the Google Colab environment, NVIDIA T4 hardware, dataset composition, augmentation, Ultralytics workflow, or the three tested training configurations in reproducible prose.
---

# Methods Writer

Write a clear Methods section from the existing experiment workflow.

## Workflow

1. Gather the technical facts:
- environment
- hardware
- dataset layout
- class list and image counts
- augmentation or balancing details
- training configurations
- evaluation procedure

2. Convert notebook steps into narrative prose:
- avoid raw code narration
- prefer reproducible technical description

3. Check for missing implementation details and flag them.

## Guardrails

- Do not invent dataset counts or preprocessing steps.
- Distinguish known facts from assumptions.
- Keep the section reproducible, but not code-like.
- Mention shared Drive or Colab details only insofar as they matter to reproducibility.

## Output Shape

Return:
- a Methods draft
- a short list of any missing details that still need confirmation
