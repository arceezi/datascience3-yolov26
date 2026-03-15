# DataScience3 YOLOv26

This repository contains the GitHub-tracked project structure for our Data Science 3 YOLOv26 work.

The project is organized for a Google Colab-first workflow:
- training and evaluation happen in Colab
- large datasets and YOLO run outputs stay in Google Drive
- GitHub stores notebooks, documentation, references, and AI project artifacts

## Workflow

1. Open the notebook from this repository in Google Colab.
2. Mount Google Drive in Colab.
3. Point the notebook to the shared Drive folders for datasets and run outputs.
4. Track experiment notes, review findings, and next steps in the `docs/` folder.

## Repository Layout

- `notebooks/` active notebooks used in the project
- `notebooks/original/` preserved baseline notebook copies
- `docs/` numbered Markdown files that keep the project history readable
- `references/` shared links and asset inventory notes
- `ai/skills/` reusable AI skill files for project-specific tasks
- `ai/sub-agents/` future specialized AI assistant roles for this project

## Data And Outputs

This repository does not store the full dataset, model weights, or YOLO training outputs.

Those assets remain in Google Drive for now so the repository stays lightweight and easy to collaborate on.

## Collaboration Notes

- Keep the original baseline notebook unchanged in `notebooks/original/`.
- Add new documentation files using the next available number after `06_...`.
- Use `docs/05_experiment_log.md` to record important changes, experiments, and observations over time.
