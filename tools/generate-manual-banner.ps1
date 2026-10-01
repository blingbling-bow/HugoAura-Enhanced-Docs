Add-Type -AssemblyName System.Drawing

$sourceDir = Join-Path $PSScriptRoot '..\docs\public\static\img\userGuide\installation\autoInstallation'
$outDir = Join-Path $sourceDir '..\manualInstallation'
New-Item -ItemType Directory -Force $outDir | Out-Null
$width = 2880
$height = 602
$left = 930
$right = 1950
$top = 190
$bottom = 525
$lightningSource = Join-Path $outDir 'Lightning_Source.png'

function Get-Lightning([bool]$transparent) {
    $source = [System.Drawing.Bitmap]::FromFile($lightningSource)
    $background = $source.GetPixel(0, 0)
    $lightning = [System.Drawing.Bitmap]::new($source.Width, $source.Height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    for ($y = 0; $y -lt $source.Height; $y++) {
        for ($x = 0; $x -lt $source.Width; $x++) {
            $pixel = $source.GetPixel($x, $y)
            $dr = [Math]::Abs($pixel.R - $background.R)
            $dg = [Math]::Abs($pixel.G - $background.G)
            $db = [Math]::Abs($pixel.B - $background.B)
            $distance = [Math]::Sqrt($dr * $dr + $dg * $dg + $db * $db)
            $alpha = [Math]::Max(0, [Math]::Min(255, [int](($distance - 8) * 4 * 0.55)))
            $color = if ($transparent) {
                [System.Drawing.Color]::FromArgb([int]($alpha * 0.62), 255, 255, 255)
            } else {
                [System.Drawing.Color]::FromArgb([int]($alpha * 0.90), 165, 225, 255)
            }
            $lightning.SetPixel($x, $y, $color)
        }
    }
    $source.Dispose()
    return $lightning
}

function Build-Banner([string]$inputPath, [string]$outputPath, [bool]$transparent) {
    $source = [System.Drawing.Bitmap]::FromFile($inputPath)
    if ($transparent) {
        $bitmap = [System.Drawing.Bitmap]::new($width, $height, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        for ($y = 0; $y -lt $height; $y++) {
            for ($x = 0; $x -lt $width; $x++) {
                if ($x -lt $left -or $x -ge $right -or $y -lt $top -or $y -ge $bottom) {
                    $bitmap.SetPixel($x, $y, $source.GetPixel($x, $y))
                }
            }
        }
    } else {
        $bitmap = [System.Drawing.Bitmap]::new($source)
        for ($y = $top; $y -lt $bottom; $y++) {
            $a = $source.GetPixel($left - 1, $y)
            $b = $source.GetPixel($right, $y)
            for ($x = $left; $x -lt $right; $x++) {
                $t = ($x - $left) / ($right - $left)
                $r = [int]($a.R + ($b.R - $a.R) * $t)
                $g = [int]($a.G + ($b.G - $a.G) * $t)
                $blue = [int]($a.B + ($b.B - $a.B) * $t)
                $bitmap.SetPixel($x, $y, [System.Drawing.Color]::FromArgb($r, $g, $blue))
            }
        }
        $source.Dispose()
    }

    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $lightning = Get-Lightning $transparent
    $graphics.DrawImage($lightning, [System.Drawing.Rectangle]::new(1346, 195, 188, 293))
    $textColor = if ($transparent) { [System.Drawing.Color]::FromArgb(205, 255, 255, 255) } else { [System.Drawing.Color]::FromArgb(220, 245, 250, 255) }
    $font = [System.Drawing.Font]::new('Microsoft YaHei UI', 174, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
    $brush = [System.Drawing.SolidBrush]::new($textColor)
    $format = [System.Drawing.StringFormat]::new()
    $format.Alignment = [System.Drawing.StringAlignment]::Center
    $format.LineAlignment = [System.Drawing.StringAlignment]::Center
    $graphics.DrawString('手动安装', $font, $brush, [System.Drawing.RectangleF]::new(0, 220, $width, 230), $format)
    $bitmap.Save($outputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $format.Dispose(); $brush.Dispose(); $font.Dispose(); $lightning.Dispose(); $graphics.Dispose(); $bitmap.Dispose(); $source.Dispose()
}

Build-Banner (Join-Path $sourceDir 'Banner_WithBg.png') (Join-Path $outDir 'Banner_WithBg.png') $false
Build-Banner (Join-Path $sourceDir 'Banner_Transparent.png') (Join-Path $outDir 'Banner_Transparent.png') $true
