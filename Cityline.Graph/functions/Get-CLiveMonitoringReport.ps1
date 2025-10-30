function Get-CLiveMonitoringReport {
    param (
        [Parameter(Mandatory = $true)]
        [string[]]
        $pmGuids
    )

    $pmList = ($pmGuids -join ',')
    $form = @{
        "no_crt"                = "2"
        "filterdefinition_guid" = "671264ee-2ca1-11ef-9f53-020ecb83aaf7"
        "pm_list"               = ("," + $pmList)
        "disable_event_filter"  = "1"
    }

    $response = Invoke-CRequest -Endpoint ("/livemonitoring_report/getFilterDefinition") -Method 'POST' -Body $form
    $jsonResponse = ($response | ConvertFrom-Json)

    if ($pmGuids.Length -ne $jsonResponse.filter_pms.Length) {
        Write-Verbose "Warning: Requested $($pmGuids.Length) PM GUIDs, but response contains $($jsonResponse.filter_pms.Length) entries."
    }

    return $jsonResponse.pm
}