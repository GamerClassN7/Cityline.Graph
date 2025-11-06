function Invoke-CRequest {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Endpoint,

        # HTTP method (default GET). We'll validate against the active parameter set below.
        [Parameter()]
        [ValidateSet('GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS')]
        [string]
        $Method = 'GET',

        # Body is only valid in the WithBody parameter set
        [Parameter(ParameterSetName = 'WithBody')]
        $Body = $null,

        # Query is only valid in the WithQuery parameter set (expected as hashtable)
        [Parameter(ParameterSetName = 'WithQuery')]
        [hashtable]
        $Query = $null
    )

    if (-not ($script:isConnected -and $script:session -and $script:Uri)) {
        if (-not ($script:isConnected -and $script:session)) {
            Write-Error "No active session found. Call Connect-CG first to establish a session."
        }
        if (-not $script:Uri) {
            Write-Error "No root URL configured. Ensure Connect-CG or a setter initialized `$script:Uri`."
        }
        return $null
    }

    # Enforce parameter-set / method consistency: Query only with GET, Body only with non-GET
    switch ($PSCmdlet.ParameterSetName) {
        'WithQuery' {
            if ($Method -ne 'GET') {
                Write-Error ("When using -Query the HTTP method must be GET. Received: {0}" -f $Method)
                return $null
            }
        }
        'WithBody' {
            if ($Method -eq 'GET') {
                Write-Error "Cannot send a body with HTTP GET. Set -Method to POST/PUT/... or remove -Body."
                return $null
            }
        }
    }

    # Build the full URI; append query string for GET requests
    $uri = "{0}{1}" -f $script:Uri, $Endpoint
    if ($Method -eq 'GET' -and $Query) {
        # Expecting $Query as a hashtable or dictionary of key/value pairs
        try {
            $qs = ($Query.GetEnumerator() | ForEach-Object { [System.Uri]::EscapeDataString($_.Key) + '=' + [System.Uri]::EscapeDataString($_.Value) }) -join '&'
            if ($qs) { $uri = "$uri?$qs" }
        }
        catch {
            Write-Warning ("Failed to build query string from provided `Query` parameter: {0}" -f $_)
        }
    }

    $requestPrefab = @{
        WebSession  = $script:session
        Method      = $Method
        ContentType = "application/x-www-form-urlencoded; charset=UTF-8"
    }

    if ($Method -ne 'GET' -and $Body) {
        Write-Verbose  "$Body test"
        $requestPrefab['Body'] = $Body
    }

    try {
        Write-Verbose $uri
        $response = Invoke-WebRequest @requestPrefab -Uri $uri
        if ($response.StatusCode -match '2*') {
            return $response
        }
        Write-Error ("HTTP request to {0} did not return successful status code: {1}" -f $uri, $response.StatusCode)
    }
    catch { 
        Write-Error ("HTTP request to {0} failed: {1}" -f $uri, $_)
        if ($script:isConnected) {
            Disconnect-CG >> $null
        }
    }
    
    return $null
}
