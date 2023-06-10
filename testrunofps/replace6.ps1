$folderPath = "C:\Users\Jobin\OneDrive\Documents\testrunofps"
$searchPattern = "fenergo.xmlbackstore.config"
$newPassword = "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"

Get-ChildItem $folderPath -Recurse -Filter $searchPattern | ForEach-Object {
    $filePath = $_.FullName
    $content = Get-Content $filePath
    $changeCount = 0

    # Loop through each line in the file
    for ($i = 0; $i -lt $content.Length; $i++) {
        $line = $content[$i]

        # Check if the line contains the svc_f-workflow username
        if ($line -match '<add name=".*username" value="svc_f-workflow" />') {

            # Check if the next line contains the WorkflowService.Security.Password property
            if ($content[$i+1] -match '<add name="WorkflowService\.Security\.Password" value=".*" />') {
                $content[$i+1] = '<add name="WorkflowService.Security.Password" value="' + $newPassword + '" />'
                $changeCount++
            }

            # Check if the next line contains the ExternalDataService.Security.Password property
            if ($content[$i+1] -match '<add name="ExternalDataService\.Security\.Password" value=".*" />') {
                $content[$i+1] = '<add name="ExternalDataService.Security.Password" value="' + $newPassword + '" />'
                $changeCount++
            }
            
            # Check if the current line contains the FenergoSystemUserName property
            if ($line -match '<add name="FenergoSystemUserName" value=".*" />') {
                $systemUserName = $line -replace '<add name="FenergoSystemUserName" value="', '' -replace '" />', ''
                
                # Find the line number of the FenergoSystemUserPassword property
                for ($j = $i; $j -lt $content.Length; $j++) {
                    $passwordLine = $content[$j]
                    if ($passwordLine -match '<add name="FenergoSystemUserPassword" value=".*" />') {
                        $content[$j] = '<add name="FenergoSystemUserPassword" value="' + $newPassword + '" />'
                        $changeCount++
                        break
                    }
                }
            }
        }
    }

    # Save the changes to the file
    if ($changeCount -gt 0) {
        Set-Content $filePath $content
        Write-Output "Updated $($filePath) with $changeCount changes."
    } else {
        Write-Output "No changes made to $($filePath)."
    }
}
