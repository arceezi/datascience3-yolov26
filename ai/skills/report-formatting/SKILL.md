---
name: report-formatting
description: Format the DataScience3 scientific paper into a Nature-like, PDF-first journal layout with a full-width lead section, double-column body text, Word automation styling, and DOCX/PDF exports.
---

# Report Formatting

Use this skill when the task is to format the report into a journal-style deliverable rather than rewrite its content.

## Goal

Produce a paper that:
- keeps the manuscript text stable
- uses a full-width title, adviser line, and abstract lead section
- switches to a readable two-column layout from `Introduction` onward
- exports to both `.docx` and `.pdf`
- stays reproducible through Pandoc plus Word automation

## Workflow

1. Use the current best Markdown draft as the source.
2. Generate a base DOCX from Markdown with `scripts/render-markdown-docx.py` and the bundled reference DOCX.
3. Run the Word automation formatter with `scripts/format-journal-docx.ps1` to apply:
   - A4 page setup
   - title and adviser styling
   - full-width first section
   - two-column body
   - caption, heading, table, and figure sizing rules
   - single-column visual neighborhoods when needed for readability
4. Export the styled DOCX to PDF from Word.
5. Verify that figures, tables, and references remain readable.

## Default V6 Layout Rules

- first page lead section:
  - centered title
  - adviser line beneath title
  - full-width abstract
- body:
  - two columns beginning at `Introduction`
  - moderate gutter
  - readable body font, not dense publisher compression
- headings:
  - prominent `Heading 1` section titles
  - smaller but distinct `Heading 2` subsection titles
- captions:
  - smaller than body text
  - left-aligned
  - directly below figures or tables
- visual neighborhoods:
  - widen the whole subsection around a major figure or wide table
  - keep the heading, lead-in text, visual, and caption together when they belong to one block
- references:
  - Vancouver style preserved
  - smaller but still readable

## Use The Bundled Tools

- Use `assets/journal-reference.docx` as the Pandoc reference DOCX.
- Use `scripts/new-journal-reference-docx.ps1` only when the reference DOCX needs regeneration.
- Use `scripts/render-markdown-docx.py` to build the unstyled DOCX from Markdown while preserving image and table references.
- Use `scripts/format-journal-docx.ps1` to apply the journal layout and export PDF.

## Notes

- This skill is formatting-first, not editing-first.
- Prefer layout adjustments over rewriting text.
- Keep older paper versions untouched when producing a new formatting version such as `v6`.
- Match the broad structure of the local sample article: a strong full-width first-page lead section followed by a double-column article body.
- Avoid fragmenting figure/table subsections across different column modes when one widened block is clearer.
