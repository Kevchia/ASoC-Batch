#Code Developed by Antony Chiu
#Enhanced by Kevin Chia

#AppScan on Cloud REST API is available here:
#https://cloud.appscan.com/eu/swagger/index.html


#Read config.json
$configFile = Get-Content -Path ".\config.json" -Raw
$configJson = ConvertFrom-Json -InputObject $configFile

#Required User supplied inputs
$ASoC_API_Key = $configJson.API_KEY
$ASoC_API_Secret = $configJson.API_SECRET
#test

#Selecting the Datacenter
$baseURL = $configJson.BASEURL

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
                "AssetGroupIds"=@($assetGroupId)
                "RoleId"=$roleId
                "Emails"=@($line)
            }
            
            $jsonInput = $inputBody | ConvertTo-Json
            
            $params = @{
                Uri         = "$baseURL/Account/InviteUsers"
                Method      = 'POST'
                Body        = $jsonInput
                Headers = @{
                    'Content-Type' = 'application/json'
                    Authorization = "Bearer $bearer_token"
                }
                
            }
            
            $output = Invoke-WebRequest @params

            If($output.StatusCode -eq 200){
                Write-host "$lineNumber. Successfully invited user: $line"
            }else{
                Write-error "Failed to invite user $line. Status code: $($output.StatusCode), Status description: $($output.StatusDescription)"
            }
            
        }
    }
}

function Get-AssetGroups{
     
     $params = @{
        Uri         = "$baseURL/AssetGroups"
        Method      = 'Get'
        Headers = @{
            'Content-Type' = 'application/json'
            Authorization = "Bearer $bearer_token"
        }
    }
    $output = Invoke-RestMethod @params

    return $output
}

function Print-AssetGroups{

    $output = Get-AssetGroups
    $AssetGroupId = ""
    $AssetGroupName = ""

    Write-Host
    Write-Host "Here are the currently available Asset Groups:" -ForegroundColor Green
    ForEach ($i in $output){
        $AssetGroupName = $i.Name
        $AssetGroupId = $i.Id
        $Index = $($output.IndexOf($i))
        Write-Host "[$Index] - NAME: $AssetGroupName - ID: $AssetGroupId"

    }
}

function PromptUser-SelectAssetGroup{

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

}


function Get-AllRoles{
    #Get List of Apps
    $params = @{
       Uri         = "$baseURL/Roles"
       Method      = 'Get'
       Headers = @{
           'Content-Type' = 'application/json'
           Authorization = "Bearer $bearer_token"
       }
   }
   $output = Invoke-RestMethod @params

   return $output
}

function Print-AllRoles{

   $output = Get-AllRoles
   $roleId = ""
   $roleName = ""

   Write-Host
   Write-Host "Here are the currently available roles:" -ForegroundColor Green
   ForEach ($i in $output){
       $roleName = $i.Name
       $roleId = $i.Id
       $Index = $($output.IndexOf($i))
       Write-Host "[$Index] - NAME: $roleName - ID: $roleId"

   }
}