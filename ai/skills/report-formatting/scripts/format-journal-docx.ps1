param(
    [Parameter(Mandatory = $true)]
    [string]$InputDocx,

    [Parameter(Mandatory = $true)]
    [string]$OutputDocx,

    [Parameter(Mandatory = $false)]
    [string]$OutputPdf = "",

    [Parameter(Mandatory = $false)]
    [ValidateSet("v6","v7","peer")]
    [string]$Profile = "v6"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$wdCollapseStart = 1
$wdCollapseEnd = 0
$wdSectionBreakContinuous = 3
$wdFormatXMLDocument = 12
$wdFormatPDF = 17
$wdPaperA4 = 7
$wdAlignParagraphLeft = 0
$wdAlignParagraphCenter = 1
$wdAlignParagraphJustify = 3
$wdLineSpaceSingle = 0
$wdAutoFitWindow = 2
$wdStory = 6

function Clean-Text([string]$text) {
    return (($text -replace "[`r`a]", "").Trim())
}

function Paragraph-Text($paragraph) {
    return Clean-Text $paragraph.Range.Text
}

function Find-ParagraphIndex($doc, [string]$exactText) {
    for ($i = 1; $i -le $doc.Paragraphs.Count; $i++) {
        if ((Paragraph-Text $doc.Paragraphs.Item($i)) -eq $exactText) {
            return $i
        }
    }
    return $null
}

function Find-PreviousContentParagraph($doc, [int]$index) {
    $i = $index - 1
    while ($i -ge 1) {
        $paragraph = $doc.Paragraphs.Item($i)
        $text = Paragraph-Text $paragraph
        if ($paragraph.Range.InlineShapes.Count -gt 0 -or -not [string]::IsNullOrWhiteSpace($text)) {
            return $i
        }
        $i--
    }
    return $null
}

function Find-PreviousNonEmptyParagraph($doc, [int]$index) {
    $i = $index - 1
    while ($i -ge 1) {
        $text = Paragraph-Text $doc.Paragraphs.Item($i)
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            return $i
        }
        $i--
    }
    return $null
}

function Find-NextNonEmptyParagraph($doc, [int]$index) {
    $i = $index + 1
    while ($i -le $doc.Paragraphs.Count) {
        $text = Paragraph-Text $doc.Paragraphs.Item($i)
        if (-not [string]::IsNullOrWhiteSpace($text) -or $doc.Paragraphs.Item($i).Range.InlineShapes.Count -gt 0) {
            return $i
        }
        $i++
    }
    return $null
}

function Insert-Break-BeforeParagraph($doc, [int]$index) {
    $range = $doc.Paragraphs.Item($index).Range.Duplicate
    $range.Collapse($wdCollapseStart)
    $range.InsertBreak($wdSectionBreakContinuous)
}

function Insert-Break-AfterParagraph($doc, [int]$index) {
    $range = $doc.Paragraphs.Item($index).Range.Duplicate
    $range.Collapse($wdCollapseEnd)
    $range.InsertBreak($wdSectionBreakContinuous)
}

function Get-OleColor([int]$r, [int]$g, [int]$b) {
    return [System.Drawing.ColorTranslator]::ToOle([System.Drawing.Color]::FromArgb($r, $g, $b))
}

function Set-ParagraphFont($range, [string]$name, [double]$size, [int]$color) {
    $range.Font.Name = $name
    $range.Font.Size = $size
    $range.Font.Color = $color
}

function Find-ParagraphContainingPosition($doc, [int]$position) {
    for ($i = 1; $i -le $doc.Paragraphs.Count; $i++) {
        $paragraph = $doc.Paragraphs.Item($i)
        if ($paragraph.Range.Start -le $position -and $paragraph.Range.End -ge $position) {
            return $i
        }
    }
    return $null
}

function Paragraph-StyleName($paragraph) {
    try {
        return [string]$paragraph.Range.Style.NameLocal
    }
    catch {
        return ""
    }
}

function Is-HeadingParagraph($paragraph) {
    $styleName = Paragraph-StyleName $paragraph
    return $styleName -like "Heading *"
}

function Add-Block($blocks, [int]$start, [int]$end) {
    if ($start -gt 0 -and $end -ge $start) {
        [void]$blocks.Add([PSCustomObject]@{ Start = $start; End = $end })
    }
}

