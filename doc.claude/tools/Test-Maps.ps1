# ============================================================================
# Test-Maps.ps1  -  Kartenordner auf fehlende Dateien pruefen
#
# Liest jede *_scenario.lua in LOUD\maps\ und LOUD\usermaps\, zieht die darin
# angegebenen Pfade heraus (map, save, script) und prueft, ob die Dateien
# tatsaechlich existieren.
#
# Aufruf (PowerShell, im tools-Ordner):
#     .\Test-Maps.ps1              # beide Ordner
#     .\Test-Maps.ps1 -NurFehler   # nur die auffaelligen Karten
#     .\Test-Maps.ps1 -Ordner maps
#
# WARUM: LOUD prueft beim Laden der Kartenauswahl mit
# IsScenarioPlayable() (gamedata\lua\lua\ui\maputil.lua), ob save-Datei und
# armies-Tabelle vorhanden sind, und wirft unvollstaendige Karten aus der Liste.
# Die Warnung nennt die Karte aber NIE beim Namen:
#
#     local mapName = 'Unknown' or scenario.name      -- Z. 92 und 98
#
# 'Unknown' ist immer wahr, der or-Zweig greift nie. Im Log steht deshalb nur
# "Map Unknown is missing a save file!". Dieses Skript schliesst die Luecke.
# Siehe doc.claude\mods\BasegameBugfixes.md, Fundstelle B-02.
#
# Nur lesend. Aendert nichts.
#
# Doku: ..\14_TOOLS.md
# ============================================================================

param(
    [ValidateSet('beide','maps','usermaps')]
    [string]$Ordner = 'beide',

    [string]$Basis = "C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance\LOUD",

    [switch]$NurFehler
)

$ErrorActionPreference = 'Stop'

$quellen = @()

if ($Ordner -eq 'beide' -or $Ordner -eq 'maps') {
    $quellen += [pscustomobject]@{ Name = 'maps';     Pfad = Join-Path $Basis 'maps' }
}
if ($Ordner -eq 'beide' -or $Ordner -eq 'usermaps') {
    $quellen += [pscustomobject]@{ Name = 'usermaps'; Pfad = Join-Path $Basis 'usermaps' }
}

# Die Szenariodateien enthalten VFS-Pfade der Form '/maps/<Ordner>/<Datei>'.
# Beide Verzeichnisse werden ins VFS nach /maps/ gemountet, deshalb muss beim
# Aufloesen in beiden gesucht werden.
$wurzeln = @(
    (Join-Path $Basis 'maps'),
    (Join-Path $Basis 'usermaps')
) | Where-Object { Test-Path $_ }


function Resolve-VfsPfad {
    param([string]$VfsPfad)

    if ([string]::IsNullOrWhiteSpace($VfsPfad)) { return $null }

    # '/maps/Foo/Bar.lua'  ->  'Foo\Bar.lua'
    $rel = $VfsPfad -replace '^/+', '' -replace '^maps/', '' -replace '/', '\'

    foreach ($w in $wurzeln) {
        $kandidat = Join-Path $w $rel
        if (Test-Path -LiteralPath $kandidat) { return $kandidat }
    }

    return $null
}


$gesamt   = 0
$fehler   = 0
$ergebnis = @()

foreach ($q in $quellen) {

    if (-not (Test-Path $q.Pfad)) {
        Write-Host "  uebersprungen: $($q.Pfad) existiert nicht" -ForegroundColor Yellow
        continue
    }

    Write-Host ""
    Write-Host "=== $($q.Name) : $($q.Pfad)" -ForegroundColor Cyan
    Write-Host ""

    $szenarien = Get-ChildItem -Path $q.Pfad -Filter *_scenario.lua -Recurse -File |
                 Sort-Object FullName

    foreach ($s in $szenarien) {

        $gesamt++

        $text = Get-Content -LiteralPath $s.FullName -Raw -ErrorAction SilentlyContinue

        if (-not $text) {
            $ergebnis += [pscustomobject]@{
                Quelle = $q.Name; Datei = $s.Name; Name = '?'; Problem = 'Datei nicht lesbar'
            }
            $fehler++
            continue
        }

        # name = "..."   bzw.  name = '...'
        $kartenname = if ($text -match "(?m)^\s*name\s*=\s*[`"']([^`"']*)[`"']") { $Matches[1] } else { '(kein name)' }

        $probleme = @()

        foreach ($feld in 'map','save','script') {

            if ($text -match "(?m)^\s*$feld\s*=\s*[`"']([^`"']*)[`"']") {

                $vfs = $Matches[1]

                if (-not (Resolve-VfsPfad $vfs)) {
                    $probleme += "$feld fehlt -> $vfs"
                }
            }
            else {
                $probleme += "$feld nicht angegeben"
            }
        }

        # LOUD prueft zusaetzlich auf die armies-Tabelle
        if ($text -notmatch 'armies') {
            $probleme += 'keine armies-Tabelle'
        }

        if ($probleme.Count -gt 0) {

            $fehler++

            $ergebnis += [pscustomobject]@{
                Quelle  = $q.Name
                Datei   = $s.Name
                Name    = $kartenname
                Problem = ($probleme -join '; ')
            }

            Write-Host ("  [FEHLER] {0,-45} {1}" -f $kartenname, ($probleme -join '; ')) -ForegroundColor Red
            Write-Host ("           {0}" -f $s.FullName) -ForegroundColor DarkGray
        }
        elseif (-not $NurFehler) {
            Write-Host ("  [ok]     {0,-45} {1}" -f $kartenname, $s.Name)
        }
    }
}

Write-Host ""
Write-Host ("Geprueft: {0} Szenarien   Auffaellig: {1}" -f $gesamt, $fehler)

if ($fehler -gt 0) {
    Write-Host ""
    Write-Host "Zusammenfassung:" -ForegroundColor Red
    $ergebnis | Format-Table Quelle, Name, Problem, Datei -AutoSize
    Write-Host "Diese Karten erscheinen NICHT in der Kartenauswahl."
}
else {
    Write-Host "Keine Auffaelligkeiten - alle Szenarien vollstaendig."
}

Write-Host ""
