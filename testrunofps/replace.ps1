$parentFolder = "C:\Users\Jobin\OneDrive\Documents\testrunofps"
$searchPattern = "a.config"
$referenceValue = "checkcheckcheck"
$count = 0

Get-ChildItem $parentFolder -Recurse -Include $searchPattern | ForEach-Object {
    $configFile = $_.FullName
    $configContent = Get-Content $configFile -Raw

    $newConfigContent = $configContent -replace '(value\s*=\s*")[^"]*(")', "`$1$referenceValue`$2"

    if ($newConfigContent -ne $configContent) {
        $count++
        Set-Content $configFile $newConfigContent
    }
}

Write-Host "Changes made: $count"
