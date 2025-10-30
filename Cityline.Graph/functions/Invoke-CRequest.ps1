function Invoke-CRequest {
    [CmdletBinding(DefaultParameterSetName='Default')]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Endpoint,

        # HTTP method (default GET). We'll validate against the active parameter set below.
        [Parameter()]
        [ValidateSet('GET','POST','PUT','DELETE','PATCH','OPTIONS')]
        [string]
        $Method = 'GET',

        # Body is only valid in the WithBody parameter set
        [Parameter(ParameterSetName='WithBody')]
        $Body = $null,

        # Query is only valid in the WithQuery parameter set (expected as hashtable)
        [Parameter(ParameterSetName='WithQuery')]
        [hashtable]
        $Query = $null
    )

    # Require existing script-scoped session and rootUrl
    if (-not $script:session) {
        Write-Error "No active session found. Call Connect-CG first to establish a session."
        return $null
    }
    if (-not $script:rootUrl) {
        Write-Error "No root URL configured. Ensure Connect-CG or a setter initialized `$script:rootUrl`."
        return $null
    }

    # Enforce parameter-set / method consistency: Query only with GET, Body only with non-GET
    switch ($PSCmdlet.ParameterSetName) {
        'WithQuery' {
            if ($Method -ne 'GET') {
                Write-Error "When using -Query the HTTP method must be GET. Received: $Method"
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
    $uri = "{0}{1}" -f $script:rootUrl, $Endpoint
    if ($Method -eq 'GET' -and $Query) {
        # Expecting $Query as a hashtable or dictionary of key/value pairs
        try {
            $qs = ($Query.GetEnumerator() | ForEach-Object { [System.Uri]::EscapeDataString($_.Key) + '=' + [System.Uri]::EscapeDataString($_.Value) }) -join '&'
            if ($qs) { $uri = "$uri?$qs" }
        } catch {
            Write-Warning "Failed to build query string from provided `Query` parameter: $_"
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
        return $response
    } catch {
        Write-Error "HTTP request to $uri failed: $_"
        return $null
    }
}
