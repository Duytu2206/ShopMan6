# Bien dich, trien khai ung dung vao Tomcat va khoi dong server.
# Mo trinh duyet: http://localhost:8080/ShopMan6/
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
& (Join-Path $PSScriptRoot "build.ps1")

$tomcat = Join-Path $root "tools\tomcat"
if (-not (Test-Path $tomcat)) { throw "Chua co Tomcat. Hay chay scripts\setup-libs.ps1 truoc." }

# Trien khai: copy toan bo WebContent thanh webapps/ShopMan6
$app = Join-Path $tomcat "webapps\ShopMan6"
if (Test-Path $app) { Remove-Item -Recurse -Force $app }
Copy-Item -Recurse (Join-Path $root "WebContent") $app

# Tomcat can JAVA_HOME
if (-not $env:JAVA_HOME) {
    $javaExe = (Get-Command java).Source
    $env:JAVA_HOME = Split-Path -Parent (Split-Path -Parent (Resolve-Path $javaExe))
    if (-not (Test-Path (Join-Path $env:JAVA_HOME "bin\javac.exe"))) {
        $jdk = Get-ChildItem "C:\Program Files\Java" -Directory -Filter "jdk*" | Sort-Object Name -Descending | Select-Object -First 1
        if ($jdk) { $env:JAVA_HOME = $jdk.FullName }
    }
}
$env:CATALINA_HOME = $tomcat
# Tranh loi "Unable to establish loopback connection" cua JDK tren Windows
# (thu muc tam mac dinh co dau cach / bi chan): dung thu muc temp cua Tomcat cho socket noi bo
$env:CATALINA_OPTS = "-Djdk.net.unixdomain.tmpdir=" + (Join-Path $tomcat "temp")
Write-Host "JAVA_HOME = $env:JAVA_HOME"
Write-Host "Mo trinh duyet tai: http://localhost:8080/ShopMan6/   (Ctrl+C de dung server)"
& (Join-Path $tomcat "bin\catalina.bat") run