function Find-ExactParagraphOrNull($doc, [string]$text) {
    return Find-ParagraphIndex $doc $text
}

function Find-ParagraphStartingWith($doc, [string]$prefix) {
    for ($i = 1; $i -le $doc.Paragraphs.Count; $i++) {
        $text = Paragraph-Text $doc.Paragraphs.Item($i)
        if ($text.StartsWith($prefix)) {
            return $i
        }
    }
    return $null
}

function Find-NextHeadingIndex($doc, [int]$index) {
    $i = $index + 1
    while ($i -le $doc.Paragraphs.Count) {
        if (Is-HeadingParagraph $doc.Paragraphs.Item($i)) {
            return $i
        }
        $i++
    }
    return $null
}

function Find-VisualParagraphBeforeCaption($doc, [int]$captionIndex) {
    $i = $captionIndex - 1
    while ($i -ge 1) {
        $paragraph = $doc.Paragraphs.Item($i)
        if ($paragraph.Range.InlineShapes.Count -gt 0 -or $paragraph.Range.Tables.Count -gt 0) {
            return $i
        }
        $text = Paragraph-Text $paragraph
        if (-not [string]::IsNullOrWhiteSpace($text)) {
            return $null
        }
        $i--
    }
    return $null
}

function Find-CaptionAfterIndex($doc, [int]$startIndex, [string]$prefix) {
    for ($i = $startIndex; $i -le $doc.Paragraphs.Count; $i++) {
        $text = Paragraph-Text $doc.Paragraphs.Item($i)
        if ($text.StartsWith($prefix)) {
            return $i
        }
        if (Is-HeadingParagraph $doc.Paragraphs.Item($i) -and $i -gt $startIndex) {
            break
        }
    }
    return $null
}

function Find-PostCaptionTail($doc, [int]$captionIndex) {
    $next = Find-NextNonEmptyParagraph $doc $captionIndex
    if ($null -eq $next) {
        return $captionIndex
    }
    $paragraph = $doc.Paragraphs.Item($next)
    $text = Paragraph-Text $paragraph
    if ($paragraph.Range.InlineShapes.Count -gt 0 -or $paragraph.Range.Tables.Count -gt 0 -or (Is-HeadingParagraph $paragraph)) {
        return $captionIndex
    }
    if ($text.StartsWith("Figure ") -or $text.StartsWith("Table ")) {
        return $captionIndex
    }
    return $next
}

$word = $null
$doc = $null

