
Function LogInToEverythingAzure {
  <#
    .SYNOPSIS
    Logs users in to AzureAd and AzureRM - you will be prompted twice
    .DESCRIPTION
    Prompts users twice to log in to Azure using their organizational credentials
    #>

    # Log in to Azure
    Connect-AzureRmAccount

    # Connect-AzureRmAccount -Environment AzureChinaCloud


    # Todo deal with China and Germany Logins
    # Todo Switch to specific subscription
    # Todo Switch to correct tenant ID

    # Connect using the Azure AD module to get access to groups
    Connect-AzureAD
  }


#$SecureStringPassword = ConvertTo-SecureString -String "password1812**" -AsPlainText -Force
#$specificUser = New-AzureRmADUser -DisplayName "Robot Three" -UserPrincipalName "robotthree@unioncrate.com" -Password $SecureStringPassword -MailNickname "RobotThreeNickName"
$specificUserId = $specificUser.Id


$groupObj = get-azureadgroup

$oneGroup = $groupObj | Where-Object -Property DisplayName -eq -Value "Developers"
$oneGroupId = $oneGroup.ObjectId

#Add user to the developer group
Add-AzureRmADGroupMember -MemberObjectId $specificUserId -TargetGroupObjectId $oneGroupId


Function StringsInList1NotInList2 {
<#
  .SYNOPSIS
  Return a list of strings from List1 that are not in List 2
  .DESCRIPTION
  Return a list of strings from List1 that are not in List 2
  #>
  Param (
  $list1,
  $list2
)
  $rtnList = New-Object System.Collections.Generic.List[string]
  ForEach($itemFromList1 in $list1)
  {
    if (-Not ($list2.Contains($itemFromList1)))
    {
      $rtnList.Add($itemFromList1)
    }
  }
  return ,$rtnList
}


Function Add-UserToGroupByName {
  <#
  .SYNOPSIS
  Adds an existing Azure User to one group
  .DESCRIPTION
  Adds an existing Azure User to one group
  #>
Param (
[string]$userPrincipalName,
[string]$groupName
   )
    $specificUser = Get-AzureADUser | Where-Object {$_.UserPrincipalName -eq $userPrincipalName}
    $specificUserId = $specificUser.ObjectId
    
    $allGroupsObj = Get-AzureADGroup

    $oneGroupObj = $allGroupsObj | Where-Object -Property DisplayName -eq -Value "Developers"
    $oneGroupId = $oneGroupObj.ObjectId

    #Add user to the developer group
    Add-AzureRmADGroupMember -MemberObjectId $specificUserId -TargetGroupObjectId $oneGroupId
    #Write-Information $message
}


Function CreateAzureGroupsByDisplayName {
  <#
    .SYNOPSIS
    Once logged into an Azure subscription and directory create a number of groups if they don't exist yet
    .DESCRIPTION
    Once logged into an Azure subscription and directory check what groups already exist by name and create a number of groups that don't yet exist
    Return the list of groups that were not able to be created
    #>
    Param (
    [System.Collections.Generic.List[string]]$groupsToAddToAzure
  )
    $allGroupsObj = Get-AzureADGroup
    $groupNamesFromAzure = $allGroupsObj.DisplayName
    $actualListOfGroupsToAdd = StringsInList1NotInList2 -list1 $groupsToAddToAzure -list2 $groupNamesFromAzure
    $nonCreatedList = New-Object System.Collections.Generic.List[string]
    ForEach($groupToAdd in $actualListOfGroupsToAdd)
    {
      try {
        New-AzureADGroup -DisplayName $groupToAdd -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
      }
      catch {
        $nonCreatedList.Add($groupToAdd)
      }
    }
    return $nonCreatedList
  }

  Function CopyToListOfStrings {
  Param (
    $someListLikeObject
    )
    $rtnList = New-Object System.Collections.Generic.List[string]
    

    return ,$rtnList
  }

  Function Add-BulkUsersFromCsv {
    <#
    .SYNOPSIS
    Adds an existing Azure User to one group
    .DESCRIPTION
    Adds an existing Azure User to one group
    #>
  #[cmdletbinding()]
  Param (
  [string]$fileLocation,
  [string]$groupName
     )
      $csvObj = Import-Csv -path fileLocation
      # Todo check the CSV that it indeed has rows
      # Todo check that the CSV inded has a DisplayName and a UserPrinicpalName for each row
      # Todo check that the UserPrincipalName is indeed a valid email address
  
      # Get the headers that have 'Group' in the name
      $tempObjTable = $csvObj | Get-Member
      $tempObjTable = $tempObjTable | Where-Object -Property MemberType -eq -Value "NoteProperty"
      $headerNames = $tempObjTable.Name
      $headerNamesWithGroups = $headerNames | Where-Object {$_ -like "*Group*"} #| Out-String -Stream
      $someHashSet = New-Object 'System.Collections.Generic.HashSet[string]'
      ForEach($columnName in $headerNamesWithGroups)
      {
        $tempGroupList = $csvObj.$groupName
        $tempGroupList | Where-Object {-Not([string]::IsNullOrEmpty($_))}
        ForEach($oneGroupNameFromCsv in $tempGroupList)
        {
          $someHashSet.Add($oneGroupNameFromCsv)
        }
      }
  
      $groupNamesFromCsv = New-Object System.Collections.Generic.List[string]
      $someHashset.CopyTo($groupNamesFromCsv)

      CreateAzureGroupsByDisplayName $groupNamesFromCsv
      

  
      $listOfGroupsToAdd = New-Object System.Collections.Generic.List[string]
  
  
      $groupObj = Get-AzureADGroup
      $groupNames = $groupObj.DisplayName   
      $specificUser = Get-AzureADUser | Where-Object {$_.UserPrincipalName -eq $userPrincipalName}
      $specificUserId = $specificUser.ObjectId
  
  
  
      $oneGroupObj = $allGroupsObj | Where-Object -Property DisplayName -eq -Value "Developers"
      $oneGroupId = $oneGroupObj.ObjectId
  
      #Add user to the developer group
      Add-AzureRmADGroupMember -MemberObjectId $specificUserId -TargetGroupObjectId $oneGroupId
      #Write-Information $message
  }
  


$userPrincipalName = "robotthree@unioncrate.com"
$specificUser = Get-AzureADUser | Where-Object {$_.UserPrincipalName -eq $userPrincipalName}




Import-Csv -path "C:\Uc\aws-to-azure\AzureUsers.csv"


$somePath = "C:\Uc\aws-to-azure\AzureUsers.csv"

New-AzureADGroup -DisplayName "SomeTestGroup" -MailEnabled $false -SecurityEnabled $true -MailNickName "some mail nickname"



New-AzureADGroup -DisplayName "My new group" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"