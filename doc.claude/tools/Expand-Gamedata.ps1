# ============================================================================
# Expand-Gamedata.ps1  -  .scd-Archive in einen Spiegelordner entpacken
#
# Erzeugt neben gamedata\ einen Ordner gamedata.entpackt\ mit je einem
# Unterordner pro .scd-Archiv - so wie er fuer LOUD bereits vorliegt.
#
# .scd-Dateien sind gewoehnliche ZIP-Archive; sie werden nur kopiert und
# umbenannt, das Original bleibt unangetastet.
#
# Aufruf (PowerShell, im tools-Ordner):
#     .\Expand-Gamedata.ps1                  # Basisspiel
#     .\Expand-Gamedata.ps1 -Ziel LOUD       # LOUD neu erzeugen
#
# Optional:
#     .\Expand-Gamedata.ps1 -Quelle "D:\Pfad\zu\gamedata" -OutDir "D:\temp\entpackt"
#     .\Expand-Gamedata.ps1 -Ueberschreiben  # vorhandene Ordner ersetzen
#
# WARUM: gamedata.entpackt spiegelt bisher nur LOUDs eigene Archive. Die
# Archive des Basisspiels (effects.scd, props.scd, env.scd, textures.scd,
# meshes.scd, projectiles.scd) werden von LoudDataPath.lua ZUSAETZLICH nach '/'
# gemountet, sind aber gepackt - dadurch liessen sich Verweise wie
# '/effects/emitters/seraphim_rift_arch_base_01_emit.bp' oder
# '/props/DefaultWreckage/DefaultWreckage_prop.bp' bisher nicht nachpruefen.
#
# ACHTUNG: Schreibt unterhalb von "Program Files (x86)". Falls die Rechte
# fehlen, PowerShell als Administrator starten oder -OutDir auf einen
# beschreibbaren Pfad legen.
#
# Doku: ..\11_DATAPATH.md, ..\14_TOOLS.md
# ============================================================================

param(
    [ValidateSet('Basisspiel','LOUD')]
    [string]$Ziel = 'Basisspiel',

    [string]$Quelle = "",
    [string]$OutDir = "",

    [switch]$Ueberschreiben
)

$ErrorActionPreference = 'Stop'

$Basis = "C:\Program Files (x86)\Steam\steamapps\common\Supreme Commander Forged Alliance"

if ([string]::IsNullOrWhiteSpace($Quelle)) {
    if ($Ziel -eq 'LOUD') {
        $Quelle = Join-Path $Basis 'LOUD\gamedata'
    } else {
        $Quelle = Join-Path $Basis 'gamedata'
    }
}

if ([string]::IsNullOrWhiteSpace($OutDir)) {
    $OutDir = Join-Path (Split-Path -Parent $Quelle) 'gamedata.entpackt'
}

if (-not (Test-Path $Quelle)) {
    Write-Error "Nicht gefunden: $Quelle`nBitte -Quelle pruefen."
    return
}

Add-Type -AssemblyName System.IO.Compression.FileSystem

$archive = Get-ChildItem -Path $Quelle -Filter *.scd -File | Sort-Object Name

if ($archive.Count -eq 0) {
    Write-Error "Keine .scd-Dateien in $Quelle gefunden."
    return
}

Write-Host ""
Write-Host "Quelle : $Quelle"
Write-Host "Ziel   : $OutDir"
Write-Host "Archive: $($archive.Count)"
Write-Host ""

if (-not (Test-Path $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
}

$temp = Join-Path $env:TEMP ("scd_entpacken_" + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $temp -Force | Out-Null

$entpackt   = 0
$uebersprungen = 0
$fehler     = @()

try {
    foreach ($a in $archive) {

        $name = [System.IO.Path]::GetFileNameWithoutExtension($a.Name)
        $zielOrdner = Join-Path $OutDir $name

        if ((Test-Path $zielOrdner) -and (-not $Ueberschreiben)) {
            Write-Host ("  [uebersprungen] {0,-28} Ordner existiert bereits" -f $name)
            $uebersprungen++
            continue
        }

        Write-Host ("  [entpacke]      {0,-28} {1,10:N1} MB" -f $name, ($a.Length / 1MB))

        # .scd ist ein ZIP - fuer ExtractToDirectory braucht es die Endung .zip.
        # Kopie im TEMP, damit die Originaldatei unangetastet bleibt.
        $zipKopie = Join-Path $temp ($name + '.zip')

        try {
            Copy-Item -LiteralPath $a.FullName -Destination $zipKopie -Force

            if ((Test-Path $zielOrdner) -and $Ueberschreiben) {
                Remove-Item -LiteralPath $zielOrdner -Recurse -Force
            }

            [System.IO.Compression.ZipFile]::ExtractToDirectory($zipKopie, $zielOrdner)
            $entpackt++
        }
        catch {
            Write-Host ("                  FEHLER: {0}" -f $_.Exception.Message) -ForegroundColor Red
            $fehler += ("{0}: {1}" -f $name, $_.Exception.Message)
        }
        finally {
            if (Test-Path $zipKopie) { Remove-Item -LiteralPath $zipKopie -Force }
        }
    }
}
finally {
    if (Test-Path $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
}

Write-Host ""
Write-Host "Fertig. Entpackt: $entpackt   Uebersprungen: $uebersprungen   Fehler: $($fehler.Count)"

if ($fehler.Count -gt 0) {
    Write-Host ""
    Write-Host "Fehler im Einzelnen:" -ForegroundColor Red
    $fehler | ForEach-Object { Write-Host ("  " + $_) -ForegroundColor Red }
}

Write-Host ""
Write-Host "Hinweis: der Spiegel wird NICHT automatisch aktuell gehalten."
Write-Host "Nach einem Spiel- oder LOUD-Update erneut mit -Ueberschreiben laufen lassen."
Write-Host ""
