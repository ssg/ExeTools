#requires -Version 7.0

function Get-PECoffHeader() {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [System.IO.FileInfo]$Path
    )    
    process {
        $Path = New-Object System.IO.FileInfo $_
        $stream = $Path.OpenRead()
        $reader = New-Object System.Reflection.PortableExecutable.PEHeaders $stream
        $header = $reader.CoffHeader
        $stream.Dispose()
        [PSCustomObject] @{
            Architecture = $header.Machine
            Path         = $Path.Name
        }
    }
}

function Get-ExeArchitecture {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [System.IO.FileInfo]$Path = "*.exe"
    )

    process {
        Get-ChildItem -ErrorAction SilentlyContinue -Recurse $Path 
        | Get-PECoffHeader
    }
}