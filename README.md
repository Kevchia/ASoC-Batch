# Managing ASoC (AppScan on Cloud) with Script for Batch operations
This script is written by Antony Chiu<br>
Modified by Kevin Chia. <br>
<br>
This Powershell script allows you to <br>
<br>
1.Check Current Token - Check your connection status with ASoC<br>
2.List Current Users - List all the users on your ASoC<br>
3.List Current Apps - List all Apps on your ASoC<br>
4.List Assist Group - List all Assist Group on your ASoC<br>
5.Invite Users - Invite the users from ASoC_UserInviteList.txt<br>
6.Clean Up Workshop - Batch Delete the scans on specefic assist group<br>
7.Get Counts  - Get application and user counts<br>

# Script Setup

In order to use the script, there are some things you need to do.<br>
<<<<<<< HEAD
1.Provide API Key<br>
You can get your API keys from ASoC Tools>API<br>
Edit <br>
```
$ASoC_API_Key = 'EDIT ME'
$ASoC_API_Secret = 'EDIT ME'
```
=======

1.Provide API Key and secret in config.json:
```
{
    "API_KEY": "YOUR ASOC API KEY",
    "API_SECRET": "YOUR ASOC API SECRET",
    "BASEURL": "https://cloud.appscan.com/api/V2"
}
```
Note: If you are working with ASoC EU, change the BASEURL to "https://cloud.appscan.com/eu/api/V2"
>>>>>>> 59e67c7 (readme)

<br>
2.Point to the right Datacenter<br>
The following example is EU Datacenter<br>

```
$baseURL = 'https://cloud.appscan.com/eu/api/V2'
```

Base URL for US Datacenter <br>

```
https://cloud.appscan.com/api/V2
```


# How to Invite users

1.Put all the emails in ASoC_UserInviteList.txt<br>
Nextline for each emails<br>
Example:<br>

```
JohnDoe@test.com
JamesBond@test.com
```


2.Assign asset Groups (Line 415)<br>
Enter your asset Group ID (Can retrieve from List Assist Group)<br>

```
Invite-Users -assetGroupId "6121ed15-202e-47ac-b3cc-14df0573c815" -roleId "fa39651a-b8b6-4094-ba29-b9ae94138d8f" -userFileName "ASoC_UserInviteList.txt"
```

3.Assign user Group (Line 415)<br>
Enter your RoleID (Can retrieve from ASoC)<br>

```
Invite-Users -assetGroupId "6121ed15-202e-47ac-b3cc-14df0573c815" -roleId "fa39651a-b8b6-4094-ba29-b9ae94138d8f" -userFileName "ASoC_UserInviteList.txt"
```
# How to delete scans and users - clean workshop

This function will delete all the scans in the specefic asset group and users


1. Set Role Name (Line 433)<br>

```
Delete-Users -roleName "Student"
``` 

2.Set Asset Name (Line 435)<br>

``` 
Delete-Apps -assetGroupNameWhereAppsWillBeDeleted "AS_Innov_DAST_ASoC_NA_Oct13"
```

<b>Reminder: Clean Workshop function will delete the scans under the specefic asset and users!!!</b>
