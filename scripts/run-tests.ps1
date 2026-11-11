# Bien dich va chay kiem thu don vi JUnit (can CSDL ShopManDB da duoc tao tu database/shopman6_db.sql)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
& (Join-Path $PSScriptRoot "build.ps1")

$classes  = Join-Path $root "WebContent\WEB-INF\classes"
$testOut  = Join-Path $root "build\test-classes"
New-Item -ItemType Directory -Force $testOut | Out-Null

$jars = @(Get-ChildItem (Join-Path $root "lib") -Filter *.jar) + @(Get-ChildItem (Join-Path $root "WebContent\WEB-INF\lib") -Filter *.jar)
$cp = (@($classes, $testOut) + ($jars | ForEach-Object { $_.FullName })) -join ";"

$tests = Get-ChildItem -Recurse (Join-Path $root "test") -Filter *.java
& javac -encoding UTF-8 -cp $cp -d $testOut ($tests | ForEach-Object { $_.FullName })
if ($LASTEXITCODE -ne 0) { throw "Bien dich test that bai" }

$classNames = $tests | ForEach-Object { "unittest." + $_.BaseName }
& java "-Dfile.encoding=UTF-8" -cp $cp org.junit.runner.JUnitCore $classNames
exit $LASTEXITCODE
