# Managing ASoC (AppScan on Cloud) with Script for Batch operations
This script is written by Antony Chiu<br>
Modified by Kevin Chia. <br>
<br>
This Powershell script allows you to <br>
<br>
1. Check Current Token - Check your connection status with ASoC
2. List Current Users - List all the users on your ASoC
3. List Current Apps - List all Apps on your ASoC
4. List Assist Group - List all Assist Group on your ASoC
5. Invite Users - Invite the users from ASoC_UserInviteList.txt
6. Delete a selected set of Users by Role - Batch Delete a set of users by their role
7. Delete a selected Asset Group - Batch delete a particular asset group
8. Get Counts - Get application and user counts

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

1. Provide API KEY and SECRET in **config.json**:
```
{
    "API_KEY": "YOUR ASOC API KEY",
    "API_SECRET": "YOUR ASOC API SECRET",
    "BASEURL": "https://cloud.appscan.com/api/V2"
}
```
*Note: If you are working with ASoC EU, change the BASEURL to the following: *
```https://cloud.appscan.com/eu/api/V2```

# How to Invite users

1.Put all the emails you want to invite in **ASoC_UserInviteList.txt**<br>
Make sure each line contains only 1 email address<br>
For example:<br>

```
JohnDoe@test.com
JamesBond@test.com
```

Afterwards, use **Option 5** to invite users. 

# How to delete users

Use **Option 6** to delete all users by role ID. 

# How to delete Asset Groups

Use **Option 7** to delete a selected asset group
