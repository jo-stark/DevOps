﻿# Define variables
$folderPath = "C:\Users\Jobin\OneDrive\Documents\testrunofps"
$configFileName = "fenergo.xmlbackstore.config"
$newPassword = "TETSTETSTST"

# Get all config files in the folder and its subfolders
$configFiles = Get-ChildItem -Path $folderPath -Recurse -Filter $configFileName

# Loop through each config file
foreach ($configFile in $configFiles) {
    # Read the contents of the file
    $content = Get-Content -Path $configFile.FullName -Raw
    
    # Replace passwords
    $content = $content -replace '(?<=<add name="WorkflowService.Security.Password" value=")[^"]*', $newPassword
    $content = $content -replace '(?<=<add name="FenergoSystemUserPassword" value=")[^"]*', $newPassword
    $content = $content -replace '(?<=<add name="ExternalDataService.Security.Password" value=")[^"]*', $newPassword
    $content = $content -replace '(?<=<add name="WorkflowService.Security.username" value=")svc_f-workflow', 'svc_f-workflow'
    $content = $content -replace '(?<=<add name="FenergoSystemUserName" value=")ubsprod\\svc_f-workflow', 'ubsprod\svc_f-workflow'

    # Write the updated content back to the file
    Set-Content -Path $configFile.FullName -Value $content
}

# Get the count of changes made
$changeCount = ($content | Select-String -Pattern $newPassword -AllMatches).Matches.Count

# Display the count of changes made
Write-Host "$changeCount changes were made."
