---
name: report-formatting
description: Format the DataScience3 scientific paper into a Nature-inspired journal layout with reusable v6/v6.1 two-column, v7 one-column, and peer-review-statement Word/PDF export profiles.
---

# Report Formatting

Use this skill when the task is to format the report into a journal-style deliverable rather than rewrite its content.

## Goal

Produce a paper that:
- keeps the manuscript text stable
- uses a journal-style title, adviser line, and abstract lead section
- exports to both `.docx` and `.pdf`
- stays reproducible through Pandoc plus Word automation

## Workflow

1. Use the current best Markdown draft as the source.
2. Generate a base DOCX from Markdown with `scripts/render-markdown-docx.py` and the bundled reference DOCX.
3. Run the Word automation formatter with `scripts/format-journal-docx.ps1` to apply:
   - A4 page setup
   - profile-specific title and adviser styling
   - profile-specific body layout
   - caption, heading, table, and figure sizing rules
   - visual-neighborhood handling when the selected profile uses widened blocks
4. Export the styled DOCX to PDF from Word.
5. Verify that figures, tables, and references remain readable.

## Supported Profiles

### V6 / V6.1

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

### V7

- page:
  - A4 portrait
  - one column from title through references
- first page:
  - thin orange-red rule at the top
  - larger black display title
  - adviser line under the title
  - abstract continues in the same one-column flow
- typography:
  - serif body text
  - black headings
  - dark gray adviser line and captions
- figures and tables:
  - full-width within page margins
  - captions directly below the figure or table
  - no column switching or widened sub-sections because the whole document is already one column

### Peer

- page:
  - A4 portrait
  - one column from title through closing sentence
- structure:
  - orange-red top rule
  - black title
  - one concise reflection paragraph below
- typography:
  - same visual family as `v7`
  - serif body text
  - black title
  - dark gray secondary text
- behavior:
  - no fake journal metadata
  - no proofing marks in the exported review file

## Use The Bundled Tools

- Use `assets/journal-reference.docx` as the Pandoc reference DOCX for `v6` and `v6.1`.
- Use `assets/journal-reference-v7.docx` as the reference DOCX for the one-column `v7` profile.
- Use `assets/journal-reference-peer.docx` as the reference DOCX for the peer-review statement export profile.
- Use `scripts/new-journal-reference-docx.ps1` only when a reference DOCX needs regeneration.
- Use `scripts/render-markdown-docx.py` to build the unstyled DOCX from Markdown while preserving image and table references.
- Use `scripts/format-journal-docx.ps1` to apply the journal layout and export PDF.

## Notes

- This skill is formatting-first, not editing-first.
- Prefer layout adjustments over rewriting text.
- Keep older paper versions untouched when producing a new formatting version such as `v6`.
- Match the broad structure of the local sample article without fabricating publisher metadata that is not part of the paper.
- Avoid fragmenting figure/table subsections across different column modes when one widened block is clearer.
