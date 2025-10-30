function Get-CStatisticsAnalysisReport {
    param (
        [Parameter(Mandatory = $true)]
        [datetime]
        $from,

        [Parameter(Mandatory = $true)]
        [datetime]
        $to,

        [Parameter(Mandatory = $true)]
        [string[]]
        $pmGuids,

        [ValidateSet('FinancialReport','TicketDurationReport')]
        [string]
        $ReportType = 'FinancialReport'
    )

    $pmList = ($pmGuids -join ',')
    $form = @{
        "no_crt"                = "7"
        "filterdefinition_guid" = "3" #Magick Variable for new filter
        "reporttype"            = $ReportType
        "pm_list"               = ("," + $pmList)
        "startdate"             = $from.ToString("dd-MM-yyy 00:00:00")
        "enddate"               = $to.ToString("dd-MM-yyy 23:59:59")
        "last5messages"         = "0"
        "grouping_by"           = "1"
    }

    $response = Invoke-CRequestBatchFilterDefinition -Method 'POST' -Endpoint ("/{0}_report/getFilterDefinition" -f ($ReportType.ToLower() -replace 'Report', '')) -Body $form -ChunkDays 7
    return $response.pm
}