try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0

    $isPeer = $Profile -eq "peer"
    $isV7 = $Profile -eq "v7" -or $isPeer
    $bodyFontName = if ($isV7) { "Cambria" } else { "Arial" }
    $bodyFontSize = if ($isV7) { 10 } else { 10 }
    $bodyColor = if ($isV7) { Get-OleColor 0 0 0 } else { Get-OleColor 26 34 43 }
    $headingColor = if ($isV7) { Get-OleColor 0 0 0 } else { Get-OleColor 26 92 122 }
    $titleColor = if ($isV7) { Get-OleColor 0 0 0 } else { Get-OleColor 26 56 99 }
    $metaColor = if ($isV7) { Get-OleColor 80 80 80 } else { Get-OleColor 70 78 90 }
    $captionColor = if ($isV7) { Get-OleColor 80 80 80 } else { Get-OleColor 60 69 78 }
    $accentColor = Get-OleColor 230 50 33
    $titleSize = if ($isV7) { 24 } else { 20 }
    $displayTitleSize = if ($isPeer) { 22 } else { $titleSize }
    $heading1Size = if ($isV7) { 14 } else { 13 }
    $captionFontName = if ($isV7) { "Cambria" } else { "Arial" }
    $captionFontSize = if ($isV7) { 9 } else { 8.5 }
    $heading3FontName = if ($isV7) { "Cambria" } else { "Arial" }
    $tableFontName = if ($isV7) { "Cambria" } else { "Arial" }
    $tableFontSize = if ($isV7) { 9 } else { 8 }

    $inputPath = (Resolve-Path $InputDocx).Path
    $doc = $word.Documents.Open($inputPath)
    $doc.PageSetup.PaperSize = $wdPaperA4
    $doc.ShowSpellingErrors = $false
    $doc.ShowGrammaticalErrors = $false
    $doc.SpellingChecked = $true
    $doc.GrammarChecked = $true
    $doc.Content.NoProofing = -1

    foreach ($section in @($doc.Sections)) {
        $section.PageSetup.PaperSize = $wdPaperA4
        $section.PageSetup.TopMargin = $word.CentimetersToPoints(1.8)
        $section.PageSetup.BottomMargin = $word.CentimetersToPoints(1.8)
        $section.PageSetup.LeftMargin = $word.CentimetersToPoints(1.7)
        $section.PageSetup.RightMargin = $word.CentimetersToPoints(1.7)
    }

    if (-not $isV7) {
        $introIndex = Find-ParagraphIndex $doc "Introduction"
        if ($null -ne $introIndex) {
            Insert-Break-BeforeParagraph $doc $introIndex
        }

        $blocks = New-Object System.Collections.ArrayList

        $conceptHeading = Find-ExactParagraphOrNull $doc "Conceptual Framework"
        if ($null -ne $conceptHeading) {
            $captionIndex = Find-CaptionAfterIndex $doc $conceptHeading "Figure 1."
            if ($null -ne $captionIndex) {
                Add-Block $blocks $conceptHeading (Find-PostCaptionTail $doc $captionIndex)
            }
        }

        $datasetCaption = Find-ParagraphStartingWith $doc "Figure 3."
        if ($null -ne $datasetCaption) {
            $imageIndex = Find-VisualParagraphBeforeCaption $doc $datasetCaption
            if ($null -ne $imageIndex) {
                Add-Block $blocks $imageIndex $datasetCaption
            }
        }

        $workflowHeading = Find-ExactParagraphOrNull $doc "Study Workflow"
        if ($null -ne $workflowHeading) {
            $captionIndex = Find-CaptionAfterIndex $doc $workflowHeading "Figure 2."
            if ($null -ne $captionIndex) {
                Add-Block $blocks $workflowHeading (Find-PostCaptionTail $doc $captionIndex)
            }
        }

        foreach ($table in @($doc.Tables)) {
            $tableStart = Find-ParagraphContainingPosition $doc $table.Range.Start
            $tableEnd = Find-ParagraphContainingPosition $doc ($table.Range.End - 1)
            if ($null -eq $tableStart -or $null -eq $tableEnd) {
                continue
            }
            $captionIndex = Find-PreviousNonEmptyParagraph $doc $tableStart
            if ($null -ne $captionIndex -and (Paragraph-Text $doc.Paragraphs.Item($captionIndex)) -like "Table *") {
                $resultsHeading = Find-ExactParagraphOrNull $doc "Results"
                $resultsIntro = $null
                if ($null -ne $resultsHeading) {
                    $resultsIntro = Find-NextNonEmptyParagraph $doc $resultsHeading
                }
                $tableNote = Find-NextNonEmptyParagraph $doc $tableEnd
                if ($null -ne $resultsIntro -and $resultsIntro -lt $captionIndex -and $null -ne $tableNote) {
                    Add-Block $blocks $resultsIntro $tableNote
                }
                else {
                    Add-Block $blocks $captionIndex $tableEnd
                }
            }
        }

        $confusionHeading = Find-ExactParagraphOrNull $doc "Confusion Matrix"
        if ($null -ne $confusionHeading) {
            $captionIndex = Find-CaptionAfterIndex $doc $confusionHeading "Figure 4."
            if ($null -ne $captionIndex) {
                Add-Block $blocks $confusionHeading (Find-PostCaptionTail $doc $captionIndex)
            }
        }

        $trainingHeading = Find-ExactParagraphOrNull $doc "Training Dynamics"
        if ($null -ne $trainingHeading) {
            $captionIndex = Find-CaptionAfterIndex $doc $trainingHeading "Figure 5."
            if ($null -ne $captionIndex) {
                Add-Block $blocks $trainingHeading (Find-PostCaptionTail $doc $captionIndex)
            }
        }

        $synthesisHeading = Find-ExactParagraphOrNull $doc "Results-Synthesis Diagram"
        if ($null -ne $synthesisHeading) {
            $captionIndex = Find-CaptionAfterIndex $doc $synthesisHeading "Figure 6."
            if ($null -ne $captionIndex) {
                Add-Block $blocks $synthesisHeading (Find-PostCaptionTail $doc $captionIndex)
            }
        }

        $blocks = $blocks | Sort-Object Start -Descending
        foreach ($block in $blocks) {
            Insert-Break-AfterParagraph $doc $block.End
            Insert-Break-BeforeParagraph $doc $block.Start
        }

        for ($i = 1; $i -le $doc.Sections.Count; $i++) {
            $section = $doc.Sections.Item($i)
            $text = Clean-Text $section.Range.Text
            $hasInlineShapes = $section.Range.InlineShapes.Count -gt 0
            $hasTables = $section.Range.Tables.Count -gt 0
            if ($i -eq 1 -or $hasInlineShapes -or $hasTables -or $text -match "^(Figure|Table)\s") {
                $section.PageSetup.TextColumns.SetCount(1)
            }
            else {
                $section.PageSetup.TextColumns.SetCount(2)
                $section.PageSetup.TextColumns.Spacing = $word.CentimetersToPoints(0.75)
            }
        }
    }
    else {
        foreach ($section in @($doc.Sections)) {
            $section.PageSetup.TextColumns.SetCount(1)
        }
    }

    $titleIndex = Find-ParagraphIndex $doc "Detecting Common Road Users in Philippine Traffic: A Comparative YOLOv26 Study"
    if ($null -ne $titleIndex) {
        $titleParagraph = $doc.Paragraphs.Item($titleIndex)
        $titleParagraph.Range.Style = "Title"
        $titleParagraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphCenter
        Set-ParagraphFont $titleParagraph.Range "Arial" $displayTitleSize $titleColor
    }

    for ($i = 1; $i -le $doc.Paragraphs.Count; $i++) {
        $paragraph = $doc.Paragraphs.Item($i)
        $text = Paragraph-Text $paragraph

        if (Is-HeadingParagraph $paragraph) {
            $paragraph.Range.ParagraphFormat.KeepWithNext = -1
            $paragraph.Range.ParagraphFormat.KeepTogether = -1
        }

        if ($text -like "Adviser:*") {
            $paragraph.Range.Font.Name = if ($isV7) { "Arial" } else { "Arial" }
            $paragraph.Range.Font.Size = if ($isV7) { 9 } else { 10 }
            $paragraph.Range.Font.Italic = $false
            $paragraph.Range.Font.Color = $metaColor
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphCenter
            $paragraph.Range.ParagraphFormat.SpaceAfter = if ($isV7) { 10 } else { 8 }
            continue
        }

        if ($text -like "Figure *" -or $text -like "Table *") {
            $paragraph.Range.Style = "Caption"
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphLeft
            $paragraph.Range.ParagraphFormat.KeepWithNext = -1
            $paragraph.Range.ParagraphFormat.KeepTogether = -1
            Set-ParagraphFont $paragraph.Range $captionFontName $captionFontSize $captionColor
            $paragraph.Range.Font.Italic = -1
            continue
        }

        if ($paragraph.Range.InlineShapes.Count -gt 0) {
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphCenter
            $paragraph.Range.ParagraphFormat.KeepWithNext = -1
            $paragraph.Range.ParagraphFormat.KeepTogether = -1
            continue
        }

        $styleName = Paragraph-StyleName $paragraph

        $nextNonEmpty = Find-NextNonEmptyParagraph $doc $i
        if ($null -ne $nextNonEmpty) {
            $nextParagraph = $doc.Paragraphs.Item($nextNonEmpty)
            $nextText = Paragraph-Text $nextParagraph
            if ($nextParagraph.Range.InlineShapes.Count -gt 0 -or $nextText -like "Figure *" -or $nextText -like "Table *") {
                $paragraph.Range.ParagraphFormat.KeepWithNext = -1
                if ($text.Length -lt 400) {
                    $paragraph.Range.ParagraphFormat.KeepTogether = -1
                }
            }
        }

        if ($styleName -eq "Normal" -and -not [string]::IsNullOrWhiteSpace($text)) {
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphJustify
            $paragraph.Range.ParagraphFormat.LineSpacingRule = $wdLineSpaceSingle
            Set-ParagraphFont $paragraph.Range $bodyFontName $bodyFontSize $bodyColor
        }

        if ($styleName -eq "Heading 1") {
            Set-ParagraphFont $paragraph.Range "Arial" $heading1Size $headingColor
        }
        elseif ($styleName -eq "Heading 2") {
            Set-ParagraphFont $paragraph.Range "Arial" 11 $headingColor
        }
        elseif ($styleName -eq "Heading 3") {
            Set-ParagraphFont $paragraph.Range $heading3FontName 10 $headingColor
        }
    }

    $refsIndex = Find-ParagraphIndex $doc "References"
    if ($null -ne $refsIndex) {
        for ($i = $refsIndex + 1; $i -le $doc.Paragraphs.Count; $i++) {
            $text = Paragraph-Text $doc.Paragraphs.Item($i)
            if (-not [string]::IsNullOrWhiteSpace($text)) {
                $doc.Paragraphs.Item($i).Range.Font.Size = 8.5
                $doc.Paragraphs.Item($i).Range.ParagraphFormat.Alignment = $wdAlignParagraphLeft
                $doc.Paragraphs.Item($i).Range.ParagraphFormat.SpaceAfter = 4
            }
        }
    }

    foreach ($table in @($doc.Tables)) {
        $table.AutoFitBehavior($wdAutoFitWindow)
        $table.Range.Font.Name = $tableFontName
        $table.Range.Font.Size = $tableFontSize
        $table.Range.Font.Color = $bodyColor
    }

    foreach ($shape in @($doc.InlineShapes)) {
        $shape.LockAspectRatio = -1
        $section = $shape.Range.Sections.Item(1)
        $columns = $section.PageSetup.TextColumns.Count
        $availableHeight = $section.PageSetup.PageHeight - $section.PageSetup.TopMargin - $section.PageSetup.BottomMargin - $word.CentimetersToPoints(3.5)
        if ($columns -eq 1) {
            $maxWidth = $section.PageSetup.PageWidth - $section.PageSetup.LeftMargin - $section.PageSetup.RightMargin - $word.CentimetersToPoints(0.5)
        }
        else {
            $maxWidth = $section.PageSetup.TextColumns.Item(1).Width - $word.CentimetersToPoints(0.2)
        }
        if ($shape.Width -gt $maxWidth) {
            $shape.Width = $maxWidth
        }
        if ($shape.Height -gt $availableHeight) {
            $shape.Height = $availableHeight
        }
    }

    if ($isV7) {
        $shape = $doc.Shapes.AddShape(
            1,
            $doc.PageSetup.LeftMargin,
            $word.CentimetersToPoints(0.75),
            $doc.PageSetup.PageWidth - $doc.PageSetup.LeftMargin - $doc.PageSetup.RightMargin,
            $word.CentimetersToPoints(0.08)
        )
        $shape.Fill.ForeColor.RGB = $accentColor
        $shape.Fill.Visible = -1
        $shape.Line.Visible = 0
        $shape.WrapFormat.Type = 3
        $shape.RelativeHorizontalPosition = 0
        $shape.RelativeVerticalPosition = 0
        $shape.LockAnchor = -1
        $shape.ZOrder(5) | Out-Null
    }

    $outputDir = Split-Path -Parent $OutputDocx
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }

    $outputDocxPath = [System.IO.Path]::GetFullPath($OutputDocx)
    $doc.SaveAs2([ref]$outputDocxPath, [ref]$wdFormatXMLDocument)

    if (-not [string]::IsNullOrWhiteSpace($OutputPdf)) {
        $pdfDir = Split-Path -Parent $OutputPdf
        if (-not (Test-Path $pdfDir)) {
            New-Item -ItemType Directory -Path $pdfDir -Force | Out-Null
        }
        $outputPdfPath = [System.IO.Path]::GetFullPath($OutputPdf)
        $doc.SaveAs2([ref]$outputPdfPath, [ref]$wdFormatPDF)
    }
}
finally {
    if ($doc -ne $null) {
        $doc.Close([ref]$false) | Out-Null
    }
    if ($word -ne $null) {
        $word.Quit() | Out-Null
    }
}
