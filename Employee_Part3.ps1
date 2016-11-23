Class Employee {


    [ValidatePattern("^[a-zA-Z]+$")]
    [string]$FirstName
    [ValidatePattern("^[a-z A-Z]+$")]
    [string]$LastName

    hidden [string]$UserName

    [ValidateSet('Internal','External')]
    [string]
    $EmployeeType
    [ValidatePattern("^OU=")]
    [string]$OU

    hidden static [string]$DomainName = "DC=District,DC=Local"


    #Methods

     [string]static GetNewUserName([string]$FirstName,[string]$LastName){

        $start = $LastName.replace(" ","").Substring(0,5)
        $end = $FirstName.Substring(0,2)
        
        
            $UName = ($start + $end).ToLower()
        
        
            $AllNames = Get-ADUser -Filter "SamaccountName -like '$UName*'"
            [int]$LastUsed = $AllNames | % {$_.SamAccountName.trim($Uname)} | select -Last 1
            $Next = $LastUsed+1
            $nextNumber = $Next.tostring().padleft(2,'0')
            $SamAccountName = $UName + $nextNumber
        return $SamAccountName
         
        
    } 

    [string]static GetNewUserName([string]$FirstName,[string]$LastName,[int]$Length){

        $start = $LastName.replace(" ","").Substring(0,$Length)
        $end = $FirstName.Substring(0,2)
        
        
            $UName = ($start + $end).ToLower()
        
        
            $AllNames = Get-ADUser -Filter "SamaccountName -like '$UName*'"
            [int]$LastUsed = $AllNames | % {$_.SamAccountName.trim($Uname)} | select -Last 1
            $Next = $LastUsed+1
            $nextNumber = $Next.tostring().padleft(2,'0')
            $SamAccountName = $UName + $nextNumber
        return $SamAccountName
         
        
    } 

   

    [employee]Create(){
        
        New-ADUser -SamAccountName $this.UserName `
                   -GivenName $this.FirstName `
                   -Surname $this.LastName `
                   -Name $this.UserName `
                   -UserPrincipalName $this.UserName `
                    -DisplayName ($this.FirstName + " " + $this.LastName) `
                    -Description ($this.FirstName + " " + $this.LastName) `
                    -Path $this.OU

        return $this
    } 

}

[employee]::GetNewUserName("Stephane","vangulick")
[employee]::GetNewUserName("Stephane","vangulick",4)

$NewEmployee = [employee]::new()
$NewEmployee.FirstName = "Stephane"
$NewEmployee.LastName = "Van Gulick"
$NewEmployee.EmployeeType = "Internal"
$NewEmployee.OU = "OU=Internal,OU=Users,OU=HQ," + [employee]::DomainName 

#Setting a value to our hidden property UserName
$NewEmployee.UserName = [employee]::GetNewUserName("Stephane","vangulick")

#Calling the create method
$NewEmployee.Create()
