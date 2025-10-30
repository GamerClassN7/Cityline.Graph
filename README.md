# Cityline.Graph
![PowerShell](https://img.shields.io/badge/PowerShell-%235391FE.svg?style=for-the-badge&logo=powershell&logoColor=white)

![](https://img.shields.io/github/v/tag/gamerclassn7/cityline.graph?sort=date)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/Cityline.Graph)
![GitHub last commit](https://img.shields.io/github/last-commit/gamerclassn7/cityline.graph)

Small yet powerful module for communication with CityLine cloud service server over API from environment of PowerShell7

### Connect to Service
```powersehll
Install-Module .Cityline.Graph
Import-Module .Cityline.Graph -Force

# create a SecureString first for -Password
$pw = ConvertTo-SecureString 'password' -AsPlainText -Force

# call the function
$session = Connect-CG -Username 'test@test.com' -Password $pw
```

### Disconnect service
```powersehll
Disconnect-CG
```

### Fetch financial report data
```powersehll
$pm = Get-CMachine

Get-CStatisticsAnalysisReport -from (Get-Date -Day 1) -to (Get-Date -Day 30) -pmGuids $pm.GUID -ReportType 'FinancialReport' | ForEach-Object{
    $temp = New-Object PSObject
    foreach ($property in $_.PSObject.Properties.Name) {
        $temp | Add-Member -MemberType 'NoteProperty' -Name ($property -replace 'FinancialReport_', '') -Value $_.$property
    }
    $temp
}
```

### Fetch financial report data
__* Search for payed ticket inside CityLine service__
```powersehll
$pm = Get-CMachine
Get-CStatisticsDataReport -from (Get-Date -Day 1) -to (Get-Date -Day 30) -pmGuids $pm.GUID -ReportType 'SinglePaymentReport' | Where-Object -Property 'PLATENO' -Value 'XX123YY' -eq
```
```powersehll
TicketGuid           : 000000-aaaa-bbbb-cccc-dddddddddddd
TYPE_COIN            : 1
guid                 : eeeeeeee-ffff-1111-2222-333333333333
STRTTIME             : 2025-10-29 10:19:38
ENDTIME              : 2025-10-29 12:19:38
DURATION             : 120
PLATENO              : XX123YY
AMTCOIN              : 40.00
MonetaryDenomination : 20.00CZK;20.00CZK
AMTCREDIT            : 
TARIFF               : 
TICKETCODE           : 9999
AMTTOT               : 40.00
pm_name              : Lokalita Alfa
Name                 : Lokalita Alfa
AreaName             : Oblast Alfa
SerialNumber         : 000000
Location             : TestZone
is_coin              : 1
ExportedDateTime     : 2025-10-30 11:57:56
pm_guid              : eeeeeeee-ffff-1111-2222-333333333333
```

### Fetch Park machines Status information
__* filter only Park Machine with errors__
```powersehll
$pm = Get-CMachine
Get-CLiveMonitoringReport -pmGuids $pm.GUID | Where-Object -Property 'hasError' -Value $true -eq
```

## Info
* https://www.hectronic.com/int/en/parking-management/cityline
* https://www.hectronic.com
* https://www.postman.com/hectronic

## TODO: Fix when report have only one page