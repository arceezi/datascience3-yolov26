---
name: report-diagrams
description: Create Mermaid-based conceptual, workflow, and evidence diagrams for the DataScience3 scientific report, then prepare consistent figure captions and export-ready image assets for Markdown and DOCX deliverables.
---

# Report Diagrams

Use this skill when the task is to create, revise, or standardize report diagrams for the DataScience3 manuscript.

## Goal

Produce diagrams that are:
- Mermaid-first for version control
- easy to export to PNG or SVG
- visually consistent across the paper
- suitable for Methods, Results, or Discussion figures

## Workflow

1. Draft the diagram in Mermaid.
2. Prefer short node labels and left-to-right flow unless the content is naturally top-down.
3. Keep one main idea per diagram:
   - conceptual framework
   - study workflow
   - results or evidence synthesis
4. Save Mermaid sources under a report-visible folder.
5. Render export assets to PNG for DOCX insertion.
6. Add a caption that states:
   - what the figure shows
   - which stage of the paper it supports
   - any specific study object such as `Model_C` when relevant

## Style Rules

- Use neutral academic wording.
- Avoid decorative nodes or excessive branching.
- Prefer 4 to 8 nodes per diagram.
- Keep arrows meaningful; every edge should communicate a study relationship.
- Use consistent names across figures: `balanced dataset`, `validation metrics`, `class-wise findings`, `comparative interpretation`.
- Prefer pseudo-3D composition through grouped panels, layered stages, and stacked blocks rather than literal 3D effects.
- Use moderate iconography only; favor Unicode-safe symbols before external icon packs.
- Keep visual styling consistent across all report diagrams by reusing the same class definitions and color family.

## Diagram Patterns

- `Conceptual framework`: input -> model configurations -> outputs -> interpretation
- `Workflow`: preparation -> training -> validation -> evidence assembly -> reporting
- `Results synthesis`: metrics + confusion matrix + training curves -> model comparison -> selected best configuration

## Export Notes

- Render both SVG and PNG files when possible.
- Keep SVG as the editable visual master and PNG as the DOCX-ready asset.
- Keep Mermaid source files beside or near the exported images.
- Use filenames that are paper-safe and stable.
