param(
    [string]$GodotBin = $env:GODOT_BIN
)

$ErrorActionPreference = 'Stop'
if (-not $GodotBin -or -not (Test-Path -LiteralPath $GodotBin)) {
    throw 'Set GODOT_BIN to the Godot console executable path.'
}

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$localGodotRoot = Join-Path $projectRoot '.local_godot'
$env:APPDATA = Join-Path $localGodotRoot 'Roaming'
$env:LOCALAPPDATA = Join-Path $localGodotRoot 'Local'
New-Item -ItemType Directory -Force -Path $env:APPDATA, $env:LOCALAPPDATA | Out-Null
& $GodotBin --headless --path $projectRoot --import
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& $GodotBin --headless --path $projectRoot --script res://scripts/tools/validate_project.gd
exit $LASTEXITCODE
