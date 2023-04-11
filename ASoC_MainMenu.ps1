
. ".\ASoC_EU_ManageUsersAndApplications.ps1"
function Show-Menu
{
    
    Clear-Host
	if($bearer_token -eq $null)
		{
			Write-Host "ERROR CHECK API Token" -ForegroundColor Red
			Write-Host "Q: Press 'Q' to quit."
		}
	else
		{
		Write-Host "ASOC Auth successful" -ForegroundColor Green
		Write-Host "================ ASOC Autmoation ================"
		Write-Host "1: Press '1' to Check Current Token."
		Write-Host "2: Press '2' to List Current Users"
		Write-Host "3: Press '3' to List Current Apps"
		Write-Host "4: Press '4' to List Assset Groups"
		Write-Host "5: Press '5' to Invite Users" -ForegroundColor Green
		Write-Host "6: Press '6' to Delete a selected set of Users by Role" -ForegroundColor Red
		Write-Host "7: Press '7' to Delete a selected Asset Group" -ForegroundColor Red
		Write-Host "8: Press '8' to Get Counts"
		Write-Host "Q: Press 'Q' to quit."
		write-host""
		write-host""
		write-host""
	}
		
   
	
	
}

function List-VMs
{
        Write-Host "Script Block to Display all the VMs"
}
function Delete-VMs
{
        Write-Host "Script Block to Delete VM"
}

do
{
    Show-Menu –Title 'My Menu'
    $input = Read-Host "what do you want to do?"
	write-host""
    switch ($input)
    {
        '1' {               
				Get-Token			
            }
        '2' {
                Get-Users
            }
		'3' {
                Get-Apps
            }
		'4' {
                Get-assetgroup
            }
		'5' {
				#Prompt user to pick an asset group
				$userSelectedAssetGroupName = ""
				$userSelectedAssetGroupId = ""

				$assetGroups = Get-AssetGroups
				Print-AssetGroups
				$validInput = $false
				while($validInput -eq $false){
					Write-Host "Select the asset Group you want to invite the user (Enter a number): " -NoNewline -ForegroundColor Yellow 
					$choice = Read-Host
					if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -le $assetGroups.Count-1){
						$ValidInput = $true
						$userSelectedAssetGroupName = $assetGroups[$choice].Name
						$userSelectedAssetGroupId = $assetGroups[$choice].Id
						

						Write-Host "You selected:"
						Write-Host "Asset Group Mame: $userSelectedAssetGroupName"
						Write-Host "Asset Group ID: $userSelectedAssetGroupId"

						
					} else{
						Write-Host "Invalid input, try again"
					}
				}

				#Prompt user to pick a role
				$userSelectedRoleName = ""
				$userSelectedRoleId = ""
				$availableRoles = Get-AllRoles
				Print-AllRoles
				$validInput = $false
				while($validInput -eq $false){
					Write-Host  "Select the role you want to invite the user (Enter a number): "  -NoNewline -ForegroundColor Yellow
					$choice = Read-Host
					if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -le $availableRoles.Count-1){
						$ValidInput = $true
						$userSelectedRoleName = $availableRoles[$choice].Name
						$userSelectedRoleId = $availableRoles[$choice].Id

						Write-Host "You selected:"
						Write-Host "role Mame: $userSelectedRoleName"
						Write-Host "role ID: $userSelectedRoleId"

						
					} else{
						Write-Host "Invalid input, try again"
					}
				}
			
				#Confirm if all settings are good (asset group and role) before sending the invitation request
								
				Write-Host
				Write-Host "You are about to Invite all users in ASoC_UserInviteList.txt into:" -ForeGroundColor Yellow
				Write-Host "Asset Group Name: $userSelectedAssetGroupName - Asset Group ID: $userSelectedAssetGroupId" -ForeGroundColor Yellow
				Write-Host "Role Name: $userSelectedRoleName - Role ID: $userSelectedRoleId" -ForeGroundColor Yellow
				
				$title    = 'Confirm'
				$question = 'Are you sure you want to continue?'
				$choices  = '&Yes', '&No'

				$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
				if ($decision -eq 0) {
					Write-Host 'Your choice is Yes.'

					Invite-Users -assetGroupId $userSelectedAssetGroupId -roleId $userSelectedRoleId -userFileName "ASoC_UserInviteList.txt"
				} else {
					Write-Host 'Your choice is No.'
					return
				}
				

            }
		'6' {
                

				#DELETE USER BY ROLE

				#Prompt user to pick a role
				$userSelectedRoleName = ""
				$userSelectedRoleId = ""
				$availableRoles = Get-AllRoles
				Print-AllRoles
				$validInput = $false
				while($validInput -eq $false){
					Write-Host  "Select the role you want to delete the user (Enter a number): "  -NoNewline -ForegroundColor Yellow
					$choice = Read-Host
					if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -le $availableRoles.Count-1){
						$ValidInput = $true
						$userSelectedRoleName = $availableRoles[$choice].Name
						$userSelectedRoleId = $availableRoles[$choice].Id

						Write-Host "You selected:"
						Write-Host "role Name: $userSelectedRoleName"
						Write-Host "role ID: $userSelectedRoleId"

						
					} else{
						Write-Host "Invalid input, try again"
					}
				}

				$title    = 'Confirm'
				$question = 'Are you sure to DELETE all users in this role?'
				$choices  = '&Yes', '&No'

				$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
				if ($decision -eq 0) {
					Write-Host 'Your choice is Yes.'
					#Edit Role Name
					Delete-Users -roleName $userSelectedRoleName
					#Edit Group Assest Name
					#Delete-Apps -assetGroupNameWhereAppsWillBeDeleted "AS_Innov_DAST_ASoC_NA_Oct13"
				} else {
					Write-Host 'Your choice is No.'
					return
				}
				
            }
		'7' {
               #DELETE ASSET GROUP

			   #Prompt user to pick an asset group
				$userSelectedAssetGroupName = ""
				$userSelectedAssetGroupId = ""

				$assetGroups = Get-AssetGroups
				Print-AssetGroups
				$validInput = $false
				while($validInput -eq $false){
					Write-Host "Select the asset Group you want to DELETE (Enter a number): " -NoNewline -ForegroundColor Yellow 
					$choice = Read-Host
					if ($choice -match '^\d+$' -and [int]$choice -ge 0 -and [int]$choice -le $assetGroups.Count-1){
						$ValidInput = $true
						$userSelectedAssetGroupName = $assetGroups[$choice].Name
						$userSelectedAssetGroupId = $assetGroups[$choice].Id
						

						Write-Host "You selected:"
						Write-Host "Asset Group Mame: $userSelectedAssetGroupName"
						Write-Host "Asset Group ID: $userSelectedAssetGroupId"

						
					} else{
						Write-Host "Invalid input, try again"
					}
				}

			   $title    = 'Confirm'
				$question = 'Are you sure to DELETE this Asset Group?'
				$choices  = '&Yes', '&No'

				$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
				if ($decision -eq 0) {
					Write-Host 'Your choice is Yes.'
					#Edit Role Name
					#Delete-Users -roleName $userSelectedRoleName
					#Edit Group Assest Name
					Delete-Apps -assetGroupNameWhereAppsWillBeDeleted $userSelectedAssetGroupName
				} else {
					Write-Host 'Your choice is No.'
					return
				}
            }
		'8' {
				Get-Counts
			 }
        'q' {
                 return
            }
    }
	write-host""
    pause
}
until ($input -eq 'q')