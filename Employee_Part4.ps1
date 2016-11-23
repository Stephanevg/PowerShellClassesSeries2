Enum EmployeeType{

  Internal
  External
  
}

Enum InternalBaseGroups{

  GG_WifiUsers
  GG_Acces_L1
  GG_Acces_L2
}


Enum ExternalBaseGroups{

  GG_ExternalUsers
  GG_Acces_L1
} 

Class Employee {


  [ValidatePattern("^[a-zA-Z]+$")]
  [string]$FirstName
  [ValidatePattern("^[a-z A-Z]+$")]
  [string]$LastName

  hidden [string]$UserName

  #[ValidateSet('Internal','External')]
  [EmployeeType]
  $EmployeeType
  [ValidatePattern("^OU=")]
  [string]$OU

  hidden static [string]$DomainName = "DC=District,DC=Local"

  #Constructors

  Employee ([String]$FirstName,[String]$Lastname,[EmployeeType]$EmployeeType){ #Changed Type

    #Initialising variables
    $UserOU = ""

    #Setting properties
    $this.EmployeeType = $EmployeeType
    $this.FirstName = $FirstName
    $this.LastName = $Lastname

    #Notice the call to our static method
    $this.UserName = [Employee]::GetNewUserName($FirstName,$Lastname)

    #Notice the call to our static property
    $this.OU = "OU=$($EmployeeType)," + "OU=Users,OU=HQ," + [employee]::DomainName   
            
  }

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

  hidden [void]AddToGroup([string]$AdGroup){
    
    Add-ADGroupMember -Identity $Adgroup -Members (get-aduser $this.UserName)

  }
    
  hidden [void]AddGroupsFromEnum([System.Enum]$GroupList){

    $AllGroups = [System.Enum]::GetNames($GroupList)
    foreach ($group in $AllGroups){
      ([Employee]$this).AddToGroup($group)
    }
        
  
  }
    
  [void]AddToGroups(){
    $GroupList = ""
    switch ($this.Department.ToString().ToLower()) {
      'information_technology'{
        $GroupList = "Information_TechnologyGroups"
        break
      }'Marketing'{
        $GroupList = "MarketingGroups"
        break
      }
      default{
        $GroupList = ""
        throw "Department $($this.Department) does not have groups yet"
            
      }
    }
    $AllGroups = [System.Enum]::GetNames($GroupList)
    foreach ($group in $AllGroups){
      ([Employee]$this).AddToGroup($group)
    }
        
  }#endMethod
}

Class ExternalEmployee : Employee{

  ExternalEmployee([string]$FirstName,[string]$LastName){
        
    $this.UserName = [Employee]::GetNewUserName($FirstName,$LastName,[employeeType]::External)
    $this.EmployeeType = [EmployeeType]::External
    $this.FirstName = $FirstName
    $this.LastName = $LastName
  }

  [void]AddToBaseGroups(){
    
    $this.AddToGroupsFromEnum([ExternalBaseGroups])
      
    }
    
  }



$NewEmployee = [employee]::new("Stephane","Van Gulick","Internal")
$NewEmployee.Create()

$NewEmployee = [ExternalEmployee]::new("Stephane","Van Gulick")
$NewEmployee.Create()

