# Yathsou-Gruppen gegen T2-U-Boote (und Exodus als Referenz) bei gleicher Masse. Siehe README.md.
# Aufruf:  & '.\Run-NavySim.ps1' [-Runs 200] [-PHit 1.0] [-Only Vesper,Exodus] [-BreakEven] [-NoTable]
#   -PHit       Trefferchance eines Abwehrwerfer-Schusses (nur Uashavoh, Exodus); ungeprueft, daher Parameter
#   -BreakEven  sucht je Yathsou-Anzahl die Gegnerzahl, ab der die Yathsou hoechstens die Haelfte der Laeufe gewinnen
param([int]$Runs = 200, [double]$PHit = 1.0, [string[]]$Only = @(), [switch]$BreakEven, [switch]$NoTable)
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not ('NavySim' -as [type])) { Add-Type -Path (Join-Path $here 'NavySim.cs') }

function New-Type($h) { $u = New-Object UnitType; foreach ($k in $h.Keys) { $u.$k = $h[$k] }; $u }

# Werte: LOUD gamedata\units.scd / brewlan.scd / projectiles.scd, Stand 2026-10-25; Yathsou mit NavyRebalance (Flak weg,
# Sonar-Tarnung aus - in der Simulation ohne Wirkung). Cycle = Salventakt nach LOUD-PhxLib.
$yathsou  = New-Type @{ Name='XSS0304 Yathsou'; Hp=4000; Regen=6; Speed=3.8; Mass=3950; Range=64; Damage=450; Salvo=7; SalvoDelay=0.3; Cycle=6.0; V0=5.5; Accel=5; VMax=18; Lifetime=7.2; Fields=2; FieldCooldown=1.0; FieldRadius=3.3 }
$vesper   = New-Type @{ Name='XAS0204 Vesper'; Hp=1650; Regen=3; Speed=3.5; Mass=1080; Range=48; Damage=300; Salvo=4; SalvoDelay=0.7; Cycle=5.0; V0=4; Accel=3; VMax=12; Lifetime=6.5; Fields=1; FieldCooldown=0.9 }
$barracuda= New-Type @{ Name='XRS0204 Barracuda'; Hp=1650; Regen=5; Speed=3.6; Mass=1200; Range=48; Damage=220; Salvo=5; SalvoDelay=0.3; Cycle=5.0; V0=4; Accel=3; VMax=12; Lifetime=7.0; Fields=1; FieldCooldown=1.0 }
$cochrane = New-Type @{ Name='SES0204 Cochrane'; Hp=1850; Regen=3; Speed=3.5; Mass=1200; Range=48; Damage=345; Salvo=4; SalvoDelay=0.4; Cycle=5.0; V0=3; Accel=3; VMax=12; Lifetime=6.5; Fields=1; FieldCooldown=1.0 }
$uashavoh = New-Type @{ Name='XSS0201 Uashavoh (getaucht)'; Hp=7000; Regen=6; Speed=4; Mass=2450; Range=44; Damage=250; Salvo=4; SalvoDelay=0.6; Cycle=5.0; V0=3.4; Accel=2.6; VMax=12; Lifetime=7.5; Fields=0; FieldCooldown=1; Launchers=[double[]]@(1.4); LauncherMin=6; LauncherMax=24 }
$exodus   = New-Type @{ Name='UAS0201 Exodus (Referenz)'; Hp=7650; Regen=5; Speed=4; Mass=2140; Range=40; Damage=200; Salvo=4; SalvoDelay=0.9; Cycle=7.0; V0=4; Accel=3; VMax=12; Lifetime=6.0; Fields=0; FieldCooldown=1; Launchers=[double[]]@(2.0,2.0,1.5); LauncherMin=6; LauncherMax=28 }

$opponents = @($vesper, $barracuda, $cochrane, $uashavoh, $exodus) | Where-Object { $o = $_; -not $Only.Count -or ($Only | Where-Object { $o.Name -like "*$_*" }) }

if (-not $NoTable) {
    $rows = foreach ($opp in $opponents) {
        foreach ($n in 1, 2, 4, 8, 16) {
            $m = [math]::Max(1, [math]::Round($n * $yathsou.Mass / $opp.Mass))
            $res = for ($i = 0; $i -lt $Runs; $i++) { [NavySim]::Run($yathsou, $n, $opp, $m, $PHit, 1000 + $i, 90, 600) }
            [pscustomobject]@{
                Gegner = $opp.Name; PHit = $PHit; Yathsou = $n; Anzahl = $m; Masseverh = '{0:N2}' -f ($m * $opp.Mass / ($n * $yathsou.Mass))
                YSiegProz = [math]::Round(100 * @($res | Where-Object AWins).Count / $Runs)
                YUebrig = '{0:N1}' -f ($res | Measure-Object ASurv -Average).Average
                GUebrig = '{0:N1}' -f ($res | Measure-Object BSurv -Average).Average
                GTotVorErstemSchuss = '{0:N1}' -f ($res | Measure-Object BDeadBeforeBFirstShot -Average).Average
                YMasseVerlust = [math]::Round(($res | Measure-Object AMassLost -Average).Average)
                GMasseVerlust = [math]::Round(($res | Measure-Object BMassLost -Average).Average)
                Dauer = '{0:N0}' -f ($res | Measure-Object Time -Average).Average
            }
        }
    }
    $rows | Format-Table -AutoSize | Out-String -Width 250
}

if ($BreakEven) {
    $be = foreach ($opp in $opponents) {
        foreach ($n in 1, 2, 4, 8, 16) {
            $m = [math]::Max(1, [math]::Floor(0.4 * $n * $yathsou.Mass / $opp.Mass))
            while ($true) {
                $res = for ($i = 0; $i -lt $Runs; $i++) { [NavySim]::Run($yathsou, $n, $opp, $m, $PHit, 5000 + $i, 90, 600) }
                $win = @($res | Where-Object AWins).Count / $Runs
                if ($win -le 0.5 -or $m -gt 20 * $n) { break }
                $m++
            }
            [pscustomobject]@{ Gegner = $opp.Name; PHit = $PHit; Yathsou = $n; GegnerNoetig = $m; MasseNoetig = '{0:N2}' -f ($m * $opp.Mass / ($n * $yathsou.Mass)); YSiegProz = [math]::Round(100 * $win) }
        }
    }
    $be | Format-Table -AutoSize | Out-String -Width 250
}
