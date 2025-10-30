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

    $response = Invoke-CRequestFilterDefinition -Endpoint ("/livemonitoring_report/getFilterDefinition") -Method 'POST' -Body $form
    return $response.pm
}