function Invoke-CRequestBatch {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Endpoint,

        [Parameter()]
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS')]
        [string]
        $Method = 'GET',

        [Parameter(ParameterSetName = 'WithBody')]
        $Body = $null,

        [Parameter(ParameterSetName = 'WithQuery')]
        [hashtable]
        $Query = $null,

        [int]
        $ChunkDays = 7
    )

    # We expect caller to pass date range and pm guids inside Body or Query
    $results = @()
    $from = [datetime]::ParseExact($Body.startdate, 'dd-MM-yyyy HH:mm:ss', $null)
    $to = [datetime]::ParseExact($Body.enddate, 'dd-MM-yyyy HH:mm:ss', $null)

    # If 'to' is in the future, clamp it to current date/time (current hour)
    $now = Get-Date
    if ($to -gt $now) {
        $to = $now
    }

    $days = New-TimeSpan -Start $from -End $to
    write-verbose "Splitting request from $($from) to $($to) into chunks of $ChunkDays days (total $($days.TotalDays) days)."

    for ($i = 0; $i -lt [System.Math]::Ceiling($days.TotalDays); $i += $ChunkDays) {
        $tempBody = $Body.Clone()
        $tempBody.startdate = $from.AddDays($i).ToString('dd-MM-yyyy 00:00:00')
        $tempBody.enddate = $from.AddDays([Math]::Min($i + $ChunkDays, [System.Math]::Ceiling($days.TotalDays))).ToString('dd-MM-yyyy 23:59:59')
    
        $response = Invoke-CRequest -Endpoint ("/{0}_report/getFilterDefinition" -f ($ReportType.ToLower() -replace 'Report', '')) -Method 'POST' -Body $tempBody
        $responseJson = ($response.Content | ConvertFrom-Json -Depth 5)
        $results += $responseJson
        Write-verbose "Invoking batched request for date range: $($tempBody.startdate) to $($tempBody.enddate)"
        Write-verbose "Results : $($responseJson.pm.Length)"
    }

    Write-Verbose "Results : $($results.Length)"
    return ($results | ConvertTo-Json -Depth 7)
}