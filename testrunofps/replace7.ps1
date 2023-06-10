# Set the directory to search in
$dir = "C:\Users\Jobin\OneDrive\Documents\testrunofps"

# Set the new password to use
$newPassword = "llllllllllllllllllllllll"

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
    } else {
        # Increment the counter for the total number of files
        $totalFiles++
    }
}

# Output the total number of files and changes made
Write-Host "Total files searched: $totalFiles"
Write-Host "Total changes made: $totalChanges"
