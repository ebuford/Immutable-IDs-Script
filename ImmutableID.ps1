<#
.SYNOPSIS
  Use this script to find the Immutable ID of One or More Users in Active Directory.
  This Script is to be run on the Domain Contorller and will produce the ImmutableID for an Active Directory User that will be used to change the ImmutableID in Office 365.
  Doing this will Hard Match the AD User to the Office 365 User
.DESCRIPTION
  <Brief description of script>
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  <Inputs if any, otherwise state None>
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         Ed Buford
  Creation Date:  12/6/2015
  License: Creative Commons
  
.EXAMPLE
  On A Domain Controller - run:    PS:C:\source ./ImmutableID
  Select 1 for a Single User 
  Select 2 for All users
  Select 3 to Exit

  If you select 1 enter the users alias should be entered and the results will come to the screen
  If you select 2 then enter the path where the CSV file will all users ImmutableID will be exported
#>

[System.Console]::ForegroundColor = [System.ConsoleColor]::White
clear-host
Import-module activedirectory

write-host
write-host This Script will Get the ObjectGUID for a user and convert
write-host it to the Immutuable ID for use in Office 365
Write-Host
write-host Please choose one of the following:
write-host
write-host '1) Get ID for a Single User'
write-host '2) Get IDs for all Users'
write-host '3) Cancel' -ForegroundColor Red
write-host
$option = Read-Host "Select an option [1-3]"

switch ($option)
{
       '1'{
        write-verbose "Option 1 selected"
        $GetUser = Read-Host -Prompt 'Enter UserName'
        $users = get-aduser $GetUser  | select samaccountname,userprincipalname,objectguid,@{label="ImmutableID";expression={[System.Convert]::ToBase64String($_.objectguid.ToByteArray())}}
$users       
}


       '2'{          
        Write-host
        Write-host Type the Path location to Export the results:   i.e. c:\source\ImmutableID.csv

        $Path = Read-Host -Prompt 'Enter Path'

        $users

        $Users = get-aduser -filter * | select samaccountname,userprincipalname,objectguid,@{label="ImmutableID";expression={[System.Convert]::ToBase64String($_.objectguid.ToByteArray())}}


$users | export-csv $Path


       }
       '3'{
              write-verbose "Option 3 selected"
        break
       }
}

