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
            [PSCustomObject]@{
                Path                 = $_.FullName
                Machine              = $header.Machine
                NumberOfSections     = $header.NumberOfSections
                NumberOfSymbols      = $header.NumberOfSymbols
                TimeDateStamp        = $header.TimeDateStamp
                PointerToSymbolTable = $header.PointerToSymbolTable
                SizeOfOptionalHeader = $header.SizeOfOptionalHeader
                Characteristics      = $header.Characteristics
            }
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
        Get-ChildItem -ErrorAction SilentlyContinue $Path 
        | Get-ExeHeader
        | Select-Object @{n = "Architecture"; e = { $_.Machine } }, Path
    }
}

Export-ModuleMember -Function Get-ExeArchitecture, Get-ExeHeader