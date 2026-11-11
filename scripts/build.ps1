# Bien dich cac lop model + dao vao WebContent/WEB-INF/classes
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$out  = Join-Path $root "WebContent\WEB-INF\classes"
if (Test-Path $out) { Remove-Item -Recurse -Force $out }
New-Item -ItemType Directory -Force $out | Out-Null

$sources = Get-ChildItem -Recurse (Join-Path $root "src") -Filter *.java | ForEach-Object { $_.FullName }
& javac -encoding UTF-8 -d $out $sources
if ($LASTEXITCODE -ne 0) { throw "Bien dich that bai" }

# Chep file cau hinh ket noi CSDL vao classpath
$cfg = Join-Path $root "src\db.properties"
if (Test-Path $cfg) {
    Copy-Item $cfg $out
} else {
    Write-Warning "Chua co src\db.properties. Hay sao chep src\db.properties.example thanh src\db.properties va sua user/password MySQL."
}
Write-Host "Bien dich thanh cong -> $out"
