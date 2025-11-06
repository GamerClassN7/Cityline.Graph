function Disconnect-CG {
    param (
        [string]
        $Username,
        [SecureString]
        $Password
    )

    Invoke-WebRequest -WebSession $script:session -Uri ("{0}/logout" -f $script:Uri) -Method "GET"
    $script:isConnected = $false
    $script:session = $null;
}
