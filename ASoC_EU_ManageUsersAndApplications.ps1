#Code Developed by Antony Chiu
#Enhanced by Kevin Chia

#AppScan on Cloud REST API is available here:
#https://cloud.appscan.com/eu/swagger/index.html

#Required User supplied inputs
$ASoC_API_Key = 'EDIT ME'
$ASoC_API_Secret = 'EDIT ME'

#EU Datacenter
$baseURL = 'https://cloud.appscan.com/eu/api/V2'

#API will grab bearer token, please leave it blank
$bearer_token =''
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12

$jsonBody = "
  {
  `"KeyId`": `"$ASoC_API_Key`",
  `"KeySecret`": `"$ASoC_API_Secret`"
  }
"

$params = @{
    Uri         = "$baseURL/Account/ApiKeyLogin"
    Method      = 'POST'
    Body        = $jsonBody
    Headers = @{
        'Content-Type' = 'application/json'
    }
}

$Members = Invoke-RestMethod @params
$bearer_token = $Members.token



function Get-Token{
    #Get Token
	$params = @{
        Uri         = "$baseURL/Account/TenantInfo"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params
    ForEach ($i in $output){
        Write-Host "Is Admin: "$i.TenantName
		Write-Host "User Name: "$i.UserInfo.Username		
		Write-Host "Is Admin: " $i.UserInfo.isAdmin    
		Write-Host "Auth successful - Token received:"
		Write-Host "$bearer_token"
		
	}
	
}


function Get-Users{
    #Get User List
    $params = @{
        Uri         = "$baseURL/Users"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    
    ForEach ($i in $output){
        Write-Host $i.UserName
    }
}


function Delete-Users{

    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $roleName
    )

    #Get User List
    $params = @{
        Uri         = "$baseURL/Users"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    $Id = ""
    $UserName = ""
    ForEach ($i in $output){
        $Id = $i.Id
        $UserName = $i.UserName
        $curentUserRoleName = $i.roleName
        If($curentUserRoleName -ne $roleName){
            Write-Host 'Skipping User:' $i.UserName 'Role Name:' $curentUserRoleName
        }
        else{
            #Deleting User
            Write-host "Deleting User: $UserName ID: $Id , Role Name: $curentUserRoleName"
            
            $params = @{
                Uri         = "$baseURL/Users/$Id"
                Method      = 'DELETE'
                Headers = @{
                    'Content-Type' = 'application/json'
                    Authorization = "Bearer $bearer_token"
                }
            }
            $output = Invoke-RestMethod @params
            Write-host "API Output: $output"
        }   
    }
}


function Get-assetgroup{
    #Get List of Apps
    $params = @{
        Uri         = "$baseURL/AssetGroups"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    $AppId = ""
    $AppName = ""
    ForEach ($i in $output){
        Write-Host $i.Name $i.Id

    }
}

function Get-Counts{
    #Get List of Apps
    $params = @{
        Uri         = "$baseURL/AssetGroups/Count"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    $AppId = ""
    $AppName = ""
    ForEach ($i in $output){
        Write-Host "Assest Group: "$i.Total
    }
	
	$params = @{
        Uri         = "$baseURL/Users/Count"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    $AppId = ""
    $AppName = ""
    ForEach ($i in $output){
        Write-Host "Current Users: "$i.Total
    }
	
	$params = @{
        Uri         = "$baseURL/Scans/CountByTechnology"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    $AppId = ""
    $AppName = ""
    ForEach ($i in $output){
        Write-Host "Technology: : "$i.Technology
		Write-Host "Current Users: "$i.Count

    }
}

#FUNCITON DELETE APPS

function Get-Apps{
    #Get List of Apps
    $params = @{
        Uri         = "$baseURL/Apps"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    $AppId = ""
    $AppName = ""
    ForEach ($i in $output){
        Write-Host $i.Name
    }
}

function Delete-Apps{
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $assetGroupNameWhereAppsWillBeDeleted
    )
    #Get List of Apps
    $params = @{
        Uri         = "$baseURL/Apps"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    $AppId = ""
    $AppName = ""
    ForEach ($i in $output){
        $AppId = $i.Id
        $AppName = $i.Name
        $currentAssetGroupName = $i.assetGroupName
        
        If($currentAssetGroupName -ne $assetGroupNameWhereAppsWillBeDeleted){
            Write-Host 'Skipping App:' $AppName 'as App belongs to Asset Group: ' $currentAssetGroupName
        }
        else{
            #Deleting App
            Write-host "Deleting App: $AppName APPID: $AppId, App belongs to Asset Group: $currentAssetGroupName"
            $params = @{
                Uri         = "$baseURL/Apps/$AppId"
                Method      = 'DELETE'
                Headers = @{
                    'Content-Type' = 'application/json'
                    Authorization = "Bearer $bearer_token"
                }
            }
            $output = Invoke-RestMethod @params
        }
    }
}

function IsValidEmail { 
    param([string]$EmailAddress)

    try {
        $null = [mailaddress]$EmailAddress
        return $true
    }
    catch {
        return $false
    }
}

function Invite-Users{
    
    Param
    (
         [Parameter(Mandatory=$true, Position=0)]
         [string] $assetGroupId,
         [Parameter(Mandatory=$true, Position=1)]
         [string] $roleId,
         [Parameter(Mandatory=$true, Position=2)]
         [string] $userFileName
    )

    $lineNumber = 0
    foreach($line in Get-Content $userFileName){
        
        $lineNumber++

        if((IsValidEmail($line)) -eq $FALSE){
            Write-Error "Invalid email address format, skipping line $lineNumber"
            
        }else
        {
            $EmailInput = @($line)
            $inputBody = @{
                "AssetGroupId"=$assetGroupId
                "RoleId"=$roleId
                "Emails"=@($line)
            }
            
            $jsonInput = $inputBody | ConvertTo-Json
            
            #$inputBody = "
            #{
                
#                `"Emails`": [
#                     `"$line`"
#                     ]
#                `"AssetGroupId`": `"$assetGroupId`",
#                `"RoleId`": `"$roleId`"
            
#            }
 #           "

            #$inputJson = $inputBody | ConvertTo-Json

            $params = @{
                Uri         = "$baseURL/Account/Invite"
                Method      = 'POST'
                Body        = $jsonInput
                Headers = @{
                    'Content-Type' = 'application/json'
                    Authorization = "Bearer $bearer_token"
                }
                
            }
            
            $output = Invoke-RestMethod @params
            write-host "Updated line $lineNumber, with email $line, API output: $output"
        }
    }
}



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
		Write-Host "4: Press '4' to List Assist Group"
		Write-Host "5: Press '5' to Invite Users" -ForegroundColor Green
		Write-Host "6: Press '6' to Clean Up Workshop" -ForegroundColor Red
		Write-Host "6: Press '7' to Get Counts"
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
				Write-Host 'Edit Invite-Users -assetGroupI Before Running This Script' -ForegroundColor Yellow
				$title    = 'Confirm'
				$question = 'Are you sure to INVITE Students from TXT List?'
				$choices  = '&Yes', '&No'

				$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
				if ($decision -eq 0) {
					Write-Host 'Your choice is Yes.'
					#INVITATION RELATED FUNCTIONS
					#Retrive Assest Role ID From API Get Roles
					#Student Role ID: fa39651a-b8b6-4094-ba29-b9ae94138d8f
					
					#Retrive Assest Group ID From API Get AssetGroups
					#Asset Group ID for ASoC APAC July 27, 2022: f4afb1e6-a5dd-4c63-8636-3633637f833d
					Invite-Users -assetGroupId "6121ed15-202e-47ac-b3cc-14df0573c815" -roleId "fa39651a-b8b6-4094-ba29-b9ae94138d8f" -userFileName "ASoC_UserInviteList.txt"
				} else {
					Write-Host 'Your choice is No.'
					return
				}
				

            }
		'6' {
                Write-Host 'Edit Delete-Apps -assetGroupNameWhereAppsWillBeDeleted Before Running This Script' -ForegroundColor Yellow
				$title    = 'Confirm'
				$question = 'Are you sure to DELETE Students?'
				$choices  = '&Yes', '&No'

				$decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
				if ($decision -eq 0) {
					Write-Host 'Your choice is Yes.'
					#Edit Role Name
					Delete-Users -roleName "Student"
					#Edit Group Assest Name
					Delete-Apps -assetGroupNameWhereAppsWillBeDeleted "AS_Innov_DAST_ASoC_NA_Oct13"
				} else {
					Write-Host 'Your choice is No.'
					return
				}
				
            }
		'7' {
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

