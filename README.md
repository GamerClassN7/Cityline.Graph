# Cityline.Graph

### Connect to Service
```powersehll
Import-Module ./Cityline.Graph/Cityline.Graph.psm1 -Force

# create a SecureString first for -Password
$pw = ConvertTo-SecureString 'heslo' -AsPlainText -Force

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
__Search for payet ticket inside citilyne service__
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