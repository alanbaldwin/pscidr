(Get-ChildItem -Path (Join-Path $PSScriptRoot functions) -Filter *.ps1 -Recurse) | % {
    . $_.FullName
}