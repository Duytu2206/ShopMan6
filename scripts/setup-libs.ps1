# Tai cac thu vien can thiet (chi can chay 1 lan):
#   - mysql-connector-j  -> WebContent/WEB-INF/lib  (driver JDBC, giong bai giang: copy vao WEB-INF/lib)
#   - junit + hamcrest   -> lib/                    (chi dung cho kiem thu don vi)
#   - Apache Tomcat 10.1 -> tools/tomcat             (web server de chay JSP)
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$webLib  = Join-Path $root "WebContent\WEB-INF\lib"
$testLib = Join-Path $root "lib"
$tools   = Join-Path $root "tools"
New-Item -ItemType Directory -Force $webLib, $testLib, $tools | Out-Null

$maven = "https://repo1.maven.org/maven2"
$jars = @(
    @{ url = "$maven/com/mysql/mysql-connector-j/8.4.0/mysql-connector-j-8.4.0.jar"; dir = $webLib },
    @{ url = "$maven/junit/junit/4.13.2/junit-4.13.2.jar";                          dir = $testLib },
    @{ url = "$maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar";          dir = $testLib }
)
foreach ($j in $jars) {
    $file = Join-Path $j.dir ([IO.Path]::GetFileName($j.url))
    if (-not (Test-Path $file)) {
        Write-Host "Dang tai $($j.url)"
        Invoke-WebRequest -Uri $j.url -OutFile $file -UseBasicParsing
    }
}

$tomcatVer = "10.1.34"
$tomcatDir = Join-Path $tools "tomcat"
if (-not (Test-Path $tomcatDir)) {
    $zip = Join-Path $tools "apache-tomcat-$tomcatVer.zip"
    $url = "https://archive.apache.org/dist/tomcat/tomcat-10/v$tomcatVer/bin/apache-tomcat-$tomcatVer.zip"
    Write-Host "Dang tai $url"
    Invoke-WebRequest -Uri $url -OutFile $zip -UseBasicParsing
    Expand-Archive -Path $zip -DestinationPath $tools -Force
    Rename-Item (Join-Path $tools "apache-tomcat-$tomcatVer") $tomcatDir
    Remove-Item $zip
}
Write-Host "Xong. Thu vien da san sang."
