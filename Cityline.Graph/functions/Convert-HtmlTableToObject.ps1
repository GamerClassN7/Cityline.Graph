function Convert-HtmlTableToObject {
    param (
        [string]$HtmlContent
    )
    $targetTable = $HtmlContent | ConvertFrom-Html  

    $rows = $targetTable.SelectNodes(".//tr")
    $results = @()

    if ($rows.Count -gt 1) {
    # Get the header from the first row
        $headerCells = $rows[0].SelectNodes(".//th")

        if ($headerCells.Count -eq 0) {
            $headerCells = $rows[0].SelectNodes(".//td")
        }

        $headers = $headerCells | ForEach-Object { $_.InnerText.Trim() }

    # Process data rows (from index 1 onwards)
        for ($i = 1; $i -lt $rows.Count; $i++) {
            $row = $rows[$i]
            $cells = $row.SelectNodes(".//td")
            if ($cells) {
                $values = $cells | ForEach-Object { $_.InnerText.Trim() }

                # Create object with column names
                $obj = [PSCustomObject]@{}
                for ($j = 0; $j -lt $headers.Count; $j++) {
                    $key = $headers[$j]
                    $value = if ($j -lt $values.Count) { $values[$j] } else { "" }
                    $obj | Add-Member -NotePropertyName $key -NotePropertyValue $value
                }

                $results += $obj
            }
        }
    }

    return $results
}
