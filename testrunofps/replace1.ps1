$parentFolder = "C:\Users\Jobin\OneDrive\Documents\testrunofps"
$searchPattern = "a.config"
$referenceValue = "testtestest"
$count = 0

Get-ChildItem $parentFolder -Recurse -Include $searchPattern | ForEach-Object {
    $configFile = $_.FullName
    $configContent = Get-Content $configFile -Raw

    $newConfigContent = $configContent -replace '(<add\s+name\s*=\s*"firstrandomvalue"\s+value\s*=\s*")[^"]*(")|(<add\s+name\s*=\s*"secondrandomvalue"\s+value\s*=\s*")[^"]*(")|(<add\s+name\s*=\s*"thirdrandomvalue"\s+value\s*=\s*")[^"]*(")|(<add\s+name\s*=\s*"fourthrandomvalue"\s+value\s*=\s*")[^"]*(")', {param($m) if ($m.Value -eq 'firstrandomvalue' -or $m.Value -eq 'secondrandomvalue' -or $m.Value -eq 'thirdrandomvalue' -or $m.Value -eq 'fourthrandomvalue') { $m.Groups[1].Value + $referenceValue + $m.Groups[2].Value } else { $m.Value } }

    if ($newConfigContent -ne $configContent) {
        $count++
        Set-Content $configFile $newConfigContent
    }
}

Write-Host "Changes made: $count"
