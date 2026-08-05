# ============================================================================
# Get-Units.ps1  -  Vollstaendige Einheitenliste aller Pakete und Mods
#
# Durchsucht gamedata.entpackt und usermods nach *_unit.bp und erzeugt
# eine Liste mit Paket, Mod, Fraktion, Techstufe, Domaene, ID und Name.
#
# Aufruf (PowerShell, im tools-Ordner):
#     .\Get-Units.ps1
#
# Optional:
#     .\Get-Units.ps1 -Root "D:\Pfad\zu\LOUD" -OutDir "C:\temp\units"
#
# Ausgabe (Standard: ..\units\ ):
#     units.csv        alle Einheiten, Semikolon-getrennt (Excel-tauglich)
#     units.md         nach Paket/Mod gruppiert, zum Lesen
#     units-summary.md Zaehlungen je Paket/Mod und je Fraktion
#
# Laufzeit: je nach Plattengeschwindigkeit einige Minuten
# (mehrere tausend Blueprints).
#
# Doku: ..\16_UNITS.md
# ============================================================================

param(
    [string]$Root   = "C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD",
    [string]$OutDir = ""
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($OutDir)) {
    $OutDir = Join-Path (Split-Path -Parent $PSScriptRoot) 'units'
}

$srcRoot  = Join-Path $Root 'gamedata.entpackt'
$modsRoot = Join-Path $Root 'usermods'

if (-not (Test-Path $srcRoot)) {
    Write-Error "Nicht gefunden: $srcRoot`nBitte -Root pruefen."
    return
}
if (-not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
}

Write-Host "Quelle 1: $srcRoot"
Write-Host "Quelle 2: $modsRoot"
Write-Host "Ausgabe : $OutDir"
Write-Host ""

# ---------------------------------------------------------------------------
# Hilfsfunktionen
# ---------------------------------------------------------------------------

function Get-LuaString {
    param([string]$Text, [string]$Key)
    $m = [regex]::Match($Text, "$Key\s*=\s*(['""])(.*?)\1", 'Singleline')
    if ($m.Success) { return $m.Groups[2].Value }
    return ''
}

function Clear-LocPrefix {
    # "<LOC uel0001_name>UEF Commander"  ->  "UEF Commander"
    param([string]$Value)
    return ([regex]::Replace($Value, '^<LOC[^>]*>', '')).Trim()
}

function Get-CategoryBlock {
    param([string]$Text)
    $m = [regex]::Match($Text, "Categories\s*=\s*\{(.*?)\}", 'Singleline')
    if ($m.Success) { return $m.Groups[1].Value.ToUpperInvariant() }
    return ''
}

$factionsByCat = @(
    @{ Cat = 'UEF';       Name = 'UEF' },
    @{ Cat = 'AEON';      Name = 'Aeon' },
    @{ Cat = 'CYBRAN';    Name = 'Cybran' },
    @{ Cat = 'SERAPHIM';  Name = 'Seraphim' },
    @{ Cat = 'NOMADS';    Name = 'Nomads' }
)

# Fallback ueber die ID-Systematik: 2. Zeichen = Fraktion
$factionsById = @{ 'A' = 'Aeon'; 'E' = 'UEF'; 'R' = 'Cybran'; 'S' = 'Seraphim' }
$domainsById  = @{ 'L' = 'Land'; 'A' = 'Air';  'S' = 'Sea';    'B' = 'Structure' }

function Resolve-Faction {
    param([string]$Cats, [string]$FactionName, [string]$UnitId)
    foreach ($f in $factionsByCat) {
        if ($Cats -match "'$($f.Cat)'") { return $f.Name }
    }
    if ($FactionName) { return $FactionName }
    if ($UnitId.Length -ge 2) {
        $c = $UnitId.Substring(1,1).ToUpperInvariant()
        if ($factionsById.ContainsKey($c)) { return $factionsById[$c] }
    }
    return '?'
}

