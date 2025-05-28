# about

ExeTools is a PowerShell module that provides few cmdlets for analyzing executable files (EXE and DLL).
I wrote it because needed it on my new Windows Dev Kit 2023 machine to find non-ARM64 binaries. Now, I'm
slowly adding more functionality to it like `Get-AssemblyInfo` to analyze .NET assemblies. 

To install it:

```
Install-Module ExeTools
```

# cmdlets

## Get-AssemblyInfo

This cmdlet returns the assembly version information for a .NET assembly. 

The output looks like this:

```
Name            : Microsoft.Bcl.AsyncInterfaces
FileVersion     : 9.0.525.21509
AssemblyVersion : 9.0.0.5
PublicKeyToken  : cc7b13ffcd2ddd51
Culture         :
Path            : C:\Users\dummy\.nuget\packages\microsoft.bcl.asyncinterfaces\9.0.5\lib\net462\Microsoft.Bcl.AsyncInterfaces.dll
```

## Get-ExeArchitecture

This cmdlet returns the target architecture of an executable binary file.
It uses .NET's native System.Reflection.PortableExecutable namespace so it probably doesn't recognize ARM64EC (x64 binaries that can be natively re-compiled into ARM64).

Since it's PortableExecutable specific at the moment, this function fails on ELF
binaries on Unix.

Example:

```
Get-ExeArchitecture *.exe
```

The output would resemble this:

```
Architecture Path
------------ ----
        I386 C:\temp\Autoruns.exe
       Amd64 C:\temp\Autoruns64.exe
       Arm64 C:\temp\Autoruns64a.exe
        I386 C:\temp\autorunsc.exe
       Amd64 C:\temp\autorunsc64.exe
       Arm64 C:\temp\autorunsc64a.exe
        I386 C:\temp\baslist.exe
       Amd64 C:\temp\bzip2.exe
        I386 C:\temp\certutil.exe
        I386 C:\temp\cloc.exe
        I386 C:\temp\Coreinfo.exe
       Amd64 C:\temp\cports.exe
       Amd64 C:\temp\curl.exe
       Amd64 C:\temp\depends.exe
        I386 C:\temp\disk2vhd.exe
        I386 C:\temp\gzip.exe
```

## Get-ExeHeader

This function returns the raw COFF header for a given executable file. Its output
is for an executable resembles this:

```
Path                 : C:\Users\dummy\.nuget\packages\microsoft.bcl.asyncinterfaces\9.0.5\lib\net462\Microsoft.Bcl.AsyncInterfaces.dll
Machine              : I386
NumberOfSections     : 3
TimeDateStamp        : -554882608
PointerToSymbolTable : 0
NumberOfSymbols      : 0
SizeOfOptionalHeader : 224
Characteristics      : ExecutableImage, LargeAddressAware, Dll
```

# examples

Recurse subdirectories:

`dir *.exe -r | Get-ExeArchitecture`

Find all ARM64 binaries on your disk:

`dir *.exe -r | Get-ExeArchitecture | where { $_.Architecture -eq Arm64 }`

Find non-x64 executables currently running on the system:

`(ps).Path | ? { $_ } | Get-ExeArchitecture | ? { $_.Architecture -ne "Amd64" }`

# contributing

Feel free to send PRs to add more functionality, add testing, or fix bugs related to executable related operations.

# license

Apache License 2.0. See the LICENSE file for details.
