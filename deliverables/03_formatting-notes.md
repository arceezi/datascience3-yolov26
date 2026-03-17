# Formatting Notes

This file is the source of truth for visible formatting choices in the polished deliverables.

## Article Structure

Use this article order in the current journal-style draft:
1. Title
2. Adviser Line
3. Abstract
4. Introduction
5. Methods
6. Results
7. Discussion
8. References

## Layout Model

- use an A4 portrait page
- `v6` / `v6.1`:
  - keep the title, adviser line, and abstract in a full-width lead section
  - begin the double-column body at `Introduction`
  - use a moderate column gutter so the text stays readable
  - widen figure and table neighborhoods when needed rather than shrinking them too aggressively
- `v7`:
  - keep the entire article in one column
  - use a thin orange-red top rule on the first page
  - use a black title and black section headings
  - use serif body text with dark gray captions and adviser line
- `peer-review statement`:
  - use the same one-column visual family as `v7`
  - keep the document simple: title plus one concise reflection paragraph
  - do not add fake journal metadata
- keep a major visual subsection together when it has a heading, a short lead-in paragraph, the visual itself, and a caption

## Table Style

- label tables as `Table 1`, `Table 2`, and so on
- use concise, descriptive titles
- keep metric names consistent across the paper
- keep wide tables readable even if they need a temporary single-column-width section
- keep the table-introduction sentence, caption, table, and short table note together when possible

## Figure Style

- label figures as `Figure 1`, `Figure 2`, and so on
- place a clear caption immediately under each figure
- captions should explain what the reader should notice, not just restate the filename
- size figures to fit the column or widened section without making text too small
- avoid using a heading that duplicates the caption label verbatim if that causes caption-style conflicts in export

## Reference Style

- use Vancouver-style numbered references
- keep numbering consistent with in-text citation order
- use a slightly smaller type size than the body text, but keep it comfortably readable

## Export Expectations

- the current journal-style sources are:
  - `deliverables/08_formatted-article-draft-v6.md`
  - `deliverables/09_formatted-article-draft-v6.1.md`
  - `deliverables/10_formatted-article-draft-v7.md`
  - `deliverables/11_formatted-peer-review-statement-v2.md`
- exported files should be saved in `deliverables/exports/`
- the journal export workflow is:
  - Markdown source
  - base DOCX via Pandoc reference DOCX
  - styled DOCX via Word automation
  - PDF export from Word
