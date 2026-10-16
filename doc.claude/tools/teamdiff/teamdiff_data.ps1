param([string]$FA, [string]$Out)
# Sammelt pro Mod und Einheit die Felder, die sich zwischen Original (LOUD), Colin
# (UEF_trans_men) und Aktuell (unser Mod, Merge angewendet) unterscheiden. Ausgabe JSON.
Set-Location -LiteralPath $FA
$enc = [Text.Encoding]::GetEncoding(28591)

function Strip([string]$line) {
    $out = New-Object System.Text.StringBuilder; $q = $null
    for ($i = 0; $i -lt $line.Length; $i++) {
        $c = $line[$i]
        if ($q) { if ($c -eq $q) { $q = $null }; [void]$out.Append(' '); continue }
        if ($c -eq "'" -or $c -eq '"') { $q = $c; [void]$out.Append(' '); continue }
        if ($c -eq '-' -and $i + 1 -lt $line.Length -and $line[$i+1] -eq '-') { break }
        if ($c -eq '#') { break }
        [void]$out.Append($c)
    }
    $out.ToString()
}

function Parse([string]$file) {
    $map = [ordered]@{}
    if (-not $file -or -not (Test-Path -LiteralPath $file)) { return $null }
    $stack = New-Object System.Collections.ArrayList
    $lines = $enc.GetString([IO.File]::ReadAllBytes($file)) -split "`r?`n"
    foreach ($raw in $lines) {
        $code = Strip $raw
        $opens = ([regex]::Matches($code, '\{')).Count
        $closes = ([regex]::Matches($code, '\}')).Count
        $path = ($stack | ForEach-Object { $_.Name }) -join '.'
        if ($raw -match '^\s*\{\s*\}\s*,?\s*(--.*)?$') {           # Platzhalter in Merge-Listen
            if ($stack.Count) { $stack[$stack.Count - 1].ListIdx++ }; continue
        }
        if ($opens -gt $closes) {
            if ($raw -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*[A-Za-z_]*\s*\{') { $name = $Matches[1] }
            elseif ($raw -match '^\s*UnitBlueprint\s*\{') { $name = 'ROOT' }
            elseif ($raw -match '^\s*\{') { $parent = $stack[$stack.Count - 1]; $parent.ListIdx++; $name = '[' + $parent.ListIdx + ']' }
            else { $name = '?' }
            [void]$stack.Add(@{ Name = $name; ListIdx = 0 })
            for ($k = 1; $k -lt ($opens - $closes); $k++) { [void]$stack.Add(@{ Name = '?'; ListIdx = 0 }) }
            continue
        }
        if ($closes -gt $opens) {
            for ($k = 0; $k -lt ($closes - $opens); $k++) { if ($stack.Count) { $stack.RemoveAt($stack.Count - 1) } }
            continue
        }
        if ($raw -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*\{([^{}]*=[^{}]*)\}\s*,?\s*(--.*)?$') {
            $tk = $Matches[1]
            foreach ($part in ($Matches[2] -split ',')) { if ($part -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?)\s*$') { $map["$path.$tk.$($Matches[1])"] = $Matches[2] } }
        } elseif ($raw -match '^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?)\s*,?\s*(--.*)?$') {
            $map["$path.$($Matches[1])"] = $Matches[2].TrimEnd(',').Trim()
        } elseif ($raw -match "^\s*(['""][^'""]+['""]\s*,?\s*)+(--.*)?$") {   # Listeneintraege (Kategorien)
            foreach ($m in [regex]::Matches($raw, "['""]([^'""]+)['""]")) {
                $k = "$path.#"
                if ($map.Contains($k)) { $map[$k] = $map[$k] + '|' + $m.Groups[1].Value } else { $map[$k] = $m.Groups[1].Value }
            }
        }
    }
    $map
}

function Norm($v) {
    if ($null -eq $v) { return $null }
    $s = ($v -replace "'", '"') -replace '\s+', ' '
    $s = [regex]::Replace($s, '(?i)/mods/[^/]+/', '/mods/~/')
    if ($s -match '\|') { $s = (($s -split '\|') | Sort-Object -Unique) -join '|' }
    $s.Trim().ToLower()
}

# Originale finden
$srcDirs = @{}
Get-ChildItem 'LOUD\gamedata.entpackt' -Recurse -Directory | Where-Object { $_.FullName -notmatch '\\hook\\' } | ForEach-Object {
    $id = $_.Name.ToUpper()
    if (Test-Path -LiteralPath (Join-Path $_.FullName "$($_.Name)_unit.bp")) {
        if (-not $srcDirs.ContainsKey($id) -or $_.FullName -match '\\units\\units\\') { $srcDirs[$id] = $_.FullName }
    }
}
$root = (Resolve-Path 'LOUD\gamedata.entpackt').Path

function WName($w, $maps) { foreach ($mp in $maps) { if ($mp -and $mp["ROOT.Weapon.[$w].DisplayName"]) { return [string]$mp["ROOT.Weapon.[$w].DisplayName"] } }; return $null }
function Bp($dir) { if (-not $dir) { return $null }; $f = Get-ChildItem -LiteralPath $dir -Filter '*_unit.bp' -ErrorAction SilentlyContinue | Select-Object -First 1; if ($f) { $f.FullName } }
function NameOf($m) {
    if (-not $m) { return '' }
    $n = $m['ROOT.General.UnitName']; $d = $m['ROOT.Description']
    $clean = { param($x) if ($x) { ($x -replace '<LOC[^>]*>', '').Trim(' ', "'", '"') } }
    $a = (& $clean $n); $b = (& $clean $d)
    ,@([string]$a, [string]$b)
}

$hidePat = '^ROOT\.(Audio|Interface|Display\.(?!Abilities)|.*\.Audio\.|.*Bone|.*\.RackBones|.*Effects?\.|.*\.Fx|LOD)'
$mods = 'T4UnitAdditions','AirForceRebalance','NavyRebalance','TacticalMissileUpgrades','DynamicGameplay','SquareShields','ImprovedHydrocarbonPowerPlants','T4MassExtractors'
$result = @()
foreach ($mod in $mods) {
    $units = @()
    foreach ($ud in (Get-ChildItem "LOUD\usermods\$mod\units" -Directory)) {
        $id = $ud.Name.ToUpper()
        $curF = Bp $ud.FullName
        $isMerge = Select-String -LiteralPath $curF -Pattern 'Merge\s*=\s*true' -Quiet
        $oDir = $srcDirs[$id]
        $o = Parse (Bp $oDir)
        $c = Parse (Bp "LOUD\usermods\doc.claude\_Altlasten\UEF_trans_men\units\$id")
        $n = Parse $curF
        if ($isMerge -and $o) { $m2 = [ordered]@{}; foreach ($k in $o.Keys) { $m2[$k] = $o[$k] }; foreach ($k in $n.Keys) { if ($k -notmatch '\.(Merge|BlueprintId)$') { $m2[$k] = $n[$k] } }; $n = $m2 }
        if ($mod -eq 'ImprovedHydrocarbonPowerPlants') {
            $t2 = $id -match '1202$'
            $n['ROOT.Adjacency'] = $(if ($t2) { 'T2PowerGeneratorAdjacencyBuffs' } else { 'T3PowerGeneratorAdjacencyBuffs' }) + ' (Hook)'
            $n['ROOT.Defense.RegenRate'] = $(if ($t2) { '2' } else { '4' }) + ' (Hook, einstellbar)'
            if ($t2) { $n['ROOT.Economy.StorageEnergy'] = '200 (Hook)' }
        }
        if ($mod -eq 'NavyRebalance' -and $id -eq 'XSS0304') {   # Flak per Hook entfernt (hook\lua\system\Blueprints.lua)
            foreach ($k in @($n.Keys)) { if ($k -like 'ROOT.Weapon.`[2`].*') { $n.Remove($k) } }
            if ($n.Contains('ROOT.Display.Abilities.#')) { $n['ROOT.Display.Abilities.#'] = (($n['ROOT.Display.Abilities.#'] -split '\|') | Where-Object { $_ -ne '<LOC ability_aa>Anti-Air' }) -join '|' }
        }
        $names = NameOf $(if ($n) { $n } elseif ($c) { $c } else { $o })
        $keys = New-Object System.Collections.Generic.List[string]
        foreach ($mp in @($o, $c, $n)) { if ($mp) { foreach ($k in $mp.Keys) { if (-not $keys.Contains($k)) { $keys.Add($k) } } } }
        # Waffen, die in einer Spalte ganz fehlen
        $wPres = @{}
        foreach ($pair in @(@('o', $o), @('c', $c), @('n', $n))) {
            $set = @{}; if ($pair[1]) { foreach ($k in $pair[1].Keys) { if ($k -match '^ROOT\.Weapon\.\[(\d+)\]') { $set[$Matches[1]] = 1 } } }
            $wPres[$pair[0]] = $set
        }
        $rows = @(); $hidden = 0; $doneW = @{}
        foreach ($k in $keys) {
            $vo = if ($o) { $o[$k] } else { $null }; $vc = if ($c) { $c[$k] } else { $null }; $vn = if ($n) { $n[$k] } else { $null }
            $no = Norm $vo; $nc = Norm $vc; $nn = Norm $vn
            if ($no -eq $nc -and $nc -eq $nn) { continue }
            if (-not $c -and $no -eq $nn) { continue }
            if (-not $o -and $nc -eq $nn) { continue }
            if ($k -match '^ROOT\.Weapon\.\[(\d+)\]') {
                $w = $Matches[1]
                $inAll = @('o','c','n' | Where-Object { ($_ -eq 'o' -and -not $o) -or ($_ -eq 'c' -and -not $c) -or $wPres[$_].ContainsKey($w) }).Count -eq 3
                if (-not $inAll) {
                    if (-not $doneW[$w]) {
                        $doneW[$w] = 1
                        $lbl = WName $w @($o, $c, $n)
                        $rows += [ordered]@{ k = "ROOT.Weapon.[$w].#vorhanden"; label = $lbl
                            o = $(if (-not $o) { $null } elseif ($wPres.o.ContainsKey($w)) { 'vorhanden' } else { 'fehlt' })
                            c = $(if (-not $c) { $null } elseif ($wPres.c.ContainsKey($w)) { 'vorhanden' } else { 'entfernt' })
                            n = $(if ($wPres.n.ContainsKey($w)) { 'vorhanden' } else { 'entfernt' }) }
                    }
                    continue
                }
            }
            if ($k -match $hidePat -or $k -match '\.(Mesh\w*|ImpactMesh|ImpactEffects|Animation\w*|MeshBlueprint|Bones?|Bank|Cue|Lod\w*|SoundEffects?|UniformScale|IconFadeInZoom|BuildIconSortPriority|StrategicIconSortPriority|SelectionPriority)$') { $hidden++; continue }
            $lbl = $null
            if ($k -match '^ROOT\.Weapon\.\[(\d+)\]') { $w = $Matches[1]; $lbl = WName $w @($o, $c, $n) }
            $rows += [ordered]@{ k = $k; label = $lbl
                o = $(if (-not $o) { $null } elseif ($null -eq $vo) { '(fehlt)' } else { $vo })
                c = $(if (-not $c) { $null } elseif ($null -eq $vc) { if ($null -ne $vo) { '(entfernt)' } else { '(fehlt)' } } else { $vc })
                n = $(if ($null -eq $vn) { if ($null -ne $vo -or $null -ne $vc) { '(entfernt)' } else { '(fehlt)' } } else { $vn }) }
        }
        if (-not $o) {
            foreach ($k in 'ROOT.Economy.BuildCostMass','ROOT.Economy.BuildCostEnergy','ROOT.Economy.BuildTime','ROOT.Defense.MaxHealth','ROOT.Economy.ProductionPerSecondMass','ROOT.Economy.ProductionPerSecondEnergy','ROOT.Economy.MaintenanceConsumptionPerSecondEnergy','ROOT.Economy.StorageMass','ROOT.Economy.StorageEnergy','ROOT.Physics.MaxSpeed') {
                $src = if ($n) { $n } else { $c }
                if ($src -and $src.Contains($k)) { $rows += [ordered]@{ k = $k; label = $null; o = $null; c = $(if ($c) { $c[$k] } else { $null }); n = $src[$k] } }
            }
        }
        $units += [ordered]@{
            id = $id; name = $names[0]; desc = $names[1]
            kind = $(if ($isMerge) { 'Merge' } else { 'Kopie' })
            src = $(if ($oDir) { $oDir.Substring($root.Length + 1) } else { $null })
            colin = [bool]$c; rows = $rows; hidden = $hidden }
    }
    $result += [ordered]@{ mod = $mod; units = $units }
}
$result | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $Out -Encoding UTF8
"ok: " + ($result | ForEach-Object { "$($_.mod)=$(@($_.units).Count)" }) -join ' '
