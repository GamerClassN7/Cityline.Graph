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