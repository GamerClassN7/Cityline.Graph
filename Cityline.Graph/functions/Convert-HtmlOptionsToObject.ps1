function Convert-HtmlOptionsToObject {
    param (
        [string]
        $HtmlContent
    )

    # Parse HTML into a DOM (relies on ConvertFrom-Html available in the project)
    $doc = $HtmlContent | ConvertFrom-Html
    if (-not $doc) {
        Write-Error "Failed to parse HTML content. Ensure ConvertFrom-Html is available."
        return @()
    }

    $optionNodes = $doc.SelectNodes('.//option')
    $results = @()
    if (-not $optionNodes) { return $results }

    foreach ($opt in $optionNodes) {
        $name = $opt.InnerText.Trim()
        # prefer explicit value attribute, fallback to the visible text
        $value = $opt.GetAttribute('value')
        if (-not $value) { $value = $name }

        $selected = $false
        if ($opt.Attributes['selected']) { $selected = $true }

        # return a PSCustomObject (hash-like) — consistent with Convert-HtmlTableToObject
        $obj = [PSCustomObject]@{
            Name     = $name
            Value    = $value
            Selected = $selected
        }
        $results += $obj
    }

    return $results
}