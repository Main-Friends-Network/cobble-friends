<#
    Benutzung: .\packwiz.ps1 <packwiz-Befehl> [Optionen]
    Beispiel : .\packwiz.ps1 modrinth add sodium
#>

$ErrorActionPreference = "Stop"
$image = "packwiz:latest"

# Aktuellen Arbeitsordner ins Container-Volume einhängen
docker run --rm -it `
    -v "${PWD}/modpack:/workspace" `
    -w /workspace `
    $image @Args