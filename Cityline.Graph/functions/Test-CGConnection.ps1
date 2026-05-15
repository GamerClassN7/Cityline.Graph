function Test-CGConnection {
    [CmdletBinding()]
    [OutputType([bool])]
    param ()

    try {
        if (-not ($script:isConnected -or ($script:session -or $script:Uri))) {
            return $false
        }

        $machines = Get-CMachine -ErrorAction Stop 2>$null
        return ($null -ne $machines)
    }
    catch {
        return $false
    }
}
