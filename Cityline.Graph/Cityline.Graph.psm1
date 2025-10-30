[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# MODULE FUNCTIONS INIT
$functions = @()
Get-ChildItem -Path "$(Split-Path $script:MyInvocation.MyCommand.Path)\functions\*" -Recurse -File -Filter '*.ps1' |
Where-object -Filter { -not $_.Name.StartsWith("dev_") } |
Where-object -Filter { -not $_.Name.StartsWith("dep_") } |
ForEach-Object {
    . $_.FullName
    $functions += $_.BaseName
}

# MODULE INFO
$Script:version = (Test-ModuleManifest $PSScriptRoot\Cityline.Graph.psd1 -Verbose).Version
Export-ModuleMember -Function $functions

# MODULE VARIABLES
$script:Uri = '';
$script:RequestID = 0;
$script:RequestAuth = ''
$script:LastRequest = @{
    Headers = @{"Content-Type" = "application/json" }
    Uri     = $null
    Method  = $null
    Body    = @{} 
}
