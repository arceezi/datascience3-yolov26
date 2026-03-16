# DataScience3 YOLOv26 Report Workspace

This repository is organized around writing a Scientific Reports-style paper from the completed YOLOv26 experiment.

The experiment workflow remains Colab-first:
- training and evaluation stay in the notebook
- datasets and run outputs stay in Google Drive
- GitHub stores the manuscript, report-planning notes, references, and AI writing helpers

## Main Workflow

1. Use the notebook in `notebooks/` as the source of experiment outputs.
2. Use `references/` for Drive links and shared asset context.
3. Draft the paper section by section in `manuscript/`.
4. Use `docs/` to organize evidence, figures, interpretation, revisions, and submission checks.
5. Use `ai/skills/` and `ai/sub-agents/` to improve titles, sections, references, and journal compliance.

## Repository Layout

- `notebooks/` experiment notebook and preserved original copy
- `references/` shared Drive and asset inventory notes
- `manuscript/` the actual scientific report draft and submission-support files
- `docs/` report support notes, evidence maps, revision history, and checklists
- `ai/skills/` section-writing and report-improvement skills
- `ai/sub-agents/` section reviewers and journal-style critics

## Report Focus

Current working topic:
- `Detection and Classification of Common Road Users in Philippine Traffic Using YOLOv26`

This title is provisional and should be improved during the report-writing workflow.

## Data And Outputs

This repository does not store the full dataset, model weights, or YOLO training outputs.

Those assets remain in Google Drive so the repository stays lightweight while still supporting scientific writing and collaboration.

## Collaboration Notes

- Do not modify `notebooks/` or `references/` unless the experiment assets themselves change.
- Treat `manuscript/00_title-and-metadata.md` as the source of truth for title and report metadata.
- Track section-level edits and critiques in `docs/06_revision_log.md`.
