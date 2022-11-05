# about

ExeTools is currently a PowerShell module that only provides the `Get-ExeArchitecture` cmdlet. I needed it on my
new Windows Dev Kit 2023 machine to see which are actually . To install it:

```
Install-Module ExeTools
```

# Get-ExeArchitecture

This cmdlet returns the target architecture value of an executable. It can also be piped to other commands. It uses
.NET's native System.Reflection.PortableExecutable namespace so it probably doesn't recognize ARM64EC (x64 binaries that can be
natively re-compiled into ARM64).

Since it's PortableExecutable specific at the moment, this cmdlet doesn't work on Linux.

To use it:

```
Get-ExeArchitecture *.exe
```

The output would resemble this:

<img width="278" alt="image" src="https://user-images.githubusercontent.com/241217/200086695-38a38bee-b7e1-4359-8283-01f5aad595ee.png">

# Get-ExeHeader

Returns the PE header for a given list of executables.

Usage:

```
Get-ExeHeader *.exe
```

The output will look like this:

```
PS C:\Users\sedat\src\ExeTools> dir c:\windows\*.exe | Get-ExeHeader

Path                 : C:\windows\explorer.exe
Machine              : Arm64
NumberOfSections     : 8
NumberOfSymbols      : 0
TimeDateStamp        : -465280943
PointerToSymbolTable : 0
SizeOfOptionalHeader : 240
Characteristics      : ExecutableImage, LargeAddressAware

Path                 : C:\windows\winhlp32.exe
Machine              : I386
NumberOfSections     : 5
NumberOfSymbols      : 0
TimeDateStamp        : 955733043
PointerToSymbolTable : 0
SizeOfOptionalHeader : 224
Characteristics      : ExecutableImage, Bit32Machine

Path                 : C:\windows\write.exe
Machine              : Arm64
NumberOfSections     : 6
NumberOfSymbols      : 0
TimeDateStamp        : -1382528321
PointerToSymbolTable : 0
SizeOfOptionalHeader : 240
Characteristics      : ExecutableImage, LargeAddressAware
```

# Contributing

Feel free to send PRs to add more functionality, add testing, or fix bugs related to executable related operations.

# License

Apache License 2.0. See the LICENSE file for details.
