$folderPath = "C:\Users\Jobin\OneDrive\Documents\testrunofps"
$filesToUpdate = Get-ChildItem -Path $folderPath -Recurse -Include "fenergo.xmlbackstore.config" | Where-Object { $_.Attributes -ne "Directory" }

$newPassword = "MyNewPassword123"

$updatedFiles = @()
$changeCount = 0

foreach ($file in $filesToUpdate) {
    $content = Get-Content -Path $file.FullName -Raw
    
    $updatedContent = $content -replace '(?s)(?<=<add name="WorkflowService.Security.username" value="svc_f-workflow" />\r?\n<add name="WorkflowService.Security.Password" value=").*?(?=" />)', $newPassword
    $updatedContent = $updatedContent -replace '(?s)(?<=<add name="ExternalDataService.Security.UserName" value="svc_f-workflow" />\r?\n<add name="ExternalDataService.Security.Password" value=").*?(?=" />)', $newPassword
    $updatedContent = $updatedContent -replace '(?s)(?<=<add name="FenergoSystemUserName" value="ubsprod\\svc_f-workflow" />\r?\n<add name="FenergoSystemUserPassword" value=").*?(?=" />)', $newPassword

    if ($updatedContent -ne $content) {
        $updatedFiles += $file.FullName
        Set-Content -Path $file.FullName -Value $updatedContent
        $changeCount++
    }
}

Write-Host "Updated $changeCount passwords in the following files:`n"
Write-Output $updatedFiles
