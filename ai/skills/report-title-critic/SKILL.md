---
name: report-title-critic
description: Critique and improve scientific report titles for clarity, scope, method fit, and publication readiness. Use when revising the paper title, comparing title options, tightening a vague title, or checking whether a title overclaims the experiment.
---

# Report Title Critic

Critique a scientific report title and produce stronger alternatives without overstating the study.

## Workflow

1. Identify the core ingredients of the study:
- task
- subject or object domain
- geographic or application context
- method or model
- experimental scope

2. Check the title for common problems:
- too generic
- too long
- redundant phrasing
- overclaiming novelty or performance
- weak match between title and actual experiment

3. Produce alternatives in tiers:
- conservative improvement
- cleaner journal-style version
- sharper version emphasizing contribution or context

4. Recommend one best option and explain why it fits the paper.

## Guardrails

- Do not imply deployment, real-world validation, or state-of-the-art performance unless the study actually demonstrates it.
- Do not claim both detection and classification as separate contributions unless the paper meaningfully supports both framings.
- Prefer specificity over hype.
- Keep the title aligned with the manuscript's actual evidence and scope.

## Output Shape

Return:
- a brief critique of the current title
- 3 to 5 improved title options
- one recommended title with a short rationale
