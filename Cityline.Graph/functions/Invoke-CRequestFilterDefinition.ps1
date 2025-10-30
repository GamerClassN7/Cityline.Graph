function Invoke-CRequestFilterDefinition {
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

    $responseParams = @{
        Endpoint = $Endpoint
        Method   = $Method
    }

    if ($PSBoundParameters.ContainsKey('Body')) {
        $responseParams.Body = $Body
    }

    if ($PSBoundParameters.ContainsKey('Query')) {
        $responseParams.Query = $Query
    }

    $response = Invoke-CRequest @responseParams
    return ($response.Content | ConvertFrom-Json -Depth 5)
}
