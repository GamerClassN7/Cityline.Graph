function Connect-CG {
    param (
        [string]
        $Uri,
        [string]
        $Username,
        [SecureString]
        $Password
    )

    # expose the base URL at script scope so other functions can reuse it
    $script:Uri = "https://cityline.cl.hectronic.cloud"
    if ($PSBoundParameters.ContainsKey('Uri')) {
        $script:Uri = $Uri
    }
    $script:session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $script:session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36"
            
    $requestPrefab = @{
        "WebSession"  = $script:session
        "Method"      = 'POST' 
        "ContentType" = "application/x-www-form-urlencoded; charset=UTF-8" 
    }

    $form = @{
        "sel_username" = $Username
        "sel_psw"      = ($Password | ConvertFrom-SecureString -AsPlainText)
        "language_cb"  = "aba41713-ba1e-41d1-84cd-24c371c9697d"
    }
            
    $response = Invoke-WebRequest @requestPrefab -Uri ("{0}/login/defaultDerivation" -f $script:Uri) -Body $form
    if ($response.StatusCode -ne 200) {
        Write-Error "Login failed with status code: $($response.StatusCode)"
        return $null
    }
    
    $script:isConnected = $true
    return $script:session
}
