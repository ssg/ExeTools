#requires -Version 7.0

function Get-ExeHeader() {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [System.IO.FileInfo]$Path = "*.exe"
    )    
    process {
        Get-ChildItem -ErrorAction SilentlyContinue $Path | ForEach-Object {
            $stream = $_.OpenRead()
            $reader = New-Object System.Reflection.PortableExecutable.PEHeaders $stream
            $header = $reader.CoffHeader
            $stream.Dispose()
            $obj = [PSCustomObject]$header 
            Add-Member  -MemberType NoteProperty `
                -InputObject $obj `
                -Name Path `
                -Value $_
            $obj
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
        Get-ExeHeader $Path
        | Select-Object @{n = "Architecture"; e = { $_.Machine } }, Path
    }
}

Export-ModuleMember -Function Get-ExeArchitecture, Get-ExeHeader