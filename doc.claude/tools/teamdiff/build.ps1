param([string]$FA = (Resolve-Path "$PSScriptRoot\..\..\..\..\..").Path, [string]$Stand = (Get-Date -Format 'dd.MM.yyyy'))
# Erzeugt das Team-PDF "Unsere Mods - was sich geaendert hat", siehe README.md.
# Schreibt nur nach doc.claude\team\ (PDF) und in den Temp-Ordner (Zwischendateien, Edge-Profil).
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$tmp  = Join-Path $env:TEMP 'loud_teamdiff'
New-Item -ItemType Directory -Force $tmp | Out-Null
$out  = Join-Path (Resolve-Path "$here\..\..").Path 'team'
New-Item -ItemType Directory -Force $out | Out-Null

& "$here\teamdiff_data.ps1" -FA $FA -Out "$tmp\teamdiff.json"

$json = [IO.File]::ReadAllText("$tmp\teamdiff.json")
$html = [IO.File]::ReadAllText("$here\teamdiff.html").Replace('/*DATA*/null', $json).Replace('/*STAND*/', $Stand)
$page = "$tmp\teamdiff.html"
[IO.File]::WriteAllText($page, $html, (New-Object Text.UTF8Encoding $false))

$edge = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe", "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe") | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw 'Microsoft Edge nicht gefunden' }
$pdf = Join-Path $out 'LOUD-Mods_Aenderungen.pdf'
$url = 'file:///' + ($page -replace '\\', '/')
$ErrorActionPreference = 'Continue'   # Edge meldet Erfolg ueber stderr
& $edge --headless=new --disable-gpu --no-first-run "--user-data-dir=$tmp\edge" --no-pdf-header-footer --virtual-time-budget=10000 "--print-to-pdf=$pdf" $url | Out-Null
Start-Sleep -Milliseconds 500
if (Test-Path $pdf) { "PDF: $pdf ($([math]::Round((Get-Item $pdf).Length / 1KB)) KB)" } else { throw 'PDF wurde nicht erzeugt' }
