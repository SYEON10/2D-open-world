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
$importOutput = & $GodotBin --headless --path $projectRoot --import 2>&1
$importCode = $LASTEXITCODE
$importOutput | Write-Output
if ($importCode -ne 0) { exit $importCode }
if ($importOutput -match 'SCRIPT ERROR:|Failed to load script|Failed to create an autoload') {
    throw 'Godot import reported script or autoload errors.'
}

$dataOutput = & $GodotBin --headless --path $projectRoot --script res://scripts/tools/validate_project.gd 2>&1
$dataCode = $LASTEXITCODE
$dataOutput | Write-Output
if ($dataCode -ne 0) { exit $dataCode }
if ($dataOutput -match 'SCRIPT ERROR:|Failed to load script') {
    throw 'Godot data validation reported script errors.'
}

$movementOutput = & $GodotBin --headless --path $projectRoot --script res://scripts/tools/verify_cube_movement.gd 2>&1
$movementCode = $LASTEXITCODE
$movementOutput | Write-Output
if ($movementCode -ne 0) { exit $movementCode }
if ($movementOutput -match 'SCRIPT ERROR:|Failed to load script') {
    throw 'Godot movement validation reported script errors.'
}
