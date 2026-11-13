<#
.SYNOPSIS
    Baut usermods\NomadsRoot.scd: Nomads-Dateien, die LOUD nur an festen Wurzelpfaden sucht.

.DESCRIPTION
    LOUD bindet Mod-Ordner nur unter /mods/<name> ein, Archive (.scd/.zip) in usermods dagegen
    unter / (LOUD\bin\CommonDataPath.lua, mount_mods). Upgrade-, Order-, Einheiten- und
    Strategie-Icons sowie Sim-Tasks sucht LOUD aber unter festen Pfaden (/textures/ui/common/...,
    /lua/sim/tasks/...). Dieses Skript packt sie in ein Archiv, das LOUD im Wurzelverzeichnis
    einbindet. Doku: doc.claude\mods\Nomads.md Abschnitt 6.

    Quellen (Pfad im Archiv in Klammern):
      Nomads\textures\ui\common\**   (textures/ui/common/**)
      Nomads\env\common\decals\**    (env/common/decals/**, Tarmacs aus den Blueprints)
      Nomads\textures\particles\<n>.dds  (textures/particles/<n>.dds, nur Namen, die im
                                      Nomads-Lua-Code als Zeichenkette vorkommen)
      Nomads\root\**                 (wie im Ordner, z. B. lua/sim/tasks/..., textures/ui/common/...)

    Ausgelassen wird jede Datei, die es in einem von LOUD eingebundenen Archiv schon gibt
    (LOUD\gamedata\*.scd, gamedata\*.scd, LOUD\bin\BrewLAN-StrategicIconsOverhaul-*.scd):
    das Archiv fuegt nur hinzu und ersetzt nichts.

    Schreibt ausschliesslich LOUD\usermods\NomadsRoot.scd. Feste Zeitstempel und sortierte
    Eintraege: gleicher Inhalt ergibt dieselbe Datei.

.EXAMPLE
    .\Build-NomadsRoot.ps1
#>

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$mods   = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$loud   = Split-Path $mods -Parent
$fa     = Split-Path $loud -Parent
$nomads = Join-Path $mods 'Nomads'
$target = Join-Path $mods 'NomadsRoot.scd'

# Dateinamen, die LOUD schon einbindet (klein, mit /)
$existing = New-Object 'System.Collections.Generic.HashSet[string]'
$archives = @()
$archives += Get-ChildItem (Join-Path $loud 'gamedata') -Filter *.scd
$archives += Get-ChildItem (Join-Path $fa 'gamedata') -Filter *.scd
$archives += Get-ChildItem (Join-Path $loud 'bin') -Filter 'BrewLAN-StrategicIconsOverhaul-*.scd'
foreach ($a in $archives) {
    $zip = [System.IO.Compression.ZipFile]::OpenRead($a.FullName)
    try {
        foreach ($e in $zip.Entries) {
            [void]$existing.Add($e.FullName.Replace('\', '/').TrimStart('/').ToLowerInvariant())
        }
    } finally {
        $zip.Dispose()
    }
}

# Archivpfad -> Quelldatei
$files = @{}
function Add-Source([string]$dir, [string]$prefix) {
    if (-not (Test-Path $dir)) { return }
    foreach ($f in Get-ChildItem $dir -Recurse -File) {
        $rel = $f.FullName.Substring($dir.Length).TrimStart('\').Replace('\', '/')
        $name = ($prefix + $rel).ToLowerInvariant()
        if ($files.ContainsKey($name)) { throw "Doppelt: $name" }
        $files[$name] = $f.FullName
    }
}
Add-Source (Join-Path $nomads 'textures\ui\common') 'textures/ui/common/'
Add-Source (Join-Path $nomads 'env\common\decals') 'env/common/decals/'
Add-Source (Join-Path $nomads 'root') ''

# Partikeltexturen: CreateLightParticle & Co. bekommen nur einen Namen, die Engine sucht
# /textures/particles/<name>.dds. Aufgenommen wird jeder Name, der im Nomads-Lua-Code als
# Zeichenkette steht und als Datei in Nomads\textures\particles\ liegt.
$particles = Join-Path $nomads 'textures\particles'
$names = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($f in Get-ChildItem $nomads -Recurse -File -Filter *.lua) {
    $text = [System.IO.File]::ReadAllText($f.FullName)
    foreach ($m in [regex]::Matches($text, '[''"]([A-Za-z0-9_]+)[''"]')) {
        [void]$names.Add($m.Groups[1].Value.ToLowerInvariant())
    }
}
foreach ($n in $names) {
    $src = Join-Path $particles ($n + '.dds')
    if (Test-Path -LiteralPath $src -PathType Leaf) {
        $key = 'textures/particles/' + $n + '.dds'
        if (-not $files.ContainsKey($key)) { $files[$key] = (Get-Item -LiteralPath $src).FullName }
    }
}

$skipped = @($files.Keys | Where-Object { $existing.Contains($_) } | Sort-Object)
$packed  = @($files.Keys | Where-Object { -not $existing.Contains($_) } | Sort-Object)

$stamp = New-Object DateTimeOffset (2026, 1, 1, 0, 0, 0, [TimeSpan]::Zero)
if (Test-Path $target) { Remove-Item $target }
$zip = [System.IO.Compression.ZipFile]::Open($target, 'Create')
try {
    foreach ($name in $packed) {
        $entry = $zip.CreateEntry($name, [System.IO.Compression.CompressionLevel]::Optimal)
        $entry.LastWriteTime = $stamp
        $out = $entry.Open()
        try {
            $bytes = [System.IO.File]::ReadAllBytes($files[$name])
            $out.Write($bytes, 0, $bytes.Length)
        } finally {
            $out.Dispose()
        }
    }
} finally {
    $zip.Dispose()
}

Write-Host ("Gepackt: {0} Dateien -> {1}" -f $packed.Count, $target)
Write-Host ("Ausgelassen (schon in LOUD): {0}" -f $skipped.Count)
foreach ($s in $skipped) { Write-Host "  $s" }
