$TokenSet = @{
        U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
        N = [Char[]]'0123456789'
    }

$Upper = Get-Random -Count 5 -InputObject $TokenSet.U
$Lower = Get-Random -Count 5 -InputObject $TokenSet.L
$Number = Get-Random -Count 5 -InputObject $TokenSet.N

$StringSet = $Upper + $Lower + $Number

$UniqueStringAz=(Get-Random -Count 15 -InputObject $StringSet) -join ''
Write-Host "Unique ID is " -nonewline
Write-Host $UniqueStringAz