function Resolve-Tech {
    param([string]$Cats, [string]$TechLevel)
    if ($Cats -match "'EXPERIMENTAL'") { return 'EXP' }
    if ($Cats -match "'TECH3'")        { return 'T3' }
    if ($Cats -match "'TECH2'")        { return 'T2' }
    if ($Cats -match "'TECH1'")        { return 'T1' }
    switch ($TechLevel) {
        'RULEUTL_Basic'        { return 'T1' }
        'RULEUTL_Advanced'     { return 'T2' }
        'RULEUTL_Secret'       { return 'T3' }
        'RULEUTL_Experimental' { return 'EXP' }
    }
    return '?'
}

function Resolve-Domain {
    param([string]$Cats, [string]$UnitId)
    if ($Cats -match "'STRUCTURE'") { return 'Structure' }
    if ($Cats -match "'NAVAL'")     { return 'Sea' }
    if ($Cats -match "'AIR'")       { return 'Air' }
    if ($Cats -match "'LAND'")      { return 'Land' }
    if ($UnitId.Length -ge 3) {
        $c = $UnitId.Substring(2,1).ToUpperInvariant()
        if ($domainsById.ContainsKey($c)) { return $domainsById[$c] }
    }
    return '?'
}

function Resolve-Package {
    # Leitet Paket und Mod aus dem Pfad ab.
    #   gamedata.entpackt\<Archiv>\mods\<Mod>\units\<ID>\...   -> Paket=Archiv, Mod=Mod
    #   gamedata.entpackt\<Archiv>\units\<ID>\...              -> Paket=Archiv, Mod=Archiv
    #   usermods\<Mod>\units\<ID>\...                          -> Paket=usermods, Mod=Mod
    param([string]$FullPath, [string]$Base, [string]$BaseLabel)

    $rel   = $FullPath.Substring($Base.Length).TrimStart('\')
    $parts = $rel -split '\\'

    if ($BaseLabel -eq 'usermods') {
        return @{ Paket = 'usermods'; Mod = $parts[0] }
    }
    $paket = $parts[0]
    if ($parts.Length -ge 3 -and $parts[1] -eq 'mods') {
        return @{ Paket = $paket; Mod = $parts[2] }
    }
    return @{ Paket = $paket; Mod = $paket }
}

# ---------------------------------------------------------------------------
# Einsammeln
# ---------------------------------------------------------------------------

$rows = New-Object System.Collections.Generic.List[object]

$sources = @(
    @{ Path = $srcRoot;  Label = 'gamedata' },
    @{ Path = $modsRoot; Label = 'usermods' }
)

foreach ($src in $sources) {

    if (-not (Test-Path $src.Path)) {
        Write-Warning "Uebersprungen (nicht vorhanden): $($src.Path)"
        continue
    }

    Write-Host "Durchsuche $($src.Path) ..."

    $files = Get-ChildItem -LiteralPath $src.Path -Recurse -File -Filter '*_unit.bp' -ErrorAction SilentlyContinue
    Write-Host "  $($files.Count) Blueprints gefunden"

    $i = 0
    foreach ($f in $files) {

        $i++
        if ($i % 250 -eq 0) { Write-Host "  ... $i / $($files.Count)" }

        # ID aus dem Dateinamen: <ID>_unit.bp
        $unitId = $f.Name -replace '_unit\.bp$', ''

        try   { $text = Get-Content -LiteralPath $f.FullName -Raw -ErrorAction Stop }
        catch { Write-Warning "Nicht lesbar: $($f.FullName)"; continue }

        $cats        = Get-CategoryBlock $text
        $factionName = Get-LuaString $text 'FactionName'
        $techLevel   = Get-LuaString $text 'TechLevel'
        $unitName    = Clear-LocPrefix (Get-LuaString $text 'UnitName')
        if (-not $unitName) {
            $unitName = Clear-LocPrefix (Get-LuaString $text 'HelpText')
        }

        $pkg = Resolve-Package -FullPath $f.FullName -Base $src.Path -BaseLabel $src.Label

        $rows.Add([pscustomobject]@{
            Paket    = $pkg.Paket
            Mod      = $pkg.Mod
            UnitID   = $unitId
            Fraktion = Resolve-Faction -Cats $cats -FactionName $factionName -UnitId $unitId
            Tech     = Resolve-Tech    -Cats $cats -TechLevel   $techLevel
            Domaene  = Resolve-Domain  -Cats $cats -UnitId      $unitId
            Name     = $unitName
            Datei    = $f.FullName
        })
    }
}

Write-Host ""
Write-Host "Gesamt: $($rows.Count) Einheiten"

# ---------------------------------------------------------------------------
# Ausgabe
# ---------------------------------------------------------------------------

$sorted = $rows | Sort-Object Paket, Mod, Fraktion, Tech, UnitID

# --- CSV ---
$csvPath = Join-Path $OutDir 'units.csv'
$sorted | Export-Csv -LiteralPath $csvPath -Delimiter ';' -NoTypeInformation -Encoding UTF8
Write-Host "geschrieben: $csvPath"

# --- Markdown, nach Paket/Mod gruppiert ---
$mdPath = Join-Path $OutDir 'units.md'
$sb = New-Object System.Text.StringBuilder

[void]$sb.AppendLine('# Einheitenliste (generiert)')
[void]$sb.AppendLine()
[void]$sb.AppendLine("Erzeugt am $(Get-Date -Format 'yyyy-MM-dd HH:mm') durch ``tools\Get-Units.ps1``.")
[void]$sb.AppendLine('**Nicht von Hand bearbeiten** - bei Aenderungen das Skript neu laufen lassen.')
[void]$sb.AppendLine()
[void]$sb.AppendLine("Gesamt: **$($rows.Count)** Einheiten.")
[void]$sb.AppendLine()

foreach ($grp in ($sorted | Group-Object Paket, Mod)) {
    $first = $grp.Group[0]
    [void]$sb.AppendLine("## $($first.Paket) / $($first.Mod)  ($($grp.Count))")
    [void]$sb.AppendLine()
    [void]$sb.AppendLine('| Unit-ID | Fraktion | Tech | Domaene | Name |')
    [void]$sb.AppendLine('|---|---|---|---|---|')
    foreach ($r in $grp.Group) {
        $n = $r.Name -replace '\|', '\|'
        [void]$sb.AppendLine("| ``$($r.UnitID)`` | $($r.Fraktion) | $($r.Tech) | $($r.Domaene) | $n |")
    }
    [void]$sb.AppendLine()
}

Set-Content -LiteralPath $mdPath -Value $sb.ToString() -Encoding UTF8
Write-Host "geschrieben: $mdPath"

# --- Zusammenfassung ---
$sumPath = Join-Path $OutDir 'units-summary.md'
$sb2 = New-Object System.Text.StringBuilder

[void]$sb2.AppendLine('# Einheitenliste - Zusammenfassung (generiert)')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine("Erzeugt am $(Get-Date -Format 'yyyy-MM-dd HH:mm'). Gesamt: **$($rows.Count)** Einheiten.")
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('## Je Paket und Mod')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('| Paket | Mod | Einheiten |')
[void]$sb2.AppendLine('|---|---|---:|')
foreach ($grp in ($sorted | Group-Object Paket, Mod | Sort-Object Count -Descending)) {
    $first = $grp.Group[0]
    [void]$sb2.AppendLine("| $($first.Paket) | $($first.Mod) | $($grp.Count) |")
}
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('## Je Fraktion')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('| Fraktion | Einheiten |')
[void]$sb2.AppendLine('|---|---:|')
foreach ($grp in ($sorted | Group-Object Fraktion | Sort-Object Count -Descending)) {
    [void]$sb2.AppendLine("| $($grp.Name) | $($grp.Count) |")
}
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('## Je Techstufe')
[void]$sb2.AppendLine()
[void]$sb2.AppendLine('| Tech | Einheiten |')
[void]$sb2.AppendLine('|---|---:|')
foreach ($grp in ($sorted | Group-Object Tech | Sort-Object Count -Descending)) {
    [void]$sb2.AppendLine("| $($grp.Name) | $($grp.Count) |")
}

Set-Content -LiteralPath $sumPath -Value $sb2.ToString() -Encoding UTF8
Write-Host "geschrieben: $sumPath"

Write-Host ""
Write-Host "Fertig."
