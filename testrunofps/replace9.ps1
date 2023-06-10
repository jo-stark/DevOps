# Set the directory to search in
$dir = "C:\Users\Jobin\OneDrive\Documents\testrunofps"

# Set the new password to use
$newPassword = "NewPassword123"

# Get all the Fenergo config files in the specified directory and its subdirectories
$configFiles = Get-ChildItem -Path $dir -Filter "fenergo.xmlbackstore.config" -Recurse

# Initialize counters for the total number of files and changes made
$totalFiles = 0
$totalChanges = 0

# Loop through each config file
foreach ($configFile in $configFiles) {
    # Read the contents of the config file
    $content = Get-Content $configFile.FullName -Raw
    
    # Check if the FenergoSystemUserName is set to "ubsprod\svc_f-workflow"
    if ($content -match '<add name="FenergoSystemUserName" value="ubsprod\\svc_f-workflow" />') {
        # If it is, update the FenergoSystemUserPassword value with the new password
        $content = $content -ireplace '(?<=<add name="FenergoSystemUserPassword" value=").*?(?=" />)', $newPassword
        
        # Write the updated content back to the config file
        Set-Content $configFile.FullName $content
        
        # Increment the counters for the total number of files and changes made
        $totalFiles++
        $totalChanges++
        
        # Output the full path of the updated file
        Write-Host "Updated $($configFile.FullName)"
    }
    # Check if the WorkflowService.Security.username is set to "svc_f-workflow"
    if ($content -match '<add name="WorkflowService\.Security\.username" value="svc_f-workflow" />') {
        # If it is, update the WorkflowService.Security.Password value with the new password
        $content = $content -ireplace '(?<=<add name="WorkflowService\.Security\.Password" value=").*?(?=" />)', $newPassword
        
        # Write the updated content back to the config file
        Set-Content $configFile.FullName $content
        
        # Increment the counters for the total number of files and changes made
        $totalFiles++
        $totalChanges++
        
        # Output the full path of the updated file
        Write-Host "Updated $($configFile.FullName)"
    } 
    # Check if the ExternalDataService.Security.UserName is set to "svc_f-workflow"
    if ($content -match '<add name="ExternalDataService\.Security\.UserName" value="svc_f-workflow" />') {
        # If it is, update the ExternalDataService.Security.Password value with the new password
        $content = $content -ireplace '(?<=<add name="ExternalDataService\.Security\.Password" value=").*?(?=" />)', $newPassword
        
        # Write the updated content back to the config file
        Set-Content $configFile.FullName $content
        
        # Increment the counters for the total number of files and changes made
        $totalFiles++
        $totalChanges++
        
        # Output the full path of the updated file
        Write-Host "Updated $($configFile.FullName)"
    } 
    
    # Increment the counter for the total number of files
    $totalFiles++
}

# Output the total number of files and changes made
Write-Host "Total files searched: $totalFiles"
Write-Host "Total changes made: $totalChanges"
