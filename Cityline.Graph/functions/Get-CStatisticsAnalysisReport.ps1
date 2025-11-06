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

        [Parameter(Mandatory = $false)]
        [ValidateSet('FinancialReport', 'TicketDurationReport')]
        [string]
        $ReportType = 'FinancialReport',

        [Parameter(Mandatory = $false)]
        [ValidateSet('ParkMachine', 'Area', 'Category', 'Tariff')]
        [string]
        $GroupBy = 'ParkMachine'
    )

    $noCrt = "1"
    if ($ReportType -eq 'TicketDurationReport') {
        $noCrt = "7"
    }

    $groupingBy = '1'
    switch ($GroupBy) {
        'ParkMachine' { 
            $groupingBy = '1' 
        }
        'Area' { 
            $groupingBy = '2' 
        }
        'Category' { 
            $groupingBy = '3' 
        }
        'Tariff' { 
            $groupingBy = '4' 
        }
    }

    $pmList = ($pmGuids -join ',')
    $form = @{
        "no_crt"                = $noCrt
        "filterdefinition_guid" = "3" #Magic Variable for new filter
        "reporttype"            = $ReportType
        "pm_list"               = ("," + $pmList)
        "startdate"             = $from.ToString("dd-MM-yyyy 00:00:00")
        "enddate"               = $to.ToString("dd-MM-yyyy 23:59:59")
        "last5messages"         = "0"
        "grouping_by"           = $groupingBy
    }

    $response = Invoke-CRequestBatchFilterDefinition -Method 'POST' -Endpoint ("/{0}_report/getFilterDefinition" -f ($ReportType.ToLower() -replace 'Report', '')) -Body $form -ChunkDays 7
    return $response.pm
}