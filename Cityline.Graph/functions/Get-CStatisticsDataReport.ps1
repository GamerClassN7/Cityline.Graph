function Get-CStatisticsDataReport {
    param (
        [Parameter(Mandatory=$true)]
        [datetime]
        $from,

        [Parameter(Mandatory=$true)]
        [datetime]
        $to,

        [Parameter(Mandatory=$true)]
        [string[]]
        $pmGuids,

        # Report type as a parameter — placed in the 'Financial' parameter set.
        [ValidateSet('SinglePaymentReport')]
        [string]
        $ReportType = 'SinglePaymentReport'
    )

    $pmList = ($pmGuids -join ',')
    $form = @{
        "no_crt"                = "1"
        "filterdefinition_guid" = "3" #Magick Variable for new filter
        "reporttype"            = $ReportType
        "pm_list"               = ("," + $pmList)
        "startdate"             = $from.ToString("dd-MM-yyy 00:00:00")
        "enddate"               = $to.ToString("dd-MM-yyy 23:59:59")
        "last5messages"         = "0"
        "grouping_settings"     = "2"
    }

    $response = Invoke-CRequestBatchFilterDefinition -Method 'POST' -Endpoint ("/{0}_report/getFilterDefinition" -f ($ReportType.ToLower() -replace 'Report','')) -Body $form -ChunkDays 7
    return $response.pm
}