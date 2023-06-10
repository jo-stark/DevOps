$folderPath = "C:\Users\Jobin\OneDrive\Documents\testrunofps"
$searchPattern = "fenergo.xmlbackstore.config"
$newPassword = "jjjjjjjjjjj"

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
            <#
            # Check if the next line contains the FenergoSystemUserPassword property
            if ($content[$i+1] -match '<add name="FenergoSystemUserName" value="ubsprod\\svc_f-workflow" />') {
                if ($content[$i+2] -match '<add name="FenergoSystemUserPassword" value=".*" />') {
                    $content[$i+2] = '<add name="FenergoSystemUserPassword" value="' + $newPassword + '" />'
                    $changeCount++
                }
            }
            #>
            # Check if the next line contains the ExternalDataService.Security.Password property
            if ($content[$i+1] -match '<add name="ExternalDataService\.Security\.Password" value=".*" />') {
                $content[$i+1] = '<add name="ExternalDataService.Security.Password" value="' + $newPassword + '" />'
                $changeCount++
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
