function Get-CMachine {
    param ()
    $response = Invoke-CRequest -Endpoint "/livemonitoring_report" -Method 'GET'
    if (-not $response -or $response.StatusCode -ne 200) {
        Write-Error "Filter failed with status code: $($response.StatusCode)"
        return $null
    }

    $PMTable = [regex]::Matches($response.RawContent, '(?s)<table\b[^>]*>(.*?)<\/table>')[0].Value
    $pmGuids = Convert-HtmlTableToObject -HtmlContent $PMTable
    return $pmGuids
}