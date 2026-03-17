param(
    [Parameter(Mandatory = $true)]
    [string]$OutputPath,

    [Parameter(Mandatory = $false)]
    [ValidateSet("v6","v7","peer")]
    [string]$Profile = "v6"
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

    $isV7 = $Profile -eq "v7" -or $Profile -eq "peer"

    $bodyFontName = if ($isV7) { "Cambria" } else { "Arial" }
    $bodyFontSize = if ($isV7) { 10 } else { 10 }
    $bodyColor = if ($isV7) { Get-OleColor 0 0 0 } else { Get-OleColor 26 34 43 }
    $titleColor = if ($isV7) { Get-OleColor 0 0 0 } else { Get-OleColor 26 56 99 }
    $headingColor = if ($isV7) { Get-OleColor 0 0 0 } else { Get-OleColor 26 92 122 }
    $captionColor = if ($isV7) { Get-OleColor 80 80 80 } else { Get-OleColor 60 69 78 }

    $normal = $doc.Styles.Item("Normal")
    $normal.Font.Name = $bodyFontName
    $normal.Font.Size = $bodyFontSize
    $normal.Font.Color = $bodyColor
    $normal.ParagraphFormat.Alignment = $wdAlignParagraphLeft
    $normal.ParagraphFormat.LineSpacingRule = $wdLineSpaceSingle
    $normal.ParagraphFormat.SpaceAfter = if ($isV7) { 8 } else { 6 }

    $title = $doc.Styles.Item("Title")
    $title.Font.Name = "Arial"
    $title.Font.Size = if ($isV7) { 24 } else { 20 }
    $title.Font.Bold = $true
    $title.Font.Color = $titleColor
    $title.ParagraphFormat.Alignment = $wdAlignParagraphCenter
    $title.ParagraphFormat.SpaceAfter = if ($isV7) { 10 } else { 8 }

    $h1 = $doc.Styles.Item("Heading 1")
    $h1.Font.Name = "Arial"
    $h1.Font.Size = if ($isV7) { 14 } else { 13 }
    $h1.Font.Bold = $true
    $h1.Font.Color = $headingColor
    $h1.ParagraphFormat.SpaceBefore = if ($isV7) { 12 } else { 10 }
    $h1.ParagraphFormat.SpaceAfter = if ($isV7) { 6 } else { 4 }
    $h1.ParagraphFormat.KeepWithNext = -1

    $h2 = $doc.Styles.Item("Heading 2")
    $h2.Font.Name = "Arial"
    $h2.Font.Size = 11
    $h2.Font.Bold = $true
    $h2.Font.Color = $headingColor
    $h2.ParagraphFormat.SpaceBefore = if ($isV7) { 10 } else { 8 }
    $h2.ParagraphFormat.SpaceAfter = if ($isV7) { 4 } else { 3 }
    $h2.ParagraphFormat.KeepWithNext = -1

    $h3 = $doc.Styles.Item("Heading 3")
    $h3.Font.Name = if ($isV7) { "Cambria" } else { "Arial" }
    $h3.Font.Size = 10
    $h3.Font.Bold = $true
    $h3.Font.Color = $headingColor
    $h3.ParagraphFormat.SpaceBefore = 6
    $h3.ParagraphFormat.SpaceAfter = 2
    $h3.ParagraphFormat.KeepWithNext = -1

    $caption = $doc.Styles.Item("Caption")
    $caption.Font.Name = if ($isV7) { "Cambria" } else { "Arial" }
    $caption.Font.Size = if ($isV7) { 9 } else { 8.5 }
    $caption.Font.Italic = -1
    $caption.Font.Color = $captionColor
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
