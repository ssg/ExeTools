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

function Get-AssemblyInfo {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [System.IO.FileInfo]$Path = "*.dll"
    )

    process {
        Get-ChildItem -ErrorAction SilentlyContinue $Path | ForEach-Object {
            try {
                $assembly = [System.Reflection.Assembly]::LoadFile($_.FullName)            
                $obj = [PSCustomObject]@{
                    Name = $assembly.GetName().Name
                    FileVersion = $_.VersionInfo.FileVersion
                    AssemblyVersion = $assembly.GetName().Version.ToString()
                    PublicKeyToken = ($assembly.GetName().GetPublicKeyToken() | ForEach-Object ToString x2) -join ''
                    Culture = $assembly.GetName().CultureInfo.Name
                    Path = $_.FullName
                }
                $obj
            }
            catch {
                Write-Error "Failed to load assembly from $($_.FullName): $_"
            }
        }
    }
}

Export-ModuleMember -Function Get-ExeArchitecture, Get-ExeHeader, Get-AssemblyInfo