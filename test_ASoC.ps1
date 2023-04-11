. ".\ASoC_EU_ManageUsersAndApplications.ps1"

Print-AssetGroups
Print-AllRoles



$userSelectedAssetGroupId = ""
$assetGroups = Get-AssetGroups
Print-AssetGroups
$validInput = $false
while($validInput -eq $false){
    Write-Host "Select the asset Group you want to invite the user (Enter a number): " -NoNewline -ForegroundColor Yellow 
    $choice = Read-Host
    if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -le $assetGroups.Count-1){
        $ValidInput = $true
        $assetGroupName = $assetGroups[$choice].Name
        $assetGroupId = $assetGroups[$choice].Id
        $userSelectedAssetGroupId = $assetGroupId

        Write-Host "You selected:"
        Write-Host "Asset Group Mame: $assetGroupName"
        Write-Host "Asset Group ID: $assetGroupId"

        
    } else{
        Write-Host "Invalid input, try again"
    }
}

$userSelectedRoleId = ""
$availableRoles = Get-AllRoles
Print-AllRoles
$validInput = $false
while($validInput -eq $false){
    Write-Host  "Select the role you want to invite the user (Enter a number): "  -NoNewline -ForegroundColor Yellow
    $choice = Read-Host
    if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -le $availableRoles.Count-1){
        $ValidInput = $true
        $roleName = $availableRoles[$choice].Name
        $roleId = $availableRoles[$choice].Id
        $userSelectedRoleId = $roleId

        Write-Host "You selected:"
        Write-Host "role Mame: $roleName"
        Write-Host "role ID: $roleId"

        
    } else{
        Write-Host "Invalid input, try again"
    }
}
