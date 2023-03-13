$TokenSet = @{
        U = [Char[]]'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        L = [Char[]]'abcdefghijklmnopqrstuvwxyz'
        N = [Char[]]'0123456789'
    }

$Upper = Get-Random -Count 5 -InputObject $TokenSet.U
$Lower = Get-Random -Count 5 -InputObject $TokenSet.L
$Number = Get-Random -Count 5 -InputObject $TokenSet.N

$StringSet = $Upper + $Lower + $Number

$UniqueStringAz= (Get-Random -Count 15 -InputObject $StringSet) -join ''
Write-Host "Unique ID is " -nonewline
Write-Host $UniqueStringAz

# attempting to find a way to export the $UniqueStringAz value to an encrypted/secure string that can be read within variables.tf
# purpose of this is to prevent malware with access to memory from reading these ID's which are appended to our resource names. 
# If an attacker has this access, we probably have bigger problems but if we can make the process more secure without a cost in terms
# of usability, then it's something I'd like to go for.
#$SecureString = ConvertTo-SecureString -String $UniqueStringAz -AsPlainText -Force
#$SecureString | Export-Clixml -Path "C:\path\to\encrypted_file.xml"