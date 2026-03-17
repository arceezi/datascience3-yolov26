param(
    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function Get-OleColor([int]$r, [int]$g, [int]$b) {
    return [System.Drawing.ColorTranslator]::ToOle([System.Drawing.Color]::FromArgb($r, $g, $b))
}

$wdPaperA4 = 7
$wdFormatXMLDocument = 12
$wdAlignParagraphLeft = 0
$wdAlignParagraphCenter = 1
$wdLineSpaceSingle = 0

$outputDir = Split-Path -Parent $OutputPath
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$word = $null
$doc = $null

try {
    $word = New-Object -ComObject Word.Application
    $word.Visible = $false
    $word.DisplayAlerts = 0

    $doc = $word.Documents.Add()
    $doc.PageSetup.PaperSize = $wdPaperA4
    $doc.PageSetup.TopMargin = $word.CentimetersToPoints(1.8)
    $doc.PageSetup.BottomMargin = $word.CentimetersToPoints(1.8)
    $doc.PageSetup.LeftMargin = $word.CentimetersToPoints(1.7)
    $doc.PageSetup.RightMargin = $word.CentimetersToPoints(1.7)

    $normal = $doc.Styles.Item("Normal")
    $normal.Font.Name = "Arial"
    $normal.Font.Size = 10
    $normal.Font.Color = Get-OleColor 26 34 43
    $normal.ParagraphFormat.Alignment = $wdAlignParagraphLeft
    $normal.ParagraphFormat.LineSpacingRule = $wdLineSpaceSingle
    $normal.ParagraphFormat.SpaceAfter = 6

    $title = $doc.Styles.Item("Title")
    $title.Font.Name = "Arial"
    $title.Font.Size = 20
    $title.Font.Bold = $true
    $title.Font.Color = Get-OleColor 26 56 99
    $title.ParagraphFormat.Alignment = $wdAlignParagraphCenter
    $title.ParagraphFormat.SpaceAfter = 8

    $h1 = $doc.Styles.Item("Heading 1")
    $h1.Font.Name = "Arial"
    $h1.Font.Size = 13
    $h1.Font.Bold = $true
    $h1.Font.Color = Get-OleColor 26 92 122
    $h1.ParagraphFormat.SpaceBefore = 10
    $h1.ParagraphFormat.SpaceAfter = 4
    $h1.ParagraphFormat.KeepWithNext = -1

    $h2 = $doc.Styles.Item("Heading 2")
    $h2.Font.Name = "Arial"
    $h2.Font.Size = 11
    $h2.Font.Bold = $true
    $h2.Font.Color = Get-OleColor 26 92 122
    $h2.ParagraphFormat.SpaceBefore = 8
    $h2.ParagraphFormat.SpaceAfter = 3
    $h2.ParagraphFormat.KeepWithNext = -1

    $h3 = $doc.Styles.Item("Heading 3")
    $h3.Font.Name = "Arial"
    $h3.Font.Size = 10
    $h3.Font.Bold = $true
    $h3.Font.Color = Get-OleColor 26 92 122
    $h3.ParagraphFormat.SpaceBefore = 6
    $h3.ParagraphFormat.SpaceAfter = 2
    $h3.ParagraphFormat.KeepWithNext = -1

    $caption = $doc.Styles.Item("Caption")
    $caption.Font.Name = "Arial"
    $caption.Font.Size = 8.5
    $caption.Font.Color = Get-OleColor 60 69 78
    $caption.ParagraphFormat.Alignment = $wdAlignParagraphLeft
    $caption.ParagraphFormat.SpaceAfter = 6

    $doc.SaveAs2([ref]$OutputPath, [ref]$wdFormatXMLDocument)
}
finally {
    if ($doc -ne $null) {
        $doc.Close([ref]$false) | Out-Null
    }
    if ($word -ne $null) {
        $word.Quit() | Out-Null
    }
}
