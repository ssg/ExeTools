# about
ExeTools is currently a PowerShell module that only provides the `Get-ExeArchitecture` cmdlet. I needed it on my
new Windows Dev Kit 2023 machine to see which are actually . To install it:

```
Install-Module ExeTools
```

To use it:

```
Get-ExeArchitecture *.exe
```

# Get-ExeArchitecture
This cmdlet returns the target architecture value of an executable. It can also be piped to other commands. It uses
.NET's native System.Reflection.PortableExecutable namespace so it probably doesn't recognize ARM64EC (x64 binaries that can be
natively re-compiled into ARM64). 

I haven't tried it on Linux either

# Contributing
Feel free to send PRs to add more functionality, add testing, or fix bugs related to executable related operations.

# License
Apache License 2.0. See the LICENSE file for details.
