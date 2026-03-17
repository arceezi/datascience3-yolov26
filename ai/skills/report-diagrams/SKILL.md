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
- vertically compact and readable in Word exports
- styled as soft pastel academic cards by default

## Workflow

1. Draft the diagram in Mermaid.
2. Prefer top-down or near-square layouts over long horizontal chains.
3. Keep one main idea per diagram:
   - conceptual framework
   - study workflow
   - results or evidence synthesis
4. Save Mermaid sources under a report-visible folder.
5. Render export assets to both SVG and PNG, using PNG for DOCX insertion.
6. Add a caption that states:
   - what the figure shows
   - which stage of the paper it supports
   - any specific study object such as `Model_C` when relevant

## Style Rules

- Use neutral academic wording.
- Avoid decorative clutter, emoji, or cartoonish icons.
- Prefer 4 to 8 nodes per diagram.
- Keep arrows meaningful; every edge should communicate a study relationship.
- Use consistent names across figures: `balanced dataset`, `validation metrics`, `class-wise findings`, `comparative interpretation`.
- Use rounded pastel cards with soft borders and generous padding.
- Favor portrait or near-square composition to preserve readable font sizes.
- Use thin, light connector arrows and dashed lines when they improve clarity.
- Prefer short 1 to 3 line labels inside each card.
- If non-emoji icons are considered later, use only export-stable SVG/icon-pack sources; otherwise rely on shape, color, and spacing alone.

## Diagram Patterns

- `Conceptual framework`: centered main outcome with supporting factors arranged around it
- `Workflow`: top-down stages from setup to reporting, not a wide pipeline
- `Results synthesis`: central conclusion card with supporting evidence cards feeding into it

## Export Notes

- Render SVG masters and PNG DOCX-ready assets.
- Keep Mermaid source files beside or near the exported images.
- Use filenames that are paper-safe and stable.
- Keep older diagram versions untouched when producing a new paper version such as `v3`.
