param(
    [Parameter(Mandatory = $true)]
    [string]$InputDocx,

    [Parameter(Mandatory = $true)]
    [string]$OutputDocx,

    [Parameter(Mandatory = $false)]
    [string]$OutputPdf = ""
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

function Find-ParagraphContainingPosition($doc, [int]$position) {
    for ($i = 1; $i -le $doc.Paragraphs.Count; $i++) {
        $paragraph = $doc.Paragraphs.Item($i)
        if ($paragraph.Range.Start -le $position -and $paragraph.Range.End -ge $position) {
            return $i
        }
    }
    return $null
}

$word = $null
$doc = $null

try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0

    $inputPath = (Resolve-Path $InputDocx).Path
    $doc = $word.Documents.Open($inputPath)
    $doc.PageSetup.PaperSize = $wdPaperA4

    foreach ($section in @($doc.Sections)) {
        $section.PageSetup.PaperSize = $wdPaperA4
        $section.PageSetup.TopMargin = $word.CentimetersToPoints(1.8)
        $section.PageSetup.BottomMargin = $word.CentimetersToPoints(1.8)
        $section.PageSetup.LeftMargin = $word.CentimetersToPoints(1.7)
        $section.PageSetup.RightMargin = $word.CentimetersToPoints(1.7)
    }

    $introIndex = Find-ParagraphIndex $doc "Introduction"
    if ($null -ne $introIndex) {
        Insert-Break-BeforeParagraph $doc $introIndex
    }

    $blocks = New-Object System.Collections.ArrayList

    for ($i = 1; $i -le $doc.Paragraphs.Count; $i++) {
        $text = Paragraph-Text $doc.Paragraphs.Item($i)
        if ($text -like "Figure *") {
            $startIndex = Find-PreviousContentParagraph $doc $i
            if ($null -ne $startIndex) {
                [void]$blocks.Add([PSCustomObject]@{ Start = $startIndex; End = $i })
            }
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
            [void]$blocks.Add([PSCustomObject]@{ Start = $captionIndex; End = $tableEnd })
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

    $titleIndex = Find-ParagraphIndex $doc "Detecting Common Road Users in Philippine Traffic: A Comparative YOLOv26 Study"
    if ($null -ne $titleIndex) {
        $titleParagraph = $doc.Paragraphs.Item($titleIndex)
        $titleParagraph.Range.Style = "Title"
        $titleParagraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphCenter
    }

    for ($i = 1; $i -le $doc.Paragraphs.Count; $i++) {
        $paragraph = $doc.Paragraphs.Item($i)
        $text = Paragraph-Text $paragraph

        if ($text -like "Adviser:*") {
            $paragraph.Range.Font.Name = "Arial"
            $paragraph.Range.Font.Size = 10
            $paragraph.Range.Font.Italic = $false
            $paragraph.Range.Font.Color = Get-OleColor 70 78 90
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphCenter
            $paragraph.Range.ParagraphFormat.SpaceAfter = 8
            continue
        }

        if ($text -like "Figure *" -or $text -like "Table *") {
            $paragraph.Range.Style = "Caption"
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphLeft
            $paragraph.Range.ParagraphFormat.KeepWithNext = -1
            continue
        }

        if ($paragraph.Range.InlineShapes.Count -gt 0) {
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphCenter
            continue
        }

        $styleName = ""
        try {
            $styleName = [string]$paragraph.Range.Style.NameLocal
        }
        catch {
            $styleName = ""
        }

        if ($styleName -eq "Normal" -and -not [string]::IsNullOrWhiteSpace($text)) {
            $paragraph.Range.ParagraphFormat.Alignment = $wdAlignParagraphJustify
            $paragraph.Range.ParagraphFormat.LineSpacingRule = $wdLineSpaceSingle
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
        $table.Range.Font.Name = "Arial"
        $table.Range.Font.Size = 8
    }

    foreach ($shape in @($doc.InlineShapes)) {
        $shape.LockAspectRatio = -1
        $section = $shape.Range.Sections.Item(1)
        $columns = $section.PageSetup.TextColumns.Count
        if ($columns -eq 1) {
            $maxWidth = $section.PageSetup.PageWidth - $section.PageSetup.LeftMargin - $section.PageSetup.RightMargin - $word.CentimetersToPoints(0.5)
        }
        else {
            $maxWidth = $section.PageSetup.TextColumns.Item(1).Width - $word.CentimetersToPoints(0.2)
        }
        if ($shape.Width -gt $maxWidth) {
            $shape.Width = $maxWidth
        }
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
