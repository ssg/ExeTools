param (
    $Path = "*.exe"
)

if ($input -ne $null) {
    Write-Debug "Substitute $Path with $input"
    $Path = $input
}
$7zipcmd = "7z"

Get-ChildItem -ErrorAction SilentlyContinue -Recurse $Path | ForEach-Object { 
    & $7zipcmd l $_.FullName 2> $null 
    | Out-String 
    | Select-String -Pattern "Path = (.+)\r\nType = PE\r\nPhysical Size = \d+\r\nCPU = (.+)\r\n" 
    | Select-Object @{n = 'Architecture'; e = { $_.Matches[0].Groups[2].Value } },
    @{n = 'Path'; e = { $_.Matches[0].Groups[1].Value } } 
}